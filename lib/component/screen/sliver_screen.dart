import 'dart:async';

import 'package:arcane/arcane.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SliverScreen extends AbstractStatefulScreen {
  final Widget sliver;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final ScrollController? sidebarController;
  final PylonBuilder? sidebar;

  const SliverScreen({
    this.sidebarController,
    super.overrideBackgroundColor,
    super.key,
    super.background,
    super.fab,
    super.footer,
    super.header,
    super.gutter,
    super.loadingProgress,
    super.loadingProgressIndeterminate,
    super.minContentFraction,
    super.minContentWidth,
    super.showLoadingSparks,
    this.physics,
    super.foreground,
    this.scrollController,
    this.sidebar,
    required this.sliver,
  });

  @override
  State<SliverScreen> createState() => _SliverScreenState();
}

class _SliverScreenState extends State<SliverScreen> {
  ScrollController? _controller;
  ScrollController? _sidebarController;
  BehaviorSubject<bool> headerBlurTop = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> headerBlurSidebar = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> headerBlur = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> footerBlur = BehaviorSubject.seeded(true);
  BehaviorSubject<bool> footerBlurBottom = BehaviorSubject.seeded(true);
  BehaviorSubject<bool> footerBlurSidebar = BehaviorSubject.seeded(true);
  GlobalKey footerKey = GlobalKey();
  double footerSize = 0;
  GlobalKey headerKey = GlobalKey();
  double headerSize = 0;
  List<StreamSubscription<bool>> _listeners = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateHeaderSize();
      updateFooterSize();
      setState(() {});
    });

    _listeners = [
      headerBlurTop
          .listen((event) => headerBlur.add(event || headerBlurSidebar.value)),
      headerBlurSidebar
          .listen((event) => headerBlur.add(event || headerBlurTop.value)),
      footerBlurBottom
          .listen((event) => footerBlur.add(event || footerBlurSidebar.value)),
      footerBlurSidebar
          .listen((event) => footerBlur.add(event || footerBlurBottom.value)),
    ];
  }

  @override
  void dispose() {
    for (var element in _listeners) {
      element.cancel();
    }
    super.dispose();
  }

  ScrollController getSidebarController(BuildContext context) {
    void bind() {
      _sidebarController!.addListener(() {
        headerBlurSidebar.add(!(_sidebarController!.position.pixels <=
            _sidebarController!.position.minScrollExtent));
        footerBlurSidebar.add(!(_sidebarController!.position.pixels >=
            _sidebarController!.position.maxScrollExtent));
      });
    }

    if (_sidebarController != null) {
      return _sidebarController!;
    }

    if (widget.sidebarController != null) {
      _sidebarController = widget.sidebarController;
      bind();
      return _sidebarController!;
    }

    _sidebarController = ScrollController();
    bind();
    return _sidebarController!;
  }

  ScrollController getController(BuildContext context) {
    void bind() {
      _controller!.addListener(() {
        footerBlurBottom.add(!(_controller!.position.pixels >=
            _controller!.position.maxScrollExtent));
        headerBlurTop.add(!(_controller!.position.pixels <=
            _controller!.position.minScrollExtent));
      });
    }

    if (_controller != null) {
      return _controller!;
    }

    if (widget.scrollController != null) {
      _controller = widget.scrollController;
      bind();
      return _controller!;
    }

    ScrollController? c = ModalScrollController.of(context);
    if (c != null) {
      _controller = c;
      bind();
      return c;
    }

    _controller = ScrollController();
    bind();
    return _controller!;
  }

  bool updateHeaderSize() {
    try {
      double v = headerKey.currentContext?.size?.height ?? 0;
      if (v != headerSize) {
        headerSize = v;
        return true;
      }
    } catch (ignored) {}
    return false;
  }

  bool updateFooterSize() {
    try {
      double v = footerKey.currentContext?.size?.height ?? 0;

      if (v != footerSize) {
        footerSize = v;
        return true;
      }
    } catch (ignored) {}
    return false;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (updateHeaderSize() || updateFooterSize()) {
        setState(() {});
      }
    });

    double width = MediaQuery.of(context).size.width;
    double gutterWidth = widget.gutter && width > widget.minContentWidth
        ? (width * ((1 - widget.minContentFraction) / 2)) - 25
        : 0;

    Widget Function(BuildContext context)? sidebar =
        widget.sidebar ?? context.pylonOr<ArcaneSidebarInjector>()?.builder;

    Widget? footer =
        widget.footer ?? InjectScreenFooter.getFooterWidget(context);

    return Scaffold(
        overrideBackgroundColor: widget.overrideBackgroundColor,
        primary: context.pylonOr<NavigationType>() != NavigationType.drawer,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            if (widget.background != null)
              PylonRemove<ArcaneSidebarInjector>(
                  builder: (context) => widget.background!),
            Positioned.fill(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (sidebar != null)
                  PylonCluster(pylons: [
                    Pylon<ArbitraryHeaderSpace>.data(
                      local: true,
                      value: ArbitraryHeaderSpace(headerSize),
                    ),
                    Pylon<SidebarScrollController>.data(
                      local: true,
                      value: SidebarScrollController(
                          controller: getSidebarController(context)),
                    ),
                  ], builder: sidebar),
                Expanded(
                  child: PylonRemove<ArcaneSidebarInjector>(
                    builder: (context) => CustomScrollView(
                      physics: widget.physics,
                      controller: getController(context),
                      slivers: [
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: headerSize,
                          ),
                        ),
                        SliverPadding(
                            padding: EdgeInsets.symmetric(
                              horizontal: gutterWidth,
                            ),
                            sliver: widget.sliver),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: footerSize,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
            if (footer != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: IntrinsicHeight(
                  child: footerBlur.build((footerHas) => GlassStopper(
                        key: footerKey,
                        builder: (context) => KeyedSubtree(
                          key: ValueKey("fblur.$footerHas"),
                          child: Pylon<AntiFlickerDirection>(
                            value: AntiFlickerDirection.bottom,
                            builder: (context) => SafeBar(
                                bottom: true,
                                builder: (context) =>
                                    PylonRemove<ArcaneSidebarInjector>(
                                        builder: (context) => footer)),
                          ),
                        ),
                        stopping: !(footerHas || widget.background != null),
                      )),
                ),
              ),
            if (widget.fab != null)
              Padding(
                  padding: EdgeInsets.only(top: headerSize, bottom: footerSize),
                  child: FabSocket(
                      child: PylonRemove<ArcaneSidebarInjector>(
                          builder: (context) => widget.fab!))),
            if (widget.foreground != null)
              Padding(
                  padding: EdgeInsets.only(top: headerSize, bottom: footerSize),
                  child: PylonRemove<ArcaneSidebarInjector>(
                      builder: (context) => widget.foreground!)),
            if (widget.header != null)
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: headerBlur.unique.build((blurring) => GlassStopper(
                        builder: (context) => KeyedSubtree(
                          key: ValueKey("hblur.$blurring"),
                          child: Pylon<AntiFlickerDirection>(
                            value: AntiFlickerDirection.top,
                            builder: (context) => SafeBar(
                                top: true,
                                builder: (context) => KeyedSubtree(
                                      key: headerKey,
                                      child: PylonRemove<ArcaneSidebarInjector>(
                                          builder: (context) => widget.header!),
                                    )),
                          ),
                        ),
                        stopping: !(blurring || widget.background != null),
                      )))
          ],
        ));
  }
}

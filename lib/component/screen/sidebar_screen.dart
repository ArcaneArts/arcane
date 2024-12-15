import 'dart:async';

import 'package:arcane/arcane.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SidebarScreen extends AbstractStatefulScreen {
  final Widget sliver;
  final ScrollController? scrollController;
  final ScrollController? sidebarController;
  final ScrollPhysics? physics;
  final PylonBuilder? sidebar;

  const SidebarScreen({
    super.overrideBackgroundColor,
    super.key,
    super.background,
    super.fab,
    super.header,
    super.footer,
    super.gutter,
    super.loadingProgress,
    super.loadingProgressIndeterminate,
    super.minContentFraction,
    super.minContentWidth,
    super.showLoadingSparks,
    this.sidebarController,
    this.sidebar,
    this.physics,
    super.foreground,
    this.scrollController,
    required this.sliver,
  });

  @override
  State<SidebarScreen> createState() => _SidebarScreenState();
}

class _SidebarScreenState extends State<SidebarScreen> {
  ScrollController? _controller;
  ScrollController? _sidebarController;
  BehaviorSubject<bool> headerBlurTop = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> headerBlurSidebar = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> headerBlur = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> footerBlur = BehaviorSubject.seeded(true);
  GlobalKey footerKey = GlobalKey();
  GlobalKey headerKey = GlobalKey();
  double footerSize = 0;
  double headerSize = 0;
  List<StreamSubscription<bool>> _listeners = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateHeaderSize();
      setState(() {});
    });

    _listeners = [
      headerBlurTop.listen((event) {
        headerBlur.add(event || headerBlurSidebar.value);
      }),
      headerBlurSidebar.listen((event) {
        headerBlur.add(event || headerBlurTop.value);
      }),
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

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (updateHeaderSize()) {
        setState(() {});
      }
    });

    double width = MediaQuery.of(context).size.width;
    double gutterWidth = widget.gutter && width > widget.minContentWidth
        ? (width * ((1 - widget.minContentFraction) / 2)) - 25
        : 0;

    return Scaffold(
        overrideBackgroundColor: widget.overrideBackgroundColor,
        primary: context.pylonOr<NavigationType>() != NavigationType.drawer,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            if (widget.background != null)
              Positioned.fill(child: widget.background!),
            Positioned.fill(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (widget.sidebar != null)
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
                  ], builder: widget.sidebar!),
                Expanded(
                  child: CustomScrollView(
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
                    ],
                  ),
                )
              ],
            )),
            if (widget.footer != null)
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
                                builder: (context) => widget.footer!),
                          ),
                        ),
                        stopping: !(footerHas || widget.background != null),
                      )),
                ),
              ),
            if (widget.fab != null)
              Positioned.fill(
                  child: Padding(
                      padding: EdgeInsets.only(top: headerSize),
                      child: FabSocket(child: widget.fab!))),
            if (widget.foreground != null)
              Positioned.fill(
                  child: Padding(
                      padding: EdgeInsets.only(top: headerSize),
                      child: widget.foreground!)),
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
                                      child: widget.header!,
                                    )),
                          ),
                        ),
                        stopping: !(blurring || widget.background != null),
                      )))
          ],
        ));
  }
}

class ArbitraryHeaderSpace {
  final double height;

  const ArbitraryHeaderSpace(this.height);
}

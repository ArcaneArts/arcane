import 'package:arcane/arcane.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class SliverScreen extends AbstractStatefulScreen {
  final Widget sliver;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;

  const SliverScreen({
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
    required this.sliver,
  });

  @override
  State<SliverScreen> createState() => _SliverScreenState();
}

class _SliverScreenState extends State<SliverScreen> {
  ScrollController? _controller;
  BehaviorSubject<bool> headerBlur = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> footerBlur = BehaviorSubject.seeded(true);
  GlobalKey headerKey = GlobalKey();
  GlobalKey footerKey = GlobalKey();
  double headerSize = 0;
  double footerSize = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  ScrollController getController(BuildContext context) {
    void bind() {
      _controller!.addListener(() {
        footerBlur.add(!(_controller!.position.pixels >=
            _controller!.position.maxScrollExtent));
        headerBlur.add(!(_controller!.position.pixels <=
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

    Widget? footer =
        widget.footer ?? InjectScreenFooter.getFooterWidget(context);

    return Scaffold(
        primary: context.pylonOr<NavigationType>() != NavigationType.drawer,
        child: MaybeStack(
          fit: StackFit.expand,
          children: [
            if (widget.background != null) widget.background!,
            CustomScrollView(
              physics: widget.physics,
              controller: getController(context),
              slivers: [
                if (widget.header != null)
                  SliverPinnedHeader(
                    child: headerBlur.unique.build((blurring) => GlassStopper(
                          key: headerKey,
                          builder: (context) => KeyedSubtree(
                            key: ValueKey("hblur.$blurring"),
                            child: Pylon<AntiFlickerDirection>(
                              value: AntiFlickerDirection.top,
                              builder: (context) => SafeBar(
                                  top: true,
                                  builder: (context) => widget.header!),
                            ),
                          ),
                          stopping: !(blurring || widget.background != null),
                        )),
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
                                bottom: true, builder: (context) => footer),
                          ),
                        ),
                        stopping: !(footerHas || widget.background != null),
                      )),
                ),
              ),
            if (widget.fab != null)
              Padding(
                  padding: EdgeInsets.only(top: headerSize, bottom: footerSize),
                  child: FabSocket(child: widget.fab!)),
            if (widget.foreground != null)
              Padding(
                  padding: EdgeInsets.only(top: headerSize, bottom: footerSize),
                  child: widget.foreground!),
          ],
        ));
  }
}

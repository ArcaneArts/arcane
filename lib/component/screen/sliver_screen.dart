import 'dart:async';

import 'package:arcane/arcane.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

/// A sliver-based screen component that extends [AbstractScreen] to provide
/// scrollable layouts using [CustomScrollView], ideal for complex UIs with
/// dynamic headers, footers, and sidebars. Integrates seamlessly with [ArcaneApp]
/// and [ArcaneTheme] for theming, supports [Sidebar] via [PylonBuilder], and
/// enables efficient rendering of slivers like [SliverAppBar], [SliverList],
/// [SliverGrid], or [SliverToBoxAdapter] for performance-optimized scrolling
/// with lazy loading. Use for screens requiring pinned elements, floating
/// behaviors, or nested scrolling as in [NestedScrollView].
class SliverScreen extends AbstractStatefulScreen {
  final Widget sliver;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final ScrollController? sidebarController;
  final PylonBuilder? sidebar;

  /// Constructs a [SliverScreen] with a required main content sliver and optional
  /// customizations for scrolling, theming, and layout. The [sliver] parameter
  /// provides the primary scrollable content, typically a [SliverList] or
  /// [SliverGrid] for efficient rendering. Use [scrollController] to manage
  /// scroll events and integrate with [NestedScrollView] for coordinated
  /// scrolling. [physics] allows custom scroll behaviors like bouncing or
  /// clamping. [sidebarController] and [sidebar] enable [Sidebar] integration
  /// for resizable layouts. Inherits parameters from [AbstractScreen] for
  /// headers, footers, FABs, and loading states, ensuring compatibility with
  /// [ArcaneTheme] and [CustomScrollView] orchestration.
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

/// State management for [SliverScreen], handling scroll controllers, blur
/// effects via [BehaviorSubject] for dynamic header/footer opacity based on
/// scroll position, and size calculations for layout adjustments. Orchestrates
/// [CustomScrollView] with slivers for pinned headers ([SliverPinnedHeader]),
/// gutters ([SliverGutter]), and footer spacing ([SliverToBoxAdapter]),
/// integrating [Pylon] for dependency injection with [ArcaneTheme], [Sidebar],
/// and [InjectScreenFooter]. Supports performance through listener bindings
/// for efficient blur updates and lazy sliver rendering in large lists.
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

  /// Retrieves or creates a [ScrollController] for the sidebar, binding listeners
  /// to update [headerBlurSidebar] and [footerBlurSidebar] based on scroll extent.
  /// Integrates with provided [widget.sidebarController] or creates a new one,
  /// enabling coordinated scrolling with [Sidebar] and blur effects for
  /// performance-optimized resizable layouts in [CustomScrollView].
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

  /// Retrieves or creates a [ScrollController] for the main content, binding
  /// listeners to update [footerBlurBottom] and [headerBlurTop] based on scroll
  /// position. Prioritizes [widget.scrollController], falls back to
  /// [ModalScrollController] for bottom sheets, or creates a new one. Essential
  /// for [CustomScrollView] integration, supporting [NestedScrollView] and
  /// efficient blur transitions in sliver-based UIs with [SliverAppBar] or
  /// [SliverList].
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

  /// Dynamically calculates and updates the header height from [headerKey],
  /// falling back to [ArcaneTheme.defaultHeaderHeight], triggering rebuilds
  /// for accurate [SliverPinnedHeader] positioning and blur effects in
  /// [CustomScrollView]. Ensures performance by avoiding unnecessary setState
  /// calls if size unchanged.
  bool updateHeaderSize() {
    try {
      double v = headerKey.currentContext?.size?.height ??
          ArcaneTheme.of(context).defaultHeaderHeight;
      if (v != headerSize) {
        headerSize = v;
        return true;
      }
    } catch (ignored) {}
    return false;
  }

  /// Dynamically calculates and updates the footer height from [footerKey],
  /// enabling precise [SliverToBoxAdapter] spacing and [GlassStopper] blur
  /// positioning at the bottom of [CustomScrollView]. Supports flexible footer
  /// integrations via [InjectScreenFooter] without impacting scroll performance.
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

  /// Builds the [SliverScreen] UI using [Scaffold] with [CustomScrollView] for
  /// sliver orchestration, incorporating [widget.sliver] as the main content
  /// wrapped in [SliverGutter] for spacing. Manages dynamic blurs ([GlassStopper])
  /// for headers/footers based on scroll position, integrates [Pylon] for
  /// [Sidebar], [ArcaneTheme], and [InjectScreenFooter], and positions FAB/foreground
  /// with padding for header/footer sizes. Optimizes performance via lazy
  /// rendering of slivers like [SliverPinnedHeader] and [SliverToBoxAdapter],
  /// supporting complex scrolling UIs with [NestedScrollView] and theme-aware
  /// elements.
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (updateHeaderSize() || updateFooterSize()) {
        setState(() {});
      }
    });

    Widget Function(BuildContext context)? sidebar =
        widget.sidebar ?? context.pylonOr<ArcaneSidebarInjector>()?.builder;

    Widget? footer =
        widget.footer ?? InjectScreenFooter.getFooterWidget(context);

    Widget cont = CustomScrollView(
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
                          top: true, builder: (context) => widget.header!),
                    ),
                  ),
                  stopping: !(blurring),
                )),
          ),
        PylonRemove<InjectScreenFooter>(
            builder: (context) => PylonRemove<InjectBarLeading>(
                local: true,
                builder: (context) => PylonRemove<InjectBarTrailing>(
                    local: true,
                    builder: (context) => SliverGutter(
                        enabled: widget.gutter ??
                            ArcaneTheme.of(context).gutter.enabled,
                        sliver: Pylon<ArbitraryHeaderSpace?>(
                          value: ArbitraryHeaderSpace(headerSize),
                          local: true,
                          builder: (context) => widget.sliver,
                        ))))),
        SliverToBoxAdapter(
          child: SizedBox(
            height: footerSize,
          ),
        )
      ],
    );

    Widget s = Scaffold(
        overrideBackgroundColor: widget.overrideBackgroundColor,
        primary: context.pylonOr<NavigationType>() != NavigationType.drawer,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            if (widget.background != null)
              PylonRemove<InjectScreenFooter>(
                  builder: (context) => PylonRemove<ArcaneSidebarInjector>(
                      builder: (context) => widget.background!)),
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
                  child: PylonRemove<InjectScreenFooter>(
                      builder: (context) => PylonRemove<ArcaneSidebarInjector>(
                            builder: (context) => Stack(
                              fit: StackFit.expand,
                              children: [cont],
                            ),
                          )),
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
                                    PylonRemove<InjectScreenFooter>(
                                        builder: (context) =>
                                            PylonRemove<ArcaneSidebarInjector>(
                                                builder: (context) => footer))),
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
                      child: PylonRemove<InjectScreenFooter>(
                          builder: (context) =>
                              PylonRemove<ArcaneSidebarInjector>(
                                  builder: (context) => widget.fab!)))),
            if (widget.foreground != null)
              Padding(
                  padding: EdgeInsets.only(top: headerSize, bottom: footerSize),
                  child: PylonRemove<InjectScreenFooter>(
                      builder: (context) => PylonRemove<ArcaneSidebarInjector>(
                          builder: (context) => widget.foreground!))),
            // if (widget.header != null)
            //   Positioned(
            //       top: 0,
            //       left: 0,
            //       right: 0,
            //       child: headerBlur.unique.build((blurring) => GlassStopper(
            //             builder: (context) => KeyedSubtree(
            //               key: ValueKey("hblur.$blurring"),
            //               child: Pylon<AntiFlickerDirection>(
            //                 value: AntiFlickerDirection.top,
            //                 builder: (context) => SafeBar(
            //                     top: true,
            //                     builder: (context) => KeyedSubtree(
            //                           key: headerKey,
            //                           child: PylonRemove<ArcaneSidebarInjector>(
            //                               builder: (context) => widget.header!),
            //                         )),
            //               ),
            //             ),
            //             stopping: !(blurring || widget.background != null),
            //           )))
          ],
        ));

    s = BackdropGroup(backdropKey: globalBlurBackdropKey, child: s);

    return s;
  }
}

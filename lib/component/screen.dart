import 'package:arcane/arcane.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rxdart/rxdart.dart';

class Screen extends StatefulWidget {
  final List<Widget> children;
  final List<Widget> slivers;
  final Widget? header;
  final Widget? footer;
  final Widget? background;
  final double? loadingProgress;
  final bool loadingProgressIndeterminate;
  final bool showLoadingSparks;
  final double footerHeight;
  final bool footerPaddingBottom;
  final ScrollController? scrollController;
  final double minContentFraction;
  final double minContentWidth;
  final Widget? fill;
  final bool gutter;
  final Widget? fab;

  const Screen({
    super.key,
    this.gutter = true,
    this.fab,
    this.background,
    this.minContentWidth = 500,
    this.minContentFraction = 0.75,
    this.scrollController,
    this.footerHeight = 52,
    this.fill,
    this.slivers = const [],
    this.children = const [],
    this.header,
    this.footer,
    this.loadingProgress,
    this.loadingProgressIndeterminate = false,
    this.showLoadingSparks = false,
    this.footerPaddingBottom = true,
  });

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  ScrollController? _controller;
  BehaviorSubject<bool> headerBlur = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> footerBlur = BehaviorSubject.seeded(true);

  ScrollController getController(BuildContext context) {
    void bind() {
      _controller!.addListener(() {
        if (_controller!.position.pixels ==
            _controller!.position.maxScrollExtent) {
          footerBlur.add(false);
        } else {
          footerBlur.add(true);
        }

        if (_controller!.position.pixels ==
            _controller!.position.minScrollExtent) {
          headerBlur.add(false);
        } else {
          headerBlur.add(true);
        }
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fill != null) {
      return Scaffold(
        loadingProgress: widget.loadingProgress,
        loadingProgressIndeterminate: widget.loadingProgressIndeterminate,
        floatingFooter: false,
        floatingHeader: false,
        headers: [
          if (widget.header != null)
            GlassStopper(builder: (context) => widget.header!, stopping: true)
        ],
        footers: [
          if (widget.footer != null)
            GlassStopper(builder: (context) => widget.footer!, stopping: true)
        ],
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (widget.background != null) widget.background!,
            widget.fill!,
            if (widget.fab != null)
              Align(
                alignment: Alignment.bottomRight,
                child: widget.fab,
              )
          ],
        ),
      );
    }

    List<Widget> slv = [
      ...widget.slivers,
      if (widget.children.length == 1)
        SliverFillRemainingBoxAdapter(
          child: widget.children.first,
        ),
      if (widget.children.length > 1)
        SliverList(
          delegate: SliverChildListDelegate(widget.children),
        ),
      if (widget.footer != null && widget.footerPaddingBottom)
        SliverToBoxAdapter(
          child: Container(
            height: widget.footerHeight,
          ),
        )
    ];
    double width = MediaQuery.of(context).size.width;
    double gutterWidth = 0;

    if (widget.gutter && width > widget.minContentWidth) {
      gutterWidth = (width * ((1 - widget.minContentFraction) / 2)) - 25;
    }

    return Scaffold(
      loadingProgress: widget.loadingProgress,
      loadingProgressIndeterminate: widget.loadingProgressIndeterminate,
      floatingFooter: true,
      footers: [
        if (widget.footer != null)
          footerBlur.unique.build((blurring) => GlassStopper(
                builder: (context) => KeyedSubtree(
                  key: ValueKey("fblur.$blurring"),
                  child: Pylon<AntiFlickerDirection>(
                    value: AntiFlickerDirection.bottom,
                    builder: (context) => widget.footer!,
                  ),
                ),
                stopping: !blurring,
              ))
      ],
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.background != null) widget.background!,
          CustomScrollView(
            controller: getController(context),
            slivers: [
              if (widget.header != null)
                SliverPinnedHeader(
                  child: headerBlur.unique.build((blurring) => GlassStopper(
                        builder: (context) => KeyedSubtree(
                          key: ValueKey("hblur.$blurring"),
                          child: Pylon<AntiFlickerDirection>(
                            value: AntiFlickerDirection.top,
                            builder: (context) => widget.header!,
                          ),
                        ),
                        stopping: !blurring,
                      )),
                ),
              if (gutterWidth > 0)
                ...slv.map((e) => SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: gutterWidth),
                    sliver: e))
              else
                ...slv
            ],
          ),
          if (widget.fab != null)
            PaddingBottom(
                padding: widget.footer != null && widget.fill == null
                    ? widget.footerHeight
                    : 0,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: widget.fab,
                ))
        ],
      ),
    );
  }
}

class NavTab {
  final bool gutter;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final List<Widget>? slivers;
  final Bar header;
  final Widget? fill;
  final Widget? fab;

  const NavTab({
    required this.header,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.fab,
    this.slivers = const [],
    this.fill,
    this.gutter = true,
  });
}

class NavScreen extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final Widget? background;
  final double? loadingProgress;
  final bool loadingProgressIndeterminate;
  final bool showLoadingSparks;
  final double footerHeight;
  final bool footerPaddingBottom;
  final ScrollController? scrollController;
  final double minContentFraction;
  final double minContentWidth;
  final List<NavTab> tabs;

  const NavScreen({
    super.key,
    required this.tabs,
    this.selectedIndex = 0,
    required this.onTabChanged,
    this.background,
    this.minContentWidth = 500,
    this.minContentFraction = 0.75,
    this.scrollController,
    this.footerHeight = 60,
    this.loadingProgress,
    this.loadingProgressIndeterminate = false,
    this.showLoadingSparks = false,
    this.footerPaddingBottom = true,
  });

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  ScrollController? _controller;
  BehaviorSubject<bool> headerBlur = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> footerBlur = BehaviorSubject.seeded(true);

  ScrollController getController(BuildContext context) {
    void bind() {
      _controller!.addListener(() {
        if (_controller!.position.pixels ==
            _controller!.position.maxScrollExtent) {
          footerBlur.add(false);
        } else {
          footerBlur.add(true);
        }

        if (_controller!.position.pixels ==
            _controller!.position.minScrollExtent) {
          headerBlur.add(false);
        } else {
          headerBlur.add(true);
        }
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

  @override
  void initState() {
    super.initState();
  }

  Widget buildBottomBar(BuildContext context) {
    return ButtonBar(selectedIndex: widget.selectedIndex, buttons: [
      ...widget.tabs.mapIndexed((e, i) => IconTab(
            icon: e.icon,
            selectedIcon: e.selectedIcon,
            label: e.label,
            onPressed: () => setState(() => widget.onTabChanged(i)),
          ))
    ]);
  }

  Widget buildRail(BuildContext context) {
    return SizedBox(
      width: 32,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Gap(11),
          GhostButton(
              density: ButtonDensity.icon,
              child: context.inSheet
                  ? const Icon(Icons.x_bold)
                  : const Icon(Icons.caret_left_bold),
              onPressed: () => Arcane.pop(context)),
          Gap(8),
          ...widget.tabs.mapIndexed((e, i) {
            if (i == widget.selectedIndex) {
              return IconButton(
                  icon: Icon(
                e.selectedIcon,
                color: Theme.of(context).colorScheme.primary,
              ));
            }

            return IconButton(
              icon: Icon(e.icon),
              onPressed: () {
                widget.onTabChanged(i);
              },
            );
          })
        ],
      ),
    ).padOnly(left: 8, right: 8);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool rail = width > widget.minContentWidth;

    double gutterWidth = 0;

    if (widget.tabs[widget.selectedIndex].gutter &&
        width > widget.minContentWidth) {
      gutterWidth = (width * ((1 - widget.minContentFraction) / 2)) - 25;
    }

    Widget content;

    if (widget.tabs[widget.selectedIndex].fill != null) {
      content = Stack(
        fit: StackFit.expand,
        children: [
          if (widget.background != null) widget.background!,
          PaddingHorizontal(
            padding: gutterWidth,
            child: widget.tabs[widget.selectedIndex].fill!,
          ),
          if (widget.tabs[widget.selectedIndex].fab != null)
            Align(
              alignment: Alignment.bottomRight,
              child: widget.tabs[widget.selectedIndex].fab,
            )
        ],
      );
    } else {
      List<Widget> slv = [
        ...widget.tabs[widget.selectedIndex].slivers!,
        if (!rail)
          SliverToBoxAdapter(
            child: Container(
              height: widget.footerHeight,
            ),
          )
      ];
      Widget list = Stack(
        fit: StackFit.expand,
        children: [
          if (widget.background != null) widget.background!,
          CustomScrollView(
            controller: getController(context),
            slivers: [
              SliverPinnedHeader(
                child: headerBlur.unique.build((blurring) => GlassStopper(
                      builder: (context) => KeyedSubtree(
                        key: ValueKey("hblur.$blurring"),
                        child: Pylon<AntiFlickerDirection>(
                          value: AntiFlickerDirection.top,
                          builder: (context) =>
                              widget.tabs[widget.selectedIndex].header.copyWith(
                                  backButton:
                                      rail ? BarBackButtonMode.never : null,
                                  height: 36),
                        ),
                      ),
                      stopping: !blurring,
                    )),
              ),
              if (gutterWidth > 0)
                ...slv.map((e) => SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: gutterWidth),
                    sliver: e))
              else
                ...slv
            ],
          ),
          if (!rail)
            Positioned.fill(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: footerBlur.unique.build((blurring) => GlassStopper(
                    builder: (context) => KeyedSubtree(
                      key: ValueKey("fblur.$blurring"),
                      child: Pylon<AntiFlickerDirection>(
                        value: AntiFlickerDirection.bottom,
                        builder: (context) => IntrinsicHeight(
                          child: buildBottomBar(context),
                        ),
                      ),
                    ),
                    stopping: !blurring,
                  )),
            )),
          if (widget.tabs[widget.selectedIndex].fab != null)
            PaddingBottom(
                padding: !rail ? widget.footerHeight : 0,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: widget.tabs[widget.selectedIndex].fab,
                ))
        ],
      );

      content = list;
    }

    Widget c = Scaffold(
      loadingProgress: widget.loadingProgress,
      loadingProgressIndeterminate: widget.loadingProgressIndeterminate,
      floatingFooter: widget.tabs[widget.selectedIndex].fill == null,
      floatingHeader: widget.tabs[widget.selectedIndex].fill == null,
      footers: [
        if (!rail && widget.tabs[widget.selectedIndex].fill != null)
          GlassStopper(
              builder: (context) => buildBottomBar(context), stopping: true)
      ],
      headers: [
        if (widget.tabs[widget.selectedIndex].fill != null)
          GlassStopper(
              builder: (context) => widget.tabs[widget.selectedIndex].header
                  .copyWith(
                      backButton: rail ? BarBackButtonMode.never : null,
                      height: 36),
              stopping: true)
      ],
      child: content,
    );

    return Scaffold(
        child: rail
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  buildRail(context),
                  Expanded(
                    child: c,
                  )
                ],
              )
            : c);
  }
}

extension XListWidgetSlv on List<Widget> {
  Widget get collapseSlivers =>
      length > 1 ? MultiSliver(children: this) : first;
}

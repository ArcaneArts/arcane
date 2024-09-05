import 'package:arcane/arcane.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pylon/pylon.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toxic/extensions/stream.dart';
import 'package:toxic_flutter/extensions/stream.dart';

class Screen extends StatefulWidget {
  final List<Widget> children;
  final List<Widget> slivers;
  final Widget? header;
  final Widget? footer;
  final Widget? background;
  final double? loadingProgress;
  final bool loadingProgressIndeterminate;
  final VoidCallback? onRefresh;
  final bool showLoadingSparks;
  final double footerHeight;
  final bool footerPaddingBottom;
  final ScrollController? scrollController;
  final double minContentFraction;
  final double minContentWidth;

  const Screen({
    super.key,
    this.background,
    this.minContentWidth = 500,
    this.minContentFraction = 0.75,
    this.scrollController,
    this.footerHeight = 52,
    this.slivers = const [],
    this.children = const [],
    this.header,
    this.footer,
    this.loadingProgress,
    this.loadingProgressIndeterminate = false,
    this.onRefresh,
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

    if (width > widget.minContentWidth) {
      gutterWidth = (width * ((1 - widget.minContentFraction) / 2)) - 25;
      print("Gutter width: $gutterWidth");
    }

    return Scaffold(
      loadingProgress: widget.loadingProgress,
      loadingProgressIndeterminate: widget.loadingProgressIndeterminate,
      onRefresh: widget.onRefresh,
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
          )
        ],
      ),
    );
  }
}

extension XListWidgetSlv on List<Widget> {
  Widget get collapseSlivers =>
      length > 1 ? MultiSliver(children: this) : first;
}

import 'package:arcane/arcane.dart';
import 'package:boxy/slivers.dart';
import 'package:pylon/pylon.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toxic/extensions/stream.dart';
import 'package:toxic_flutter/extensions/stream.dart';

class Screen extends StatefulWidget {
  final List<Widget> children;
  final List<Widget> slivers;
  final Widget? header;
  final Widget? footer;
  final double? loadingProgress;
  final bool loadingProgressIndeterminate;
  final VoidCallback? onRefresh;
  final bool
      floatingHeader; // when header floats, it takes no space in the layout, and positioned on top of the content
  final bool floatingFooter;
  final Color? headerBackgroundColor;
  final Color? footerBackgroundColor;
  final bool showLoadingSparks;
  final double footerHeight;

  const Screen({
    super.key,
    this.footerHeight = 50,
    this.slivers = const [],
    this.children = const [],
    this.header,
    this.footer,
    this.loadingProgress,
    this.loadingProgressIndeterminate = false,
    this.onRefresh,
    this.floatingHeader = false,
    this.floatingFooter = false,
    this.headerBackgroundColor,
    this.footerBackgroundColor,
    this.showLoadingSparks = false,
  });

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  late ScrollController controller;
  BehaviorSubject<bool> headerBlur = BehaviorSubject.seeded(false);
  BehaviorSubject<bool> footerBlur = BehaviorSubject.seeded(true);

  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        footerBlur.add(false);
      } else {
        footerBlur.add(true);
      }

      if (controller.position.pixels == controller.position.minScrollExtent) {
        headerBlur.add(false);
      } else {
        headerBlur.add(true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> slv = [
      ...widget.slivers,
      if (widget.children.length == 1)
        SliverFillRemaining(
          child: widget.children.first,
        ),
      if (widget.children.length > 1)
        SliverList(
          delegate: SliverChildListDelegate(widget.children),
        ),
    ];

    if (widget.footer != null) {
      slv = [
        SliverContainer(
          sliver: [
            ...slv,
            SliverToBoxAdapter(child: SizedBox(height: widget.footerHeight))
          ].collapseSlivers,
          foreground: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
            ),
          ),
        )
      ];
    }

    return Scaffold(
      child: CustomScrollView(
        controller: controller,
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
          ...slv
        ],
      ),
    );
  }
}

extension XListWidgetSlv on List<Widget> {
  Widget get collapseSlivers =>
      length > 1 ? MultiSliver(children: this) : first;
}

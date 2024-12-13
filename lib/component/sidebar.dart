import 'package:arcane/arcane.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

enum ArcaneSidebarState {
  expanded,
  collapsed,
}

extension XArcaneSidebarStatePylon on BuildContext {
  bool get isSidebarExpanded =>
      pylonOr<ArcaneSidebarState>() == ArcaneSidebarState.expanded;
}

List<Widget> _defWList(BuildContext context) => [];
Widget _defSliver(BuildContext context) => SliverToBoxAdapter();

class ArcaneSidebar extends StatefulWidget {
  final List<Widget> Function(BuildContext context) children;
  final PylonBuilder sliver;
  final bool _isSliver;
  final double width;
  final double collapsedWidth;
  final PylonBuilder? footer;
  final Curve expansionAnimationCurve;
  final Duration expansionAnimationDuration;
  final bool sidebarDivider;

  const ArcaneSidebar({
    super.key,
    this.width = 250,
    this.expansionAnimationCurve = Curves.easeOutExpo,
    this.expansionAnimationDuration = const Duration(milliseconds: 450),
    this.footer,
    this.collapsedWidth = 52,
    this.sidebarDivider = true,
    required this.children,
  })  : _isSliver = false,
        sliver = _defSliver;

  const ArcaneSidebar.sliver(
      {super.key,
      this.sidebarDivider = true,
      this.width = 250,
      this.expansionAnimationCurve = Curves.easeOutExpo,
      this.expansionAnimationDuration = const Duration(milliseconds: 450),
      this.footer,
      this.collapsedWidth = 50,
      required this.sliver})
      : _isSliver = true,
        children = _defWList;

  @override
  State<ArcaneSidebar> createState() => _ArcaneSidebarState();
}

class _ArcaneSidebarState extends State<ArcaneSidebar> {
  GlobalKey footerKey = GlobalKey();
  double footerSize = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateFooterSize();
      setState(() {});
    });
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

  Widget buildSliverContent(BuildContext context) => widget._isSliver
      ? widget.sliver(context)
      : SListView(
          children: widget.children(context),
        );

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (updateFooterSize()) {
        setState(() {});
      }
    });

    return MutablePylon<ArcaneSidebarState>(
        local: true,
        rebuildChildren: true,
        value: ArcaneSidebarState.expanded,
        builder: (context) => AnimatedSize(
              alignment: Alignment.centerLeft,
              duration: widget.expansionAnimationDuration,
              curve: widget.expansionAnimationCurve,
              child: Stack(
                children: [
                  SizedBox(
                    width: context.isSidebarExpanded
                        ? widget.width
                        : widget.collapsedWidth,
                    child: CustomScrollView(
                        controller: context
                            .pylonOr<SidebarScrollController>()
                            ?.controller,
                        slivers: [
                          SliverStickyHeader.builder(
                              builder: (context, _) => SizedBox(
                                  height: context
                                          .pylonOr<ArbitraryHeaderSpace>()
                                          ?.height ??
                                      0),
                              sliver: MultiSliver(
                                children: [
                                  buildSliverContent(context),
                                  SliverToBoxAdapter(
                                    child: SizedBox(height: footerSize),
                                  ),
                                ],
                              ))
                        ]),
                  ),
                  if (widget.footer != null)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: KeyedSubtree(
                          key: footerKey, child: widget.footer!(context)),
                    ),
                  if (widget.sidebarDivider)
                    Positioned(
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          color: Theme.of(context).colorScheme.muted,
                          width: 1,
                        )),
                ],
              ),
            ));
  }
}

class ArcaneSidebarFooter extends StatelessWidget {
  final Widget content;
  final Widget trailing;

  const ArcaneSidebarFooter(
      {super.key,
      this.trailing = const ArcaneSidebarExpansionToggle(),
      this.content = const SizedBox.shrink()});

  @override
  Widget build(BuildContext context) => SurfaceCard(
      padding: const EdgeInsets.all(0),
      borderRadius: BorderRadius.zero,
      borderColor: Colors.transparent,
      borderWidth: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (context.isSidebarExpanded) content.padLeft(8),
              Spacer(),
              trailing
            ],
          ).pad(8)
        ],
      ));
}

class ArcaneSidebarExpansionToggle extends StatelessWidget {
  const ArcaneSidebarExpansionToggle({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        icon: context.streamPylon<ArcaneSidebarState>().build((g) =>
            g == ArcaneSidebarState.expanded
                ? Icon(Icons.chevron_back_ionic)
                : Icon(Icons.chevron_forward_ionic)),
        onPressed: () => context.modPylon<ArcaneSidebarState>((i) =>
            i == ArcaneSidebarState.expanded
                ? ArcaneSidebarState.collapsed
                : ArcaneSidebarState.expanded),
      );
}

class SidebarScrollController {
  final ScrollController? controller;

  SidebarScrollController({this.controller});
}

class ArcaneSidebarButton extends StatelessWidget {
  final Widget icon;
  final String? label;
  final String? subLabel;
  final VoidCallback? onTap;
  final bool selected;

  const ArcaneSidebarButton(
      {super.key,
      required this.icon,
      this.label,
      this.subLabel,
      this.onTap,
      this.selected = false});

  @override
  Widget build(BuildContext context) => AnimatedContainer(
      decoration: BoxDecoration(
        color: selected ? Theme.of(context).colorScheme.muted : null,
        borderRadius: Theme.of(context).borderRadiusMd,
      ),
      duration: const Duration(milliseconds: 100),
      child: context.isSidebarExpanded
          ? GhostButton(
              leading: icon,
              onPressed: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null) Text(label!).normal(),
                  if (subLabel != null) Text(subLabel!).muted().small(),
                ],
              ),
            )
          : IconButton(icon: icon, onPressed: onTap));
}

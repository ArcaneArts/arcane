import 'package:arcane/arcane.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

enum ArcaneSidebarState {
  expanded,
  collapsed,
}

extension XArcaneSidebarStatePylon on BuildContext {
  bool get isSidebarExpanded =>
      pylonOr<ArcaneSidebarState>() == ArcaneSidebarState.expanded;

  bool get isSidebarExpandedOrAbsent =>
      (pylonOr<ArcaneSidebarState>() ?? ArcaneSidebarState.expanded) ==
      ArcaneSidebarState.expanded;
}

List<Widget> _defWList(BuildContext context) => [];

Widget _defSliver(BuildContext context) => SliverToBoxAdapter();

class ArbitraryHeaderSpace {
  final double height;

  const ArbitraryHeaderSpace(this.height);
}

class ArcaneSidebar extends StatefulWidget {
  final List<Widget> Function(BuildContext context) children;
  final PylonBuilder sliver;
  final bool _isSliver;
  final double width;
  final double collapsedWidth;
  final PylonBuilder? footer;
  final PylonBuilder? header;
  final Curve expansionAnimationCurve;
  final Duration expansionAnimationDuration;
  final bool sidebarDivider;

  const ArcaneSidebar({
    super.key,
    this.header,
    this.width = 250,
    this.expansionAnimationCurve = Curves.easeOutCirc,
    this.expansionAnimationDuration = const Duration(milliseconds: 333),
    this.footer,
    this.collapsedWidth = 52,
    this.sidebarDivider = true,
    required this.children,
  })  : _isSliver = false,
        sliver = _defSliver;

  const ArcaneSidebar.sliver(
      {super.key,
      this.header,
      this.sidebarDivider = true,
      this.width = 250,
      this.expansionAnimationCurve = Curves.easeOutCirc,
      this.expansionAnimationDuration = const Duration(milliseconds: 333),
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
  GlobalKey headerKey = GlobalKey();
  double footerSize = 0;
  double headerSize = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateFooterSize();
      updateHeaderSize();
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

  Widget buildSliverContent(BuildContext context) => widget._isSliver
      ? widget.sliver(context)
      : SListView(
          children: widget.children(context),
        );

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (updateFooterSize() || updateHeaderSize()) {
        setState(() {});
      }
    });

    return AnimatedSize(
      alignment: Alignment.centerLeft,
      duration: widget.expansionAnimationDuration,
      curve: widget.expansionAnimationCurve,
      child: context
          .streamPylon<ArcaneSidebarState>()
          .build((sbs) => Pylon<ArcaneSidebarState>(
                value: sbs,
                builder: (context) => Stack(
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
                                builder: (context, _) => widget.header != null
                                    ? KeyedSubtree(
                                        key: headerKey,
                                        child: KeyedSubtree(
                                          child: widget.header!(context),
                                          key: ValueKey(sbs),
                                        ))
                                    : SizedBox(height: 0),
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
              )),
    );
  }
}

class ArcaneSidebarHeader extends StatelessWidget {
  final List<Widget> trailing;
  final List<Widget> leading;
  final Widget? child;
  final Widget? title;
  final Widget? barHeader;
  final Widget? barFooter;
  final String? titleText;
  final String? headerText;
  final String? subtitleText;
  final Widget? header; // small widget placed on top of title
  final Widget? subtitle; // small widget placed below title
  final bool
      trailingExpanded; // expand the trailing instead of the main content
  final Alignment alignment;
  final Color? backgroundColor;
  final double? leadingGap;
  final double? trailingGap;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final bool useGlass;
  final BarBackButtonMode backButton;
  final bool ignoreContextSignals;
  final BarActions? actions;
  final PylonBuilder? collapsedBuilder;
  final VoidCallback? onTitleClick;

  const ArcaneSidebarHeader(
      {super.key,
      this.ignoreContextSignals = true,
      this.trailing = const [],
      this.leading = const [],
      this.titleText,
      this.backButton = BarBackButtonMode.never,
      this.headerText,
      this.subtitleText,
      this.title,
      this.actions,
      this.collapsedBuilder,
      this.header,
      this.subtitle,
      this.child,
      this.trailingExpanded = false,
      this.alignment = Alignment.center,
      this.padding,
      this.backgroundColor,
      this.leadingGap,
      this.trailingGap,
      this.height,
      this.barHeader,
      this.barFooter,
      this.onTitleClick,
      this.useGlass = true});

  @override
  Widget build(BuildContext context) {
    bool e = context.isSidebarExpanded;

    if (collapsedBuilder != null && !e) {
      return collapsedBuilder!(context);
    }

    return Bar(
      title:
          !e ? null : (title ?? (titleText != null ? Text(titleText!) : null)),
      subtitle: !e
          ? null
          : (subtitle ?? (subtitleText != null ? Text(subtitleText!) : null)),
      header: !e ? null : header,
      actions: !e ? null : actions,
      backButton: backButton,
      barHeader: !e ? null : barHeader,
      barFooter: !e ? null : barFooter,
      trailing: !e ? const [] : trailing,
      leading: leading,
      trailingExpanded: trailingExpanded,
      alignment: alignment,
      backgroundColor: backgroundColor,
      leadingGap: leadingGap,
      trailingGap: trailingGap,
      padding: padding,
      height: height,
      useGlass: useGlass,
      ignoreContextSignals: ignoreContextSignals,
      titleText: !e ? null : titleText,
      headerText: !e ? null : headerText,
      onTitleClick: !e ? null : onTitleClick,
      subtitleText: !e ? null : subtitleText,
      child: !e ? null : child,
    );
  }
}

class ArcaneSidebarFooter extends StatelessWidget {
  final Widget content;
  final Widget trailing;

  // Cant be const because pylon
  // ignore: prefer_const_constructors_in_immutables
  ArcaneSidebarFooter(
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
        onPressed: (context.pylonOr<ArcaneDrawerSignal>()?.open ?? false)
            ? () => Arcane.closeDrawer(context)
            : () => context.modPylon<ArcaneSidebarState>((i) =>
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
  Widget build(BuildContext context) => AnimatedPadding(
      padding:
          EdgeInsets.symmetric(horizontal: context.isSidebarExpanded ? 16 : 0),
      duration: const Duration(milliseconds: 333),
      curve: Curves.easeOutCirc,
      child: AnimatedContainer(
          decoration: BoxDecoration(
            color: selected ? Theme.of(context).colorScheme.muted : null,
            borderRadius: Theme.of(context).borderRadiusMd,
          ),
          duration: const Duration(milliseconds: 333),
          curve: Curves.easeOutCirc,
          child: context.isSidebarExpanded
              ? GhostButton(
                  density: ButtonDensity.compact,
                  onPressed: onTap,
                  child: Row(
                    children: [
                      icon.pad(8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (label != null) Text(label!).normal(),
                          if (subLabel != null) Text(subLabel!).muted().small(),
                        ],
                      )
                    ],
                  ).padLeft(8),
                )
              : IconButton(icon: icon, onPressed: onTap)));
}

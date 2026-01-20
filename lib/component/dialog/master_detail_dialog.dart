import 'package:arcane/arcane.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

List<Widget> _defWList(BuildContext context) => [];
Widget _defSliver(BuildContext context) => SliverToBoxAdapter();

class MasterDetailDialog extends StatefulWidget with ArcaneDialogLauncher {
  final Bar? header;
  final List<MasterDetailTab> tabs;
  final bool hideSidebarIfSingleTab;
  final double sidebarWidth;
  final int initialTab;

  const MasterDetailDialog({
    super.key,
    this.header,
    this.initialTab = 0,
    this.sidebarWidth = 150,
    this.tabs = const [],
    this.hideSidebarIfSingleTab = true,
  });

  @override
  State<MasterDetailDialog> createState() => _MasterDetailDialogState();
}

class _MasterDetailDialogState extends State<MasterDetailDialog> {
  int index = 0;
  final GlobalKey _navKey = GlobalKey();

  @override
  void initState() {
    index = widget.initialTab;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<NavItem> nTabs = [
      ...widget.tabs.expand(
        (e) => [
          NavTab(
            label: e.label ?? '',
            icon: e.icon,
            selectedIcon: e.icon,
            builder: (context) => Screen(
              gutter: false,
              header: (e.header ?? widget.header)?.copyWith(
                backButton: BarBackButtonMode.never,
              ),
              child: e.child,
            ),
          ),
        ],
      ),
    ];

    void onChanged(int i) {
      setState(() {
        index = i;
      });
    }

    double sidebarPrefixPadding = 8;
    Widget sidebarFooter(BuildContext context) => ArcaneSidebarFooter();
    Widget sidebarHeader(BuildContext context) => GhostButton(
      onPressed: () => Arcane.pop(context),
      leading: Icon(Icons.check),
      child: context.isSidebarExpanded ? Text("Done") : Container(),
    );

    return ClipRRect(
      borderRadius: Theme.of(context).borderRadiusLg,
      child: NavigationScreen(
        key: _navKey,
        index: index,
        onIndexChanged: onChanged,
        sidebarPrefixPadding: sidebarPrefixPadding,
        type: NavigationType.custom,
        sidebarWidth: widget.sidebarWidth,
        customNavigationBuilder: (context, nav, i) => Scaffold(
          child: Pylon<ArcaneSidebarInjector>(
            local: false,
            value: ArcaneSidebarInjector(
              (context) => _MasterDetailSidebar(
                width: widget.sidebarWidth,
                children: (context) =>
                    [
                      if (sidebarPrefixPadding > 0)
                        SizedBox(height: sidebarPrefixPadding),
                      ...nTabs.whereType<NavTab>().mapIndexed(
                        (e, i) => _MasterDetailSidebarButton(
                          trailing: widget.tabs[i].trailing,
                          icon: Icon(
                            index == i ? e.selectedIcon ?? e.icon : e.icon,
                          ),
                          label:
                              e.label?.split(":").last ?? "Item ${index + 1}",
                          selected: index == i,
                          onTap: () {
                            if (index != i) {
                              onChanged(i);
                            }
                          },
                        ),
                      ),
                    ].joinSeparator(
                      SizedBox(
                        height: ArcaneTheme.of(
                          context,
                        ).navigationScreen.sidebarSpacing,
                      ),
                    ),
                header: sidebarHeader,
                footer: sidebarFooter,
              ),
            ),
            builder: (context) {
              int trueIndex = 0;

              for (int ti = 0; ti < i; ti++) {
                if (nav.tabs[ti] is NavTab) {
                  trueIndex++;
                }
              }

              return nav.tabs.whereType<NavTab>().toList()[trueIndex].builder(
                context,
              );
            },
          ),
        ),
        sidebarHeader: sidebarHeader,
        sidebarFooter: sidebarFooter,
        tabs: nTabs,
      ),
    );
  }
}

class MasterDetailTab extends StatelessWidget {
  final IconData icon;
  final String? label;
  final String? subLabel;
  final VoidCallback? onTap;
  final bool selected;
  final Widget? trailing;
  final Bar? header;
  final Widget child;

  const MasterDetailTab({
    super.key,
    this.header,
    required this.child,
    required this.icon,
    this.label,
    this.trailing,
    this.subLabel,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _MasterDetailSidebar extends StatefulWidget {
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

  const _MasterDetailSidebar({
    super.key,
    this.header,
    this.width = 250,
    this.expansionAnimationCurve = Curves.easeOutCirc,
    this.expansionAnimationDuration = const Duration(milliseconds: 333),
    this.footer,
    this.collapsedWidth = 52,
    this.sidebarDivider = true,
    required this.children,
  }) : _isSliver = false,
       sliver = _defSliver;

  const _MasterDetailSidebar.sliver({
    super.key,
    this.header,
    this.sidebarDivider = true,
    this.width = 250,
    this.expansionAnimationCurve = Curves.easeOutCirc,
    this.expansionAnimationDuration = const Duration(milliseconds: 333),
    this.footer,
    this.collapsedWidth = 50,
    required this.sliver,
  }) : _isSliver = true,
       children = _defWList;

  @override
  State<_MasterDetailSidebar> createState() => _MasterDetailSidebarState();
}

class _MasterDetailSidebarState extends State<_MasterDetailSidebar> {
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
      : SListView(children: widget.children(context));

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
      child: context.streamPylon<ArcaneSidebarState>().build(
        (sbs) => Pylon<ArcaneSidebarState>(
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
                                key: ValueKey(sbs),
                                child: widget.header!(context),
                              ),
                            )
                          : SizedBox(height: 0),
                      sliver: MultiSliver(
                        children: [
                          buildSliverContent(context),
                          SliverToBoxAdapter(
                            child: SizedBox(height: footerSize),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.footer != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: KeyedSubtree(
                    key: footerKey,
                    child: widget.footer!(context),
                  ),
                ),
              if (widget.sidebarDivider)
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: Theme.of(context).colorScheme.muted,
                    width: 1,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MasterDetailSidebarButton extends StatelessWidget {
  final Widget icon;
  final String? label;
  final String? subLabel;
  final VoidCallback? onTap;
  final bool selected;
  final Widget? trailing;

  const _MasterDetailSidebarButton({
    super.key,
    required this.icon,
    this.label,
    this.trailing,
    this.subLabel,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) => AnimatedPadding(
    key: ValueKey("mdte_$label"),
    padding: EdgeInsets.symmetric(horizontal: 0),
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
              trailing: trailing,
              child: Row(
                children: [icon.pad(8), Text(label!).normal()],
              ).padLeft(8),
            )
          : IconButton(icon: icon, onPressed: onTap).withTooltip(label ?? ''),
    ),
  );
}

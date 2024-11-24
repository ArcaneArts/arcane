import 'package:arcane/arcane.dart';

class NavTab {
  final String? label;
  final IconData icon;
  final IconData? selectedIcon;
  final Widget Function(BuildContext, Widget?) builder;

  const NavTab({
    this.label,
    required this.icon,
    this.selectedIcon,
    required this.builder,
  });
}

enum NavigationType { bottomNavigationBar, navigationRail, sidebar, drawer }

class NavigationScreen extends AbstractStatelessScreen {
  final int index;
  final NavigationType type;
  final ValueChanged<int>? onIndexChanged;
  final double siderailRightPadding;
  final List<NavTab> tabs;
  final Widget? overrideSidebarGap;
  final double siderailTopPadding;
  final bool endSide;
  const NavigationScreen(
      {super.key,
      this.siderailRightPadding = 8,
      this.index = 0,
      this.overrideSidebarGap,
      this.siderailTopPadding = 8,
      this.onIndexChanged,
      required this.tabs,
      this.endSide = false,
      this.type = NavigationType.bottomNavigationBar});

  Widget buildBottomNavigationBar(BuildContext context, int index) => ButtonBar(
      selectedIndex: index,
      buttons: tabs
          .mapIndexed((tab, barIndex) => IconTab(
                icon: tab.icon,
                selectedIcon: tab.selectedIcon ?? tab.icon,
                label: tab.label,
                onPressed: index == barIndex
                    ? null
                    : () => onIndexChanged?.call(barIndex),
              ))
          .toList());

  Widget buildNavigationRail(BuildContext context, int index) => Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Gap(5),
          if (Navigator.canPop(context))
            SafeArea(
                top: true,
                child: GhostButton(
                    density: ButtonDensity.icon,
                    child: context.inSheet
                        ? const Icon(Icons.x_bold)
                        : const Icon(Icons.caret_left_bold),
                    onPressed: () => Arcane.pop(context))),
          ...tabs
              .mapIndexed((tab, railIndex) => IconButton(
                    icon: Icon(
                        railIndex == index
                            ? (tab.selectedIcon ?? tab.icon)
                            : tab.icon,
                        color: railIndex == index
                            ? Theme.of(context).colorScheme.primary
                            : null),
                    onPressed: index == railIndex
                        ? null
                        : () => onIndexChanged?.call(railIndex),
                  ))
              .toList(),
        ],
      ).padTop(siderailTopPadding);

  Widget buildSidebar(BuildContext context, int index, {bool drawer = false}) =>
      NavigationSidebar(
        labelType: NavigationLabelType.expanded,
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 150),
        index: index,
        children: [
          if (Navigator.canPop(context)) ...[
            NavigationButton(
              index: -1,
              child: Icon(Icons.caret_left_bold),
              onChanged: (e) => Arcane.pop(context),
              label: Text("Back"),
            ),
            NavigationGap(16)
          ],
          ...tabs.mapIndexed((e, i) => NavigationButton(
              onChanged: (e) {
                if (drawer) {
                  Arcane.closeDrawer(context);
                }

                if (index != i) {
                  onIndexChanged?.call(i);
                }
              },
              index: i,
              label: Text(e.label ?? "Item ${index + 1}"),
              child: Icon(index == i ? e.selectedIcon ?? e.icon : e.icon)))
        ],
      ).padTop(siderailTopPadding);

  @override
  Widget build(BuildContext context) => DrawerOverlay(
          child: Pylon<NavigationType>(
        value: type,
        local: true,
        builder: (context) => IndexedStack(
          index: index,
          children: tabs
              .mapIndexed((tab, index) => switch (type) {
                    NavigationType.drawer => InjectBarEnds(
                        trailing: endSide,
                        start: !endSide,
                        children: (context) => [
                          IconButton(
                              icon: Icon(Icons.menu_ionic),
                              onPressed: () {
                                openDrawer(
                                    expands: false,
                                    showDragHandle: false,
                                    context: context,
                                    builder: (context) => Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            SingleChildScrollView(
                                              child: buildSidebar(
                                                  context, index,
                                                  drawer: true),
                                            )
                                          ],
                                        ),
                                    position: endSide
                                        ? OverlayPosition.right
                                        : OverlayPosition.left);
                              })
                        ],
                        builder: (context) =>
                            tabs[index].builder(context, null),
                      ),
                    NavigationType.bottomNavigationBar => tabs[index].builder(
                        context, buildBottomNavigationBar(context, index)),
                    NavigationType.sidebar => Scaffold(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            buildSidebar(context, index),
                            overrideSidebarGap ?? Gap(siderailRightPadding),
                            Expanded(
                              child: BlockBackButton(
                                  builder: (context) =>
                                      tabs[index].builder(context, null)),
                            ),
                          ],
                        ),
                      ),
                    NavigationType.navigationRail => Scaffold(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            buildNavigationRail(context, index),
                            Gap(siderailRightPadding),
                            Expanded(
                              child: BlockBackButton(
                                  builder: (context) =>
                                      tabs[index].builder(context, null)),
                            ),
                          ],
                        ),
                      ),
                  })
              .toList(),
        ),
      ));
}

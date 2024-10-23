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

enum NavigationType { bottomNavigationBar, navigationRail, sidebar }

class NavigationScreen extends AbstractStatelessScreen {
  final int index;
  final NavigationType type;
  final ValueChanged<int>? onIndexChanged;
  final double siderailRightPadding;
  final List<NavTab> tabs;
  final double siderailTopPadding;
  const NavigationScreen(
      {super.key,
      this.siderailRightPadding = 8,
      this.index = 0,
      this.siderailTopPadding = 8,
      this.onIndexChanged,
      required this.tabs,
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

  Widget buildSidebar(BuildContext context, int index) => NavigationSidebar(
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
  Widget build(BuildContext context) => IndexedStack(
        index: index,
        children: tabs
            .mapIndexed((tab, index) => switch (type) {
                  NavigationType.bottomNavigationBar => tabs[index].builder(
                      context, buildBottomNavigationBar(context, index)),
                  NavigationType.sidebar => Scaffold(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildSidebar(context, index),
                          Gap(siderailRightPadding),
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
      );
}

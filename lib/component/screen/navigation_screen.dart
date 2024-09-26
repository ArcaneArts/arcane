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

enum NavigationType { bottomNavigationBar, navigationRail }

class NavigationScreen extends AbstractStatelessScreen {
  final int index;
  final NavigationType type;
  final ValueChanged<int>? onIndexChanged;
  final List<NavTab> tabs;
  const NavigationScreen(
      {super.key,
      this.index = 0,
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
      );

  @override
  Widget build(BuildContext context) => IndexedStack(
        index: index,
        children: tabs
            .mapIndexed((tab, index) => switch (type) {
                  NavigationType.bottomNavigationBar => tabs[index].builder(
                      context, buildBottomNavigationBar(context, index)),
                  NavigationType.navigationRail => Scaffold(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildNavigationRail(context, index),
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

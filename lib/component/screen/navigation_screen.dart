import 'package:arcane/arcane.dart';

Widget _defaultDivider(BuildContext context) => const Divider();

abstract class NavItem {
  final Widget Function(BuildContext) builder;

  const NavItem({
    required this.builder,
  });
}

class NavDivider extends NavWidget {
  const NavDivider() : super(builder: _defaultDivider);
}

class NavWidget extends NavItem {
  const NavWidget({
    required super.builder,
  });
}

class NavTab extends NavWidget {
  final String? label;
  final IconData icon;
  final IconData? selectedIcon;

  const NavTab({
    this.label,
    required this.icon,
    this.selectedIcon,
    required super.builder,
  });
}

enum NavigationType {
  bottomNavigationBar,
  navigationRail,
  sidebar,
  drawer,
  custom
}

class NavigationTheme {
  final NavigationType type;
  final double sidebarSpacing;
  final double railRightPadding;
  final double railTopPadding;
  final bool endSide;
  final bool drawerTransformsBackdrop;

  const NavigationTheme({
    this.railRightPadding = 8,
    this.railTopPadding = 8,
    this.sidebarSpacing = 4,
    this.endSide = false,
    this.drawerTransformsBackdrop = false,
    this.type = NavigationType.bottomNavigationBar,
  });

  NavigationTheme copyWith({
    NavigationType? type,
    double? sidebarSpacing,
    double? railRightPadding,
    double? railTopPadding,
    bool? endSide,
    bool? drawerTransformsBackdrop,
  }) =>
      NavigationTheme(
        type: type ?? this.type,
        sidebarSpacing: sidebarSpacing ?? this.sidebarSpacing,
        railRightPadding: railRightPadding ?? this.railRightPadding,
        railTopPadding: railTopPadding ?? this.railTopPadding,
        endSide: endSide ?? this.endSide,
        drawerTransformsBackdrop:
            drawerTransformsBackdrop ?? this.drawerTransformsBackdrop,
      );
}

class NavigationScreen extends AbstractStatelessScreen {
  final int index;
  final double? sidebarSpacing;
  final double sidebarWidth;
  final NavigationType? type;
  final ValueChanged<int>? onIndexChanged;
  final double? railRightPadding;
  final List<NavItem> tabs;
  final double? railTopPadding;
  final bool? endSide;
  final PylonBuilder? sidebarFooter;
  final PylonBuilder? sidebarHeader;
  final bool? drawerTransformsBackdrop;
  final Widget Function(BuildContext, NavigationScreen, int)?
      customNavigationBuilder;

  const NavigationScreen(
      {super.key,
      this.sidebarHeader,
      this.railRightPadding,
      this.index = 0,
      this.sidebarWidth = 250,
      this.railTopPadding,
      this.sidebarSpacing,
      this.drawerTransformsBackdrop,
      this.onIndexChanged,
      this.sidebarFooter,
      required this.tabs,
      this.customNavigationBuilder,
      this.endSide,
      this.type});

  Widget buildBottomNavigationBar(BuildContext context, int index) => ButtonBar(
      selectedIndex: index,
      buttons: tabs
          .whereType<NavTab>()
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
              .mapIndexed((tab, railIndex) => switch (tab) {
                    NavTab tab => IconButton(
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
                      ),
                    NavItem item => item.builder(context),
                  })
              .toList(),
        ],
      ).padTop(railTopPadding ??
          ArcaneTheme.of(context).navigationScreen.railTopPadding);

  Widget buildSidebar(BuildContext context, int index, {bool drawer = false}) =>
      ArcaneSidebar(
          width: sidebarWidth,
          children: (context) => [
                ...tabs.mapIndexed((e, i) => switch (e) {
                      NavTab e => ArcaneSidebarButton(
                          icon: Icon(
                              index == i ? e.selectedIcon ?? e.icon : e.icon),
                          label: e.label ?? "Item ${index + 1}",
                          selected: index == i,
                          onTap: () {
                            if (drawer) {
                              Arcane.closeDrawer(context);
                            }

                            if (index != i) {
                              onIndexChanged?.call(i);
                            }
                          },
                        ),
                      NavItem e => e.builder(context),
                    })
              ].joinSeparator(SizedBox(
                  height: sidebarSpacing ??
                      ArcaneTheme.of(context).navigationScreen.sidebarSpacing)),
          header: sidebarHeader == null
              ? null
              : drawer
                  ? (context) =>
                      context.streamPylon<ArcaneSidebarState?>().build((st) {
                        if (st == ArcaneSidebarState.collapsed) {
                          Arcane.closeDrawer(context);
                        }

                        context.setPylon(ArcaneSidebarState.expanded);
                        return Pylon<ArcaneDrawerSignal?>(
                          local: true,
                          value: ArcaneDrawerSignal(true),
                          builder: sidebarHeader,
                        );
                      })
                  : sidebarHeader,
          footer: sidebarFooter == null
              ? null
              : drawer
                  ? (context) =>
                      context.streamPylon<ArcaneSidebarState?>().build((st) {
                        if (st == ArcaneSidebarState.collapsed) {
                          Arcane.closeDrawer(context);
                        }

                        context.setPylon(ArcaneSidebarState.expanded);
                        return Pylon<ArcaneDrawerSignal?>(
                          local: true,
                          value: ArcaneDrawerSignal(true),
                          builder: sidebarFooter,
                        );
                      })
                  : sidebarFooter);

  @override
  Widget build(BuildContext context) => WindowBar(child: DrawerOverlay(
      child: Pylon<NavigationType?>(
        value: type ?? ArcaneTheme.of(context).navigationScreen.type,
        local: false,
        builder: (context) => MutablePylon<ArcaneSidebarState>(
          value: ArcaneSidebarState.expanded,
          builder: (context) => IndexedStack(
            index: index,
            children: tabs
                .mapIndexed((tab, index) => switch (
            type ?? ArcaneTheme.of(context).navigationScreen.type) {
              NavigationType.custom =>
                  customNavigationBuilder!(context, this, index),
              NavigationType.drawer => InjectBarEnds(
                trailing: endSide ??
                    ArcaneTheme.of(context).navigationScreen.endSide,
                start: !(endSide ??
                    ArcaneTheme.of(context).navigationScreen.endSide),
                children: (context) => [
                  IconButton(
                      icon: Icon(Icons.menu_ionic),
                      onPressed: () {
                        openDrawer(
                            expands: false,
                            showDragHandle: false,
                            transformBackdrop:
                            drawerTransformsBackdrop ??
                                ArcaneTheme.of(context)
                                    .navigationScreen
                                    .drawerTransformsBackdrop,
                            context: context,
                            builder: (context) =>
                                MutablePylon<ArcaneSidebarState>(
                                    value:
                                    ArcaneSidebarState.expanded,
                                    builder: (context) =>
                                        buildSidebar(context, index,
                                            drawer: true)),
                            position: (endSide ??
                                ArcaneTheme.of(context)
                                    .navigationScreen
                                    .endSide)
                                ? OverlayPosition.right
                                : OverlayPosition.left);
                      })
                ],
                builder: (context) => tabs[index].builder(context),
              ),
              NavigationType.bottomNavigationBar => InjectScreenFooter(
                  footer: (context) =>
                      buildBottomNavigationBar(context, index),
                  builder: (context) => tabs[index].builder(context)),
              NavigationType.sidebar => Scaffold(
                child: Pylon<ArcaneSidebarInjector?>(
                  local: true,
                  value: ArcaneSidebarInjector((context) =>
                      buildSidebar(context, index, drawer: false)),
                  builder: tabs[index].builder,
                ),
              ),
              NavigationType.navigationRail => Scaffold(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildNavigationRail(context, index),
                    Gap(railRightPadding ??
                        ArcaneTheme.of(context)
                            .navigationScreen
                            .railRightPadding),
                    Expanded(
                      child: BlockBackButton(
                          builder: (context) =>
                              tabs[index].builder(context)),
                    ),
                  ],
                ),
              ),
            })
                .toList(),
          ),
        ),
      )));
}

class ArcaneSidebarInjector {
  final Widget Function(BuildContext) builder;

  const ArcaneSidebarInjector(this.builder);
}

class ArcaneDrawerSignal {
  final bool open;

  const ArcaneDrawerSignal(this.open);
}

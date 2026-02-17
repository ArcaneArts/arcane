import 'package:arcane/arcane.dart';

Widget _defaultDivider(BuildContext context) => const Divider();

/// A base abstract class representing a navigation item in Arcane's [NavigationScreen].
///
/// Navigation items define content builders that integrate with various navigation types
/// such as [BottomNavigationBar], [Sidebar], or [NavigationRail]. This class serves as
/// the foundation for both simple widgets and tab-based items, enabling efficient
/// content switching via [IndexedStack] while maintaining theme consistency through
/// [ArcaneTheme].
abstract class NavItem {
  final Widget Function(BuildContext) builder;

  const NavItem({
    required this.builder,
  });
}

/// A predefined divider navigation item for use in [NavigationScreen]'s sidebar or rail.
///
/// This item inserts a standard [Divider] between navigation tabs, providing visual
/// separation in layouts like [Sidebar] or [NavigationRail]. It extends [NavItem]
/// for seamless integration with Arcane's navigation patterns, ensuring minimal
/// rebuilds and consistent spacing via [ArcaneTheme].
class NavDivider extends NavWidget {
  const NavDivider() : super(builder: _defaultDivider);
}

/// A navigation item that renders a custom widget in [NavigationScreen].
///
/// Use this for non-tab elements like dividers or custom UI in navigation rails,
/// sidebars, or drawers. It builds content via a provided [builder] function,
/// supporting dynamic rendering based on context, such as theme-aware styling
/// from [ArcaneTheme]. Integrates with [Navigator] for route-aware layouts.
class NavWidget extends NavItem {
  const NavWidget({
    required super.builder,
  });
}

/// A tab-based navigation item for [NavigationScreen], featuring icons and labels.
///
/// This class supports both selected and unselected states for icons, enabling
/// adaptive UIs in [BottomNavigationBar], [Sidebar], or [NavigationRail]. Labels
/// provide accessibility and visual cues, while the [builder] defines the tab's
/// content page. Use with [IndexedStack] for efficient state persistence during
/// navigation transitions, minimizing rebuilds in [ArcaneApp] integrations.
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

/// Theme configuration for [NavigationScreen], customizing layout behaviors.
///
/// This class extends [ArcaneTheme] capabilities, allowing adjustments to spacing,
/// padding, and side alignments for different [NavigationType]s. It supports
/// efficient route caching and minimal rebuilds, ensuring performant navigation
/// in [ArcaneApp]. Use [copyWith] to override defaults dynamically based on
/// device or user preferences.
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

  /// Creates a copy of this [NavigationTheme] with specified properties replaced.
  ///
  /// This method facilitates theme updates without full recreation, supporting
  /// reactive UIs in [ArcaneTheme]. It preserves performance by avoiding
  /// unnecessary widget rebuilds during navigation state changes.
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

/// A versatile navigation hub screen extending [AbstractScreen] for Arcane apps.
///
/// [NavigationScreen] manages tab-based routing with support for multiple UI types
/// via [NavigationType], integrating [Sidebar], [BottomNavigationBar], and
/// [NavigationRail] for responsive layouts. It uses [IndexedStack] for content
/// persistence, ensuring efficient navigation with minimal rebuilds and haptic
/// feedback on changes. Customizable via [ArcaneTheme] for spacing and alignment,
/// it works with [Navigator] for push/pop operations and [MaterialPageRoute]
/// transitions, ideal for [ArcaneApp] dashboards or multi-section interfaces.
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
  final double sidebarPrefixPadding;
  final Widget Function(BuildContext, NavigationScreen, int)?
      customNavigationBuilder;

  /// Constructs a [NavigationScreen] with required tabs and optional customizations.
  ///
  /// The [tabs] list defines navigable sections via [NavItem] builders, with [index]
  /// setting the initial active tab. Callbacks like [onIndexChanged] enable parent
  /// coordination, while theme overrides (e.g., [sidebarSpacing], [railRightPadding])
  /// allow layout tweaks. For custom UIs, provide [customNavigationBuilder]; otherwise,
  /// defaults to [NavigationType] from [ArcaneTheme]. Supports drawer overlays with
  /// [drawerTransformsBackdrop] for backdrop effects during [Navigator] interactions.
  const NavigationScreen(
      {super.key,
      this.sidebarHeader,
      this.railRightPadding,
      this.index = 0,
      this.sidebarPrefixPadding = 8,
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

  /// Handles index changes with haptic feedback and optional callback invocation.
  ///
  /// This private method triggers [Arcane.hapticViewChange] for tactile response
  /// and notifies listeners via [onIndexChanged], facilitating state management
  /// in parent widgets like [ArcaneApp]. It ensures smooth transitions without
  /// full rebuilds, integrating with [IndexedStack] for content preservation.
  void _onChanged(int index) {
    Arcane.hapticViewChange();
    onIndexChanged?.call(index);
  }

  /// Builds a [BottomNavigationBar]-style navigation for mobile layouts.
  ///
  /// Renders [NavTab] items as tappable icons with labels, using [ButtonBar]
  /// for selection state. Integrates with [ArcaneTheme] for styling and
  /// supports disabled states for the active tab. Efficient for touch-based
  /// navigation, pairing with [IndexedStack] to avoid content recreation
  /// during switches.
  Widget buildBottomNavigationBar(BuildContext context, int index) => ButtonBar(
      selectedIndex: index,
      buttons: tabs
          .whereType<NavTab>()
          .mapIndexed((tab, barIndex) => IconTab(
                icon: tab.icon,
                selectedIcon: tab.selectedIcon ?? tab.icon,
                label: tab.label,
                onPressed:
                    index == barIndex ? null : () => _onChanged(barIndex),
              ))
          .toList());

  /// Constructs a [NavigationRail] for compact vertical navigation.
  ///
  /// Displays [NavItem]s as icon buttons with color-coded selection via
  /// [Theme.of(context).colorScheme.primary]. Includes a back button if
  /// [Navigator.canPop] is true, supporting hierarchical routing. Padded
  /// with [railTopPadding] for ergonomic placement, it expands content
  /// horizontally with [Expanded] for full-screen views, minimizing
  /// layout shifts in [AbstractScreen] extensions.
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
                            : () => _onChanged(railIndex),
                      ),
                    NavItem item => item.builder(context),
                  })
              .toList(),
        ],
      ).padTop(railTopPadding ??
          ArcaneTheme.of(context).navigationScreen.railTopPadding);

  /// Renders a [Sidebar] for expansive navigation, optional as drawer overlay.
  ///
  /// Builds [ArcaneSidebar] with [NavItem]s as buttons, supporting headers/footers
  /// via [sidebarHeader] and [sidebarFooter]. For drawers, handles state expansion
  /// and backdrop transforms with [drawerTransformsBackdrop], integrating [Pylon]
  /// for signal management. Uses [sidebarSpacing] for separators, ensuring
  /// performant rendering with [Arcane.closeDrawer] on selection in overlay mode.
  /// Aligns with [endSide] for RTL/LTR support in [ArcaneTheme].
  Widget buildSidebar(BuildContext context, int index, {bool drawer = false}) =>
      ArcaneSidebar(
          width: sidebarWidth,
          children: (context) => [
                if (sidebarPrefixPadding > 0)
                  SizedBox(height: sidebarPrefixPadding),
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
                              _onChanged(i);
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

  /// Builds the main [NavigationScreen] UI with type-specific layouts.
  ///
  /// Uses [Pylon] for theme-aware [NavigationType] resolution and [MutablePylon]
  /// for sidebar state. Renders content via [IndexedStack] for persistence,
  /// wrapping in [DrawerOverlay] for drawer support. Handles custom builders,
  /// injects navigation controls (e.g., menu button for drawers, rail/sidebar),
  /// and blocks back navigation in rails. Ensures efficient [Navigator]
  /// integration with [PageRoute] transitions and [ArcaneTheme] styling for
  /// seamless [AbstractScreen] usage in [ArcaneApp].
  @override
  Widget build(BuildContext context) => DrawerOverlay(
          child: Pylon<NavigationType?>(
        value: type ?? ArcaneTheme.of(context).navigationScreen.type,
        local: false,
        builder: (context) => MutablePylon<ArcaneSidebarState>(
          local: true,
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
                                              local: true,
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
      ));
}

/// Injector for embedding [Sidebar] into [Scaffold] layouts in [NavigationScreen].
///
/// Provides a builder function to render sidebar content, used with [Pylon] for
/// stateful injection. Ensures consistent integration with [ArcaneTheme] and
/// [AbstractScreen], supporting dynamic width and spacing without affecting
/// main content flow.
class ArcaneSidebarInjector {
  final Widget Function(BuildContext) builder;

  const ArcaneSidebarInjector(this.builder);
}

/// Signal for managing drawer open state in [NavigationScreen] drawers.
///
/// Used with [Pylon] to propagate open/close signals, enabling reactive
/// backdrop transforms and sidebar expansion. Integrates with [Arcane.closeDrawer]
/// for smooth [Navigator]-like overlays, preserving performance in mobile
/// and tablet views.
class ArcaneDrawerSignal {
  final bool open;

  const ArcaneDrawerSignal(this.open);
}

import 'package:arcane/arcane.dart';

/// An individual tab in a bottom navigation bar.
///
/// This widget represents a single selectable tab within a [ButtonBar], featuring an icon
/// that can change based on selection state and optional accessibility label. It integrates
/// with the Arcane UI system by leveraging [Pylon] for state propagation and [IconButton]
/// for interactive rendering, automatically applying theme-based coloring from [ArcaneTheme]
/// to highlight the selected state. Use [IconTab] instances within a [ButtonBar] to create
/// intuitive bottom navigation for mobile or tablet interfaces in Arcane applications,
/// ensuring smooth transitions between sections like [Section] or [Tabbed] views.
///
/// Key features:
/// - Supports distinct icons for selected and unselected states.
/// - Handles tap callbacks for navigation logic.
/// - Accessibility-friendly with optional labels.
/// - Thematically styled to match [ArcaneTheme]'s color scheme.
///
/// See also:
/// * [ButtonBar], the container widget that manages multiple [IconTab] instances.
/// * [IconButton], used internally for the tab's interactive element.
/// * [Pylon], for propagating selection state to child widgets.
/// * [doc/component/bottom_navigation_bar.md] for usage examples and integration details.
class IconTab extends StatelessWidget {
  /// The icon to display when this tab is not selected.
  final IconData icon;

  /// Optional alternate icon to display when this tab is selected.
  /// If null, [icon] will be used in both states.
  final IconData? selectedIcon;

  /// Optional text label to display with the icon.
  /// Currently used primarily for accessibility.
  final String? label;

  /// Function to call when the tab is pressed.
  final VoidCallback? onPressed;

  /// Creates an [IconTab] for use in a [ButtonBar].
  ///
  /// The [icon] parameter is required and specifies the base icon for the tab,
  /// which displays in the unselected state and falls back for selected if [selectedIcon]
  /// is not provided. The [selectedIcon] allows customization of the highlighted appearance.
  /// The [label] provides semantic information for screen readers, enhancing accessibility
  /// in compliance with Arcane's inclusive design principles. The [onPressed] callback
  /// enables navigation or state updates, typically integrating with a parent [ButtonBar]'s
  /// selection logic to switch between app sections.
  ///
  /// Example usage within a [ButtonBar]:
  /// ```dart
  /// IconTab(
  ///   icon: Icons.home,
  ///   selectedIcon: Icons.home_outlined,
  ///   label: 'Home',
  ///   onPressed: () => _navigateToHome(),
  /// )
  /// ```
  ///
  /// This constructor initializes the widget as const for performance optimization
  /// in Flutter's widget tree.
  const IconTab(
      {super.key,
      required this.icon,
      this.selectedIcon,
      this.label,
      this.onPressed});

  /// Builds the [IconTab] widget, rendering an [IconButton] that responds to the
  /// current selection state propagated via [Pylon].
  ///
  /// This method queries the widget tree for the [_IsSelectedBottomIndex] state
  /// using [PylonOr] to determine if the tab is selected. It then constructs an
  /// [IconButton] with the appropriate icon (selected or default) and applies
  /// primary color from [ArcaneTheme] for visual feedback. The [onPressed] callback
  /// is wired to handle user interactions, facilitating seamless navigation within
  /// the Arcane UI ecosystem.
  ///
  /// Returns a fully interactive [IconButton] widget ready for embedding in a [ButtonBar].
  @override
  Widget build(BuildContext context) {
    bool selected =
        context.pylonOr<_IsSelectedBottomIndex>()?.selected ?? false;

    return IconButton(
      onPressed: onPressed,
      icon: Icon(selected ? (selectedIcon ?? icon) : icon,
          color: selected ? Theme.of(context).colorScheme.primary : null),
    );
  }
}

/// Internal class used to propagate selection state to child tabs.
///
/// This utility class encapsulates the selection status for an [IconTab] within a [ButtonBar].
/// It is injected via [Pylon] to enable reactive updates without direct parent-child
/// communication, aligning with Arcane's state management patterns. Use this internally
/// when building custom navigation components that extend [ButtonBar] functionality,
/// ensuring tabs respond dynamically to index changes while integrating with [ArcaneTheme].
///
/// Key features:
/// - Simple boolean flag for selected state.
/// - Const constructor for efficient widget rebuilding.
/// - Designed for use with [Pylon] in the Arcane widget tree.
class _IsSelectedBottomIndex {
  /// Indicates whether the associated tab is currently selected.
  final bool selected;

  /// Constructs an [_IsSelectedBottomIndex] instance with the given selection status.
  ///
  /// The [selected] parameter determines if the tab should render in its highlighted state.
  /// This constructor is const to support Flutter's optimization for immutable state objects,
  /// reducing rebuilds in performance-sensitive navigation UIs.
  const _IsSelectedBottomIndex(this.selected);
}

/// A bottom navigation bar that displays a row of selectable icon tabs.
///
/// The [ButtonBar] serves as a foundational navigation component in the Arcane UI system,
/// rendering a horizontal row of [IconTab] widgets within a [Bar] container. It manages
/// selection state centrally, propagating updates to individual tabs via [Pylon] and
/// [_IsSelectedBottomIndex], enabling smooth transitions and thematic consistency with
/// [ArcaneTheme]. Ideal for bottom navigation in mobile apps, it spaces tabs evenly and
/// supports integration with higher-level structures like [NavigationScreen] or [SliverScreen]
/// for full-screen navigation flows.
///
/// Key features:
/// - Automatic even spacing of tabs using [MainAxisAlignment.spaceEvenly].
/// - Centralized [selectedIndex] tracking for state management.
/// - No back button by default, focusing on forward navigation.
/// - Responsive to [ArcaneTheme] for color and layout adaptations.
///
/// See also:
/// * [IconTab], the building block for individual navigation items.
/// * [Bar], the enclosing container providing structural padding and elevation.
/// * [Pylon], for efficient state propagation to child widgets.
/// * [doc/component/bottom_navigation_bar.md] for advanced usage and theming examples.
class ButtonBar extends StatelessWidget {
  /// The index of the currently selected tab.
  final int selectedIndex;

  /// The list of icon tabs to display in the bar.
  final List<IconTab> buttons;

  /// Creates a [ButtonBar] widget.
  ///
  /// The [buttons] parameter is required and defines the collection of [IconTab]
  /// instances to render, each handling its own icon and callback logic. The
  /// [selectedIndex] specifies the active tab (defaults to 0), triggering visual
  /// updates across all tabs via [Pylon]. This constructor initializes the widget
  /// as const, promoting efficient rebuilding in Flutter's hot reload and runtime
  /// environments. It ensures the bar integrates seamlessly with Arcane's navigation
  /// patterns, such as switching between [Section] or [Tabbed] content areas.
  ///
  /// Example:
  /// ```dart
  /// ButtonBar(
  ///   selectedIndex: _currentIndex,
  ///   buttons: [
  ///     IconTab(
  ///       icon: Icons.home,
  ///       label: "Home",
  ///       onPressed: () => setState(() => _currentIndex = 0),
  ///     ),
  ///     IconTab(
  ///       icon: Icons.search,
  ///       label: "Search",
  ///       onPressed: () => setState(() => _currentIndex = 1),
  ///     ),
  ///   ],
  /// )
  /// ```
  ///
  /// This setup allows for dynamic navigation, where tapping a tab updates the
  /// app's state and potentially routes to new [Screen] implementations.
  const ButtonBar({super.key, this.selectedIndex = 0, required this.buttons});

  /// Builds the [ButtonBar] widget, constructing a [Bar] with embedded tabs.
  ///
  /// This method creates a [Bar] container configured without a back button, housing
  /// a [Row] of [IconTab] widgets. Each tab is wrapped in a [Pylon] that injects
  /// the [_IsSelectedBottomIndex] based on the [selectedIndex], enabling reactive
  /// rendering. The tabs are evenly spaced for balanced layout, and unique keys
  /// ensure stable widget identities during state changes. This build process
  /// respects [ArcaneTheme] for overall styling, making it suitable for bottom
  /// navigation in responsive Arcane applications.
  ///
  /// Returns a complete [Bar] widget ready for placement in a [Scaffold]'s bottomNavigationBar slot.
  @override
  Widget build(BuildContext context) => Bar(
        backButton: BarBackButtonMode.never,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buttons
              .mapIndexed((button, index) => Pylon<_IsSelectedBottomIndex>(
                    value: _IsSelectedBottomIndex(index == selectedIndex),
                    builder: (context) => button,
                    key: ValueKey("$index.${button.icon}.$index"),
                  ))
              .toList(),
        ),
      );
}

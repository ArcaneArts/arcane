import 'package:arcane/arcane.dart';

/// An individual tab in a bottom navigation bar.
///
/// This widget represents a single tab with an icon and optional label. It can display
/// different icons based on selection state and automatically applies appropriate styling.
///
/// See also:
///  * [doc/component/bottom_navigation_bar.md] for more detailed documentation
///  * [ButtonBar], which manages a collection of [IconTab] widgets
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
  /// The [icon] parameter is required and specifies the icon to display.
  /// If [selectedIcon] is provided, it will be shown when the tab is selected.
  /// The [label] is optional and provides accessibility information.
  /// The [onPressed] callback is triggered when the tab is tapped.
  const IconTab(
      {super.key,
      required this.icon,
      this.selectedIcon,
      this.label,
      this.onPressed});

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
class _IsSelectedBottomIndex {
  /// Indicates whether the associated tab is currently selected.
  final bool selected;

  const _IsSelectedBottomIndex(this.selected);
}

/// A bottom navigation bar that displays a row of selectable icon tabs.
///
/// The [ButtonBar] component displays a row of [IconTab] instances evenly spaced 
/// within a bar. It keeps track of which tab is currently selected and renders 
/// each tab with its appropriate selected state.
///
/// See also:
///  * [doc/component/bottom_navigation_bar.md] for more detailed documentation
///  * [IconTab], which represents the individual tabs in this bar
///  * [Bar], which this component uses as its container
class ButtonBar extends StatelessWidget {
  /// The index of the currently selected tab.
  final int selectedIndex;
  
  /// The list of icon tabs to display in the bar.
  final List<IconTab> buttons;

  /// Creates a [ButtonBar] widget.
  ///
  /// The [buttons] parameter is required and contains the list of tabs to display.
  /// The [selectedIndex] parameter indicates which tab should be shown as selected,
  /// defaulting to 0 (the first tab).
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
  const ButtonBar({super.key, this.selectedIndex = 0, required this.buttons});

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

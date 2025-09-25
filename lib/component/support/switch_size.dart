import 'package:arcane/arcane.dart';

/// A responsive utility widget that dynamically switches between child [Widget]s based on screen width breakpoints from [MediaQuery].
///
/// This component enables adaptive UI in Arcane applications by mapping logical pixel widths to specific widgets, ensuring layouts scale efficiently across devices.
/// It integrates seamlessly with [ArcaneTheme] for theme-aware scaling and is commonly used in responsive screens like [SliverScreen] or [FillScreen] to avoid full rebuilds during size transitions.
/// The sorted breakpoint approach provides O(n log n) initial sorting and O(n) selection for optimal performance in dynamic layouts.
class SwitchSize extends StatelessWidget {
  /// Creates a [SwitchSize] widget that switches between widgets at specified width breakpoints.
  ///
  /// The [sizes] map associates screen width thresholds (in logical pixels) with corresponding [Widget] variants; the widget for the largest breakpoint <= current width is selected.
  /// Use this for multi-variant responsive designs, such as switching from compact to expanded views in Arcane components.
  final Map<double, Widget> sizes;

  const SwitchSize({super.key, required this.sizes});

  /// Builds and returns the appropriate child [Widget] based on the current device screen width from [MediaQuery].
  ///
  /// Breakpoints from [sizes] are sorted ascending, then iterated to find the first matching threshold <= width, falling back to the largest if none match.
  /// This ensures efficient, non-rebuilding responsive switching, compatible with [LayoutBuilder] for nested layouts and [ArcaneTheme] scaling factors.
  @override
  Widget build(BuildContext context) {
    assert(sizes.isNotEmpty, "Sizes map cannot be empty");
    double width = MediaQuery.of(context).size.width;
    List<double> sk = sizes.keys.toList();
    sk.sort((a, b) => a.compareTo(b));
    for (double i in sk) {
      if (width <= i) {
        return sizes[i]!;
      }
    }

    return sizes[sk.last]!;
  }
}

/// A simple binary responsive widget that switches between large and small [Widget] children based on a 700px screen width threshold from [MediaQuery].
///
/// Designed for quick adaptive decisions in Arcane UI, such as toggling between detailed and compact representations in navigation or content areas like [BottomNavigationBar] or [Sidebar].
/// It promotes performance by using a direct ternary evaluation without sorting or iteration, ideal for frequent size checks.
class BigSmall extends StatelessWidget {
  /// Creates a [BigSmall] widget for binary responsive switching between big and small children.
  ///
  /// The [big] child is displayed on screens wider than 700 logical pixels, while [small] is used for narrower viewports.
  /// This constructor supports const initialization for efficient widget tree construction in Arcane apps.
  final Widget big;
  final Widget small;

  const BigSmall({super.key, required this.big, required this.small});

  @override
  Widget build(BuildContext context) =>
      MediaQuery.of(context).size.width > 700 ? big : small;
}

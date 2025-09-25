import 'dart:math';

import 'package:arcane/arcane.dart';

/// Default function for calculating gutter width based on screen width.
///
/// The calculation provides responsive horizontal padding that grows with screen width:
/// - For very small screens, minimal gutters are applied
/// - As screen width increases, gutters grow proportionally
/// - Gutters are capped at 1/3 of the screen width
///
/// Formula: max(0, min(max(0, 25 + ((screenWidth * 0.25) - 250)), screenWidth / 3))
double _defaultGutterCalc(double screenWidth) =>
    max(0, min(max(0, 25 + ((screenWidth * 0.25) - 250)), screenWidth / 3));

/// A theme class that defines how gutters should be calculated based on screen width.
///
/// [GutterTheme] provides configuration for the [Gutter] and [SliverGutter] components,
/// controlling how responsive horizontal padding is calculated across different screen sizes.
///
/// See also:
///  * [doc/component/gutter.md] for more detailed documentation
///  * [Gutter], which uses this theme to apply responsive horizontal padding
///  * [SliverGutter], which provides the same functionality for slivers
class GutterTheme {
  /// Function that calculates the gutter width based on screen width.
  ///
  /// The value returned is applied to both the left and right sides.
  final double Function(double screenWidth) gutterCalc;
  
  /// Whether gutters are enabled by default.
  final bool enabled;

  /// Creates a [GutterTheme] with the specified configuration.
  ///
  /// The [gutterCalc] parameter defaults to a function that provides responsive
  /// padding that grows with screen width while maintaining reasonable proportions.
  /// The [enabled] parameter controls whether gutters are applied by default.
  const GutterTheme(
      {this.gutterCalc = _defaultGutterCalc, this.enabled = true});

  /// Creates a copy of this GutterTheme with the given fields replaced.
  GutterTheme copyWith(
          {double Function(double screenWidth)? gutterCalc, bool? enabled}) =>
      GutterTheme(
          gutterCalc: gutterCalc ?? this.gutterCalc,
          enabled: enabled ?? this.enabled);
}

/// A widget that adds responsive horizontal padding to a sliver widget.
///
/// [SliverGutter] applies horizontal padding to sliver widgets for use in 
/// sliver-based scrolling layouts like [CustomScrollView]. The padding amount
/// is calculated based on the current screen width according to the [GutterTheme].
///
/// See also:
///  * [doc/component/gutter.md] for more detailed documentation
///  * [Gutter], which provides the same functionality for non-sliver widgets
///  * [GutterTheme], which controls how gutter width is calculated
class SliverGutter extends StatelessWidget {
  /// The sliver widget to which the horizontal padding will be applied.
  final Widget sliver;
  
  /// Whether the gutter padding is enabled.
  ///
  /// When false, no padding is applied regardless of the [GutterTheme] configuration.
  final bool enabled;

  /// Creates a [SliverGutter] widget.
  ///
  /// The [sliver] parameter is required and specifies the sliver to apply padding to.
  /// The [enabled] parameter controls whether padding is applied, defaulting to true.
  ///
  /// Example:
  /// ```dart
  /// CustomScrollView(
  ///   slivers: [
  ///     SliverGutter(
  ///       sliver: SliverList(
  ///         delegate: SliverChildBuilderDelegate(
  ///           (context, index) => ListTile(
  ///             title: Text("Item $index"),
  ///           ),
  ///           childCount: 20,
  ///         ),
  ///       ),
  ///     ),
  ///   ],
  /// )
  /// ```
  const SliverGutter({super.key, required this.sliver, this.enabled = true});

  @override
  Widget build(BuildContext context) => SliverPadding(
      sliver: sliver,
      padding: EdgeInsets.symmetric(
          horizontal: enabled
              ? Arcane.themeOf(context)
                  .gutter
                  .gutterCalc(MediaQuery.of(context).size.width)
              : 0));
}

/// A widget that adds responsive horizontal padding to its child widget.
///
/// [Gutter] automatically adjusts horizontal padding based on screen width,
/// creating layouts that adapt well to different device sizes. The padding
/// amount is calculated based on the current [GutterTheme].
///
/// See also:
///  * [doc/component/gutter.md] for more detailed documentation
///  * [SliverGutter], which provides the same functionality for sliver widgets
///  * [GutterTheme], which controls how gutter width is calculated
class Gutter extends StatelessWidget {
  /// The widget to which the horizontal padding will be applied.
  final Widget child;
  
  /// Whether the gutter padding is enabled.
  ///
  /// When false, no padding is applied regardless of the [GutterTheme] configuration.
  final bool enabled;

  /// Creates a [Gutter] widget.
  ///
  /// The [child] parameter is required and specifies the widget to apply padding to.
  /// The [enabled] parameter controls whether padding is applied, defaulting to true.
  ///
  /// Example:
  /// ```dart
  /// Gutter(
  ///   child: Container(
  ///     color: Colors.blue.shade100,
  ///     padding: EdgeInsets.symmetric(vertical: 16),
  ///     child: Text("This content has responsive horizontal margins"),
  ///   ),
  /// )
  /// ```
  const Gutter({super.key, required this.child, this.enabled = true});

  @override
  Widget build(BuildContext context) => PaddingHorizontal(
      padding: enabled
          ? Arcane.themeOf(context)
              .gutter
              .gutterCalc(MediaQuery.of(context).size.width)
          : 0,
      child: child);
}

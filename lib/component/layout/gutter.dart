import 'dart:math';

import 'package:arcane/arcane.dart';

/// Default function for calculating gutter width based on screen width.
///
/// This responsive calculation ensures horizontal padding adapts to device sizes in the Arcane UI system:
/// - Minimal padding on small screens to maximize content space
/// - Proportional growth for medium screens to improve readability
/// - Capped at one-third of screen width on large screens to prevent excessive margins
///
/// The formula balances usability across phones, tablets, and desktops, integrating seamlessly with [Gutter], [SliverGutter], and [Section] components for consistent layout spacing.
///
/// Formula: `max(0, min(max(0, 25 + ((screenWidth * 0.25) - 250)), screenWidth / 3))`
///
/// Used by default in [GutterTheme] to provide out-of-the-box responsive gutters without custom configuration.
double _defaultGutterCalc(double screenWidth) =>
    max(0, min(max(0, 25 + ((screenWidth * 0.25) - 250)), screenWidth / 3));

/// A theme class that defines how gutters should be calculated based on screen width.
///
/// [GutterTheme] is a core configuration component in the Arcane UI system, enabling customizable responsive horizontal padding for layout widgets like [Gutter] and [SliverGutter]. It allows developers to tailor margin behaviors to app-specific design needs, such as tighter spacing for compact forms or wider margins for expansive sections. Key features include:
/// - A pluggable calculation function for dynamic gutter widths
/// - Toggleable enabling to disable gutters globally or per-widget
/// - Integration with [ArcaneTheme] for theme-wide consistency
///
/// Usage: Extend or override in [ArcaneTheme] to apply custom gutter logic across the app, ensuring layouts remain balanced on varying screen sizes. For example, pair with [Section] for sectioned content or [Padding] for fine-tuned inner spacing.
///
/// See also:
///  * [doc/component/gutter.md] for detailed usage examples and best practices
///  * [Gutter], the primary widget for non-sliver responsive padding
///  * [SliverGutter], the sliver counterpart for scrollable layouts
class GutterTheme {
  /// Function that calculates the gutter width based on screen width.
  ///
  /// This core field drives the responsive behavior, receiving the current screen width from [MediaQuery] and returning a double value for symmetric horizontal padding.
  /// Default implementation provides proportional scaling; custom functions can implement device-specific logic, such as fixed widths for tablets or zero on mobile.
  /// Integrates with [ArcaneTheme] to ensure theme-consistent spacing in components like [Section] or [Flow].
  final double Function(double screenWidth) gutterCalc;

  /// Whether gutters are enabled by default.
  ///
  /// Controls global activation of gutter padding in [Gutter] and [SliverGutter] widgets.
  /// When false, widgets default to zero padding, useful for full-bleed layouts or when overriding per-instance with the [enabled] parameter.
  final bool enabled;

  /// Creates a [GutterTheme] with the specified configuration.
  ///
  /// Initializes the theme for use in [ArcaneTheme], applying to all gutter-related widgets.
  /// The [gutterCalc] parameter accepts a function that computes padding from screen width, defaulting to a responsive formula that grows from 25px on small screens to up to 1/3 screen width on large ones, ensuring adaptive layouts.
  /// The [enabled] parameter sets default activation, allowing theme-wide disabling for edge-to-edge designs while permitting per-widget overrides.
  ///
  /// This constructor supports const creation for performance in theme definitions, integrating with [ArcaneTheme.of(context).gutter] for runtime access.
  const GutterTheme(
      {this.gutterCalc = _defaultGutterCalc, this.enabled = true});

  /// Creates a copy of this GutterTheme with the given fields replaced.
  ///
  /// Provides immutable updates for theme extensions, commonly used in [ArcaneTheme] overrides or local customizations.
  /// Inputs: Optional [gutterCalc] function to redefine width calculation, and [enabled] bool to toggle default state.
  /// Output: A new [GutterTheme] instance with merged values, preserving originals where unspecified.
  /// No state interactions; purely functional for building variant themes without mutation.
  GutterTheme copyWith(
          {double Function(double screenWidth)? gutterCalc, bool? enabled}) =>
      GutterTheme(
          gutterCalc: gutterCalc ?? this.gutterCalc,
          enabled: enabled ?? this.enabled);
}

/// A widget that adds responsive horizontal padding to a sliver widget.
///
/// [SliverGutter] is designed for sliver-based scrolling in the Arcane UI system, such as [CustomScrollView] or [SliverList], providing adaptive horizontal margins that respond to screen size via [GutterTheme].
/// Key features:
/// - Automatic padding calculation using [ArcaneTheme]'s gutter configuration
/// - Optional disabling for full-width slivers in specific contexts
/// - Seamless integration with other slivers like [SliverSection] or [SliverToBoxAdapter]
///
/// Usage: Wrap sliver children to ensure consistent spacing in scrollable areas, enhancing readability on wide screens while keeping content centered on mobile. For non-sliver use, prefer [Gutter].
///
/// See also:
///  * [doc/component/gutter.md] for integration examples with scrollable layouts
///  * [Gutter], the non-sliver version for standard widget trees
///  * [GutterTheme], for customizing calculation logic
///  * [SliverPadding], the underlying Flutter primitive enhanced here
class SliverGutter extends StatelessWidget {
  /// The sliver widget to which the horizontal padding will be applied.
  final Widget sliver;

  /// Whether the gutter padding is enabled.
  ///
  /// Overrides [GutterTheme.enabled] for this instance; when false, applies zero padding to allow full-width sliver content, useful in hero sections or banners.
  final bool enabled;

  /// Creates a [SliverGutter] widget.
  ///
  /// Initializes the wrapper for sliver padding, requiring the [sliver] child to pad.
  /// The [enabled] parameter determines if [GutterTheme.gutterCalc] is invoked with current screen width from [MediaQuery], defaulting to true for standard responsive behavior.
  /// Initialization logic: Defers padding computation to build time, ensuring context-aware theme access without early evaluation.
  ///
  /// Example in a scrollable layout:
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
  /// This applies symmetric horizontal padding, scaling with device width for optimal content framing.
  const SliverGutter({super.key, required this.sliver, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    /// Builds the padded sliver, computing horizontal padding dynamically.
    ///
    /// Functionality: Retrieves [GutterTheme] from [ArcaneTheme.of(context)], applies [gutterCalc] to screen width if [enabled], and wraps [sliver] in [SliverPadding] with symmetric horizontal edges.
    /// Inputs: Build context for theme and media query access.
    /// Output: A [SliverPadding] widget with computed padding (double width) or zero if disabled.
    /// No async operations; stateless and efficient for sliver contexts, integrating with [CustomScrollView] for responsive scrolling layouts.
    return SliverPadding(
        sliver: sliver,
        padding: EdgeInsets.symmetric(
            horizontal: enabled
                ? Arcane.themeOf(context)
                    .gutter
                    .gutterCalc(MediaQuery.of(context).size.width)
                : 0));
  }
}

/// A widget that adds responsive horizontal padding to its child widget.
///
/// [Gutter] provides adaptive horizontal margins for standard widget trees in the Arcane UI system, ensuring content remains well-framed across device sizes using [GutterTheme] calculations.
/// Key features:
/// - Responsive width based on [MediaQuery] screen size
/// - Per-instance enabling for flexible layout control
/// - Built on [PaddingHorizontal] for efficient, horizontal-only spacing
///
/// Usage: Wrap body content, forms, or sections to create breathing room that scales appropriately—e.g., narrow on phones for immersion, wider on desktops for hierarchy. Complements [Section] for grouped content or [Flow] for dynamic arrangements.
///
/// See also:
///  * [doc/component/gutter.md] for layout patterns and theme customization
///  * [SliverGutter], for sliver-compatible padding in scroll views
///  * [GutterTheme], controlling global calculation and enabling
///  * [Padding], the Flutter base extended for Arcane's responsive needs
class Gutter extends StatelessWidget {
  /// The widget to which the horizontal padding will be applied.
  final Widget child;

  /// Whether the gutter padding is enabled.
  ///
  /// When false, bypasses theme calculation for zero-padding scenarios, such as edge-to-edge images or full-width cards, overriding [GutterTheme.enabled].
  final bool enabled;

  /// Creates a [Gutter] widget.
  ///
  /// Sets up the padding wrapper, mandating the [child] to margin.
  /// The [enabled] flag governs whether to compute padding via [GutterTheme.gutterCalc] and screen width, defaulting to true for responsive defaults.
  /// Initialization: Const-friendly for performance; padding resolved in build for context-dependent values.
  ///
  /// Example for responsive content framing:
  /// ```dart
  /// Gutter(
  ///   child: Container(
  ///     color: Colors.blue.shade100,
  ///     padding: EdgeInsets.symmetric(vertical: 16),
  ///     child: Text("This content has responsive horizontal margins"),
  ///   ),
  /// )
  /// ```
  /// Results in adaptive left/right padding, harmonizing with [ArcaneTheme] for consistent app-wide spacing.
  const Gutter({super.key, required this.child, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    /// Constructs the padded child widget.
    ///
    /// Functionality: Fetches [GutterTheme] from context, calculates horizontal padding if [enabled] using screen width, and applies via [PaddingHorizontal].
    /// Inputs: Build context for theme resolution and [MediaQuery].
    /// Output: [PaddingHorizontal] enclosing [child] with dynamic or zero padding.
    /// Stateless operation with no async; optimizes for frequent rebuilds in dynamic UIs, supporting integrations like [FormHeader] or [ButtonPanel].
    return PaddingHorizontal(
        padding: enabled
            ? Arcane.themeOf(context)
                .gutter
                .gutterCalc(MediaQuery.of(context).size.width)
            : 0,
        child: child);
  }
}

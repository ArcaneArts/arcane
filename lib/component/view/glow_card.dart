import 'package:arcane/arcane.dart';

/// A glowing card widget that provides a subtle background glow effect using thumbhash images,
/// enhancing visual appeal in Arcane UI components.
///
/// Key features:
/// - Supports optional thumbhash for a semi-transparent background glow, creating an ethereal lighting effect.
/// - Integrates seamlessly with [Section], [FillScreen], and [SliverScreen] for structured layouts, such as highlighting content sections or full-screen cards.
/// - Customizable borders, shadows, padding, and surface effects via parameters, with fallbacks to [ArcaneTheme] for consistent styling.
/// - Efficient rendering as a [StatelessWidget], avoiding unnecessary rebuilds and leveraging const constructors for optimal performance in scrollable views like [SliverScreen].
///
/// Usage:
/// Wrap any [Widget] as [child] to create an elevated card presentation.
/// For glow effects, provide [thumbHash]; otherwise, it behaves like a standard [BasicCard].
/// Combine with [Gesture] for interactions or nest within [Section] for grouped content.
/// Performance note: The glow uses [MagicThumbHash] with shaders enabled, ensuring smooth rendering without impacting frame rates in complex UIs.
class GlowCard extends StatelessWidget {
  final Widget child;
  final double intensityMultiplier;
  final EdgeInsetsGeometry? padding;
  final String? thumbHash;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final Clip? clipBehavior;
  final List<BoxShadow>? boxShadow;
  final double? surfaceOpacity;
  final double? surfaceBlur;
  final Duration? duration;
  final VoidCallback? onPressed;
  final bool? filled;
  final Color? fillColor;
  final bool dashedBorder;

  /// Creates a GlowCard with the given [child] and optional styling parameters.
  ///
  /// The [child] is the primary content widget to display within the card.
  ///
  /// If [thumbHash] is provided, a semi-transparent [MagicThumbHash] background is rendered
  /// as a glow effect, with opacity adjusted by [intensityMultiplier] (default: 1.0)
  /// and theme brightness for light/dark mode consistency (0.15 base opacity).
  ///
  /// Styling parameters:
  /// - [padding]: Inner spacing around [child]; defaults to EdgeInsets.all(16 * scaling) from [ArcaneTheme] if null.
  /// - [borderRadius], [borderColor], [borderWidth]: Control card shape and outline; inherit from [CardTheme] if unspecified.
  /// - [clipBehavior]: Specifies clipping for content overflow (e.g., Clip.hardEdge).
  /// - [boxShadow]: Custom shadows for depth; overrides theme defaults.
  /// - [surfaceOpacity], [surfaceBlur]: Adjust card surface transparency and blur for glassmorphism effects.
  /// - [duration]: Animation duration for press or state changes.
  /// - [onPressed]: Optional callback for tap interactions, enabling button-like behavior similar to [Gesture].
  /// - [filled], [fillColor]: Fill the card background; useful for solid-colored cards without glow.
  /// - [dashedBorder]: Renders a dashed border style (default: false) for decorative outlines.
  ///
  /// When [thumbHash] is null, falls back to a standard [Card] without glow, ensuring lightweight rendering.
  /// All parameters support null for theme-based defaults, promoting consistency in Arcane apps.
  const GlowCard({
    super.key,
    required this.child,
    this.dashedBorder = false,
    this.thumbHash,
    this.padding,
    this.intensityMultiplier = 1,
    this.borderRadius,
    this.clipBehavior,
    this.borderColor,
    this.borderWidth,
    this.boxShadow,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.duration,
    this.onPressed,
    this.filled,
    this.fillColor,
  });

  /// Builds the GlowCard widget tree.
  ///
  /// Inputs: Relies on [child], [thumbHash], and styling parameters; uses [BuildContext] for theme access via [ArcaneTheme].
  ///
  /// Logic:
  /// - If [thumbHash] is null, returns a simple [Card] wrapping [child] with applied padding and styles.
  /// - Otherwise:
  ///   - Resolves padding from [padding], [CardTheme.padding], or default EdgeInsets.all(16 * scaling).
  ///   - Determines border radius from [borderRadius], [CardTheme.borderRadius], or theme.borderRadiusXl.
  ///   - Constructs a [Card] with zero padding containing a [Stack]:
  ///     - [Positioned.fill] with [ClipRRect] (using resolved border radius) holding [MagicThumbHash]
  ///       (shaders enabled, thumbHash provided) at opacity = (0.15 * [intensityMultiplier]).clamp(0.001, 1),
  ///       adjusted uniformly for light/dark themes.
  ///     - [Padding] with resolved padding wrapping [child].
  /// - Applies all other parameters ([dashedBorder], [borderColor], etc.) directly to the [Card].
  ///
  /// Outputs: A fully styled [Widget] ready for layout integration, such as in [Section] or [FillScreen].
  /// Ensures efficient composition without deep widget trees, minimizing rebuilds in parent contexts like [SliverScreen].
  @override
  Widget build(BuildContext context) {
    if (thumbHash == null) {
      return Card(
        dashedBorder: dashedBorder,
        padding: padding,
        borderRadius: borderRadius,
        borderColor: borderColor,
        borderWidth: borderWidth,
        clipBehavior: clipBehavior,
        boxShadow: boxShadow,
        surfaceOpacity: surfaceOpacity,
        surfaceBlur: surfaceBlur,
        duration: duration,
        onPressed: onPressed,
        fillColor: fillColor,
        filled: filled,
        child: child,
      );
    }

    CardTheme? compTheme = ComponentTheme.maybeOf<CardTheme>(context);
    ThemeData theme = Theme.of(context);
    double scaling = theme.scaling;
    EdgeInsetsGeometry mPadding = styleValue<EdgeInsetsGeometry>(
      widgetValue: padding,
      themeValue: compTheme?.padding,
      defaultValue: EdgeInsets.all(16 * scaling),
    );
    final br = styleValue(
      themeValue: compTheme?.borderRadius,
      defaultValue: theme.borderRadiusXl,
    );

    return Card(
        dashedBorder: dashedBorder,
        borderRadius: borderRadius,
        borderColor: borderColor,
        borderWidth: borderWidth,
        clipBehavior: clipBehavior,
        boxShadow: boxShadow,
        surfaceOpacity: surfaceOpacity,
        surfaceBlur: surfaceBlur,
        duration: duration,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            if (thumbHash != null)
              Positioned.fill(
                  child: ClipRRect(
                      borderRadius: br,
                      child: MagicThumbHash(
                              useShaders: true, thumbHash: thumbHash!)
                          .withOpacity(((theme.brightness == Brightness.light
                                      ? 0.15
                                      : 0.15) *
                                  intensityMultiplier)
                              .clamp(0.001, 1)))),
            Padding(
              padding: mPadding,
              child: child,
            ),
          ],
        ));
  }
}

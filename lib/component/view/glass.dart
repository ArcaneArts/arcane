import 'package:arcane/arcane.dart';
import 'package:flutter/foundation.dart';

/// Defines the directions for the anti-flicker gradient used with [GlassAntiFlicker].
///
/// This enum specifies the possible fade directions to prevent visual artifacts
/// at the edges of glass panels in Arcane UI components. It enables smooth
/// transitions between [Glass] elements and surrounding content, particularly
/// useful in layouts like [Section] or [FillScreen] where glass overlays
/// might otherwise cause flickering during animations or scrolling.
///
/// Key features:
/// - Supports four cardinal directions for flexible edge handling.
/// - Integrates seamlessly with [ArcaneTheme] for consistent styling.
/// - Performance: Stateless and const, ensuring no unnecessary rebuilds in
///   dynamic UIs like [SliverScreen].
///
/// Usage example in a [Section]:
/// ```dart
/// Section(
///   child: GlassAntiFlicker(direction: AntiFlickerDirection.bottom),
/// )
/// ```
///
/// See also:
/// * [doc/component/glass.md] for detailed glass effect documentation.
/// * [GlassAntiFlicker], the widget that applies this gradient.
enum AntiFlickerDirection {
  /// Gradient fades from top to bottom, ideal for top edges of glass panels.
  top,

  /// Gradient fades from bottom to top, suitable for bottom-aligned [Glass] in [FillScreen].
  bottom,

  /// Gradient fades from left to right, for left-side transitions in [Section] layouts.
  left,

  /// Gradient fades from right to left, for right-side anti-flicker in navigation-heavy UIs.
  right,
}

/// Extension methods for [AntiFlickerDirection] to simplify gradient alignment calculations.
///
/// This extension provides utility getters for determining gradient alignments
/// based on direction, enhancing usability when integrating with [Glass] in
/// complex Arcane layouts like [SliverScreen] or [BasicCard] overlays.
///
/// Key features:
/// - Computes dark and light alignments efficiently without runtime overhead.
/// - Enables opposite direction lookup for bidirectional effects.
/// - Performance: Purely computational, no state management, avoiding rebuilds
///   in responsive UIs.
///
/// Usage:
/// ```dart
/// final direction = AntiFlickerDirection.top;
/// final darkAlign = direction.alignmentDark; // Alignment.topCenter
/// ```
extension XAntiFlickerDirection on AntiFlickerDirection {
  /// Gets the alignment for the dark end of the gradient, matching the direction's origin.
  ///
  /// Returns the appropriate [Alignment] for the starting point of the fade,
  /// ensuring correct positioning in [GlassAntiFlicker] widgets.
  Alignment get alignmentDark {
    switch (this) {
      case AntiFlickerDirection.top:
        return Alignment.topCenter;
      case AntiFlickerDirection.bottom:
        return Alignment.bottomCenter;
      case AntiFlickerDirection.left:
        return Alignment.centerLeft;
      case AntiFlickerDirection.right:
        return Alignment.centerRight;
    }
  }

  /// Gets the opposite direction for bidirectional gradient applications.
  ///
  /// Useful for symmetric effects or when reversing fade directions in
  /// mirrored [Glass] setups within [Section] components.
  AntiFlickerDirection get opposite => switch (this) {
        AntiFlickerDirection.top => AntiFlickerDirection.bottom,
        AntiFlickerDirection.bottom => AntiFlickerDirection.top,
        AntiFlickerDirection.left => AntiFlickerDirection.right,
        AntiFlickerDirection.right => AntiFlickerDirection.left,
      };

  /// Gets the alignment for the light end of the gradient, derived from the opposite direction.
  ///
  /// Automatically computes the end alignment, simplifying implementation
  /// in [GlassAntiFlicker] for seamless integration with [ArcaneTheme].
  Alignment get alignmentLight => opposite.alignmentDark;
}

/// Internal class for tracking glass stopping state in the widget tree.
///
/// This private class manages the propagation of glass disable signals via
/// [Pylon], ensuring efficient inheritance without deep tree traversals.
/// Performance: Const constructor and immutable, preventing rebuild cascades.
class _GlassStop {
  /// Whether glass effects should be stopped in descendant widgets.
  final bool stopping;

  const _GlassStop(this.stopping);
}

/// A component that controls whether glass effects should be applied to child components.
///
/// [GlassStopper] provides a mechanism to selectively disable [Glass] blur effects
/// in specific subtrees of the Arcane UI, useful for performance optimization
/// in dense layouts or when transitioning to non-blurred content. It propagates
/// the stopping signal via [Pylon] for efficient inheritance checking.
///
/// Key features:
/// - Conditionally disables descendant [Glass] widgets without rebuilding them.
/// - Integrates with [Section], [FillScreen], and [SliverScreen] for scoped control.
/// - Supports [Gesture] interactions and [ArcaneTheme] styling unaffected by stopping.
/// - Performance: Stateless with local [Pylon] scoping, avoiding unnecessary
///   rebuilds even in large, dynamic UIs; uses const where possible for optimization.
///
/// Usage in a [FillScreen] to disable glass in a specific panel:
/// ```dart
/// FillScreen(
///   child: GlassStopper(
///     stopping: true,
///     builder: (context) => BasicCard(
///       child: Text("No glass effect here"),
///     ),
///   ),
/// )
/// ```
///
/// See also:
/// * [doc/component/glass.md] for detailed glass effect documentation.
/// * [Glass], the primary widget affected by this stopper.
class GlassStopper extends StatelessWidget {
  /// Builder function that provides the content to render within the stopping context.
  ///
  /// This callback receives the [BuildContext] and returns the widget tree
  /// where glass effects are controlled; defaults to no-op if not provided,
  /// but required for content.
  final Widget Function(BuildContext context) builder;

  /// Whether to stop glass effects in descendant widgets.
  ///
  /// When true, child [Glass] instances will render without blur unless
  /// [Glass.ignoreContextSignals] is set; defaults to false for normal operation.
  final bool stopping;

  /// Creates a [GlassStopper] widget for scoped glass effect control.
  ///
  /// The [builder] is required to define the content subtree affected by stopping.
  /// Use [stopping] to enable/disable effects, with false as default to maintain
  /// glass rendering. This constructor is const for performance in repeated builds.
  ///
  /// Integrates well with [ArcaneTheme] for consistent disabled appearances
  /// and [BasicCard] for contained sections without blur overhead.
  const GlassStopper({super.key, required this.builder, this.stopping = false});

  /// Checks if a [GlassStopper] in the widget tree is stopping glass effects.
  ///
  /// Scans the nearest ancestor via [Pylon] for the stopping state, returning
  /// true if effects should be disabled or if no stopper is found (fallback to safe default).
  /// This method is efficient, avoiding full tree traversals, and is used internally
  /// by [Glass] for conditional rendering in performance-sensitive areas like [SliverScreen].
  ///
  /// Returns: bool indicating if glass should be stopped.
  static bool isStopping(BuildContext context) =>
      context.pylonOr<_GlassStop>()?.stopping ?? true;

  @override
  Widget build(BuildContext context) => Pylon<_GlassStop>(
      local: true, value: _GlassStop(stopping), builder: builder);
}

bool kShowStoppedGlass = kDebugMode && false;

/// A component that applies a blur effect to its child widget with a semi-transparent background.
///
/// [Glass] simulates frosted glass by combining [ArcaneBlur] with a tinted overlay,
/// creating depth in Arcane UI without heavy performance costs. It respects
/// [GlassStopper] signals for conditional disabling and supports edge anti-flicker
/// via [GlassAntiFlicker]. Ideal for overlays in [Section], [FillScreen], or [SliverScreen].
///
/// Key features:
/// - Applies configurable blur intensity from [ArcaneTheme.surfaceBlur] (default 24).
/// - Supports underlay widgets for layered effects, like content behind glass.
/// - Customizable tint and disabled color for theme integration.
/// - Handles context signals for scoped disabling, e.g., in performance-critical [Gesture] areas.
/// - Performance: Stateless and const; uses null safety with ?? for defaults,
///   minimizing rebuilds. Blur is only applied when enabled, falling back to
///   efficient [Container] for disabled state without unnecessary computations.
///
/// Usage in a [Section] with tint:
/// ```dart
/// Section(
///   child: Glass(
///     tint: Colors.indigo.withOpacity(0.1),
///     borderRadius: BorderRadius.circular(16),
///     child: Padding(
///       padding: EdgeInsets.all(12),
///       child: Text("Frosted content"),
///     ),
///   ),
/// )
/// ```
///
/// See also:
/// * [doc/component/glass.md] for detailed glass effect documentation.
/// * [GlassStopper], for disabling effects in subtrees.
/// * [GlassAntiFlicker], to prevent edge flickering.
/// * [ArcaneTheme], for blur and opacity customization.
class Glass extends StatelessWidget {
  /// The widget to which the glass effect is applied.
  ///
  /// This is the primary content rendered with or without the blur overlay;
  /// required for the widget to function.
  final Widget child;

  /// Border radius for clipping the glass effect.
  ///
  /// Defines the rounded corners of the [ClipRRect]; defaults to zero radius
  /// for sharp edges, but commonly set to circular for modern [BasicCard]-like appearances.
  final BorderRadius borderRadius;

  /// Whether to disable the glass effect directly.
  ///
  /// When true, renders as a simple [Container] without blur; also triggered
  /// by parent [GlassStopper] unless [ignoreContextSignals] is true. Defaults to false.
  final bool disabled;

  /// Widget to display underneath the glass effect.
  ///
  /// Optional underlay for layered visuals, e.g., background patterns or images
  /// visible through the semi-transparent glass in [FillScreen] layouts.
  final Widget? under;

  /// Color tint to apply to the glass effect.
  ///
  /// Overrides the default theme-based tint (background with [ArcaneTheme.surfaceOpacity]);
  /// use for custom colors like brand accents in [Section] headers.
  final Color? tint;

  /// Background color to use when glass effect is disabled.
  ///
  /// Fallback color for non-blur state; defaults to theme background or transparent
  /// in translucent contexts, ensuring seamless integration with [ArcaneTheme].
  final Color? disabledColor;

  /// Whether to ignore glass stopping signals from parent context.
  ///
  /// When true, [Glass] ignores [GlassStopper.isStopping] and always applies blur;
  /// useful for critical UI elements in [SliverScreen] that must remain frosted.
  final bool ignoreContextSignals;

  final double? blurRadius;
  final double? opacity;

  /// Creates a [Glass] widget for applying frosted glass effects.
  ///
  /// The [child] is required as the content to blur. Use named parameters for
  /// customization: [borderRadius] for clipping (default zero), [tint] for color overlay,
  /// [disabled] to skip effects (default false), [under] for layered backgrounds,
  /// [disabledColor] for fallback styling, and [ignoreContextSignals] to bypass stoppers (default false).
  /// This const constructor supports efficient reuse in dynamic UIs like [Gesture]-driven panels.
  ///
  /// Integrates with [ArcaneTheme] for blur intensity and opacity, ensuring
  /// consistent performance across [FillScreen] and [Section] usages.
  const Glass(
      {super.key,
      this.ignoreContextSignals = false,
      this.disabledColor,
      this.blurRadius,
      this.opacity,
      this.under,
      this.tint,
      this.disabled = false,
      this.borderRadius = const BorderRadius.all(Radius.circular(0)),
      required this.child});

  @override
  Widget build(BuildContext context) {
    bool disabled = this.disabled ||
        (GlassStopper.isStopping(context) && !ignoreContextSignals);
    Widget b = disabled
        ? Container(
            color: kShowStoppedGlass
                ? Colors.red
                : disabledColor ??
                    (context.isTranslucent
                            ? Colors.transparent
                            : Theme.of(context).colorScheme.background)
                        .withOpacity(opacity ?? 1),
            child: child,
          )
        : ArcaneBlur(
            intensity: blurRadius ?? Theme.of(context).surfaceBlur ?? 24,
            child: child,
          );

    if (under != null) {
      b = Stack(
        fit: StackFit.passthrough,
        children: [
          under!,
          b,
        ],
      );
    }

    b = Container(
      color: tint ??
          Theme.of(context)
              .colorScheme
              .background
              .withOpacity(Theme.of(context).surfaceOpacity ?? 0.5),
      child: b,
    );

    return disabled
        ? Container(
            color: kShowStoppedGlass
                ? Colors.red
                : disabledColor ?? Theme.of(context).colorScheme.background,
            child: child,
          )
        : ClipRRect(
            borderRadius: borderRadius,
            child: b,
          );
  }
}

/// A component that helps prevent flickering at the edges of glass effects by applying a gradient.
///
/// [GlassAntiFlicker] generates a subtle linear gradient from the theme background
/// to transparent, smoothing transitions at [Glass] boundaries. This is essential
/// for clean visuals in scrolling [SliverScreen] or stacked [Section] layouts
/// where glass edges might artifact during motion.
///
/// Key features:
/// - Directional fade control via [AntiFlickerDirection] for top/bottom/left/right edges.
/// - Automatically uses [ArcaneTheme.colorScheme.background] for seamless blending.
/// - Minimal height/width impact, designed for thin overlay strips.
/// - Performance: Stateless and const; inline gradient computation with fixed stops
///   (0 to 0.1 opacity), no state or rebuilds, ideal for high-frequency updates
///   in [Gesture] or animation-heavy UIs.
///
/// Usage as a bottom edge smoother in [FillScreen]:
/// ```dart
/// FillScreen(
///   child: Column(
///     children: [
///       Expanded(child: Glass(child: YourContent())),
///       GlassAntiFlicker(direction: AntiFlickerDirection.top, height: 20),
///     ],
///   ),
/// )
/// ```
///
/// See also:
/// * [doc/component/glass.md] for detailed glass effect documentation.
/// * [Glass], the widget this enhances for edge transitions.
/// * [AntiFlickerDirection], for specifying gradient orientation.
class GlassAntiFlicker extends StatelessWidget {
  /// The direction of the anti-flicker gradient.
  ///
  /// Required parameter defining the fade orientation (e.g., [AntiFlickerDirection.top]
  /// for downward fades); uses [XAntiFlickerDirection] extensions for alignment computation.
  final AntiFlickerDirection direction;

  /// Creates a [GlassAntiFlicker] widget for edge smoothing in glass effects.
  ///
  /// The [direction] is required to set the gradient's fade path, enabling
  /// precise control for [Glass] boundaries in layouts like [BasicCard] or [Section].
  /// This const constructor ensures zero-cost instantiation and integration
  /// with [ArcaneTheme] for background color matching.
  const GlassAntiFlicker({super.key, required this.direction});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: direction.alignmentDark,
                end: direction.alignmentLight,
                stops: const [
              0,
              0.1
            ],
                colors: [
              Theme.of(context).colorScheme.background,
              Colors.transparent,
            ])),
      );
}

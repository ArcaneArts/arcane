import 'package:arcane/arcane.dart';
import 'package:arcane/util/unicorn.dart';
import 'package:flutter/foundation.dart';

/// Defines the directions for the anti-flicker gradient used with [GlassAntiFlicker].
///
/// These directions specify where the gradient should fade from to prevent
/// visual artifacts at the edges of glass panels.
///
/// See also:
///  * [doc/component/glass.md] for more detailed documentation
///  * [GlassAntiFlicker], which uses this enum to create anti-flicker gradients
enum AntiFlickerDirection {
  /// Gradient fades from top to bottom
  top,

  /// Gradient fades from bottom to top
  bottom,

  /// Gradient fades from left to right
  left,

  /// Gradient fades from right to left
  right,
}

/// Extension methods for working with [AntiFlickerDirection].
extension XAntiFlickerDirection on AntiFlickerDirection {
  /// Gets the alignment for the dark end of the gradient.
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

  /// Gets the opposite direction.
  AntiFlickerDirection get opposite => switch (this) {
        AntiFlickerDirection.top => AntiFlickerDirection.bottom,
        AntiFlickerDirection.bottom => AntiFlickerDirection.top,
        AntiFlickerDirection.left => AntiFlickerDirection.right,
        AntiFlickerDirection.right => AntiFlickerDirection.left,
      };

  /// Gets the alignment for the light end of the gradient.
  Alignment get alignmentLight => opposite.alignmentDark;
}

/// Internal class for tracking glass stopping state.
class _GlassStop {
  /// Whether glass effects should be stopped.
  final bool stopping;

  const _GlassStop(this.stopping);
}

/// A component that controls whether glass effects should be applied to child components.
///
/// [GlassStopper] allows for selectively disabling glass effects in specific parts
/// of the UI. When [stopping] is true, descendant [Glass] widgets will not render
/// their blur effect (unless they have [ignoreContextSignals] set to true).
///
/// See also:
///  * [doc/component/glass.md] for more detailed documentation
///  * [Glass], which is affected by this component
class GlassStopper extends StatelessWidget {
  /// Builder function for the content.
  final Widget Function(BuildContext context) builder;

  /// Whether to stop glass effects in descendant widgets.
  final bool stopping;

  /// Creates a [GlassStopper] widget.
  ///
  /// The [builder] parameter is required and provides the content to render.
  /// The [stopping] parameter controls whether glass effects are disabled (defaults to false).
  ///
  /// Example:
  /// ```dart
  /// GlassStopper(
  ///   stopping: true,
  ///   builder: (context) => Column(
  ///     children: [
  ///       Text("This area has glass effects disabled"),
  ///       Glass(
  ///         child: Text("This won't have a glass effect"),
  ///       ),
  ///     ],
  ///   ),
  /// )
  /// ```
  const GlassStopper({super.key, required this.builder, this.stopping = false});

  /// Checks if a [GlassStopper] in the widget tree is stopping glass effects.
  ///
  /// Returns true if glass effects should be stopped based on the nearest
  /// ancestor [GlassStopper], or true if no [GlassStopper] is found.
  static bool isStopping(BuildContext context) =>
      context.pylonOr<_GlassStop>()?.stopping ?? true;

  @override
  Widget build(BuildContext context) => Pylon<_GlassStop>(
      local: true, value: _GlassStop(stopping), builder: builder);
}

bool kShowStoppedGlass = kDebugMode && false;

/// A component that applies a blur effect to its child widget with a semi-transparent background.
///
/// [Glass] creates a frosted glass appearance by applying a blur effect and a
/// semi-transparent background tint. The effect can be disabled either directly
/// or through a parent [GlassStopper].
///
/// See also:
///  * [doc/component/glass.md] for more detailed documentation
///  * [GlassStopper], which can disable glass effects in parts of the UI
///  * [GlassAntiFlicker], which helps prevent flickering at glass edges
class Glass extends StatelessWidget {
  /// The widget to which the glass effect is applied.
  final Widget child;

  /// Border radius for clipping the glass effect.
  final BorderRadius borderRadius;

  /// Whether to disable the glass effect.
  final bool disabled;

  /// Widget to display underneath the glass effect.
  final Widget? under;

  /// Color tint to apply to the glass effect.
  final Color? tint;

  /// Background color to use when glass effect is disabled.
  final Color? disabledColor;

  /// Whether to ignore glass stopping signals from parent context.
  final bool ignoreContextSignals;

  /// Creates a [Glass] widget.
  ///
  /// The [child] parameter is required and specifies the widget to apply the
  /// glass effect to. Other parameters customize the appearance of the glass effect.
  ///
  /// Example:
  /// ```dart
  /// Glass(
  ///   borderRadius: BorderRadius.circular(12),
  ///   tint: Colors.blue.withOpacity(0.1),
  ///   child: Padding(
  ///     padding: EdgeInsets.all(16),
  ///     child: Text("This text is behind glass"),
  ///   ),
  /// )
  /// ```
  const Glass(
      {super.key,
      this.ignoreContextSignals = false,
      this.disabledColor,
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
                        : Theme.of(context).colorScheme.background),
            child: child,
          )
        : ArcaneBlur(
            intensity: Theme.of(context).surfaceBlur ?? 24,
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
/// [GlassAntiFlicker] creates a gradient that transitions from the background color
/// to transparent, helping to smooth the visual transition between glass and non-glass
/// areas of the UI.
///
/// See also:
///  * [doc/component/glass.md] for more detailed documentation
///  * [Glass], which this component helps to visually integrate
///  * [AntiFlickerDirection], which defines the direction of the gradient
class GlassAntiFlicker extends StatelessWidget {
  /// The direction of the anti-flicker gradient.
  ///
  /// This specifies where the gradient should fade from (e.g., [AntiFlickerDirection.top]
  /// creates a gradient that fades from top to bottom).
  final AntiFlickerDirection direction;

  /// Creates a [GlassAntiFlicker] widget.
  ///
  /// The [direction] parameter is required and specifies the direction of the gradient.
  ///
  /// Example:
  /// ```dart
  /// Stack(
  ///   children: [
  ///     Positioned(
  ///       bottom: 0,
  ///       left: 0,
  ///       right: 0,
  ///       child: Glass(
  ///         child: Text("Glass panel at bottom"),
  ///       ),
  ///     ),
  ///     Positioned(
  ///       bottom: 0,
  ///       left: 0,
  ///       right: 0,
  ///       height: 20,
  ///       child: GlassAntiFlicker(direction: AntiFlickerDirection.top),
  ///     ),
  ///   ],
  /// )
  /// ```
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

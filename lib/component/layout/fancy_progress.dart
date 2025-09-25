import 'dart:ui';

import 'package:arcane/arcane.dart' hide TileMode, Gradient;

const int _kIndeterminateLinearDuration = 1800;
const kDefaultDurationX = Duration(milliseconds: 10000);

/// A customizable linear progress bar widget that supports both determinate and indeterminate progress states,
/// with optional spark effects at the end for visual enhancement. It integrates seamlessly with the
/// [ArcaneTheme] for consistent coloring and scaling, providing a polished alternative to the standard
/// [LinearProgressIndicator]. Use this in loading states within [Section] or [Carpet] layouts to indicate
/// progress during data operations or async tasks, such as file uploads or API calls in [Dialog] flows.
class FancyProgressBar extends StatelessWidget {
  static const Curve _line1Head = Interval(
    0.0,
    750.0 / _kIndeterminateLinearDuration,
    curve: Cubic(0.2, 0.0, 0.8, 1.0),
  );
  static const Curve _line1Tail = Interval(
    333.0 / _kIndeterminateLinearDuration,
    (333.0 + 750.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.4, 0.0, 1.0, 1.0),
  );
  static const Curve _line2Head = Interval(
    1000.0 / _kIndeterminateLinearDuration,
    (1000.0 + 567.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.0, 0.0, 0.65, 1.0),
  );
  static const Curve _line2Tail = Interval(
    1267.0 / _kIndeterminateLinearDuration,
    (1267.0 + 533.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.10, 0.0, 0.45, 1.0),
  );

  final double? value;
  final Color? backgroundColor;
  final double? minHeight;
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final bool showSparks;
  final bool disableAnimation;

  /// Creates a [FancyProgressBar] with optional determinate progress value (0.0 to 1.0).
  ///
  /// - If [value] is provided, renders a determinate progress bar animating to the specified value.
  /// - If [value] is null, displays an indeterminate animation with moving segments mimicking
  ///   [LinearProgressIndicator] indeterminate mode.
  /// - [backgroundColor] sets the track color, defaulting to a scaled [ArcaneTheme] primary.
  /// - [minHeight] controls the bar thickness, scaled by [ArcaneTheme.scaling].
  /// - [color] overrides the progress fill color from [ArcaneTheme.primary].
  /// - [borderRadius] applies rounded corners, defaulting to zero.
  /// - [showSparks] enables a radial gradient spark effect at the progress end for visual flair.
  /// - [disableAnimation] skips animations for static display, useful in performance-critical UIs.
  const FancyProgressBar({
    super.key,
    this.value,
    this.backgroundColor,
    this.minHeight,
    this.color,
    this.borderRadius,
    this.showSparks = false,
    this.disableAnimation = false,
  });

  /// Builds the progress bar widget, handling determinate and indeterminate modes with smooth
  /// animations via [AnimatedValueBuilder] and [RepeatedAnimationBuilder]. For determinate mode,
  /// interpolates properties using [_LinearProgressIndicatorProperties] and paints via
  /// [_LinearProgressIndicatorPainter]. Indeterminate mode cycles two progress segments with
  /// predefined curves for fluid motion. Wraps in [ClipRRect] for border radius and [SizedBox]
  /// for height, ensuring RTL support via [Directionality] and theme integration with [ArcaneTheme].
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final directionality = Directionality.of(context);
    Widget childWidget;
    if (value != null) {
      childWidget = AnimatedValueBuilder(
          value: _LinearProgressIndicatorProperties(
            start: 0,
            end: value!.clamp(0, 1),
            color: color ?? theme.colorScheme.primary,
            backgroundColor:
                backgroundColor ?? theme.colorScheme.primary.scaleAlpha(0.2),
            showSparks: showSparks,
            sparksColor: color ?? theme.colorScheme.primary,
            sparksRadius: theme.scaling * 16,
            textDirection: directionality,
          ),
          duration: disableAnimation ? Duration.zero : kDefaultDurationX,
          lerp: _LinearProgressIndicatorProperties.lerp,
          curve: Curves.easeOutExpo,
          builder: (context, value, child) {
            return CustomPaint(
              painter: _LinearProgressIndicatorPainter(
                start: 0,
                end: value.end,
                start2: value.start2,
                end2: value.end2,
                color: value.color,
                backgroundColor: value.backgroundColor,
                showSparks: value.showSparks,
                sparksColor: value.sparksColor,
                sparksRadius: value.sparksRadius,
                textDirection: value.textDirection,
              ),
            );
          });
    } else {
      // indeterminate
      childWidget = RepeatedAnimationBuilder(
        start: 0.0,
        end: 1.0,
        duration: const Duration(milliseconds: _kIndeterminateLinearDuration),
        builder: (context, value, child) {
          double start = _line1Tail.transform(value);
          double end = _line1Head.transform(value);
          double start2 = _line2Tail.transform(value);
          double end2 = _line2Head.transform(value);
          return AnimatedValueBuilder(
              duration: kDefaultDurationX,
              lerp: _LinearProgressIndicatorProperties.lerp,
              value: _LinearProgressIndicatorProperties(
                start: start,
                end: end,
                start2: start2,
                end2: end2,
                color: color ?? theme.colorScheme.primary,
                backgroundColor: backgroundColor ??
                    theme.colorScheme.primary.scaleAlpha(0.2),
                showSparks: showSparks,
                sparksColor: color ?? theme.colorScheme.primary,
                sparksRadius: theme.scaling * 16,
                textDirection: directionality,
              ),
              builder: (context, prop, child) {
                return CustomPaint(
                  painter: _LinearProgressIndicatorPainter(
                    // do not animate start and end value
                    start: start,
                    end: end,
                    start2: start2,
                    end2: end2,
                    color: prop.color,
                    backgroundColor: prop.backgroundColor,
                    showSparks: prop.showSparks,
                    sparksColor: prop.sparksColor,
                    sparksRadius: prop.sparksRadius,
                    textDirection: prop.textDirection,
                  ),
                );
              });
        },
      );
    }
    return RepaintBoundary(
      child: SizedBox(
        height: minHeight ?? (theme.scaling * 2),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: childWidget,
        ),
      ),
    );
  }
}

/// Internal class holding properties for linear progress interpolation during animations,
/// supporting both single and dual progress segments for determinate and indeterminate states.
/// Used by [FancyProgressBar] to smoothly transition between progress values, colors, and effects
/// while respecting [TextDirection] for RTL layouts.
class _LinearProgressIndicatorProperties {
  final double start;
  final double end;
  final double? start2;
  final double? end2;
  final Color color;
  final Color backgroundColor;
  final bool showSparks;
  final Color sparksColor;
  final double sparksRadius;
  final TextDirection textDirection;

  const _LinearProgressIndicatorProperties({
    required this.start,
    required this.end,
    this.start2,
    this.end2,
    required this.color,
    required this.backgroundColor,
    required this.showSparks,
    required this.sparksColor,
    required this.sparksRadius,
    required this.textDirection,
  });

  /// Linearly interpolates between two [_LinearProgressIndicatorProperties] instances for smooth
  /// animations in [FancyProgressBar]. Handles optional secondary segments (start2/end2), color
  /// blending, and scalar values like radius, ensuring null-safe lerping for indeterminate modes.
  static _LinearProgressIndicatorProperties lerp(
    _LinearProgressIndicatorProperties a,
    _LinearProgressIndicatorProperties b,
    double t,
  ) {
    return _LinearProgressIndicatorProperties(
      start: _lerpDouble(a.start, b.start, t)!,
      end: _lerpDouble(a.end, b.end, t)!,
      start2: _lerpDouble(a.start2, b.start2, t),
      end2: _lerpDouble(a.end2, b.end2, t),
      color: Color.lerp(a.color, b.color, t)!,
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      showSparks: b.showSparks,
      sparksColor: Color.lerp(a.sparksColor, b.sparksColor, t)!,
      sparksRadius: _lerpDouble(a.sparksRadius, b.sparksRadius, t)!,
      textDirection: b.textDirection,
    );
  }
}

double? _lerpDouble(double? a, double? b, double t) {
  if (a == null && b == null) {
    return null;
  }
  if (a!.isNaN || b!.isNaN) {
    return double.nan;
  }
  return a + (b - a) * t;
}

/// Custom painter for rendering the [FancyProgressBar] visuals, drawing a rounded background track,
/// progress fill rectangles (one or two for indeterminate), and optional radial gradient sparks.
/// Optimizes repaints by comparing all properties, integrating with [ArcaneTheme] colors for consistency
/// in [Section] or [Dialog] progress indicators.
class _LinearProgressIndicatorPainter extends CustomPainter {
  static final gradientTransform =
      (Matrix4.identity()..scale(1.0, 0.5)).storage;

  final double start;
  final double end;
  final double? start2; // for indeterminate
  final double? end2;
  final Color color;
  final Color backgroundColor;
  final bool showSparks;
  final Color sparksColor;
  final double sparksRadius;
  final TextDirection textDirection;

  _LinearProgressIndicatorPainter({
    required this.start,
    required this.end,
    this.start2,
    this.end2,
    required this.color,
    required this.backgroundColor,
    required this.showSparks,
    required this.sparksColor,
    required this.sparksRadius,
    this.textDirection = TextDirection.ltr,
  });

  /// Paints the progress bar on the provided [Canvas] within the given [Size], handling RTL flipping,
  /// NaN clamping, background rounded rect, progress rectangles (primary and optional secondary),
  /// and spark effects using [RadialGradient] centered at the end position for dynamic visuals.
  @override
  void paint(Canvas canvas, Size size) {
    var start = this.start;
    var end = this.end;
    var start2 = this.start2;
    var end2 = this.end2;
    if (textDirection == TextDirection.rtl) {
      start = 1 - end;
      end = 1 - this.start;
      if (start2 != null && end2 != null) {
        start2 = 1 - end2;
        end2 = 1 - this.start2!;
      }
    }

    if (start.isNaN) {
      start = 0;
    }
    if (end.isNaN) {
      end = 0;
    }
    if (start2 != null && start2.isNaN) {
      start2 = 0;
    }
    if (end2 != null && end2.isNaN) {
      end2 = 0;
    }

    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = backgroundColor;

    canvas.drawRRect(
      RRect.fromLTRBR(
          0, 0, size.width, size.height, Radius.circular(size.height / 2)),
      paint,
    );

    paint.color = color;
    var rectValue = Rect.fromLTWH(
      size.width * start,
      0,
      size.width * (end - start),
      size.height,
    );
    canvas.drawRect(rectValue, paint);
    if (start2 != null && end2 != null) {
      rectValue = Rect.fromLTWH(
        size.width * start2,
        0,
        size.width * (end2 - start2),
        size.height,
      );
      canvas.drawRect(rectValue, paint);
    }

    if (showSparks) {
      // use RadialGradient to create sparks

      final gradient = Gradient.radial(
        // colors: [sparksColor, Colors.transparent],
        // stops: const [0.0, 1.0],
        Offset(size.width * (end - start), size.height / 2),
        sparksRadius,
        [
          sparksColor,
          sparksColor.withAlpha(0),
        ],
        [0.0, 1.0],
        TileMode.clamp,
        // scale to make oval
        gradientTransform,
      );
      paint.shader = gradient;
      canvas.drawCircle(
        Offset(size.width * (end - start), size.height / 2),
        sparksRadius,
        paint,
      );
    }
  }

  /// Determines if repainting is needed by comparing all visual properties against the old delegate,
  /// including progress values, colors, sparks, and direction, to optimize performance in animated
  /// [FancyProgressBar] instances within dynamic UIs like [Selector] loading states.
  @override
  bool shouldRepaint(covariant _LinearProgressIndicatorPainter oldDelegate) {
    return oldDelegate.start != start ||
        oldDelegate.end != end ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.showSparks != showSparks ||
        oldDelegate.sparksColor != sparksColor ||
        oldDelegate.sparksRadius != sparksRadius ||
        oldDelegate.textDirection != textDirection ||
        oldDelegate.start2 != start2 ||
        oldDelegate.end2 != end2;
  }
}

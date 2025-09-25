import 'package:arcane/arcane.dart';

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

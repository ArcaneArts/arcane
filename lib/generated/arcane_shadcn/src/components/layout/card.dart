import 'package:arcane/arcane.dart';

class Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool filled;
  final Color? fillColor;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final Clip clipBehavior;
  final List<BoxShadow>? boxShadow;
  final double? surfaceOpacity;
  final double? surfaceBlur;
  final Duration? duration;
  final VoidCallback? onPressed;

  const Card({
    super.key,
    required this.child,
    this.padding,
    this.filled = false,
    this.fillColor,
    this.borderRadius,
    this.clipBehavior = Clip.none,
    this.borderColor,
    this.borderWidth,
    this.boxShadow,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.duration,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    Widget m = DefaultTextStyle.merge(
      child: child,
      style: TextStyle(
        color: theme.colorScheme.cardForeground,
      ),
    );
    EdgeInsetsGeometry p = padding ?? (EdgeInsets.all(16 * scaling));
    return OutlinedContainer(
      clipBehavior: clipBehavior,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      borderColor: borderColor,
      backgroundColor: filled
          ? fillColor ?? theme.colorScheme.border
          : theme.colorScheme.card,
      boxShadow: boxShadow,
      padding: onPressed != null ? EdgeInsets.zero : p,
      surfaceOpacity: surfaceOpacity,
      surfaceBlur: surfaceBlur,
      duration: duration,
      child: onPressed != null
          ? GhostButton(
              onPressed: onPressed,
              density: ButtonDensity.compact,
              child: Padding(
                padding: p,
                child: m,
              ))
          : m,
    );
  }
}

class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool filled;
  final Color? fillColor;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final Clip clipBehavior;
  final List<BoxShadow>? boxShadow;
  final double? surfaceOpacity;
  final double? surfaceBlur;
  final Duration? duration;

  const SurfaceCard({
    super.key,
    required this.child,
    this.padding,
    this.filled = false,
    this.fillColor,
    this.borderRadius,
    this.clipBehavior = Clip.none,
    this.borderColor,
    this.borderWidth,
    this.boxShadow,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var isSheetOverlay = SheetOverlayHandler.isSheetOverlay(context);
    final scaling = theme.scaling;
    var padding = this.padding;
    if (isSheetOverlay) {
      return Padding(
        padding: padding ?? (EdgeInsets.all(16 * scaling)),
        child: child,
      );
    }
    return Glass(
        ignoreContextSignals: true,
        child: Card(
          clipBehavior: clipBehavior,
          borderRadius: borderRadius,
          borderWidth: borderWidth,
          borderColor: borderColor,
          filled: filled,
          fillColor: fillColor,
          boxShadow: boxShadow,
          padding: padding,
          surfaceOpacity: 0,
          surfaceBlur: 0,
          duration: duration,
          child: child,
        ));
  }
}

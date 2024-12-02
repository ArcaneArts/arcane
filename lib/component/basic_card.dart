import 'package:arcane/arcane.dart';

/// Card(child: Basic()) macro
class BasicCard extends StatelessWidget {
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
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? content;
  final Widget? trailing;
  final AlignmentGeometry? leadingAlignment;
  final AlignmentGeometry? trailingAlignment;
  final AlignmentGeometry? titleAlignment;
  final AlignmentGeometry? subtitleAlignment;
  final AlignmentGeometry? contentAlignment;
  final double? contentSpacing;
  final double? titleSpacing;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsetsGeometry? basicPadding;

  const BasicCard({
    super.key,
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
    this.leading,
    this.title,
    this.subtitle,
    this.content,
    this.trailing,
    this.leadingAlignment,
    this.trailingAlignment,
    this.titleAlignment,
    this.subtitleAlignment,
    this.contentAlignment,
    this.contentSpacing, // 16
    this.titleSpacing, //4
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.basicPadding,
  });

  @override
  Widget build(BuildContext context) => Card(
      onPressed: onPressed,
      padding: padding,
      surfaceOpacity: surfaceOpacity,
      surfaceBlur: surfaceBlur,
      filled: filled,
      duration: duration,
      clipBehavior: clipBehavior,
      borderRadius: borderRadius,
      borderColor: borderColor,
      borderWidth: borderWidth,
      boxShadow: boxShadow,
      fillColor: fillColor,
      child: Basic(
        padding: basicPadding,
        title: title,
        leading: leading,
        subtitle: subtitle,
        trailing: trailing,
        content: content,
        contentAlignment: contentAlignment,
        contentSpacing: contentSpacing,
        leadingAlignment: leadingAlignment,
        mainAxisAlignment: mainAxisAlignment,
        subtitleAlignment: subtitleAlignment,
        titleAlignment: titleAlignment,
        titleSpacing: titleSpacing,
        trailingAlignment: trailingAlignment,
      ));
}

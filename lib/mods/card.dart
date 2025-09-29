import 'package:arcane/arcane.dart';
import 'package:arcane/generated/arcane_shadcn/shadcn_flutter.dart' as c
    show Card;

class Card extends StatelessWidget with BoxSignal {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final bool? filled;
  final Color? fillColor;
  final BorderRadiusGeometry? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final Clip? clipBehavior;
  final List<BoxShadow>? boxShadow;
  final double? surfaceOpacity;
  final double? surfaceBlur;
  final Duration? duration;
  final VoidCallback? onPressed;
  final bool dashedBorder;
  final double thumbHashIntensityMultiplier;
  final String? thumbHash;
  final bool thumbHashUseShaders;
  final IconData? leadingIcon;
  final Widget? leading;
  final Widget? title;
  final String? titleText;
  final Widget? subtitle;
  final String? subtitleText;
  final Widget? content;
  final List<Widget>? children;
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
  final bool spanning;

  const Card({
    super.key,
    this.child,
    this.children,
    this.thumbHash,
    this.thumbHashIntensityMultiplier = 1,
    this.padding,
    this.filled,
    this.fillColor,
    this.borderRadius,
    this.clipBehavior,
    this.borderColor,
    this.borderWidth,
    this.boxShadow,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.duration,
    this.onPressed,
    this.thumbHashUseShaders = true,
    this.dashedBorder = false,
    this.leadingIcon,
    this.leading,
    this.title,
    this.titleText,
    this.subtitle,
    this.subtitleText,
    this.content,
    this.trailing,
    this.leadingAlignment,
    this.trailingAlignment,
    this.titleAlignment,
    this.subtitleAlignment,
    this.contentAlignment,
    this.contentSpacing,
    this.titleSpacing,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.basicPadding,
    this.spanning = false,
  });

  @override
  Widget build(BuildContext context) {
    bool hasBasic = leading != null ||
        title != null ||
        subtitle != null ||
        content != null ||
        trailing != null ||
        leadingIcon != null ||
        titleText != null ||
        subtitleText != null;

    Widget child = children != null && !hasBasic
        ? Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: children!,
          )
        : this.child != null && !hasBasic
            ? this.child!
            : Basic(
                padding: basicPadding,
                title: titleText?.text ?? title,
                leading: leadingIcon?.icon ?? leading,
                subtitle: subtitleText?.text ?? subtitle,
                trailing: trailing,
                content: content ??
                    (children != null
                        ? Column(
                            mainAxisAlignment: mainAxisAlignment,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: children!,
                          )
                        : this.child),
                contentAlignment: contentAlignment,
                contentSpacing: contentSpacing,
                leadingAlignment: leadingAlignment,
                mainAxisAlignment: mainAxisAlignment,
                subtitleAlignment: subtitleAlignment,
                titleAlignment: titleAlignment,
                titleSpacing: titleSpacing,
                trailingAlignment: trailingAlignment,
              );

    CardTheme? compTheme = ComponentTheme.maybeOf<CardTheme>(context);
    ThemeData theme = Theme.of(context);
    double scaling = theme.scaling;
    EdgeInsetsGeometry mPadding = styleValue<EdgeInsetsGeometry>(
      widgetValue: padding,
      themeValue: compTheme?.padding,
      defaultValue: EdgeInsets.all(16 * scaling),
    );
    BorderRadiusGeometry br = styleValue(
      themeValue: compTheme?.borderRadius,
      defaultValue: theme.borderRadiusXl,
    );

    if (thumbHash != null) {
      child = Stack(
        children: [
          if (thumbHash != null)
            Positioned.fill(
                child: ClipRRect(
                    borderRadius: br,
                    child: MagicThumbHash(
                            useShaders: thumbHashUseShaders,
                            thumbHash: thumbHash!)
                        .withOpacity((0.15 * thumbHashIntensityMultiplier)
                            .clamp(0.001, 1)))),
          Padding(
            padding: mPadding,
            child: child,
          ),
        ],
      );
    }

    return c.Card(
      padding: thumbHash != null ? EdgeInsetsGeometry.zero : mPadding,
      filled: filled,
      fillColor: fillColor,
      borderRadius: borderRadius,
      clipBehavior: clipBehavior,
      borderColor: borderColor,
      borderWidth: borderWidth,
      boxShadow: boxShadow,
      surfaceOpacity: surfaceOpacity,
      surfaceBlur: surfaceBlur,
      duration: duration,
      onPressed: onPressed,
      dashedBorder: dashedBorder,
      child: child,
    );
  }
}

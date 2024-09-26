import 'package:arcane/arcane.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

enum BarBackButtonMode { never, always, whenPinned }

class Bar extends StatelessWidget {
  final List<Widget> trailing;
  final List<Widget> leading;
  final Widget? child;
  final Widget? title;
  final String? titleText;
  final String? headerText;
  final String? subtitleText;
  final Widget? header; // small widget placed on top of title
  final Widget? subtitle; // small widget placed below title
  final bool
      trailingExpanded; // expand the trailing instead of the main content
  final Alignment alignment;
  final Color? backgroundColor;
  final double? leadingGap;
  final double? trailingGap;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final bool useGlass;
  final BarBackButtonMode backButton;
  final bool ignoreContextSignals;

  const Bar(
      {super.key,
      this.ignoreContextSignals = false,
      this.trailing = const [],
      this.leading = const [],
      this.titleText,
      this.backButton = BarBackButtonMode.always,
      this.headerText,
      this.subtitleText,
      this.title,
      this.header,
      this.subtitle,
      this.child,
      this.trailingExpanded = false,
      this.alignment = Alignment.center,
      this.padding,
      this.backgroundColor,
      this.leadingGap,
      this.trailingGap,
      this.height,
      this.useGlass = true});

  Bar copyWith({
    Key? key,
    List<Widget>? trailing,
    List<Widget>? leading,
    Widget? child,
    Widget? title,
    String? titleText,
    String? headerText,
    String? subtitleText,
    Widget? header,
    Widget? subtitle,
    bool? trailingExpanded,
    Alignment? alignment,
    Color? backgroundColor,
    double? leadingGap,
    double? trailingGap,
    EdgeInsetsGeometry? padding,
    double? height,
    bool? useGlass,
    BarBackButtonMode? backButton,
    bool? ignoreContextSignals,
  }) =>
      Bar(
        key: key ?? this.key,
        trailing: trailing ?? this.trailing,
        leading: leading ?? this.leading,
        title: title ?? this.title,
        titleText: titleText ?? this.titleText,
        headerText: headerText ?? this.headerText,
        subtitleText: subtitleText ?? this.subtitleText,
        header: header ?? this.header,
        subtitle: subtitle ?? this.subtitle,
        trailingExpanded: trailingExpanded ?? this.trailingExpanded,
        alignment: alignment ?? this.alignment,
        padding: padding ?? this.padding,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        leadingGap: leadingGap ?? this.leadingGap,
        trailingGap: trailingGap ?? this.trailingGap,
        height: height ?? this.height,
        useGlass: useGlass ?? this.useGlass,
        backButton: backButton ?? this.backButton,
        ignoreContextSignals: ignoreContextSignals ?? this.ignoreContextSignals,
        child: child ?? this.child,
      );

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Glass(
              tint: Theme.of(context)
                  .colorScheme
                  .background
                  .withOpacity(Theme.of(context).surfaceOpacity ?? 0.5),
              ignoreContextSignals: ignoreContextSignals,
              disabled: !useGlass,
              blur: Theme.of(context).surfaceBlur ?? 16,
              child: SafeBar.withSafety(
                  context,
                  AppBar(
                    leading: [
                      if ((backButton == BarBackButtonMode.always ||
                              (backButton == BarBackButtonMode.whenPinned &&
                                  !GlassStopper.isStopping(context))) &&
                          Navigator.canPop(context) &&
                          !BlockBackButton.isBlocking(context))
                        GhostButton(
                            density: ButtonDensity.icon,
                            child: context.inSheet
                                ? const Icon(PhosphorIcons.x_bold)
                                : const Icon(PhosphorIcons.caret_left_bold),
                            onPressed: () => Arcane.pop(context)),
                      ...leading
                    ],
                    surfaceOpacity: 0,
                    trailing: trailing,
                    title: titleText?.text ?? title,
                    header: headerText?.text ?? header,
                    subtitle: subtitleText?.text ?? subtitle,
                    trailingExpanded: trailingExpanded,
                    alignment: alignment,
                    padding: padding,
                    backgroundColor: backgroundColor,
                    leadingGap: leadingGap,
                    trailingGap: trailingGap,
                    height: height,
                    surfaceBlur: 0,
                    child: child,
                  )))
        ],
      );
}

class SafeBar extends StatelessWidget {
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;
  final PylonBuilder builder;

  static Widget withSafety(BuildContext context, Widget widget) {
    SafeBar? s = context.pylonOr<SafeBar>();

    if (s != null) {
      return SafeArea(
        top: s.top,
        bottom: s.bottom,
        left: s.left,
        right: s.right,
        child: widget,
      );
    }
    return widget;
  }

  const SafeBar(
      {super.key,
      this.top = false,
      this.bottom = false,
      this.left = false,
      this.right = false,
      required this.builder});

  @override
  Widget build(BuildContext context) => Pylon<SafeBar>(
        local: true,
        value: this,
        builder: builder,
      );
}

class BlockBackButton extends StatelessWidget {
  final bool block;
  final PylonBuilder builder;

  static bool isBlocking(BuildContext context) =>
      context.pylonOr<BlockBackButton>()?.block ?? false;

  const BlockBackButton({super.key, this.block = true, required this.builder});

  @override
  Widget build(BuildContext context) => Pylon<BlockBackButton>(
        local: true,
        value: this,
        builder: builder,
      );
}

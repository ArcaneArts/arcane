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
  final bool useSafeArea;
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
      this.useGlass = true,
      this.useSafeArea = true});

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Glass(
              ignoreContextSignals: ignoreContextSignals,
              disabled: !useGlass,
              blur: Theme.of(context).surfaceBlur ?? 16,
              child: AppBar(
                leading: [
                  if ((backButton == BarBackButtonMode.always ||
                          (backButton == BarBackButtonMode.whenPinned &&
                              !GlassStopper.isStopping(context))) &&
                      Navigator.canPop(context))
                    GhostButton(
                        density: ButtonDensity.icon,
                        child: context.inSheet
                            ? const Icon(PhosphorIcons.x_bold)
                            : const Icon(PhosphorIcons.caret_left_bold),
                        onPressed: () => Arcane.pop(context)),
                  ...leading
                ],
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
                surfaceOpacity: 0,
                useSafeArea: useSafeArea,
                child: child,
              ))
        ],
      );
}

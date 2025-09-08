import 'package:arcane/arcane.dart';
import 'package:arcane/component/glow_card.dart';

class MagicTile extends StatelessWidget with BoxSignal {
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onPressed;
  final String? titleText;
  final String? subtitleText;
  final IconData? leadingIcon;
  final bool essentialLeading;
  final bool essentialTrailing;
  final List<MenuItem> contextMenu;
  final bool contextMenuEnabled;
  final bool fatPad;
  final double fatThreshold;
  final double leadingThreshold;
  final double trailingThreshold;
  final String? thumbHash;

  const MagicTile({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.thumbHash,
    this.onPressed,
    this.titleText,
    this.subtitleText,
    this.leadingIcon,
    this.contextMenu = const [],
    this.fatPad = true,
    this.contextMenuEnabled = false,
    this.essentialLeading = false,
    this.essentialTrailing = true,
    this.fatThreshold = 500,
    this.leadingThreshold = 300,
    this.trailingThreshold = 350,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ContextMenu(
        items: contextMenu,
        enabled: contextMenuEnabled && contextMenu.isNotEmpty,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          child: width > fatThreshold
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: fatPad ? 16 : 0, vertical: 4),
                  child: GlowCard(
                    thumbHash: thumbHash,
                    surfaceOpacity: context.isTranslucent
                        ? ArcaneTheme.of(context).surfaceOpacity
                        : null,
                    surfaceBlur: context.isTranslucent
                        ? ArcaneTheme.of(context).surfaceBlur
                        : null,
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: leading != null &&
                                  leading is Icon &&
                                  (leading as Icon).color != null
                              ? (leading as Icon).color!.withOpacity(0.1)
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: leadingIcon != null
                            ? Icon(leadingIcon,
                                color: leading != null &&
                                        leading is Icon &&
                                        (leading as Icon).color != null
                                    ? (leading as Icon).color!
                                    : Theme.of(context)
                                        .colorScheme
                                        .accentForeground)
                            : leading != null && leading is Icon
                                ? Icon((leading as Icon).icon,
                                    color: leading != null &&
                                            leading is Icon &&
                                            (leading as Icon).color != null
                                        ? (leading as Icon).color!
                                        : Theme.of(context)
                                            .colorScheme
                                            .accentForeground)
                                : leading,
                      ),
                      title: title ?? Text(titleText ?? ''),
                      subtitle: subtitle == null && subtitleText == null
                          ? null
                          : subtitle ?? Text(subtitleText ?? ''),
                      trailing: trailing,
                      onPressed: onPressed,
                    ),
                  ),
                )
              : ListTile(
                  leading: width > leadingThreshold || essentialLeading
                      ? leading ??
                          (leadingIcon != null ? Icon(leadingIcon) : null)
                      : null,
                  title: title ?? Text(titleText ?? ''),
                  subtitle: subtitle == null && subtitleText == null
                      ? null
                      : subtitle ?? Text(subtitleText ?? ''),
                  trailing: width > trailingThreshold || essentialTrailing
                      ? trailing
                      : null,
                  onPressed: onPressed,
                ),
        )).blurIn;
  }
}

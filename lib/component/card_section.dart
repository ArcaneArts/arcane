import 'package:arcane/arcane.dart';
import 'package:arcane/component/glow_card.dart';

class CardSection extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final Widget? title;
  final Widget? subtitle;
  final List<Widget> children;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final String? titleText;
  final String? subtitleText;
  final bool essentialLeading;
  final bool essentialTrailing;
  final double leadingThreshold;
  final double trailingThreshold;
  final String? thumbHash;

  const CardSection(
      {super.key,
      this.leading,
      this.thumbHash,
      this.trailing,
      this.leadingThreshold = 300,
      this.trailingThreshold = 350,
      this.title,
      this.subtitle,
      this.essentialLeading = false,
      this.essentialTrailing = true,
      this.onPressed,
      this.leadingIcon,
      this.titleText,
      this.subtitleText,
      this.children = const []});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Pylon<OverrideEdgeInsets>(
      value: OverrideEdgeInsets(
          const EdgeInsets.symmetric(vertical: 8, horizontal: 8)),
      builder: (context) => GlowCard(
        thumbHash: thumbHash,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Basic(
                  leading: width > leadingThreshold || essentialLeading
                      ? (leading ??
                          (leadingIcon != null
                              ? FancyIcon(icon: leadingIcon!)
                              : null))
                      : null,
                  trailing: width > trailingThreshold || essentialTrailing
                      ? trailing
                      : null,
                  title: title ?? (titleText != null ? Text(titleText!) : null),
                  subtitle: subtitle ??
                      (subtitleText != null ? Text(subtitleText!) : null),
                ))
              ],
            ),
            if (children.isNotEmpty) ...[
              Gap(16),
              Divider(),
              Gap(8),
              ...children
            ]
          ],
        ),
      ),
    );
  }
}

class OverrideEdgeInsets {
  final EdgeInsetsGeometry insets;

  const OverrideEdgeInsets(this.insets);
}

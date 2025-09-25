import 'package:arcane/arcane.dart';

/// A [StatelessWidget] that creates a structured card section for organizing content in Arcane UI.
///
/// This widget groups related items within a [GlowCard], featuring an optional header with leading/trailing elements,
/// title, and subtitle, followed by a list of children separated by a [Divider]. It integrates with [ArcaneTheme]
/// for consistent styling, including borders and elevation. Use in [FillScreen] or [SliverScreen] for modular content
/// sections, such as grouping [BasicCard]s or form fields. Supports responsive design by conditionally showing
/// leading/trailing based on screen width thresholds, ensuring efficient rendering with const constructors and
/// minimal rebuilds. Key features include thumbhash for blurred backgrounds, dashed borders, and press callbacks
/// for interactive sections.
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
  final bool dashedBorder;

  /// Creates a [CardSection] with customizable header and content.
  ///
  /// - [key]: Standard Flutter key for widget identification.
  /// - [leading]: Optional leading widget (e.g., icon or image) shown on wider screens or when essential.
  /// - [thumbHash]: Optional thumbhash string for generating a blurred background image in the [GlowCard].
  /// - [trailing]: Optional trailing widget (e.g., action button) shown on wider screens or when essential.
  /// - [leadingThreshold]: Screen width threshold (default 300) below which leading is hidden unless essential.
  /// - [trailingThreshold]: Screen width threshold (default 350) below which trailing is hidden unless essential.
  /// - [title]: Optional [Widget] for the section title, or use [titleText] for simple text.
  /// - [subtitle]: Optional [Widget] for the section subtitle, or use [subtitleText] for simple text.
  /// - [essentialLeading]: If true, forces leading to always show regardless of width.
  /// - [essentialTrailing]: If true (default), forces trailing to always show regardless of width.
  /// - [onPressed]: Optional callback for handling press events on the section.
  /// - [leadingIcon]: Optional [IconData] to display as a [FancyIcon] if no [leading] provided.
  /// - [titleText]: Simple string for title if no [title] widget provided; rendered as [Text].
  /// - [subtitleText]: Simple string for subtitle if no [subtitle] widget provided; rendered as [Text].
  /// - [children]: List of [Widget]s for the section body; separated by [Divider] if non-empty.
  /// - [dashedBorder]: If true, applies a dashed border style to the [GlowCard].
  ///
  /// Usage example: `CardSection(title: Text('Details'), children: [BasicCard(...)])` for structured content in screens.
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
      this.children = const [],
      this.dashedBorder = false});

  /// Builds the [CardSection] widget, applying responsive layout and theme integrations.
  ///
  /// Uses [MediaQuery] to determine screen width and conditionally renders leading/trailing via [Basic] widget.
  /// Wraps content in [Pylon] with [OverrideEdgeInsets] for custom padding, then [GlowCard] for elevated appearance.
  /// The body is a [Column] with header [Row], optional [Gap], [Divider], and children. Integrates [ArcaneTheme]
  /// for colors, borders, and elevation. Efficiently handles empty children to avoid unnecessary [Divider] rendering.
  /// Supports performance by using const widgets where possible and avoiding deep rebuilds in lists.
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Pylon<OverrideEdgeInsets>(
      value: OverrideEdgeInsets(
          const EdgeInsets.symmetric(vertical: 8, horizontal: 0)),
      builder: (context) => GlowCard(
        dashedBorder: dashedBorder,
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

/// A simple wrapper class for overriding [EdgeInsetsGeometry] values in the widget tree.
///
/// Used internally by [CardSection] via [Pylon] to apply custom vertical/horizontal padding (e.g., symmetric 8px vertical).
/// Allows theme-consistent spacing without direct [Padding] widget nesting, promoting efficient layout.
class OverrideEdgeInsets {
  final EdgeInsetsGeometry insets;

  const OverrideEdgeInsets(this.insets);
}

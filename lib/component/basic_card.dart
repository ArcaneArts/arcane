import 'package:arcane/arcane.dart';

/// A wrapper widget that combines the functionality of [Card] and [Basic] components
/// to create styled cards with structured content.
///
/// [BasicCard] provides a convenient way to create cards with title, subtitle,
/// leading, trailing, and content sections. It offers flexible layout options,
/// customizable styling, and touch interactivity.
///
/// See also:
///  * [doc/component/basic_card.md] for more detailed documentation
///  * [Card] - The base card component used by BasicCard for styling
///  * [Basic] - Used internally to structure the content of the card
///  * [Tile] - A similar component for list items
class BasicCard extends StatelessWidget {
  /// Padding around the entire card
  final EdgeInsetsGeometry? padding;

  /// Whether the card has a filled background
  final bool filled;

  /// Background color of the card
  final Color? fillColor;

  /// Radius of the card's corners
  final BorderRadiusGeometry? borderRadius;

  /// Color of the card's border
  final Color? borderColor;

  /// Width of the card's border
  final double? borderWidth;

  /// How to clip content that overflows the card
  final Clip clipBehavior;

  /// Shadow effects applied to the card
  final List<BoxShadow>? boxShadow;

  /// Opacity of the card's surface
  final double? surfaceOpacity;

  /// Blur amount for the card's background
  final double? surfaceBlur;

  /// Duration for card animations
  final Duration? duration;

  /// Function called when the card is tapped
  final VoidCallback? onPressed;

  /// Widget displayed at the start of the card
  final Widget? leading;

  /// Main title widget
  final Widget? title;

  /// Subtitle widget displayed below the title
  final Widget? subtitle;

  /// Main content of the card
  final Widget? content;

  /// Widget displayed at the end of the card
  final Widget? trailing;

  /// Alignment for the leading widget
  final AlignmentGeometry? leadingAlignment;

  /// Alignment for the trailing widget
  final AlignmentGeometry? trailingAlignment;

  /// Alignment for the title widget
  final AlignmentGeometry? titleAlignment;

  /// Alignment for the subtitle widget
  final AlignmentGeometry? subtitleAlignment;

  /// Alignment for the content widget
  final AlignmentGeometry? contentAlignment;

  /// Space between content and title/subtitle
  final double? contentSpacing;

  /// Space between title and subtitle
  final double? titleSpacing;

  /// Main axis alignment for the card content
  final MainAxisAlignment mainAxisAlignment;

  /// Padding applied to the inner Basic widget
  final EdgeInsetsGeometry? basicPadding;

  final bool spanned;

  /// Creates a [BasicCard] widget.
  ///
  /// A [BasicCard] is a convenience widget that combines [Card] and [Basic] to create
  /// styled cards with structured content.
  ///
  /// Example:
  /// ```dart
  /// BasicCard(
  ///   title: Text("Card Title"),
  ///   content: Text("This is the content of the card with more details."),
  ///   onPressed: () => print("Card was tapped"),
  /// )
  /// ```
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
    this.spanned = false,
    this.contentAlignment,
    this.contentSpacing, // 16
    this.titleSpacing, //4
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.basicPadding,
  });

  @override
  Widget build(BuildContext context) {
    Widget b = Basic(
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
    );
    return Card(
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
        child: spanned
            ? Row(
                children: [b],
              )
            : b);
  }
}

import 'package:arcane/arcane.dart';

/// A basic card widget in the Arcane UI library that extends the functionality of
/// [Card] with integrated [ArcaneTheme] styling, customizable padding, elevation,
/// and structured content layout. It combines [GlowCard] for visual effects like
/// shadows and borders with [Basic] for organizing title, subtitle, leading,
/// trailing, and content sections, providing a lightweight, performant container
/// for simple content display.
///
/// Key features include:
/// - Theming integration via [ArcaneTheme] for consistent colors, radii, and shadows.
/// - Flexible content alignment and spacing for title, subtitle, and body.
/// - Optional interactivity with [onPressed] for tap handling.
/// - Support for blurred or opaque surfaces, dashed borders, and thumbnail hashes
///   for optimized image loading.
/// - Const decoration and inline composition for minimal rebuilds and efficient
///   rendering.
///
/// Usage: Ideal for displaying concise information in lists such as [DataTable]
/// rows, [Tile] companions, or within [CardSection] groupings. For example, use
/// in a [Section] to present user profiles or summary cards:
///
/// ```dart
/// BasicCard(
///   title: Text('User Profile'),
///   subtitle: Text('Active Member'),
///   leading: CircleAvatar(child: Icon(Icons.person)),
///   content: Text('Detailed description here.'),
///   trailing: Icon(Icons.arrow_forward),
///   onPressed: () => navigateToProfile(),
/// )
/// ```
///
/// Integrates seamlessly with [Container] for additional wrapping, [Padding] for
/// margins, [BorderRadius] for custom shapes, and [BoxShadow] for depth. For
/// advanced cards with glow effects, prefer [GlowCard] directly; BasicCard
/// emphasizes simplicity and performance for basic content cards in Arcane apps.
class BasicCard extends StatelessWidget {
  /// Padding around the entire card
  final EdgeInsetsGeometry? padding;

  /// Whether the card has a filled background
  final bool filled;

  final String? thumbHash;

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

  final bool dashedBorder;

  /// Creates a [BasicCard] widget with customizable styling and content structure.
  ///
  /// This constructor initializes a basic card that wraps content in [GlowCard] for
  /// visual styling (e.g., elevation via [boxShadow], borders with [borderColor]
  /// and [borderWidth], rounded corners using [borderRadius]) and [Basic] for layout
  /// (e.g., positioning [leading], [title], [subtitle], [content], and [trailing]
  /// with alignments like [leadingAlignment] and spacing via [contentSpacing]).
  ///
  /// Parameters control appearance and behavior:
  /// - [padding]: Outer padding around the card, defaults to none.
  /// - [filled]: If true, applies a solid [fillColor] background; otherwise, transparent.
  /// - [thumbHash]: BlurHash string for placeholder during image loading in content.
  /// - [fillColor]: Custom background color, overrides [ArcaneTheme] if provided.
  /// - [borderRadius]: Corner radius geometry, integrates with [ArcaneTheme]'s default.
  /// - [clipBehavior]: Clipping mode for overflowing content, defaults to [Clip.none].
  /// - [borderColor] and [borderWidth]: Define border styling, useful for outlined cards.
  /// - [boxShadow]: Custom shadows for elevation, enhancing depth in [DataTable] or [Tile].
  /// - [surfaceOpacity] and [surfaceBlur]: Apply semi-transparent or blurred overlays.
  /// - [duration]: Animation timing for press effects or transitions.
  /// - [onPressed]: Optional tap handler, enabling interactive cards like in [CardSection].
  /// - [leading], [title], [subtitle], [content], [trailing]: Core content widgets.
  /// - [leadingAlignment], [trailingAlignment], [titleAlignment], [subtitleAlignment],
  ///   [contentAlignment]: Position elements within their slots.
  /// - [contentSpacing] and [titleSpacing]: Vertical gaps between sections.
  /// - [mainAxisAlignment]: Aligns content along the main axis, defaults to center.
  /// - [basicPadding]: Inner padding for the [Basic] layout structure.
  /// - [spanned]: If true, wraps content in a [Row] for full-width spanning.
  /// - [dashedBorder]: Renders a dashed border style when true.
  ///
  /// Returns a performant [StatelessWidget] suitable for lists or sections, leveraging
  /// const constructors and inline composition to minimize rebuilds. For usage in
  /// [ArcaneApp], ensure [ArcaneTheme] is applied at the root for consistent styling.
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
    this.dashedBorder = false,
    this.fillColor,
    this.borderRadius,
    this.clipBehavior = Clip.none,
    this.thumbHash,
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

  /// Builds the [BasicCard] widget by composing [Basic] for content layout and
  /// [GlowCard] for visual styling, applying [ArcaneTheme] integrations for colors
  /// and shadows while handling spanned layouts via [Row] for full-width display.
  ///
  /// This method creates an efficient widget tree: first constructs a [Basic] instance
  /// to arrange [title], [subtitle], [leading], [trailing], and [content] with specified
  /// alignments and spacings. It then wraps this in [GlowCard], passing parameters like
  /// [fillColor], [borderRadius], [boxShadow], and [surfaceBlur] to render themed card
  /// decoration with optional dashed borders ([dashedBorder]) and press effects
  /// ([onPressed], [duration]). If [spanned] is true, embeds the [Basic] in a [Row]
  /// to span available width, ideal for table-like integrations such as [DataTable].
  ///
  /// Performance notes: Uses const constructors where possible and avoids unnecessary
  /// allocations by inlining the composition. Integrates [BorderRadius] and [BoxShadow]
  /// from [ArcaneTheme] for consistent elevation without custom [Container] wrappers.
  /// For content clipping, applies [clipBehavior] to prevent overflow in dense UIs
  /// like [Tile] lists or [CardSection] stacks.
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
    return GlowCard(
        dashedBorder: dashedBorder,
        thumbHash: thumbHash,
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

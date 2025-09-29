import 'package:arcane/arcane.dart';
import 'package:arcane/generated/arcane_shadcn/shadcn_flutter.dart' as c
    show Card;

/// A unified Card widget in the Arcane UI library that combines the functionality of [BasicCard] and [GlowCard],
/// providing structured content layout with optional glow effects using thumbhash, theming integration via [ArcaneTheme]
/// and [CardTheme], and customizable styling for borders, shadows, and surfaces.
///
/// Key features include:
/// - [Basic]-style layout for organizing [leading], [title], [subtitle], [content], [trailing] with alignments
///   ([leadingAlignment], etc.) and spacing ([contentSpacing], [titleSpacing]), or direct [child]/[children] for simple content.
/// - Optional thumbhash glow background via [MagicThumbHash] with adjustable [thumbHashIntensityMultiplier] and shader support.
/// - Interactivity with [onPressed] and animation [duration]; spanning mode ([spanning]) for full-width [Row] layouts.
/// - Surface effects like [surfaceOpacity], [surfaceBlur], dashed borders ([dashedBorder]), and clipping ([clipBehavior]).
/// - Efficient [StatelessWidget] with [BoxSignal] mixing, const constructors, and inline composition for performance
///   in lists ([DataTable]), sections ([Section]), or screens ([FillScreen], [SliverScreen]).
///
/// Usage: Ideal for displaying structured information with optional visual enhancements. Replaces deprecated [BasicCard]
/// and [GlowCard] as the single card implementation.
///
/// ```dart
/// Card(
///   title: Text('Card Title'),
///   subtitle: Text('Subtitle'),
///   content: Text('Detailed content here.'),
///   leading: Icon(Icons.info),
///   trailing: Icon(Icons.arrow_forward),
///   thumbHash: 'L6PZfRi#00ay%MgmIAa}EVkB~qofR+j[oz;RIaukW',
///   onPressed: () => navigateToDetails(),
/// )
/// ```
///
/// Integrates with [Container] for margins, [Gesture] for advanced interactions, or [CardSection] for groupings.
/// For basic content without structure, use [child] or [children]; for glow-only, provide [thumbHash] with empty structure.
///
/// Creates a [Card] widget combining basic structured layout and glow effects.
///
/// This constructor initializes a versatile card that uses [Basic] for content organization when structured elements
/// ([leading], [title], etc.) are provided, or falls back to direct [child]/[children]. It overlays [thumbHash] glow
/// via [Stack] and [MagicThumbHash] for visual depth, wrapping everything in shadcn [Card] for base styling with
/// theme integration ([ArcaneTheme], [CardTheme]).
///
/// Parameters control layout and appearance:
/// - [child]/[children]: Direct content widget or list for non-structured display; used if no basic elements present.
/// - [leadingIcon]/[leading], [title]/[titleText], [subtitle]/[subtitleText], [content], [trailing]: Structured slots;
///   [titleText]/[subtitleText] render as [Text] if widgets not provided.
/// - [thumbHash], [thumbHashIntensityMultiplier] (default: 1), [thumbHashUseShaders] (default: true): Enable glow background
///   with opacity clamped at 0.15 * multiplier; shaders for smooth rendering.
/// - [padding]: Outer padding around card content; defaults to EdgeInsets.all(16 * scaling) from theme.
/// - [basicPadding]: Inner padding for [Basic] layout structure.
/// - [filled], [fillColor]: Apply solid background; overrides theme if specified.
/// - [borderRadius]: Corner geometry; falls back to [CardTheme.borderRadius] or theme.borderRadiusXl.
/// - [borderColor], [borderWidth], [dashedBorder] (default: false): Outline styling options.
/// - [clipBehavior]: Overflow clipping mode (e.g., [Clip.hardEdge]).
/// - [boxShadow]: Custom elevation shadows.
/// - [surfaceOpacity], [surfaceBlur]: Transparency and blur for glass-like effects.
/// - [duration]: Timing for press animations or transitions.
/// - [onPressed]: Tap callback for interactive cards.
/// - [leadingAlignment], [trailingAlignment], [titleAlignment], [subtitleAlignment], [contentAlignment]:
///   Position elements within their sections (default: unspecified).
/// - [contentSpacing], [titleSpacing]: Vertical gaps between content/title-subtitle (defaults from [Basic]).
/// - [mainAxisAlignment] (default: [MainAxisAlignment.center]): Aligns [children] in [Column] for non-basic mode.
/// - [spanning] (default: auto if basic + [onPressed]): Wraps content in [Row] with [Expanded] for full-width spanning,
///   useful in tables or flexible layouts.
///
/// Returns a performant widget suitable for Arcane apps, minimizing rebuilds via const params and efficient tree structure.
/// Ensure [ArcaneTheme] wraps the app root for optimal theming.
///
/// Builds the [Card] widget by composing content layout, optional glow overlay, and shadcn base styling.
///
/// Inputs: Uses provided parameters and [BuildContext] for theme access ([ArcaneTheme], [CardTheme], [ThemeData.scaling]).
///
/// Logic:
/// - Determines [hasBasic] from presence of structured elements ([leading], [title], etc.).
/// - Sets [spanning] to true if [hasBasic] and [onPressed] (or explicit [spanning]); wraps child in [Row] with [Expanded].
/// - Constructs inner [child]:
///   - If no [hasBasic] and [children] provided: [Column] with [mainAxisAlignment].
///   - Else if no [hasBasic] and [child] provided: direct [child].
///   - Otherwise: [Basic] widget with structured params ([titleText?.text ?? title], etc.), falling back [content] to
///     [Column] of [children] or [child]; applies alignments and spacings.
/// - If [thumbHash] provided: Wraps in [Stack] with [Positioned.fill] [ClipRRect] ([borderRadius]) containing
///   [MagicThumbHash] ([thumbHash], [useShaders]) at opacity (0.15 * [thumbHashIntensityMultiplier]).clamp(0.001, 1),
///   plus [Padding]([padding]) for inner content; sets card [padding] to [EdgeInsets.zero].
/// - Resolves [mPadding] from [padding], [CardTheme.padding], or default EdgeInsets.all(16 * scaling).
/// - Resolves [br] (border radius) from [borderRadius], [CardTheme.borderRadius], or theme.borderRadiusXl.
/// - Returns shadcn [c.Card] with resolved/params: [padding] (adjusted for thumbhash), [filled], [fillColor],
///   [borderRadius], [clipBehavior], [borderColor], [borderWidth], [boxShadow], [surfaceOpacity], [surfaceBlur],
///   [duration], [onPressed], [dashedBorder], and final [child].
///
/// Outputs: A complete, themed [Widget] for integration in layouts like [Section] or [DataTable], ensuring consistent
/// Arcane styling with minimal overhead. Performance optimized by avoiding unnecessary [Container] wrappers and using
/// inline resolutions.
class Card extends StatelessWidget with BoxSignal {
  /// Widget content to display directly within the card when no structured elements are used.
  final Widget? child;

  /// Padding around the card's inner content.
  final EdgeInsetsGeometry? padding;

  /// Whether the card should have a filled background.
  final bool? filled;

  /// Custom background color for the filled card.
  final Color? fillColor;

  /// Geometry for the card's corner radius.
  final BorderRadiusGeometry? borderRadius;

  /// Color of the card's border.
  final Color? borderColor;

  /// Width of the card's border.
  final double? borderWidth;

  /// Clipping behavior for content overflowing the card bounds.
  final Clip? clipBehavior;

  /// List of shadows to apply for elevation and depth.
  final List<BoxShadow>? boxShadow;

  /// Opacity level for the card's surface.
  final double? surfaceOpacity;

  /// Blur radius for the card's background surface.
  final double? surfaceBlur;

  /// Duration for animations like press effects.
  final Duration? duration;

  /// Callback triggered when the card is pressed.
  final VoidCallback? onPressed;

  /// Whether to render the border as dashed.
  final bool dashedBorder;

  /// Multiplier for the intensity of the thumbhash glow effect.
  final double thumbHashIntensityMultiplier;

  /// Thumbhash string for generating a subtle background glow.
  final String? thumbHash;

  /// Whether to use shaders for rendering the thumbhash.
  final bool thumbHashUseShaders;

  /// Icon to display as the leading element.
  final IconData? leadingIcon;

  /// Widget to display at the start of the structured card.
  final Widget? leading;

  /// Widget for the card's main title.
  final Widget? title;

  /// Text string for the title, rendered as [Text] if [title] is null.
  final String? titleText;

  /// Widget for the subtitle below the title.
  final Widget? subtitle;

  /// Text string for the subtitle, rendered as [Text] if [subtitle] is null.
  final String? subtitleText;

  /// Widget for the main body content of the card.
  final Widget? content;

  /// List of widgets for the card's content when using structured layout.
  final List<Widget>? children;

  /// Widget to display at the end of the structured card.
  final Widget? trailing;

  /// Alignment for the leading widget within its slot.
  final AlignmentGeometry? leadingAlignment;

  /// Alignment for the trailing widget within its slot.
  final AlignmentGeometry? trailingAlignment;

  /// Alignment for the title widget.
  final AlignmentGeometry? titleAlignment;

  /// Alignment for the subtitle widget.
  final AlignmentGeometry? subtitleAlignment;

  /// Alignment for the content widget.
  final AlignmentGeometry? contentAlignment;

  /// Spacing between content and title/subtitle sections.
  final double? contentSpacing;

  /// Spacing between title and subtitle.
  final double? titleSpacing;

  /// Main axis alignment for [children] in non-structured mode.
  final MainAxisAlignment mainAxisAlignment;

  /// Padding specifically for the inner [Basic] layout.
  final EdgeInsetsGeometry? basicPadding;

  /// Whether the card should span full width, auto-enabled for basic + onPressed.
  final bool? spanning;

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
    this.spanning,
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

    bool spanning = this.spanning ?? (hasBasic && onPressed != null);

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

    if (spanning) {
      child = Row(
        children: [
          Expanded(child: child),
        ],
      );
    }

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

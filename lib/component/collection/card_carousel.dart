import 'package:arcane/arcane.dart';

/// Theme configuration for [CardCarousel] widgets.
///
/// This class provides customization options for the visual appearance of [CardCarousel]
/// components within the Arcane UI system. It integrates with [ArcaneTheme] to allow
/// global theming of carousel edge effects, ensuring consistent design across the application.
///
/// Key features include control over gradient sharpness for edge fading, which enhances
/// the user experience by visually indicating scrollable content boundaries.
///
/// Usage example:
/// ```dart
/// ArcaneTheme(
///   cardCarousel: CardCarouselTheme(sharpness: 12),
///   child: CardCarousel(children: [/* cards */]),
/// )
/// ```
///
/// See also:
///  * [doc/component/card_carousel.md] for more detailed documentation
///  * [CardCarousel], the widget that applies this theme for horizontal scrolling with fade effects
///  * [ArcaneTheme], the overarching theme system in Arcane
class CardCarouselTheme {
  /// The intensity level for the edge gradient fade effect in [CardCarousel] widgets.
  ///
  /// This integer value determines how sharply the fade transitions from opaque to transparent
  /// at the carousel's edges. Values range from 1 (soft fade) to 12 (sharp fade), with clamping
  /// applied for out-of-range inputs. Higher sharpness creates a more defined boundary, improving
  /// visual cues for scrollable content.
  ///
  /// Type: int
  /// Default: 9 (moderate fade)
  /// Usage: Set via [ArcaneTheme.cardCarousel] or directly in [CardCarousel.sharpness].
  final int sharpness;

  /// Constructs a [CardCarouselTheme] instance with optional sharpness customization.
  ///
  /// The [sharpness] parameter specifies the gradient intensity for edge fades. It defaults
  /// to 9, offering a balanced visual effect suitable for most UI layouts. This constructor
  /// is typically used when defining theme extensions in [ArcaneTheme].
  ///
  /// Parameters:
  /// - sharpness: int (optional, default 9) - Controls fade sharpness (1-12, clamped).
  ///
  /// Example:
  /// ```dart
  /// final theme = CardCarouselTheme(sharpness: 5); // Softer fade
  /// ```
  const CardCarouselTheme({this.sharpness = 9});

  /// Returns a new [CardCarouselTheme] with specified fields overridden.
  ///
  /// This method facilitates immutable theme updates by copying the current instance
  /// and applying changes only to provided parameters. It is useful for theme merging
  /// in [ArcaneTheme] extensions or when propagating partial updates.
  ///
  /// Parameters:
  /// - sharpness: int? (optional) - New sharpness value; retains original if null.
  ///
  /// Returns: [CardCarouselTheme] - Updated theme instance.
  ///
  /// Example:
  /// ```dart
  /// final updated = original.copyWith(sharpness: 10);
  /// ```
  CardCarouselTheme copyWith({int? sharpness}) =>
      CardCarouselTheme(sharpness: sharpness ?? this.sharpness);
}

/// A horizontally scrollable widget container with dynamic edge fading for enhanced UX.
///
/// [CardCarousel] is a specialized [StatefulWidget] in the Arcane component library,
/// designed for displaying sequences of widgets (e.g., [BasicCard], [GlowCard]) in a
/// compact horizontal layout. It supports smooth scrolling with [BouncingScrollPhysics]
/// and overlays semi-transparent gradients at the edges to subtly indicate additional
/// content, preventing abrupt visual cutoffs.
///
/// This component integrates seamlessly with Arcane's theming system via [CardCarouselTheme],
/// allowing customization of fade effects. It is ideal for collection views, galleries,
/// or any horizontal browsing interface where space is constrained.
///
/// Key features:
/// - Automatic edge fading based on scroll position.
/// - Customizable sharpness and color for gradients.
/// - Responsive to theme changes for consistent app-wide styling.
///
/// Usage example:
/// ```dart
/// CardCarousel(
///   children: [
///     GlowCard(child: Text('Item 1')),
///     BasicCard(title: Text('Item 2'), content: Text('Details')),
///     // Additional cards...
///   ],
///   sharpness: 8,
/// )
/// ```
///
/// See also:
///  * [doc/component/card_carousel.md] for more detailed documentation and advanced usage
///  * [CardCarouselTheme], for configuring default fade properties
///  * [BasicCard], [GlowCard], common child widgets for carousels
///  * [ArcaneTheme], overarching theme integration
class CardCarousel extends StatefulWidget {
  /// The collection of widgets to render within the carousel.
  ///
  /// This list is arranged horizontally in a scrollable [Row], enabling users to swipe
  /// through content. While optimized for card-based UIs (e.g., [BasicCard], [CardSection]),
  /// it accepts any [Widget], providing flexibility for images, text, or custom components.
  /// An empty list renders an empty carousel; populate with 3+ items for effective scrolling.
  ///
  /// Type: List<Widget>
  /// Default: const [] (empty list)
  /// Usage: Pass card widgets to create a browsable collection view.
  final List<Widget> children;

  /// Optional override for the edge gradient fade intensity.
  ///
  /// Specifies the sharpness of the fade effect at carousel boundaries. Higher values
  /// (1-12) produce crisper transitions, enhancing visibility of scrollable edges.
  /// If null, inherits from [ArcaneTheme.of(context).cardCarousel.sharpness].
  ///
  /// Type: int? (nullable)
  /// Usage: Set for instance-specific theming; omit for global theme application.
  final int? sharpness;

  /// Optional color for the edge fade overlay gradient.
  ///
  /// Defines the base color for the semi-transparent gradients at the carousel's left
  /// and right edges. Defaults to the theme's background color if null, ensuring seamless
  /// integration with the app's color scheme. Useful for tinted fades in themed sections.
  ///
  /// Type: Color? (nullable)
  /// Usage: Customize for branded or contextual fading effects.
  final Color? featherColor;

  /// Initializes a [CardCarousel] with the provided children and styling options.
  ///
  /// This const constructor supports efficient widget tree building. The [children]
  /// list defines the scrollable content, while [sharpness] and [featherColor] allow
  /// per-instance overrides of theme defaults from [CardCarouselTheme]. The key is
  /// forwarded to the superclass for widget identification.
  ///
  /// Parameters:
  /// - key: Key? (super) - Widget key for build context.
  /// - children: List<Widget> (default const []) - Widgets to display horizontally.
  /// - sharpness: int? (optional) - Fade sharpness override (1-12).
  /// - featherColor: Color? (optional) - Custom fade color.
  ///
  /// For optimal UX, provide at least 3-5 children to enable meaningful scrolling.
  /// Integrates with [ArcaneTheme] for unstyled fallbacks.
  ///
  /// Example:
  /// ```dart
  /// CardCarousel(
  ///   children: [
  ///     BasicCard(
  ///       title: Text("Card 1"),
  ///       content: Text("First card content"),
  ///     ),
  ///     BasicCard(
  ///       title: Text("Card 2"),
  ///       content: Text("Second card content"),
  ///     ),
  ///     BasicCard(
  ///       title: Text("Card 3"),
  ///       content: Text("Third card content"),
  ///     ),
  ///   ],
  ///   sharpness: 10,
  ///   featherColor: Colors.blue.withOpacity(0.1),
  /// )
  /// ```
  const CardCarousel(
      {super.key, this.children = const [], this.sharpness, this.featherColor});

  /// Creates the state object for this [CardCarousel] widget.
  ///
  /// Returns an instance of [_CardCarouselState], which manages the scroll controller
  /// and builds the interactive carousel layout. This override is required for
  /// [StatefulWidget] to handle dynamic scroll listening and gradient animations.
  ///
  /// Returns: [_CardCarouselState] - The state managing scroll and visual effects.
  @override
  State<CardCarousel> createState() => _CardCarouselState();
}

/// Internal state management for [CardCarousel], handling scroll events and rendering.
///
/// This private class extends [State<CardCarousel>] to control the [ScrollController]
/// for horizontal navigation and dynamically update edge fade gradients based on
/// scroll position. It ensures smooth animations and ignores pointer events on
/// overlay gradients to maintain scroll interactivity.
///
/// Key responsibilities:
/// - Initialize and listen to scroll changes for real-time UI updates.
/// - Render the scrollable [Row] of children with overlaid [AnimatedContainer] for fades.
/// - Clamp sharpness values and compute gradient stops for visual consistency.
///
/// This state is not exposed publicly and is tightly coupled to [CardCarousel].
class _CardCarouselState extends State<CardCarousel> {
  /// Manages horizontal scrolling for the carousel's content.
  ///
  /// This [ScrollController] is initialized in [initState] and used to track the
  /// current scroll position ([pixels]) relative to content bounds ([maxScrollExtent]).
  /// It triggers [setState] on changes to rebuild gradients, enabling dynamic edge effects.
  ///
  /// Type: ScrollController (late-bound)
  /// Usage: Attached to [SingleChildScrollView] for physics and listener callbacks.
  late ScrollController _controller;

  /// Initializes the carousel state, setting up the scroll controller and listener.
  ///
  /// Called once when the widget is inserted into the tree. Creates a new
  /// [ScrollController], attaches a listener to trigger rebuilds on scroll (via [setState]),
  /// and invokes the superclass initializer. This enables responsive gradient updates
  /// without external dependencies.
  ///
  /// Side effects: Registers scroll listener for real-time UI feedback.
  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

  /// Builds the [CardCarousel] UI, rendering scrollable children with edge gradients.
  ///
  /// Constructs a [Stack] containing a horizontal [SingleChildScrollView] for the
  /// [Row] of [widget.children], overlaid with conditional [Positioned] gradients.
  /// Gradients animate based on scroll position, using [AnimatedContainer] with
  /// [Curves.easeOutExpo] for smooth transitions. Sharpness is clamped (1-12) and
  /// sourced from [widget.sharpness] or [ArcaneTheme.cardCarousel.sharpness].
  ///
  /// The fade appears only when scrollable (pixels > 0 or < maxScrollExtent),
  /// using [IgnorePointer] to prevent interference with scrolling. Colors default
  /// to [Theme.of(context).colorScheme.background] if [widget.featherColor] is null.
  ///
  /// Parameters:
  /// - context: BuildContext - Provides theme and media access.
  ///
  /// Returns: Widget - The complete carousel assembly.
  ///
  /// Performance note: Listener-driven [setState] ensures efficient rebuilds only on scroll.
  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        SingleChildScrollView(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(mainAxisSize: MainAxisSize.min, children: widget.children),
        ),
        if (_controller.hasClients &&
            _controller.position.hasContentDimensions &&
            ((_controller.position.pixels > 0 ||
                _controller.position.pixels <
                    _controller.position.maxScrollExtent)))
          Positioned.fill(
              child: IgnorePointer(
                  ignoring: true,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutExpo,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      if (_controller.position.pixels > 0)
                        widget.featherColor ?? cs.background,
                      ...List.generate(
                          (widget.sharpness ??
                                  ArcaneTheme.of(context)
                                      .cardCarousel
                                      .sharpness)
                              .clamp(1, 12)
                              .toInt(),
                          (_) => (widget.featherColor ?? cs.background)
                              .withOpacity(0)),
                      if (_controller.hasClients &&
                          _controller.position.hasContentDimensions &&
                          _controller.position.pixels <
                              _controller.position.maxScrollExtent)
                        widget.featherColor ?? cs.background
                    ])),
                  ))),
      ],
    );
  }
}

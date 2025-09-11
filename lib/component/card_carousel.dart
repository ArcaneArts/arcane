import 'package:arcane/arcane.dart';

/// Theme configuration for [CardCarousel] widgets.
///
/// This class allows customizing the appearance of all [CardCarousel] instances
/// through the [ArcaneTheme].
///
/// See also:
///  * [doc/component/card_carousel.md] for more detailed documentation
///  * [CardCarousel], which uses this theme
class CardCarouselTheme {
  /// Controls the intensity of the edge gradient fade effect.
  ///
  /// Higher values create sharper gradients. Valid range is 1-12,
  /// with values outside this range being clamped.
  final int sharpness;

  /// Creates a [CardCarouselTheme] with the specified sharpness.
  ///
  /// The [sharpness] parameter defaults to 9, which provides a moderate
  /// edge fading effect.
  const CardCarouselTheme({this.sharpness = 9});

  /// Creates a copy of this theme but with the given fields replaced with new values.
  CardCarouselTheme copyWith({int? sharpness}) =>
      CardCarouselTheme(sharpness: sharpness ?? this.sharpness);
}

/// A horizontally scrollable list of widgets with attractive edge fading effects.
///
/// [CardCarousel] provides a convenient way to browse through a collection of cards
/// (or other widgets) in a limited horizontal space. It features a gradient fading
/// effect at the edges to indicate more content is available.
///
/// See also:
///  * [doc/component/card_carousel.md] for more detailed documentation
///  * [CardCarouselTheme], which defines the default appearance of carousels
class CardCarousel extends StatefulWidget {
  /// The list of widgets to display in the carousel.
  ///
  /// These widgets are laid out horizontally in a row that can be scrolled.
  /// Typically, these would be card-like widgets, but any widget can be used.
  final List<Widget> children;

  /// Controls the intensity of the edge gradient fade effect.
  ///
  /// Higher values create sharper gradients. If null, the value from
  /// [CardCarouselTheme] is used.
  final int? sharpness;

  final Color? featherColor;

  /// Creates a [CardCarousel] widget.
  ///
  /// The [children] parameter defaults to an empty list, but should typically
  /// contain at least enough widgets to allow horizontal scrolling.
  ///
  /// The [sharpness] parameter is optional and if not provided, the value
  /// from the current theme's [CardCarouselTheme] will be used.
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
  /// )
  /// ```
  const CardCarousel(
      {super.key, this.children = const [], this.sharpness, this.featherColor});

  @override
  State<CardCarousel> createState() => _CardCarouselState();
}

class _CardCarouselState extends State<CardCarousel> {
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
    _controller.addListener(() {
      setState(() {});
    });
  }

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

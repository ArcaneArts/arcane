import 'package:arcane/arcane.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:octo_image/octo_image.dart';

/// A configuration class that defines how an image should be displayed in the Arcane UI.
///
/// [ImageStyle] provides a flexible way to specify image sizing, positioning, blending, and alignment,
/// ensuring consistent visual presentation across components. It supports efficient rendering without
/// unnecessary computations due to its const constructor.
///
/// Key features:
/// - Supports various [BoxFit] modes (excluding scaleDown and none for optimal display).
/// - Allows color blending for tinted or overlaid effects.
/// - Configurable width, height, and alignment for precise layout control.
///
/// Usage in Arcane UI:
/// - Integrate with [ImageView] or [ImagePlaceholderView] within [Section], [BasicCard], or [FillScreen]
///   for responsive image displays.
/// - Use in [SliverScreen] for scrollable image sections with smooth performance.
/// - Pair with [ArcaneTheme] colors for themed blending (e.g., subtle overlays).
///
/// Performance notes:
/// - Const constructor prevents rebuilds in stateless contexts.
/// - Minimal properties ensure low memory footprint and fast equality checks.
class ImageStyle {
  /// How the image should be inscribed into the space.
  final BoxFit fit;

  /// Width of the image.
  final double width;

  /// Height of the image.
  final double height;

  /// Color to blend with the image.
  final Color? color;

  /// Blend mode for applying the color.
  final BlendMode? colorBlendMode;

  /// Alignment of the image within its bounds.
  final AlignmentGeometry? alignment;

  /// Creates an [ImageStyle] configuration for consistent image display.
  ///
  /// The [fit] controls how the image scales within its bounds, defaulting to [BoxFit.contain]
  /// to preserve aspect ratio without cropping. Width and height default to [double.infinity]
  /// for flexible sizing based on parent constraints. [color] and [colorBlendMode] enable
  /// overlay effects, such as darkening or tinting, while [alignment] positions the image
  /// within available space, defaulting to center.
  ///
  /// Initialization ensures invalid fits (scaleDown, none) are asserted against to maintain
  /// display integrity. Use named parameters for clarity in complex UIs.
  const ImageStyle(
      {this.fit = BoxFit.contain,
      this.width = double.infinity,
      this.height = double.infinity,
      this.color,
      this.colorBlendMode,
      this.alignment})
      : assert(fit != BoxFit.scaleDown,
            "Fit cannot be scaleDown. Use contain instead."),
        assert(fit != BoxFit.none, "Fit cannot be none. Use contain instead.");
}

/// The main component for loading and displaying images with automatic placeholder and error handling in Arcane apps.
///
/// [ImageView] is a robust, stateful widget that handles asynchronous image loading from URLs,
/// providing seamless transitions from placeholders to final images. It uses caching for performance
/// and integrates BlurHash/ThumbHash for low-bandwidth previews.
///
/// Key features:
/// - Asynchronous URL resolution via Future<String>.
/// - Built-in placeholders (BlurHash/ThumbHash) and error states with fade animations.
/// - Caching support via [cacheKey] for repeated loads.
/// - Efficient state management with [BoxSignal] to avoid unnecessary rebuilds.
///
/// Usage in Arcane UI:
/// - Embed in [Section] or [BasicCard] for content images with loading feedback.
/// - Use within [FillScreen] or [SliverScreen] for full-view or scrollable galleries.
/// - Combine with [Gesture] for interactive zoom/tap behaviors and [ArcaneTheme] for styled errors.
///
/// Performance notes:
/// - Leverages [CachedNetworkImageProvider] for memory-efficient caching.
/// - Fade animations (250ms default) ensure smooth UX without blocking renders.
/// - [BoxSignal] trait optimizes rebuilds to only when URL or style changes.
class ImageView extends StatefulWidget with BoxSignal {
  /// ThumbHash string for generating a thumbnail placeholder.
  final String? thumbHash;

  /// BlurHash string for generating a blurred placeholder.
  final String? blurHash;

  /// Future that resolves to the image URL to load.
  final Future<String> url;

  /// Optional key for caching the image.
  final String? cacheKey;

  /// Style configuration for the image.
  final ImageStyle style;

  /// Duration for the fade animation when transitioning from placeholder to actual image.
  final Duration? fadeOutDuration;

  /// Creates an [ImageView] widget for asynchronous image loading with placeholders.
  ///
  /// The required [url] Future resolves to the image source, enabling dynamic loading (e.g., from API).
  /// Provide [thumbHash] or [blurHash] for instant previews during network delays. [style] applies
  /// display configurations like fit and blending. [fadeOutDuration] controls the transition animation
  /// from placeholder to image, defaulting to 250ms for subtle changes. [cacheKey] enables custom
  /// caching to prevent redundant downloads.
  ///
  /// Initialization sets up the state for efficient handling of loading, error, and success states.
  const ImageView(
      {super.key,
      required this.url,
      this.fadeOutDuration = const Duration(milliseconds: 250),
      this.style = const ImageStyle(),
      this.thumbHash,
      this.blurHash,
      this.cacheKey});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) =>
      widget.url.buildNullable((url) => OctoImage(
          fit: widget.style.fit,
          width: widget.style.width,
          height: widget.style.height,
          alignment: widget.style.alignment,
          color: widget.style.color,
          colorBlendMode: widget.style.colorBlendMode,
          fadeOutDuration: widget.fadeOutDuration,
          fadeOutCurve: Curves.easeIn,
          errorBuilder: (context, e, es) => ImagePlaceholderView(
                isError: true,
                style: widget.style,
                blurHash: widget.blurHash,
              ),
          placeholderBuilder: (w) => ImagePlaceholderView(
                style: widget.style,
                blurHash: widget.blurHash,
              ),
          image: url == null
              ? _DummyImageProvider()
              : CachedNetworkImageProvider(
                  url,
                  cacheKey: widget.cacheKey,
                )));
}

/// An internal image provider that's used as a placeholder while waiting for a URL.
class _DummyImageProvider extends ImageProvider<CachedNetworkImageProvider> {
  @override
  Future<CachedNetworkImageProvider> obtainKey(
      ImageConfiguration configuration) async {
    await Future.delayed(Duration(hours: 1));
    throw "Waited for url?";
  }
}

/// A component that displays a placeholder while the main image is loading, or an error indicator in Arcane UIs.
///
/// [ImagePlaceholderView] generates blurred previews from BlurHash strings and handles error visuals
/// with opacity reduction and warning icons. It's stateless for optimal performance in loading contexts.
///
/// Key features:
/// - BlurHash decoding for compact, instant placeholders.
/// - Error mode with 50% opacity fade and centered [Icons.warning] icon.
/// - Seamless integration as a builder in image loading pipelines.
///
/// Usage in Arcane UI:
/// - Serves as placeholder/error handler in [ImageView] within [Section] or [Glass] containers.
/// - Enhances [FillScreen] loading states with themed warnings via [ArcaneTheme].
/// - Use in [SliverScreen] for non-blocking scrollable image feeds.
///
/// Performance notes:
/// - Stateless design with no internal state, minimizing rebuilds.
/// - BlurHash rendering is lightweight, avoiding full image downloads initially.
/// - Animations use short durations (250ms) for responsive feel without jank.
class ImagePlaceholderView extends StatelessWidget {
  /// Whether to show an error state with warning icon.
  final bool isError;

  /// BlurHash string for generating a blurred placeholder.
  final String? blurHash;

  /// Style configuration for the placeholder.
  final ImageStyle style;

  /// Creates an [ImagePlaceholderView] widget for loading or error placeholders.
  ///
  /// The [isError] flag triggers reduced opacity and a red warning icon overlay.
  /// [blurHash] provides the string for generating the blurred preview; omit for empty container.
  /// [style] applies sizing, fit, and blending to the placeholder image.
  ///
  /// Initialization conditionally builds the BlurHash image or empty container, with error visuals
  /// animated in for smooth feedback.
  const ImagePlaceholderView(
      {super.key,
      this.isError = false,
      this.style = const ImageStyle(),
      this.blurHash});

  @override
  Widget build(BuildContext context) {
    Widget ph = blurHash != null
        ? SizedBox.expand(
            child: ImageWithStyle(
              style: style,
              image: BlurHashImage(blurHash!),
            ),
          )
        : Container();

    if (isError) {
      ph = ph
          .animate()
          .fade(duration: 250.ms, curve: Curves.easeIn, begin: 1, end: 0.5);
    }

    return MaybeStack(
      children: [
        ph,
        if (isError)
          Center(
            child: Icon(
              Icons.warning,
              color: Colors.red,
              size: 24,
            ),
          ).animate().fadeIn(
                duration: 250.ms,
                curve: Curves.easeIn,
              ),
      ],
    );
  }
}

/// A utility component that applies styling to an ImageProvider for consistent display in Arcane.
///
/// [ImageWithStyle] wraps any [ImageProvider] (e.g., network, asset, or generated) with [ImageStyle]
/// options, simplifying styled image rendering without boilerplate.
///
/// Key features:
/// - Direct application of fit, size, alignment, color, and blend mode.
/// - Supports gapless playback for animations or sequences.
/// - Stateless for immediate rendering in any context.
///
/// Usage in Arcane UI:
/// - Wrap placeholders in [ImagePlaceholderView] for styled BlurHash previews.
/// - Use with [BasicCard] or [GlowCard] images, integrating [ArcaneTheme] blends.
/// - Embed in [Section] or [Expander] for collapsible styled visuals in [FillScreen].
///
/// Performance notes:
/// - Inline Image widget usage avoids extra layers or state.
/// - Const style propagation enables Flutter's const optimization.
/// - No caching here; pair with providers like [CachedNetworkImageProvider] for efficiency.
class ImageWithStyle extends StatelessWidget {
  /// The image provider to display.
  final ImageProvider image;

  /// Style configuration for the image.
  final ImageStyle style;

  final bool gapless;

  /// Creates an [ImageWithStyle] widget to render a styled image from a provider.
  ///
  /// The required [image] specifies the source (e.g., BlurHashImage, NetworkImage).
  /// [style] configures display properties like fit and color blending.
  /// [gapless] enables continuous playback for animated or sequential images, default false.
  ///
  /// Initialization builds the Image widget with all style params, defaulting alignment to center
  /// for balanced presentation.
  const ImageWithStyle(
      {super.key,
      required this.image,
      this.style = const ImageStyle(),
      this.gapless = false});

  @override
  Widget build(BuildContext context) => Image(
        fit: style.fit,
        width: style.width,
        height: style.height,
        alignment: style.alignment ?? Alignment.center,
        color: style.color,
        colorBlendMode: style.colorBlendMode,
        image: image,
        gaplessPlayback: gapless,
      );
}

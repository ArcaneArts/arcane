import 'package:arcane/arcane.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_thumbhash/flutter_thumbhash.dart';
import 'package:octo_image/octo_image.dart';

/// A configuration class that defines how an image should be displayed.
///
/// [ImageStyle] provides a way to specify how images should be sized, positioned,
/// and blended within their containers.
///
/// See also:
///  * [doc/component/image.md] for more detailed documentation
///  * [ImageView], which uses this class to style images
///  * [ImagePlaceholderView], which uses this class for placeholder styling
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

  /// Creates an [ImageStyle] configuration.
  ///
  /// The [fit] parameter defaults to [BoxFit.contain], and width and height
  /// default to [double.infinity]. Note that [BoxFit.scaleDown] and [BoxFit.none]
  /// are not supported and will cause an assertion error.
  ///
  /// Example:
  /// ```dart
  /// ImageStyle(
  ///   fit: BoxFit.cover,
  ///   width: 300,
  ///   height: 200,
  ///   color: Colors.blue,
  ///   colorBlendMode: BlendMode.srcIn,
  /// )
  /// ```
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

/// The main component for loading and displaying images with automatic placeholder and error handling.
///
/// [ImageView] provides a robust way to display images from URLs with loading states,
/// placeholders using BlurHash or ThumbHash, and error handling. It automatically
/// shows a placeholder while the image is loading and smoothly transitions to the
/// actual image once loaded.
///
/// See also:
///  * [doc/component/image.md] for more detailed documentation
///  * [ImagePlaceholderView], which is used for loading and error states
///  * [ImageStyle], which defines the styling of the image
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

  /// Creates an [ImageView] widget.
  ///
  /// The [url] parameter is required and should be a Future that resolves to the image URL.
  /// Either [thumbHash] or [blurHash] can be provided to generate a placeholder.
  ///
  /// Example:
  /// ```dart
  /// ImageView(
  ///   url: Future.value("https://example.com/image.jpg"),
  ///   blurHash: "L6PZfSi_.AyE_3t7t7R**0o#DgR4",
  ///   style: ImageStyle(
  ///     fit: BoxFit.cover,
  ///     width: 300,
  ///     height: 200,
  ///   ),
  /// )
  /// ```
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
                thumbHash: widget.thumbHash,
                blurHash: widget.blurHash,
              ),
          placeholderBuilder: (w) => ImagePlaceholderView(
                style: widget.style,
                thumbHash: widget.thumbHash,
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

/// A component that displays a placeholder while the main image is loading, or an error indicator.
///
/// [ImagePlaceholderView] can generate a placeholder from either a BlurHash or a ThumbHash
/// string. In error state, it shows the placeholder with reduced opacity and an error icon.
///
/// See also:
///  * [doc/component/image.md] for more detailed documentation
///  * [ImageView], which uses this component for placeholder and error states
///  * [ImageWithStyle], which is used to display the placeholder images
class ImagePlaceholderView extends StatelessWidget {
  /// Whether to show an error state with warning icon.
  final bool isError;

  /// BlurHash string for generating a blurred placeholder.
  final String? blurHash;

  /// ThumbHash string for generating a thumbnail placeholder.
  final String? thumbHash;

  /// Style configuration for the placeholder.
  final ImageStyle style;

  /// Creates an [ImagePlaceholderView] widget.
  ///
  /// Either [blurHash] or [thumbHash] can be provided to generate a placeholder.
  /// If [isError] is true, the placeholder will be shown with reduced opacity
  /// and a warning icon will be displayed.
  const ImagePlaceholderView(
      {super.key,
      this.isError = false,
      this.style = const ImageStyle(),
      this.blurHash,
      this.thumbHash});

  @override
  Widget build(BuildContext context) {
    Widget ph = blurHash != null
        ? SizedBox.expand(
            child: ImageWithStyle(
              style: style,
              image: BlurHashImage(blurHash!),
            ),
          )
        : thumbHash != null
            ? SizedBox.expand(
                child: ImageWithStyle(
                  gapless: true,
                  style: style,
                  image: ThumbHash.fromBase64(thumbHash!).toImage(),
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

/// A utility component that applies styling to an ImageProvider.
///
/// [ImageWithStyle] wraps an [ImageProvider] with the styling options defined
/// in an [ImageStyle], making it easy to consistently style various types of images.
///
/// See also:
///  * [doc/component/image.md] for more detailed documentation
///  * [ImageStyle], which defines the styling options
///  * [ImagePlaceholderView], which uses this component to style placeholders
class ImageWithStyle extends StatelessWidget {
  /// The image provider to display.
  final ImageProvider image;

  /// Style configuration for the image.
  final ImageStyle style;

  final bool gapless;

  /// Creates an [ImageWithStyle] widget.
  ///
  /// The [image] parameter is required and specifies the image provider to use.
  /// The [style] parameter defines how the image should be displayed.
  ///
  /// Example:
  /// ```dart
  /// ImageWithStyle(
  ///   image: NetworkImage("https://example.com/image.jpg"),
  ///   style: ImageStyle(
  ///     fit: BoxFit.cover,
  ///     width: 300,
  ///     height: 200,
  ///   ),
  /// )
  /// ```
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

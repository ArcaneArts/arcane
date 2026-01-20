import 'package:arcane/arcane.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:octo_image/octo_image.dart';

class ImageStyle {
  final BoxFit fit;
  final double width;
  final double height;
  final Color? color;
  final BlendMode? colorBlendMode;
  final AlignmentGeometry? alignment;
  final bool useShadersForThumbHash;

  const ImageStyle(
      {this.fit = BoxFit.contain,
      this.width = double.infinity,
      this.height = double.infinity,
      this.useShadersForThumbHash = true,
      this.color,
      this.colorBlendMode,
      this.alignment})
      : assert(fit != BoxFit.scaleDown,
            "Fit cannot be scaleDown. Use contain instead."),
        assert(fit != BoxFit.none, "Fit cannot be none. Use contain instead.");
}

class ImageView extends StatefulWidget with BoxSignal {
  final String? thumbHash;
  final String? blurHash;
  final Future<String> url;
  final String? cacheKey;
  final ImageStyle style;
  final Duration? fadeOutDuration;
  final bool hideOnError;

  const ImageView(
      {super.key,
      required this.url,
      this.fadeOutDuration = const Duration(milliseconds: 250),
      this.style = const ImageStyle(),
      this.thumbHash,
      this.blurHash,
      this.hideOnError = true,
      this.cacheKey});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late ImageProvider provider;

  @override
  void initState() {
    provider = FutureImageProvider<String, CachedNetworkImageProvider>(
        ignoreErrors: true,
        future: widget.url,
        providerBuilder: (url) => CachedNetworkImageProvider(
              url,
              cacheKey: widget.cacheKey,
            ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => OctoImage(
      fit: widget.style.fit,
      width: widget.style.width,
      height: widget.style.height,
      alignment: widget.style.alignment,
      color: widget.style.color,
      colorBlendMode: widget.style.colorBlendMode,
      fadeOutDuration: widget.fadeOutDuration,
      fadeOutCurve: Curves.easeIn,
      errorBuilder: (context, e, es) => widget.hideOnError
          ? Container()
          : ImagePlaceholderView(
              isError: true,
              style: widget.style,
              blurHash: widget.blurHash,
              thumbHash: widget.thumbHash,
            ),
      placeholderBuilder: (w) => ImagePlaceholderView(
            style: widget.style,
            blurHash: widget.blurHash,
            thumbHash: widget.thumbHash,
          ),
      image: provider);
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

class ImagePlaceholderView extends StatelessWidget {
  final bool isError;
  final String? blurHash;
  final String? thumbHash;
  final ImageStyle style;

  const ImagePlaceholderView(
      {super.key,
      this.isError = false,
      this.style = const ImageStyle(),
      this.blurHash,
      this.thumbHash});

  @override
  Widget build(BuildContext context) {
    if (thumbHash != null) {
      return SizedBox(
        width: style.width,
        height: style.height,
        child: MagicThumbHash(
            thumbHash: thumbHash!, useShaders: style.useShadersForThumbHash),
      );
    }

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

class ImageWithStyle extends StatelessWidget {
  final ImageProvider image;
  final ImageStyle style;
  final bool gapless;

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

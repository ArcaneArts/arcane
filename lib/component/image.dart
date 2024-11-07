import 'package:arcane/arcane.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_thumbhash/flutter_thumbhash.dart';
import 'package:octo_image/octo_image.dart';

class ImageStyle {
  final BoxFit fit;
  final double width;
  final double height;
  final Color? color;
  final BlendMode? colorBlendMode;
  final AlignmentGeometry? alignment;

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

class ImageView extends StatefulWidget {
  final String? thumbHash;
  final String? blurHash;
  final Future<String> url;
  final String? cacheKey;
  final ImageStyle style;
  final Duration? fadeOutDuration;

  const ImageView(
      {super.key,
      required this.url,
      this.fadeOutDuration = const Duration(milliseconds: 950),
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
                  style: style,
                  image: ThumbHash.fromBase64(thumbHash!).toImage(),
                ),
              )
            : Container();

    if (isError) {
      ph = ph
          .animate()
          .fade(duration: 500.ms, curve: Curves.easeIn, begin: 1, end: 0.5);
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
                duration: 500.ms,
                curve: Curves.easeIn,
              ),
      ],
    );
  }
}

class ImageWithStyle extends StatelessWidget {
  final ImageProvider image;
  final ImageStyle style;

  const ImageWithStyle(
      {super.key, required this.image, this.style = const ImageStyle()});

  @override
  Widget build(BuildContext context) => Image(
        fit: style.fit,
        width: style.width,
        height: style.height,
        alignment: style.alignment ?? Alignment.center,
        color: style.color,
        colorBlendMode: style.colorBlendMode,
        image: image,
      );
}

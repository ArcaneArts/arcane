import 'dart:convert';
import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:flutter_thumbhash/flutter_thumbhash.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:thumbhash/thumbhash.dart' as th;
import 'package:tinycolor2/tinycolor2.dart';

class TranslucentBackground {
  final bool translucent;

  const TranslucentBackground({this.translucent = false});
}

extension XTranslucentBackground on BuildContext {
  bool get isTranslucent =>
      pylonOr<TranslucentBackground>()?.translucent ?? false;
}

const TranslucentBackground _tt = TranslucentBackground(translucent: true);
const TranslucentBackground _tf = TranslucentBackground(translucent: false);

extension XTrWidget on Widget {
  Widget withTranslucentBackground(bool translucent) =>
      Pylon(value: translucent ? _tt : _tf, builder: (context) => this);
}

Iterable<Offset> randomNormalPositions(int seed) sync* {
  Random r = Random(seed);

  while (true) {
    yield Offset(r.nextDouble(), r.nextDouble());
  }
}

class MagicThumbHash extends StatelessWidget {
  final double noise;
  final double blend;
  final String thumbHash;
  final double intensity;
  final bool useShaders;

  const MagicThumbHash(
      {super.key,
      this.blend = 3,
      this.noise = 0.1,
      required this.thumbHash,
      this.intensity = 1.0,
      this.useShaders = true});

  @override
  Widget build(BuildContext context) => (useShaders
          ? MeshGradient(
              points: ThumbHashSampler.base64(thumbHash).supersample(),
              options: MeshGradientOptions(
                noiseIntensity: noise,
                blend: blend,
              ))
          : Image(
              fit: BoxFit.cover,
              image: ThumbHash.fromBase64(thumbHash).toImage()))
      .withOpacity(intensity);
}

class ThumbHashSampler {
  final String hash;
  final th.Image image;

  ThumbHashSampler(this.hash, this.image);

  factory ThumbHashSampler.base64(String bs) => ThumbHashSampler(
      bs, th.thumbHashToRGBA(base64.decode(base64.normalize(bs))));

  List<MeshGradientPoint> samplePoints(int w, int h) {
    List<MeshGradientPoint> points = [];

    for (double x = 0; x <= 1; x += (1 / (w - 1))) {
      for (double y = 0; y <= 1; y += (1 / (h - 1))) {
        print("$x  x $y");
        points.add(getMeshPointNormalized(x, y));
      }
    }

    return points;
  }

  List<Color> snap(int w, int h) {
    List<Color> f = List.generate(w * h, (_) => Colors.transparent);
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        f[y * w + x] = getColorAtPixel(
            (x * (image.width - 1) / (w - 1)).floor(),
            (y * (image.height - 1) / (h - 1)).floor());
      }
    }

    return f;
  }

  Color lerp(Color a, Color b, double t) => a.lerp(b, t);

  Color blerp(
      Color c00, Color c10, Color c01, Color c11, double tx, double ty) {
    Color cx0 = lerp(c00, c10, tx);
    Color cx1 = lerp(c01, c11, tx);
    return lerp(cx0, cx1, ty);
  }

  List<MeshGradientPoint> supersample(
      {double r = 0.1, double p = 0.15, h = 0.15}) {
    return [
      samplePointBlerp(0 + p, 0 + p, r),
      samplePointBlerp(1 - p, 0 + p, r),
      samplePointBlerp(0 + p, 1 - p, r),
      samplePointBlerp(1 - p, 1 - p, r),
      samplePointBlerp(0 + p + p, 0.5, r),
      samplePointBlerp(1 - (p + p), 0.5, r),
    ];
  }

  MeshGradientPoint samplePointBlerp(double x, double y, double p) =>
      MeshGradientPoint(
          position: Offset(x, y),
          color: blerp(
                  getColorNormalized(x - p, y - p), // Top-left
                  getColorNormalized(x + p, y - p), // Top-right
                  getColorNormalized(x - p, y + p), // Bottom-left
                  getColorNormalized(x + p, y + p), // Bottom-right
                  0.5,
                  0.5)
              .lerp(getColorNormalized(x, y), 0.2)
              .shade(15)
              .saturate(15)
              .darken(15));

  Color sampleColorBlerp(double x, double y, double p) => blerp(
      getColorNormalized(x - p, y - p), // Top-left
      getColorNormalized(x + p, y - p), // Top-right
      getColorNormalized(x - p, y + p), // Bottom-left
      getColorNormalized(x + p, y + p), // Bottom-right
      0.5,
      0.5);

  List<MeshGradientPoint> hardSample({double p = 0.15}) {
    return [
      getMeshPointNormalized(0 + p, 0 + p),
      getMeshPointNormalized(1 - p, 0 + p),
      getMeshPointNormalized(0 + p, 1 - p),
      getMeshPointNormalized(1 - p, 1 - p),
      getMeshPointNormalized(0.5, 0.5),
    ];
  }

  List<Color> sample(List<Offset> normals) => normals
      .map((e) => getColorNormalized(e.dx.clamp(0, 1), e.dy.clamp(0, 1)))
      .toList();

  Color getColorNormalized(double x, double y) => getColorAtPixel(
      (x.clamp(0, 1) * (image.width - 1)).floor(),
      (y.clamp(0, 1) * (image.height - 1)).floor());

  MeshGradientPoint getMeshPointNormalized(double x, double y) =>
      MeshGradientPoint(
          position: Offset(x, y), color: getColorNormalized(x, y));

  Color getColorAtPixel(int x, int y) {
    if (x < 0 || x >= image.width || y < 0 || y >= image.height) {
      throw Exception(
          "Out of bounds Tried to access:\n0 > $x < ${image.width}\n0 > $y < ${image.height}");
    }

    int index = (y * image.width + x) * 4;
    return Color.fromARGB(image.rgba[index + 3], image.rgba[index],
        image.rgba[index + 1], image.rgba[index + 2]);
  }

  int get width => image.width;

  int get height => image.height;
}

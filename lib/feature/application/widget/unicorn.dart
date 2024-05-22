import 'dart:math';

import 'package:arcane/arcane.dart';

class UnicornVomit extends StatefulWidget {
  final bool dark;
  final int points;
  final double blendAmount;
  final Color blendColor;

  const UnicornVomit(
      {super.key,
      this.points = 6,
      this.blendAmount = 0.5,
      this.dark = true,
      this.blendColor = const Color(0xFF5500ff)});

  @override
  State<UnicornVomit> createState() => _UnicornVomitState();
}

class _UnicornVomitState extends State<UnicornVomit>
    with TickerProviderStateMixin {
  late MeshGradientController controller;
  late StreamSubscription<String> subscription;

  @override
  void initState() {
    controller = MeshGradientController(
      points: [
        ...seedPoints("/", widget.points, widget.dark, widget.blendColor,
                widget.blendAmount)
            .map((e) => e.gradientPoint),
      ],
      vsync: this,
    );

    subscription = Opal.of(context)
        .backgroundSeedStream
        .listen((event) => controller.animateSequence(
              duration: const Duration(seconds: 4),
              sequences: [
                ...seedPoints(event, widget.points, widget.dark,
                        widget.blendColor, widget.blendAmount)
                    .map((e) => e.animationSequence),
              ],
            ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        MeshGradient(
            controller: controller,
            options: MeshGradientOptions(noiseIntensity: 0.3, blend: 3)),
      ],
    );
  }
}

List<UnicornVomitPoint> seedPoints(
    String seed, int count, bool dark, Color blendColor, double blendAmount) {
  List<UnicornVomitPoint> vps = [];

  for (int i = 0; i < count; i++) {
    vps.add(UnicornVomitPoint.fromSeed(seed, i, dark, blendColor, blendAmount,
        vps.map((e) => e.position).toList()));
  }

  return vps;
}

class UnicornVomitPoint {
  final int index;
  final Offset position;
  final Color color;
  final bool dark;

  UnicornVomitPoint({
    required this.index,
    required this.position,
    required this.color,
    required this.dark,
  });

  factory UnicornVomitPoint.fromSeed(String seed, int key, bool dark,
      Color blendColor, double blendAmount, List<Offset> existing) {
    double coord(Random random) {
      double g = random.nextDouble() * 0.25;

      return random.nextBool() ? g : (1 - g);
    }

    Offset pos(Random random) {
      if (random.nextBool()) {
        return Offset(coord(random), random.nextDouble());
      }

      return Offset(random.nextDouble(), coord(random));
    }

    Offset best(Random random, List<Offset> existing) {
      if (existing.isEmpty) {
        return pos(random);
      }

      double furthest = 0;
      Offset b = pos(random);

      for (int i = 0; i < 3 + existing.length; i++) {
        Offset n = pos(random);
        double closest = 2;

        for (final e in existing) {
          double d = (e - n).distance;

          if (d < closest) {
            closest = d;
          }
        }

        if (closest > furthest) {
          furthest = closest;
          b = n;
        }
      }

      return b;
    }

    Random random =
        Random(seed.hashCode ^ (key * 395461) ^ Arcane.app.title.hashCode);
    return UnicornVomitPoint(
        dark: dark,
        index: key,
        position: best(random, existing),
        color: blendColor.spin(
            (random.nextDouble() * blendAmount * 360) - (blendAmount * 180)));
  }

  AnimationSequence get animationSequence => AnimationSequence(
        pointIndex: index,
        newPoint: gradientPoint,
        interval: const Interval(
          0,
          1,
          curve: Curves.easeOutCirc,
        ),
      );

  MeshGradientPoint get gradientPoint =>
      MeshGradientPoint(position: position, color: color);
}

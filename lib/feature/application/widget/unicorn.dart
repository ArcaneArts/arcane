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
            options: MeshGradientOptions(noiseIntensity: 0.25, blend: 2)),
      ],
    );
  }
}

List<UnicornVomitPoint> seedPoints(String seed, int count, bool dark,
        Color blendColor, double blendAmount) =>
    [
      for (int i = 0; i < count; i++)
        UnicornVomitPoint.fromSeed(seed, i, dark, blendColor, blendAmount)
    ];

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

  factory UnicornVomitPoint.fromSeed(
      String seed, int key, bool dark, Color blendColor, double blendAmount) {
    Random random = Random(seed.hashCode ^ (key * 395461));
    return UnicornVomitPoint(
        dark: dark,
        index: key,
        position: Offset(random.nextDouble(), random.nextDouble()),
        color: dark
            ? Color.fromARGB(
                255,
                random.nextInt(255),
                random.nextInt(255),
                random.nextInt(255),
              )
                .darken(random.nextInt(30) + 25)
                .saturate((random.nextInt(100) + 50).clamp(0, 100))
                .mix(blendColor, (blendAmount * 100).clamp(0, 100).round())
            : Color.fromARGB(
                255,
                random.nextInt(255),
                random.nextInt(255),
                random.nextInt(255),
              )
                .darken(random.nextInt(100))
                .saturate(random.nextInt(25))
                .mix(blendColor, (blendAmount * 100).clamp(0, 100).round()));
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

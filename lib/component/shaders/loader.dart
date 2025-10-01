import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

const String _name = "loader";
Future<FragmentProgram> _loadShader() => ArcaneShader.loadShader(_name);

class LoaderShader extends ArcaneShader {
  const LoaderShader({super.programProvider = _loadShader, super.name = _name});
}

class LoaderEffect extends StatelessWidget with BoxSignal {
  final Color? color1;
  final Color? color2;
  final Color? color3;
  final Size size;
  final double scale;
  final double speed;
  final double length;
  final double radius;
  final double fading;
  final double glow;

  const LoaderEffect(
      {super.key,
      this.size = const Size(50, 50),
      this.color1,
      this.color2,
      this.color3,
      this.scale = 0.25,
      this.speed = 0.25,
      this.length = 0.6,
      this.radius = 0.035,
      this.fading = 0.2,
      this.glow = 4});

  List<double> _color(Color color) => [color.r, color.g, color.b];

  @override
  Widget build(BuildContext context) {
    List<double> c1 = _color(color1 ?? Theme.of(context).colorScheme.primary);
    List<double> c2 =
        _color(color2 ?? Theme.of(context).colorScheme.foreground);
    List<double> c3 =
        _color(color3 ?? Theme.of(context).colorScheme.foreground);
    double uInvert =
        Theme.of(context).colorScheme.brightness == Brightness.dark ? 1 : -1;

    if (uInvert == -1) {
      c1 = c1.map((e) => 1 - e).toList();
      c2 = c2.map((e) => 1 - e).toList();
      c3 = c3.map((e) => 1 - e).toList();
    }

    return SizedBox(
      width: size.width,
      height: size.height,
      child: OverflowBox(
        minHeight: 0,
        alignment: Alignment.center,
        minWidth: 0,
        maxWidth: size.width * 2,
        maxHeight: size.height * 2,
        child: (const LoaderShader().program)
            .build((program) => AnimatedShadedSurface(
                  size: size * 2,
                  program: program,
                  shaderBuilder: (program, elapsed) => program.fragmentShader()
                    ..setFloatUniforms((s) => s
                      ..setFloat(elapsed.inMilliseconds / 1000)
                      ..setSize(size * 2)
                      ..setFloats(c1)
                      ..setFloats(c2)
                      ..setFloats(c3)
                      ..setFloat(uInvert)
                      ..setFloat(scale)
                      ..setFloat(speed)
                      ..setFloat(length)
                      ..setFloat(radius)
                      ..setFloat(fading)
                      ..setFloat(glow)),
                )),
      ),
    );
  }
}

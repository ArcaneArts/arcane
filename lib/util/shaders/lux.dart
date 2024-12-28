import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:arcane/util/shaders.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

const String _name = "lux";
Future<FragmentProgram> _loadShader() => ArcaneShader.loadShader(_name);

class LuxShader extends ArcaneShader {
  const LuxShader({super.programProvider = _loadShader, super.name = _name});
}

class LuxEffect extends StatelessWidget with BoxSignal {
  final double size;
  final double thickness;
  final double repeats;
  final double scale;
  final double shimmer;
  final Color? color;
  final double power;
  final double speed;

  const LuxEffect.bump({
    super.key,
    this.size = 100,
    this.thickness = 90,
    this.repeats = -1,
    this.scale = 3.14159,
    this.shimmer = 2,
    this.color,
    this.power = 2.5,
    this.speed = 2,
  });

  const LuxEffect.ping({
    super.key,
    this.size = 100,
    this.thickness = 1,
    this.repeats = 3,
    this.scale = 4,
    this.shimmer = 0.8,
    this.color,
    this.power = 2.5,
    this.speed = 2,
  });

  const LuxEffect.reactor({
    super.key,
    this.size = 1,
    this.thickness = 100,
    this.repeats = 13,
    this.scale = 1,
    this.shimmer = 1,
    this.color,
    this.power = 2.5,
    this.speed = 0.333,
  });

  const LuxEffect.star({
    super.key,
    this.size = 100,
    this.thickness = 33,
    this.repeats = 11,
    this.scale = 0.9,
    this.shimmer = 1,
    this.color,
    this.power = 2.5,
    this.speed = 1,
  });

  const LuxEffect({
    super.key,
    this.size = 1,
    this.thickness = 1,
    this.repeats = 9,
    this.scale = 1,
    this.shimmer = 1,
    this.color,
    this.power = 2.5,
    this.speed = 1,
  });

  List<double> _color(Color color) => [color.r, color.g, color.b];

  @override
  Widget build(BuildContext context) {
    List<double> c1 = _color(color ?? Theme.of(context).colorScheme.primary);
    return SizedBox(
      width: size,
      height: size,
      child:
          (const LuxShader().program).build((program) => AnimatedShadedSurface(
                size: Size.square(size),
                program: program,
                shaderBuilder: (program, elapsed) => program.fragmentShader()
                  ..setFloatUniforms((s) => s
                    ..setFloat((elapsed.inMilliseconds / 1000) * speed)
                    ..setSize(Size.square(size))
                    ..setFloat(thickness)
                    ..setFloat(repeats)
                    ..setFloat(scale)
                    ..setFloat(shimmer)
                    ..setFloats(c1)
                    ..setFloat(power)),
              )),
    );
  }
}

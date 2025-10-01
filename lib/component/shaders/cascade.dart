import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

const String _name = "cascade";
Future<FragmentProgram> _loadShader() => ArcaneShader.loadShader(_name);

class CascadeShader extends ArcaneShader {
  const CascadeShader(
      {super.programProvider = _loadShader, super.name = _name});
}

class CascadeEffect extends StatelessWidget with BoxSignal {
  final double size;
  final double thickness;
  final double repeats;
  final double scale;
  final double shimmer;
  final Color? color;
  final double power;
  final double speed;

  const CascadeEffect({
    super.key,
    this.size = 1,
    this.thickness = 1,
    this.repeats = 1,
    this.scale = 1,
    this.shimmer = 1,
    this.color,
    this.power = 2,
    this.speed = 1,
  });

  const CascadeEffect.flower({
    super.key,
    this.size = 1,
    this.thickness = 0.4,
    this.repeats = 1.56,
    this.scale = 3,
    this.shimmer = 0.7,
    this.color,
    this.power = 2,
    this.speed = 2.5,
  });

  const CascadeEffect.prism({
    super.key,
    this.size = 1,
    this.thickness = 0.6,
    this.repeats = 2,
    this.scale = 2,
    this.shimmer = 2,
    this.color,
    this.power = 1.7,
    this.speed = 1,
  });

  const CascadeEffect.orb({
    super.key,
    this.size = 1,
    this.thickness = 0.6,
    this.repeats = 1,
    this.scale = 3,
    this.shimmer = 0.5,
    this.color,
    this.power = 0.6,
    this.speed = 1,
  });

  const CascadeEffect.gem({
    super.key,
    this.size = 1,
    this.thickness = 0.5,
    this.repeats = 1,
    this.scale = 1,
    this.shimmer = 1,
    this.color,
    this.power = 1.1,
    this.speed = 1,
  });

  List<double> _color(Color color) => [color.r, color.g, color.b];

  @override
  Widget build(BuildContext context) {
    List<double> c1 = _color(color ?? Theme.of(context).colorScheme.primary);
    return SizedBox(
      width: size,
      height: size,
      child: (const CascadeShader().program)
          .build((program) => AnimatedShadedSurface(
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

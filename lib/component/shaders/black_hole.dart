import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

const String _name = "black_hole";
Future<FragmentProgram> _loadShader() => ArcaneShader.loadShader(_name);

class BlackHoleShader extends ArcaneShader {
  const BlackHoleShader(
      {super.programProvider = _loadShader, super.name = _name});
}

class BlackHoleEffect extends StatelessWidget with BoxSignal {
  final double size;
  final double speed;
  final double power;
  final Offset focal;
  final double scale;
  final Color? color;
  final Offset direction;

  const BlackHoleEffect(
      {this.size = 100,
      this.speed = 1,
      this.power = 3.4,
      this.scale = 1,
      this.direction = const Offset(1, 1.1),
      this.color,
      this.focal = Offset.zero});

  List<double> _color(Color color) => [color.r, color.g, color.b];

  @override
  Widget build(BuildContext context) {
    List<double> c1 = _color(color ?? Theme.of(context).colorScheme.primary);
    return SizedBox(
      width: size,
      height: size,
      child: (const BlackHoleShader().program)
          .build((program) => AnimatedShadedSurface(
                size: Size.square(size),
                program: program,
                shaderBuilder: (program, elapsed) => program.fragmentShader()
                  ..setFloatUniforms((s) => s
                    ..setFloat(elapsed.inMilliseconds / 1000)
                    ..setSize(Size.square(size))
                    ..setFloat(speed)
                    ..setFloat(power)
                    ..setOffset(focal)
                    ..setFloat(scale)
                    ..setFloats(c1)
                    ..setFloats([direction.dx, direction.dy])),
              )),
    );
  }
}

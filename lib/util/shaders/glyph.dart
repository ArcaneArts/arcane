import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:arcane/util/shaders.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

const String _name = "glyph";
Future<FragmentProgram> _loadShader() => ArcaneShader.loadShader(_name);

class GlyphShader extends ArcaneShader {
  const GlyphShader({super.programProvider = _loadShader, super.name = _name});
}

class GlyphEffect extends StatelessWidget with BoxSignal {
  final Size size;
  final double intensity;
  final double speed;
  final double rotationSpeed;
  final double threshold;
  final int uComplex;

  const GlyphEffect({
    super.key,
    this.intensity = 1,
    this.speed = 0.1,
    this.threshold = 0.2,
    this.rotationSpeed = 0.01,
    this.uComplex = 32,
    this.size = const Size(50, 50),
  });

  @override
  Widget build(BuildContext context) {
    return (const GlyphShader().program)
        .build((program) => AnimatedShadedSurface(
              size: size,
              program: program,
              shaderBuilder: (program, elapsed) => program.fragmentShader()
                ..setFloatUniforms(
                  (s) => s
                    ..setFloat(elapsed.inMilliseconds / 1000)
                    ..setSize(size)
                    ..setFloat((1 / intensity) * 200.0)
                    ..setFloat(speed)
                    ..setFloat(rotationSpeed)
                    ..setFloat(threshold)
                    ..setFloat(uComplex.toDouble()),
                ),
            ));
  }
}

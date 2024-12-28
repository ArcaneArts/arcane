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
  final double size;
  final double intensity;
  final double speed;
  final double rotationSpeed;
  final double threshold;
  final double colorBias;
  final int uComplex;
  final Color? color1;
  final Color? color2;
  final double zoom;
  final bool debugBorder;
  final double overdraw;
  final double bloom;
  final double power;

  const GlyphEffect({
    super.key,
    this.debugBorder = false,
    this.intensity = 0.5,
    this.bloom = 5,
    this.overdraw = 2,
    this.speed = 6,
    this.threshold = 0.01,
    this.rotationSpeed = 1,
    this.colorBias = 0.5,
    this.uComplex = 2,
    this.color1,
    this.zoom = 1.8,
    this.color2,
    this.power = 1.3,
    this.size = 50,
  });

  const GlyphEffect.arcane1({
    super.key,
    this.debugBorder = false,
    this.intensity = 0.7,
    this.bloom = 10,
    this.overdraw = 3,
    this.speed = 4,
    this.threshold = 0.08,
    this.rotationSpeed = 1,
    this.colorBias = 0.01,
    this.uComplex = 1,
    this.color1,
    this.zoom = 0.4,
    this.color2,
    this.power = 2,
    this.size = 50,
  });

  const GlyphEffect.arcane2({
    super.key,
    this.debugBorder = false,
    this.intensity = 0.7,
    this.bloom = 10,
    this.overdraw = 3,
    this.speed = 4,
    this.threshold = 0.08,
    this.rotationSpeed = 1,
    this.colorBias = 0.01,
    this.uComplex = 2,
    this.color1,
    this.zoom = 0.6,
    this.color2,
    this.power = 2,
    this.size = 50,
  });

  const GlyphEffect.arcane3({
    super.key,
    this.debugBorder = false,
    this.intensity = 0.7,
    this.bloom = 10,
    this.overdraw = 3,
    this.speed = 3,
    this.threshold = 0.08,
    this.rotationSpeed = 1,
    this.colorBias = 0.01,
    this.uComplex = 3,
    this.color1,
    this.zoom = 0.8,
    this.color2,
    this.power = 2,
    this.size = 50,
  });

  const GlyphEffect.arcane4({
    super.key,
    this.debugBorder = false,
    this.intensity = 0.7,
    this.bloom = 10,
    this.overdraw = 3,
    this.speed = 3,
    this.threshold = 0.08,
    this.rotationSpeed = 1,
    this.colorBias = 0.01,
    this.uComplex = 4,
    this.color1,
    this.zoom = 0.77,
    this.color2,
    this.power = 2,
    this.size = 50,
  });

  const GlyphEffect.arcane5({
    super.key,
    this.debugBorder = false,
    this.intensity = 0.7,
    this.bloom = 10,
    this.overdraw = 3,
    this.speed = 3,
    this.threshold = 0.08,
    this.rotationSpeed = 1,
    this.colorBias = 0.01,
    this.uComplex = 5,
    this.color1,
    this.zoom = 0.88,
    this.color2,
    this.power = 1.6,
    this.size = 50,
  });

  const GlyphEffect.arcane6({
    super.key,
    this.debugBorder = false,
    this.intensity = 0.7,
    this.bloom = 10,
    this.overdraw = 3,
    this.speed = 2,
    this.threshold = 0.08,
    this.rotationSpeed = 1,
    this.colorBias = 0.01,
    this.uComplex = 6,
    this.color1,
    this.zoom = 0.88,
    this.color2,
    this.power = 1.7,
    this.size = 50,
  });

  List<double> _color(Color color) => [color.r, color.g, color.b];

  @override
  Widget build(BuildContext context) {
    List<double> c1 = _color(color1 ?? Theme.of(context).colorScheme.primary);
    List<double> c2 =
        _color(color2 ?? Theme.of(context).colorScheme.background);
    double uInvert = Theme.of(context).colorScheme.brightness == Brightness.dark
        ? 1.0
        : -1.0;
    return Container(
      decoration: debugBorder
          ? BoxDecoration(
              border: Border.all(color: Colors.blue, width: 1),
            )
          : null,
      child: SizedBox(
        width: size,
        height: size,
        child: OverflowBox(
          maxHeight: size * overdraw,
          maxWidth: size * overdraw,
          child: Container(
            width: size * overdraw,
            height: size * overdraw,
            decoration: debugBorder
                ? BoxDecoration(
                    border: Border.all(color: Colors.red, width: 1),
                  )
                : null,
            child: (const GlyphShader().program)
                .build((program) => AnimatedShadedSurface(
                      size: Size.square(size) * overdraw,
                      program: program,
                      shaderBuilder: (program, elapsed) =>
                          program.fragmentShader()
                            ..setFloatUniforms(
                              (s) => s
                                ..setFloat(elapsed.inMilliseconds / 1000)
                                ..setSize(Size.square(size) * overdraw)
                                ..setFloat((1 / intensity) * 200.0)
                                ..setFloat(speed)
                                ..setFloat(rotationSpeed)
                                ..setFloat(threshold)
                                ..setFloat(uComplex.toDouble())
                                ..setFloat(colorBias)
                                ..setFloat(zoom)
                                ..setFloat(uInvert)
                                ..setFloat(bloom)
                                ..setFloat(power)
                                ..setFloats(c1)
                                ..setFloats(c2),
                            ),
                    )),
          ),
        ),
      ),
    );
  }
}

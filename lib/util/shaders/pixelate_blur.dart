import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:arcane/util/shaders.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

const String _name = "pixelate_blur";
Future<FragmentProgram> _loadShader() => ArcaneShader.loadShader(_name);

class PixelateBlurShader extends ArcaneShader {
  const PixelateBlurShader(
      {super.programProvider = _loadShader, super.name = _name});
}

extension XWidgetPixelateBlur on Widget {
  Widget shadePixelateBlur({
    int samples = 4,
    double pixelSize = 8,
    double radius = 2,
  }) =>
      PixelateBlurFilter(
          samples: samples, pixelSize: pixelSize, radius: radius, child: this);
}

class PixelateBlurFilter extends StatelessWidget with BoxSignal {
  final int samples;
  final double pixelSize;
  final double radius;
  final Widget child;

  const PixelateBlurFilter(
      {super.key,
      required this.child,
      this.samples = 4,
      this.pixelSize = 8,
      this.radius = 2});

  @override
  Widget build(BuildContext context) =>
      (const PixelateBlurShader().program).build(
          (context) => ShaderBuilder(
              (context, shader, child) =>
                  AnimatedSampler((image, size, canvas) {
                    shader.setFloatUniforms((uniforms) {
                      uniforms
                        ..setSize(size)
                        ..setFloat(samples.toDouble())
                        ..setFloat(pixelSize)
                        ..setFloat(radius);
                    });

                    shader.setImageSampler(0, image);
                    canvas.drawRect(
                      Rect.fromLTWH(0, 0, size.width, size.height),
                      Paint()..shader = shader,
                    );
                  }, child: this.child),
              assetKey: ArcaneShader.assetKey(_name)),
          loading: child);
}

import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

const String _name = "rgb";
Future<FragmentProgram> _loadShader() => ArcaneShader.loadShader(_name);

class RGBShader extends ArcaneShader {
  const RGBShader({super.programProvider = _loadShader, super.name = _name});
}

extension XWidgetRGB on Widget {
  Widget shadeRGB({double radius = 5, double spin = 1}) =>
      RGBFilter(radius: radius, spin: spin, child: this);
}

class RGBFilter extends StatelessWidget with BoxSignal {
  final double radius;
  final double spin;
  final Widget child;

  const RGBFilter(
      {super.key, required this.child, this.radius = 5, this.spin = 1});

  @override
  Widget build(BuildContext context) => (const RGBShader().program).build(
      (context) => ShaderBuilder(
          (context, shader, child) => AnimatedSampler((image, size, canvas) {
                shader.setFloatUniforms((uniforms) {
                  uniforms
                    ..setSize(size)
                    ..setFloat(radius)
                    ..setFloat(spin);
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

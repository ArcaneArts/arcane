import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:arcane/util/shaders.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

const String _name = "edge";
Future<FragmentProgram> _loadShader() => ArcaneShader.loadShader(_name);

class EdgeShader extends ArcaneShader {
  const EdgeShader({super.programProvider = _loadShader, super.name = _name});
}

extension XWidgetEdge on Widget {
  Widget shadeEdge(double radius) => EdgeFilter(radius: radius, child: this);
}

class EdgeFilter extends StatelessWidget with BoxSignal {
  final Widget child;
  final double radius;

  const EdgeFilter({super.key, required this.child, this.radius = 4});

  @override
  Widget build(BuildContext context) => (const EdgeShader().program).build(
      (context) => ShaderBuilder(
          (context, shader, child) => AnimatedSampler((image, size, canvas) {
                shader.setFloatUniforms((uniforms) {
                  uniforms
                    ..setFloat(radius)
                    ..setSize(size);
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

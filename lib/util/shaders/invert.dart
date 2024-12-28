import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:arcane/util/shaders.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

const String _name = "invert";
Future<FragmentProgram> _loadShader() => ArcaneShader.loadShader(_name);

class InvertShader extends ArcaneShader {
  const InvertShader({super.programProvider = _loadShader, super.name = _name});
}

extension XWidgetInvert on Widget {
  Widget shadeInvert() => InvertFilter(child: this);
}

class InvertFilter extends StatelessWidget with BoxSignal {
  final Widget child;

  const InvertFilter({super.key, required this.child});

  @override
  Widget build(BuildContext context) => (const InvertShader().program).build(
      (context) => ShaderBuilder(
          (context, shader, child) => AnimatedSampler((image, size, canvas) {
                shader.setFloatUniforms((uniforms) {
                  uniforms..setSize(size);
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

import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:arcane/util/shaders.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

const String _name = "frost";
Future<FragmentProgram> _loadShader() => ArcaneShader.loadShader(_name);

class FrostShader extends ArcaneShader {
  const FrostShader({super.programProvider = _loadShader, super.name = _name});
}

extension XWidgetFrost on Widget {
  Widget shadeFrost(double value) => FrostFilter(value: value, child: this);
}

class FrostFilter extends StatelessWidget with BoxSignal {
  final double value;
  final Widget child;

  const FrostFilter({super.key, required this.child, this.value = 1});

  @override
  Widget build(BuildContext context) => (const FrostShader().program).build(
      (context) => ShaderBuilder(
          (context, shader, child) => AnimatedSampler((image, size, canvas) {
                shader.setFloatUniforms((uniforms) {
                  uniforms
                    ..setSize(size)
                    ..setFloat(value);
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

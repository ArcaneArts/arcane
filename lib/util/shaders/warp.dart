import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:arcane/util/shaders.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

const String _name = "warp";
Future<FragmentProgram> _loadShader() => ArcaneShader.loadShader(_name);

class WarpShader extends ArcaneShader {
  const WarpShader({super.programProvider = _loadShader, super.name = _name});
}

extension XWidgetWarp on Widget {
  Widget shadeWarp() => WarpFilter(child: this);
}

class WarpFilter extends StatelessWidget with BoxSignal {
  final Widget child;

  const WarpFilter({super.key, required this.child});

  @override
  Widget build(BuildContext context) => (const WarpShader().program).build(
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

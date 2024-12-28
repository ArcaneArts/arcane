import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:arcane/util/shaders.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

const String _name = "warp";
Future<FragmentProgram> _loadShader() => ArcaneShader.loadShader(_name);

class WarpShader extends ArcaneShader {
  const WarpShader({super.programProvider = _loadShader, super.name = _name});
}

extension XWidgetWarp on Widget {
  Widget shadeWarp({
    double amplitude = 1,
    double frequency = 1,
    double z = 1,
  }) =>
      WarpFilter(amplitude: amplitude, frequency: frequency, z: z, child: this);

  Widget shadeWarpAnimation({
    double amplitude = 1,
    double frequency = 1,
    double z = 1,
    double zSpeed = 1,
  }) =>
      WarpyFilter(
          amplitude: amplitude,
          frequency: frequency,
          z: z,
          zSpeed: zSpeed,
          child: this);
}

class WarpyFilter extends StatefulWidget {
  final Widget child;
  final double amplitude;
  final double frequency;
  final double z;
  final double zSpeed;

  const WarpyFilter(
      {super.key,
      required this.child,
      this.amplitude = 1,
      this.frequency = 1,
      this.zSpeed = 1,
      this.z = 1});

  @override
  State<WarpyFilter> createState() => _WarpyFilterState();
}

class _WarpyFilterState extends State<WarpyFilter>
    with SingleTickerProviderStateMixin {
  late Ticker ticker;
  late double zz;

  @override
  void initState() {
    ticker = createTicker((elapsed) {
      setState(() {
        zz = (elapsed.inMilliseconds / 1000) * widget.zSpeed;
      });
    });
    ticker.start();
    super.initState();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WarpFilter(
      amplitude: widget.amplitude,
      frequency: widget.frequency,
      z: (widget.z + zz),
      child: widget.child);
}

class WarpFilter extends StatelessWidget with BoxSignal {
  final Widget child;
  final double amplitude;
  final double frequency;
  final double z;

  const WarpFilter(
      {super.key,
      required this.child,
      this.amplitude = 1,
      this.frequency = 1,
      this.z = 1});

  @override
  Widget build(BuildContext context) => (const WarpShader().program).build(
      (context) => ShaderBuilder(
          (context, shader, child) => AnimatedSampler((image, size, canvas) {
                shader.setFloatUniforms((uniforms) {
                  uniforms
                    ..setSize(size)
                    ..setFloat(amplitude)
                    ..setFloat(frequency)
                    ..setFloat(z);
                });

                shader.setImageSampler(0, image);
                canvas.drawRect(
                  Rect.fromLTWH(0, 0, size.width, size.height),
                  Paint()..shader = shader,
                );
              }, child: this.child.pad(64)),
          assetKey: ArcaneShader.assetKey(_name)),
      loading: child.pad(64));
}

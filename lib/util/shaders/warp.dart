import 'dart:async';
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
  Widget shadeWarp({
    double amplitude = 1,
    double frequency = 1,
    double z = 1,
    int octaves = 2,
  }) =>
      WarpFilter(
          amplitude: amplitude,
          frequency: frequency,
          z: z,
          octaves: octaves,
          child: this);

  Widget shadeWarpAnimation({
    double amplitude = 1,
    double frequency = 1,
    double z = 1,
    double zSpeed = 1,
    int octaves = 2,
  }) =>
      WarpyFilter(
          amplitude: amplitude,
          frequency: frequency,
          z: z,
          octaves: octaves,
          zSpeed: zSpeed,
          child: this);
}

class WarpyFilter extends StatefulWidget {
  final Widget child;
  final double amplitude;
  final double frequency;
  final double z;
  final double zSpeed;
  final int octaves;

  const WarpyFilter(
      {super.key,
      required this.child,
      this.amplitude = 1,
      this.frequency = 1,
      this.octaves = 2,
      this.zSpeed = 1,
      this.z = 1});

  @override
  State<WarpyFilter> createState() => _WarpyFilterState();
}

class _WarpyFilterState extends State<WarpyFilter>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  double fpsLimit = mMaxShaderFPS;
  late PrecisionStopwatch pWallClock;
  double zz = 1;

  void _startTimer() {
    double currentLimit = fpsLimit;
    int lim = 1000 ~/ currentLimit;
    _timer = Timer.periodic(Duration(milliseconds: lim), (t) {
      setState(() {
        zz = (pWallClock.getMilliseconds() / 1000) * widget.zSpeed;
      });

      if (currentLimit != fpsLimit) {
        currentLimit = fpsLimit;
        t.cancel();
        _startTimer();
      }

      double tfps = fpsLimit;

      if (mRenderUsage > 0.9) {
        tfps -= 0.77;
      } else {
        tfps += 0.1;
      }

      fpsLimit = tfps.clamp(mMinShaderFPS, mMaxShaderFPS);
    });
  }

  @override
  void initState() {
    pWallClock = PrecisionStopwatch.start();
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WarpFilter(
      amplitude: widget.amplitude,
      frequency: widget.frequency,
      z: (widget.z + zz),
      octaves: widget.octaves,
      child: widget.child);
}

class WarpFilter extends StatelessWidget with BoxSignal {
  final Widget child;
  final double amplitude;
  final double frequency;
  final double z;
  final int octaves;

  const WarpFilter(
      {super.key,
      required this.child,
      this.octaves = 2,
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
                    ..setFloat(frequency)
                    ..setFloat(amplitude)
                    ..setFloat(z)
                    ..setFloat(octaves.toDouble());
                });

                shader.setImageSampler(0, image);
                canvas.drawRect(
                  Rect.fromLTWH(0, 0, size.width, size.height),
                  Paint()
                    ..shader = shader
                    ..isAntiAlias = true,
                );
              }, child: this.child),
          assetKey: ArcaneShader.assetKey(_name)),
      loading: child);
}

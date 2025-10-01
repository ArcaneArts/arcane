import 'dart:async';
import 'dart:ui';

import 'package:arcane/arcane.dart' hide Image;
import 'package:arcane/util/shaders/arcane_blur.dart';
import 'package:arcane/util/shaders/invert.dart';
import 'package:chat_color/chat_color.dart';
import 'package:fast_log/fast_log.dart';
import 'package:flutter/scheduler.dart';

Map<String, ArcaneShader> arcaneShaderRegistry = {};
Map<String, Future<FragmentProgram>> arcaneShaderPrograms = {};
double targetShaderFrameTime = 8;
double mRenderUsage = 0;
double mMinShaderFPS = 15;
double mMaxShaderFPS = 60;
double mMinShaderRS = 0.5;
double mMaxShaderRS = 1;
double cShaderFPS = mMaxShaderFPS;
double cShaderRS = mMaxShaderRS;
late PrecisionStopwatch _wallClock;

Future<void> loadArcaneShaders(List<ArcaneShader> shaders) async {
  WidgetsFlutterBinding.ensureInitialized();
  _wallClock = PrecisionStopwatch.start();

  void _processTimings(List<FrameTiming> timings) {
    for (final frame in timings) {
      Duration totalFrameTime = frame.rasterDuration;
      double frameTime = totalFrameTime.inMicroseconds / 1000;
      double frameUsage = frameTime / targetShaderFrameTime;
      mRenderUsage = frameUsage;
      double tfps = cShaderFPS;

      if (mRenderUsage > 0.9) {
        double intensity = mRenderUsage - 0.9;
        tfps -= 1.2 * intensity;
        cShaderRS -= 0.001 * intensity;
      } else {
        double intensity = 0.9 - mRenderUsage;
        tfps += 0.1 * intensity;
        cShaderRS += 0.0003 * intensity;
      }

      cShaderRS = cShaderRS.clamp(mMinShaderRS, mMaxShaderRS);
      cShaderFPS = tfps.clamp(mMinShaderFPS, mMaxShaderFPS);
    }
  }

  SchedulerBinding.instance.addTimingsCallback(_processTimings);
  List<String> failures = [];
  List<Future> shaderFutures = [];
  PrecisionStopwatch p = PrecisionStopwatch.start();
  for (ArcaneShader shader in shaders) {
    Future<FragmentProgram> f = shader.programProvider().thenRun((i) {
      verbose(
          "Compiled shader: ${shader.name} to 0x${i.identityHash.toRadixString(16)}");
    }).catchError((e, es) {
      error("Failed to compile shader: ${shader.name}");
      error(es);
      failures.add(shader.name);
    });
    shaderFutures.add(f);
    arcaneShaderPrograms[shader.name] = f;
    arcaneShaderRegistry[shader.name] = shader;
  }

  try {
    await Future.wait(shaderFutures);
  } catch (e) {
    error("Failed to compile shaders: $e");
  }
  if (failures.isNotEmpty) {
    warningAnnounce(
        "Arcane failed to compile ${failures.length} ${failures.length.plural("Shader")}\n${failures.join("\n")}\n\nCheck tome.arcane.art setup page for more information.");

    info("""
Did you forget to add the shaders to the pubspec.yaml?

@(#FFcfc7b6)&(#FF24180d)flutter: 
  shaders: 
${failures.map((i) => "    - &(#FF106b00)packages/arcane/resources/shaders/${i}.frag").join("&(#FF24180d)\n")}
&r
    """
        .chatColor);
  }
  actioned(
      "Compiled ${shaders.length - failures.length} shaders in ${p.getMilliseconds()}ms");
}

class ArcaneShader {
  final String name;
  final Future<FragmentProgram> Function() programProvider;

  const ArcaneShader({required this.programProvider, required this.name});

  Future<FragmentProgram> get program => arcaneShaderPrograms[name]!;

  static String assetKey(String name) =>
      "packages/arcane/resources/shaders/$name.frag";

  static Future<FragmentProgram> loadShader(String name) async {
    try {
      return await FragmentProgram.fromAsset(
          name.startsWith("packages/arcane/resources/shaders/")
              ? name
              : assetKey(name));
    } catch (e) {
      error("Failed to load shader: $name");
      error(e);
      return Future.error(e);
    }
  }

  static void loadAll() => loadArcaneShaders(const [
        FrostShader(),
        PixelateShader(),
        PixelateBlurShader(),
        RGBShader(),
        LoaderShader(),
        GlyphShader(),
        InvertShader(),
        WarpShader(),
        BlackHoleShader(),
        LuxShader(),
        CascadeShader(),
        EdgeShader(),
        ArcaneBlurShader(),
      ]);
}

class AnimatedShadedSurface extends StatefulWidget {
  final FragmentProgram program;
  final Size size;
  final FragmentShader Function(FragmentProgram program, Duration elapsed)
      shaderBuilder;

  const AnimatedShadedSurface(
      {super.key,
      required this.program,
      required this.size,
      required this.shaderBuilder});

  @override
  State<AnimatedShadedSurface> createState() => _AnimatedShadedSurfaceState();
}

class _AnimatedShadedSurfaceState extends State<AnimatedShadedSurface> {
  late Timer _timer;
  late FragmentShader shader;
  double fpsLimit = mMaxShaderFPS;
  late PrecisionStopwatch pWallClock;
  double res = 1;
  double ires = 1;
  Image? _frameBuffer;

  void _draw() {
    fpsLimit = cShaderFPS.roundToDouble();
    res = cShaderRS > 0.9 ? 1 : cShaderRS;

    shader = widget.shaderBuilder(widget.program,
        Duration(milliseconds: pWallClock.getMilliseconds().round()));

    if (res < 1) {
      PictureRecorder p = PictureRecorder();
      Canvas c = Canvas(p);
      ires = res;
      c.scale(res / (1 / res));
      c.drawRect(
        Rect.fromLTWH(0, 0, widget.size.width, widget.size.height),
        Paint()
          ..shader = shader
          ..filterQuality = FilterQuality.high,
      );
      setState(() {
        _frameBuffer = p.endRecording().toImageSync(
            (widget.size.width * res).ceil() + 1,
            (widget.size.height * res).ceil() + 1);
      });
    } else {
      setState(() {
        _frameBuffer = null;
        ires = res;
      });
    }
  }

  void _startTimer() {
    double currentLimit = fpsLimit;
    int lim = 1000 ~/ currentLimit;
    _timer = Timer.periodic(Duration(milliseconds: lim), (t) {
      _draw();

      if (currentLimit != fpsLimit) {
        currentLimit = fpsLimit;
        t.cancel();
        _startTimer();
      }
    });
  }

  @override
  void initState() {
    pWallClock = PrecisionStopwatch.start();
    shader = widget.shaderBuilder(widget.program, Duration(milliseconds: 1));
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
        key: ValueKey(ires),
        size: widget.size,
        isComplex: true,
        willChange: true,
        painter: ShadedSurfacePainter(shader, _frameBuffer, ires),
      );
}

class ShadedSurfacePainter extends CustomPainter {
  final FragmentShader shader;
  final Image? frameBuffer;
  final double renderResolution;

  ShadedSurfacePainter(this.shader, this.frameBuffer, this.renderResolution);

  @override
  void paint(Canvas canvas, Size size) {
    if (frameBuffer != null && renderResolution < 1) {
      canvas.drawImageRect(
          frameBuffer!,
          Rect.fromLTWH(0, 0, frameBuffer!.width.toDouble(),
              frameBuffer!.height.toDouble()),
          Rect.fromLTWH(0, 0, size.width / renderResolution,
              size.height / renderResolution),
          Paint());
    } else {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()
          ..shader = shader
          ..filterQuality = FilterQuality.high,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

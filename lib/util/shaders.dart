import 'dart:async';
import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:arcane/util/shaders/invert.dart';
import 'package:chat_color/chat_color.dart';
import 'package:fast_log/fast_log.dart';
import 'package:flutter/scheduler.dart';

Map<String, ArcaneShader> arcaneShaderRegistry = {};
Map<String, Future<FragmentProgram>> arcaneShaderPrograms = {};
double targetShaderFrameTime = 16;
double mRenderUsage = 0;
double mMinShaderFPS = 24;
double mMaxShaderFPS = 60;
double mMinShaderRS = 0.25;
double mMaxShaderRS = 1;

Future<void> loadArcaneShaders(List<ArcaneShader> shaders) async {
  WidgetsFlutterBinding.ensureInitialized();
  List<double> avgFT = [];
  int _ftIndex = 0;

  while (avgFT.length < 10) {
    avgFT.add(1);
  }

  SchedulerBinding.instance.addTimingsCallback((List<FrameTiming> timings) {
    for (final frame in timings) {
      Duration totalFrameTime = frame.totalSpan;
      double usedMs = totalFrameTime.inMicroseconds / 1000.0;

      avgFT[_ftIndex] = usedMs;
      _ftIndex = (_ftIndex + 1) % 10;
      usedMs = avgFT.reduce((a, b) => a + b) / avgFT.length;
      mRenderUsage = (usedMs / targetShaderFrameTime);
    }
  });

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
      return await FragmentProgram.fromAsset(assetKey(name));
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
        CascadeShader()
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

  void _startTimer() {
    double currentLimit = fpsLimit;
    int lim = 1000 ~/ currentLimit;
    _timer = Timer.periodic(Duration(milliseconds: lim), (t) {
      setState(() {
        shader = widget.shaderBuilder(widget.program,
            Duration(milliseconds: pWallClock.getMilliseconds().round()));
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
        size: widget.size,
        isComplex: true,
        willChange: true,
        painter: ShadedSurfacePainter(shader),
      );
}

class ShadedSurfacePainter extends CustomPainter {
  final FragmentShader shader;
  final double renderResolution; // 1 = full, 0.5 = half

  ShadedSurfacePainter(this.shader, {this.renderResolution = 1});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = shader
        ..filterQuality = FilterQuality.high,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

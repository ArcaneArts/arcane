import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:arcane/util/shaders/invert.dart';
import 'package:arcane/util/shaders/warp.dart';
import 'package:fast_log/fast_log.dart';
import 'package:flutter/scheduler.dart';

Map<String, ArcaneShader> arcaneShaderRegistry = {};
Map<String, Future<FragmentProgram>> arcaneShaderPrograms = {};

Future<void> loadArcaneShaders(List<ArcaneShader> shaders) async {
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
      ]);
}

class AnimatedShadedSurface extends StatefulWidget {
  final double fpsLimit;
  final FragmentProgram program;
  final Size size;
  final FragmentShader Function(FragmentProgram program, Duration elapsed)
      shaderBuilder;

  const AnimatedShadedSurface(
      {super.key,
      required this.program,
      this.fpsLimit = 24,
      required this.size,
      required this.shaderBuilder});

  @override
  State<AnimatedShadedSurface> createState() => _AnimatedShadedSurfaceState();
}

class _AnimatedShadedSurfaceState extends State<AnimatedShadedSurface>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late FragmentShader shader;
  double lastTime = 0;

  @override
  void initState() {
    shader = widget.shaderBuilder(widget.program, Duration(milliseconds: 1));
    PrecisionStopwatch p = PrecisionStopwatch.start();
    lastTime = p.getMilliseconds();
    super.initState();
    _ticker = createTicker((elapsed) {
      if (p.getMilliseconds() - lastTime < 1000 / widget.fpsLimit) return;
      lastTime = p.getMilliseconds();
      setState(() {
        shader = widget.shaderBuilder(widget.program, elapsed);
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
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

  ShadedSurfacePainter(this.shader);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

import 'dart:async';
import 'dart:ui' as ui;

import 'package:arcane/arcane.dart';
import 'package:arcane/util/shaders/arcane_blur.dart';
import 'package:flutter/rendering.dart';

enum ArcaneBlurMode {
  /// Blurs the child widget using a [RenderObject]. which is faster than a [BackdropFilter].
  renderObject,

  /// Uses a [BackdropFilter] to blur the child widget.
  backdropFilter,
  frost,
  disabled,
  liquidGlass,
}

enum EdgeDirection {
  left,
  right,
  top,
  bottom,
}

class EdgeTheme {
  final bool autoEdge;
  final double blurIntensity;
  final double blurAddedIntensity;
  final int blurCount;
  final double size;

  const EdgeTheme({
    this.blurIntensity = 0.15,
    this.blurAddedIntensity = 0.15,
    this.blurCount = 5,
    this.size = 28,
    this.autoEdge = false,
  });
}

class ArcaneBlur extends StatelessWidget {
  final double intensity;
  final TileMode tileMode;
  final ArcaneBlurMode? mode;
  final Widget child;

  const ArcaneBlur({
    super.key,
    this.intensity = 0,
    this.tileMode = TileMode.clamp,
    this.mode,
    required this.child,
  });

  ArcaneBlurMode getBlurMode(BuildContext context) {
    if (mode != null) return mode!;
    return ArcaneTheme.of(context).blurMode;
  }

  @override
  Widget build(BuildContext context) {
    if (intensity <= 0) return child;

    ArcaneBlurMode mode = getBlurMode(context);

    if (!ui.ImageFilter.isShaderFilterSupported &&
        mode == ArcaneBlurMode.liquidGlass) {
      mode = ArcaneBlurMode.backdropFilter;
    }

    if (mode == ArcaneBlurMode.disabled) {
      return child;
    }

    if (mode == ArcaneBlurMode.frost) {
      return ArcaneShaderBlur(
        intensity: intensity,
        child: child,
      );
    }

    if (mode == ArcaneBlurMode.renderObject) {
      return _RenderObjectBlur(
        blurriness: intensity,
        tileMode: tileMode,
        child: child,
      );
    }

    if (mode == ArcaneBlurMode.backdropFilter) {
      return _BackdropFilterBlur(
        blurriness: intensity,
        tileMode: tileMode,
        child: child,
      );
    }

    if (mode == ArcaneBlurMode.liquidGlass) {
      ArcaneLiquidGlass g = ArcaneTheme.of(context).liquidGlass;

      return LiquidGlass(
        shape: g.shape ??
            LiquidRoundedSuperellipse(
                borderRadius: Theme.of(context).radiusMdRadius),
        glassContainsChild: g.glassContainsChild,
        settings: (g.settings ?? LiquidGlassSettings(blur: intensity)),
        clipBehavior: g.clipBehavior,
        child: child,
      );
    }

    return child;
  }
}

class ArcaneShaderBlur extends StatefulWidget {
  final double intensity;
  final Widget child;

  const ArcaneShaderBlur({super.key, this.intensity = 1, required this.child});

  @override
  State<ArcaneShaderBlur> createState() => _ArcaneShaderBlurState();
}

class _ArcaneShaderBlurState extends State<ArcaneShaderBlur> {
  late Future<ui.FragmentProgram?> shader;

  @override
  void initState() {
    shader = !ui.ImageFilter.isShaderFilterSupported
        ? Future.value(null)
        : const ArcaneBlurShader().program;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget blank = _BackdropFilterBlur(
      blurriness: widget.intensity,
      child: widget.child,
    );
    return shader.build(
        (shader) => shader == null
            ? blank
            : BackdropFilter(
                filter: ui.ImageFilter.compose(
                    inner: ui.ImageFilter.blur(
                        sigmaX: widget.intensity,
                        sigmaY: widget.intensity,
                        tileMode: TileMode.decal),
                    outer: ui.ImageFilter.compose(
                        inner: ui.ImageFilter.shader(shader.fragmentShader()
                          ..setFloat(2, widget.intensity * 0.06)),
                        outer:
                            ui.ImageFilter.dilate(radiusX: 2, radiusY: 0.001))),
                child: widget.child,
              ),
        loading: blank);
  }
}

BackdropKey globalBlurKey = BackdropKey();

class _BackdropFilterBlur extends StatelessWidget {
  final double blurriness;
  final TileMode tileMode;
  final Widget child;

  const _BackdropFilterBlur(
      {required this.blurriness,
      this.tileMode = TileMode.decal,
      required this.child});

  @override
  Widget build(BuildContext context) {
    BackdropKey? key = BackdropGroup.of(context)?.backdropKey;

    if (key != null) {
      return BackdropFilter.grouped(
        filter: ui.ImageFilter.blur(
            sigmaX: blurriness, sigmaY: blurriness, tileMode: tileMode),
        child: child,
      );
    }

    return BackdropFilter(
      filter: ui.ImageFilter.blur(
          sigmaX: blurriness, sigmaY: blurriness, tileMode: tileMode),
      child: child,
    );
  }
}

class _RenderObjectBlur extends SingleChildRenderObjectWidget {
  final double blurriness;
  final TileMode tileMode;

  const _RenderObjectBlur({
    super.key,
    super.child,
    required this.blurriness,
    this.tileMode = TileMode.decal,
  });

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderObjectBlurRenderBox renderObject) {
    if (blurriness == renderObject.blurriness) return;
    renderObject.blurriness = blurriness;
    renderObject.tileMode = tileMode;
    super.updateRenderObject(context, renderObject);
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderObjectBlurRenderBox(
      blurriness: blurriness,
      tileMode: tileMode,
    );
  }
}

class _RenderObjectBlurRenderBox extends RenderProxyBox {
  double blurriness;
  TileMode tileMode;

  _RenderObjectBlurRenderBox({
    required this.blurriness,
    required this.tileMode,
  });

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? child = this.child;
    final Canvas canvas = context.canvas;

    if (child == null) {
      return;
    }

    if (blurriness == 0) {
      context.paintChild(child, offset);
      canvas.restore();
      return;
    }

    final Paint paint = Paint()
      ..imageFilter = ui.ImageFilter.blur(
        sigmaX: blurriness,
        sigmaY: blurriness,
        tileMode: tileMode,
      );

    canvas.saveLayer(offset & size, paint);
    context.paintChild(child, offset);
    canvas.restore();
  }
}

class MotionBlurScrollable extends StatefulWidget {
  const MotionBlurScrollable({
    super.key,
    required this.child,
    this.tileMode,
    this.intensity = 1,
  });

  final ScrollView child;
  final TileMode? tileMode;
  final double intensity;

  @override
  State<MotionBlurScrollable> createState() => _MotionBlurScrollableState();
}

class _MotionBlurScrollableState extends State<MotionBlurScrollable> {
  double delta = 0;
  bool horizontal = false;

  /// A timer is needed due to an unresolved bug that [ScrollEndNotification]
  /// would be emitted on every scroll update.
  /// https://github.com/flutter/flutter/issues/44732#issuecomment-862405208
  Timer? scrollEndTimer;

  bool onScroll(ScrollUpdateNotification scroll) {
    if (scroll.depth != 0) {
      return false;
    }
    if (scroll.scrollDelta == null) {
      return false;
    }
    final deltaPixels = scroll.scrollDelta!.abs();
    setState(() {
      delta = (deltaPixels / 2.0) * widget.intensity;
      horizontal = scroll.metrics.axis == Axis.horizontal;
    });
    scrollEndTimer?.cancel();
    scrollEndTimer = Timer(const Duration(milliseconds: 50), () {
      setState(() {
        delta = 0;
      });
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: onScroll,
      child: ImageFiltered(
        imageFilter: ui.ImageFilter.blur(
          sigmaX: horizontal ? delta : 0.0,
          sigmaY: horizontal ? 0.0 : delta,
          tileMode: widget.tileMode ?? TileMode.decal,
        ),
        child: widget.child,
      ),
    );
  }
}

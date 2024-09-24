import 'dart:async';
import 'dart:ui' as ui;

import 'package:arcane/arcane.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart' hide Image;
import 'package:flutter_shaders/flutter_shaders.dart';

enum ArcaneBlurMode {
  /// Blurs the child widget using a [RenderObject]. which is faster than a [BackdropFilter].
  renderObject,

  /// Uses a [BackdropFilter] to blur the child widget.
  backdropFilter,

  /// Uses a shader to blur the child widget when it moves.
  motionBlur
}

class ArcaneBlur extends StatelessWidget {
  final double intensity;
  final TileMode tileMode;
  final ArcaneBlurMode mode;
  final Widget child;

  const ArcaneBlur({
    super.key,
    this.intensity = 0,
    this.tileMode = TileMode.clamp,
    this.mode = ArcaneBlurMode.backdropFilter,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => switch (this) {
        ArcaneBlur(intensity: double i) when i <= 0 => child,
        ArcaneBlur(mode: ArcaneBlurMode.motionBlur) => MotionBlur(
            child: child,
            intensity: intensity,
          ),
        ArcaneBlur(mode: ArcaneBlurMode.renderObject) => _RenderObjectBlur(
            blurriness: intensity,
            tileMode: tileMode,
            child: child,
          ),
        ArcaneBlur(mode: ArcaneBlurMode.backdropFilter) => _BackdropFilterBlur(
            blurriness: intensity,
            tileMode: tileMode,
            child: child,
          ),
      };
}

class _BackdropFilterBlur extends StatelessWidget {
  final double blurriness;
  final TileMode tileMode;
  final Widget child;

  const _BackdropFilterBlur(
      {super.key,
      required this.blurriness,
      this.tileMode = TileMode.decal,
      required this.child});

  @override
  Widget build(BuildContext context) => BackdropFilter(
        filter: ui.ImageFilter.blur(
            sigmaX: blurriness, sigmaY: blurriness, tileMode: tileMode),
        child: child,
      );
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

class MotionBlur extends StatefulWidget {
  const MotionBlur({
    super.key,
    this.intensity = 1.0,
    this.enabled = true,
    required this.child,
  });
  final Widget child;

  ///The intensity of the motion blur
  final double intensity;

  ///Whether to enable the shader.
  final bool enabled;

  @override
  State<MotionBlur> createState() => _MotionBlurState();
}

class _MotionBlurState extends State<MotionBlur> {
  Size? prevSize;
  Offset? prevPosition;

  @override
  void didUpdateWidget(covariant MotionBlur oldWidget) {
    if (oldWidget.child != widget.child ||
        oldWidget.intensity != widget.intensity ||
        oldWidget.enabled != widget.enabled) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder((context, shader, child) {
      return AnimatedSampler(
        enabled: widget.enabled,
        (frame, size, canvas) {
          final position = (context.findRenderObject()! as RenderBox)
              .localToGlobal(Offset.zero);
          var deltaPosition = (prevPosition ?? position) - position;
          shader
            ..setFloat(0, size.width)
            ..setFloat(1, size.height)
            ..setFloat(2, (prevSize ?? size).width)
            ..setFloat(3, (prevSize ?? size).height)
            ..setFloat(4, deltaPosition.dx)
            ..setFloat(5, deltaPosition.dy)
            ..setFloat(6, widget.intensity)
            ..setImageSampler(0, frame);
          canvas.drawRect(
            Offset.zero & size,
            Paint()..shader = shader,
          );
          prevSize = size;
          prevPosition = position;
        },
        child: widget.child,
      );
    }, assetKey: 'packages/arcane/shaders/motion_blur.glsl');
  }
}

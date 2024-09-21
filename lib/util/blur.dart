import 'dart:async';
import 'dart:ui' as ui;

import 'package:arcane/arcane.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart' hide Image;

enum ArcaneBlurMode {
  /// Blurs the child widget using a [RenderObject]. which is faster than a [BackdropFilter].
  renderObject,

  /// Uses a [BackdropFilter] to blur the child widget.
  backdropFilter,
}

class ArcaneBlur extends StatelessWidget {
  final double intensity;
  final TileMode tileMode;
  final ArcaneBlurMode mode;
  final Widget child;

  const ArcaneBlur({
    super.key,
    this.intensity = 0,
    this.tileMode = TileMode.decal,
    this.mode = ArcaneBlurMode.backdropFilter,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => switch (this) {
        ArcaneBlur(intensity: double i) when i <= 0 => child,
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

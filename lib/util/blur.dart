import 'dart:ui' as ui;

import 'package:arcane/arcane.dart';
import 'package:flutter/rendering.dart';

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

import 'dart:async';
import 'dart:ui' as ui;

import 'package:arcane/arcane.dart';
import 'package:flutter/rendering.dart';

enum ArcaneBlurMode {
  /// Blurs the child widget using a [RenderObject]. which is faster than a [BackdropFilter].
  renderObject,

  /// Uses a [BackdropFilter] to blur the child widget.
  backdropFilter,
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
    this.autoEdge = true,
  });
}

class ArcaneEdge extends StatelessWidget {
  final List<EdgeDirection> directions;
  final double? blurIntensity;
  final double? blurAddedIntensity;
  final int? blurCount;
  final double? size;
  final Widget child;
  final bool autoMode;

  const ArcaneEdge(
      {super.key,
      this.directions = const [],
      this.blurIntensity,
      this.blurAddedIntensity,
      this.blurCount,
      this.size,
      this.autoMode = false,
      required this.child});

  @override
  Widget build(BuildContext context) {
    EdgeTheme e = ArcaneTheme.of(context).edge;
    if (autoMode && !e.autoEdge) return child;

    return directions.isEmpty
        ? child
        : Stack(
            fit: StackFit.passthrough,
            children: [
              child,
              ...directions.expand((i) => blurStackEdge(
                  count: blurCount ?? e.blurCount,
                  edge: size ?? e.size,
                  intensity: blurIntensity ?? e.blurIntensity,
                  addedIntensity: blurAddedIntensity ?? e.blurAddedIntensity,
                  direction: i)),
            ],
          );
    ;
  }
}

extension XAEW on Widget {
  Widget edgeBlur(
          {List<EdgeDirection> directions = const [],
          double? blurIntensity,
          double? blurAddedIntensity,
          int? blurCount,
          double? size,
          bool autoMode = false}) =>
      directions.isEmpty
          ? this
          : ArcaneEdge(
              autoMode: autoMode,
              directions: directions,
              blurIntensity: blurIntensity,
              blurAddedIntensity: blurAddedIntensity,
              blurCount: blurCount,
              size: size,
              child: this,
            );

  Widget leftEdgeBlur(
          {double? blurIntensity,
          double? blurAddedIntensity,
          int? blurCount,
          double? size,
          bool autoMode = false}) =>
      edgeBlur(
        autoMode: autoMode,
        directions: [EdgeDirection.left],
        blurIntensity: blurIntensity,
        blurAddedIntensity: blurAddedIntensity,
        blurCount: blurCount,
        size: size,
      );

  Widget rightEdgeBlur(
          {double? blurIntensity,
          double? blurAddedIntensity,
          int? blurCount,
          double? size,
          bool autoMode = false}) =>
      edgeBlur(
        autoMode: autoMode,
        directions: [EdgeDirection.right],
        blurIntensity: blurIntensity,
        blurAddedIntensity: blurAddedIntensity,
        blurCount: blurCount,
        size: size,
      );

  Widget topEdgeBlur(
          {double? blurIntensity,
          double? blurAddedIntensity,
          int? blurCount,
          double? size,
          bool autoMode = false}) =>
      edgeBlur(
        autoMode: autoMode,
        directions: [EdgeDirection.top],
        blurIntensity: blurIntensity,
        blurAddedIntensity: blurAddedIntensity,
        blurCount: blurCount,
        size: size,
      );

  Widget bottomEdgeBlur(
          {double? blurIntensity,
          double? blurAddedIntensity,
          int? blurCount,
          double? size,
          bool autoMode = false}) =>
      edgeBlur(
        autoMode: autoMode,
        directions: [EdgeDirection.bottom],
        blurIntensity: blurIntensity,
        blurAddedIntensity: blurAddedIntensity,
        blurCount: blurCount,
        size: size,
      );

  Widget horizontalEdgeBlur(
          {double? blurIntensity,
          double? blurAddedIntensity,
          int? blurCount,
          double? size,
          bool autoMode = false}) =>
      edgeBlur(
        autoMode: autoMode,
        directions: [EdgeDirection.left, EdgeDirection.right],
        blurIntensity: blurIntensity,
        blurAddedIntensity: blurAddedIntensity,
        blurCount: blurCount,
        size: size,
      );

  Widget verticalEdgeBlur(
          {double? blurIntensity,
          double? blurAddedIntensity,
          int? blurCount,
          double? size,
          bool autoMode = false}) =>
      edgeBlur(
        autoMode: autoMode,
        directions: [EdgeDirection.top, EdgeDirection.bottom],
        blurIntensity: blurIntensity,
        blurAddedIntensity: blurAddedIntensity,
        blurCount: blurCount,
        size: size,
      );

  Widget allEdgeBlur({
    bool autoMode = false,
    double? blurIntensity,
    double? blurAddedIntensity,
    int? blurCount,
    double? size,
  }) =>
      edgeBlur(
        autoMode: autoMode,
        directions: [
          EdgeDirection.left,
          EdgeDirection.right,
          EdgeDirection.top,
          EdgeDirection.bottom
        ],
        blurIntensity: blurIntensity,
        blurAddedIntensity: blurAddedIntensity,
        blurCount: blurCount,
        size: size,
      );
}

Iterable<Widget> blurStackEdge(
    {required int count,
    required double edge,
    required EdgeDirection direction,
    double intensity = 0.333,
    double addedIntensity = 0.333}) sync* {
  double l = edge / count;

  for (int i = 0; i < count; i++) {
    yield Positioned(
      left: direction == EdgeDirection.right ? null : 0,
      right: direction == EdgeDirection.left ? null : 0,
      top: direction == EdgeDirection.bottom ? null : 0,
      bottom: direction == EdgeDirection.top ? null : 0,
      height:
          direction == EdgeDirection.top || direction == EdgeDirection.bottom
              ? (l * i) + l
              : null,
      width: direction == EdgeDirection.left || direction == EdgeDirection.right
          ? (l * i) + l
          : null,
      child: ClipRect(
        child: BlurSurface(
            blur: intensity + (addedIntensity * (count - i)),
            child: Container()),
      ),
    );
  }
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
      {required this.blurriness,
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

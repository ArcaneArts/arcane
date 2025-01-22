import 'dart:math';

import 'package:arcane/component/animated_reorderable_list/animated_reorderable_list.dart';
import 'package:flutter/cupertino.dart';

class FlipInX extends AnimationEffect<double> {
  static const double beginValue = pi / 2;
  static const double endValue = 0.0;
  final double? begin;
  final double? end;

  /// An animation that flips the item along the X-axis.
  FlipInX({super.delay, super.duration, super.curve, this.begin, this.end});

  @override
  Widget build(BuildContext context, Widget child, Animation<double> animation,
      EffectEntry entry, Duration totalDuration) {
    final Animation<double> rotation = buildAnimation(entry, totalDuration,
            begin: begin ?? beginValue, end: endValue)
        .animate(animation);
    return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return Transform(
            transform: Matrix4.rotationX(rotation.value),
            alignment: Alignment.center,
            child: child,
          );
        },
        child: child);
  }
}

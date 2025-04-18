import 'package:arcane/component/animated_reorderable_list/animated_reorderable_list.dart';
import 'package:flutter/cupertino.dart';

class SlideInRight extends AnimationEffect<Offset> {
  static const Offset beginValue = Offset(1, 0);
  static const Offset endValue = Offset(0, 0);
  final Offset? begin;
  final Offset? end;

  /// A sliding animation from the right.
  SlideInRight(
      {super.delay, super.duration, super.curve, this.begin, this.end});

  @override
  Widget build(BuildContext context, Widget child, Animation<double> animation,
      EffectEntry entry, Duration totalDuration) {
    final Animation<Offset> position = buildAnimation(entry, totalDuration,
            begin: begin ?? beginValue, end: end ?? endValue)
        .animate(animation);
    return ClipRect(
        clipBehavior: Clip.hardEdge,
        child: SlideTransition(position: position, child: child));
  }
}

import 'dart:ui';

import 'package:arcane/arcane.dart';

enum GestureType {
  press,
  secondaryPress,
  tertiaryPress,
  longPress,
  longSecondaryPress,
  longTertiaryPress,
  doublePress,
}

class OnHover extends StatelessWidget {
  final void Function(bool hovering) action;
  final Widget child;

  const OnHover({super.key, required this.action, required this.child});

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => action(true),
        onExit: (_) => action(false),
        child: child,
      );
}

class OnGesture extends StatelessWidget {
  final GestureType type;
  final Widget child;
  final HitTestBehavior? behavior;
  final VoidCallback action;
  final Set<PointerDeviceKind>? supportedDevices;

  const OnGesture(
      {super.key,
      required this.type,
      required this.child,
      this.behavior,
      this.supportedDevices,
      required this.action});

  const OnGesture.press(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.press;

  const OnGesture.secondaryPress(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.secondaryPress;

  const OnGesture.tertiaryPress(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.tertiaryPress;

  const OnGesture.longPress(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.longPress;

  const OnGesture.longSecondaryPress(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.longSecondaryPress;

  const OnGesture.longTertiaryPress(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.longTertiaryPress;

  const OnGesture.doublePress(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.doublePress;

  @override
  Widget build(BuildContext context) => GestureDetector(
        supportedDevices: supportedDevices,
        onTap: type == GestureType.press ? action : null,
        onSecondaryTap: type == GestureType.secondaryPress ? action : null,
        onDoubleTap: type == GestureType.doublePress ? action : null,
        onLongPress: type == GestureType.longPress ? action : null,
        onTertiaryTapUp:
            type == GestureType.tertiaryPress ? (details) => action() : null,
        onSecondaryLongPress:
            type == GestureType.longSecondaryPress ? action : null,
        onTertiaryLongPress:
            type == GestureType.longTertiaryPress ? action : null,
        behavior: behavior,
        child: child,
      );
}

extension XOnGestureWidget on Widget {
  Widget onPressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.press(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  Widget onSecondaryPressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.secondaryPress(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  Widget onTertiaryPressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.tertiaryPress(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  Widget onLongPressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.longPress(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  Widget onLongSecondaryPressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.longSecondaryPress(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  Widget onLongTertiaryPressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.longTertiaryPress(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  Widget onDoublePressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.doublePress(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  Widget onHover(void Function(bool hovering) action) =>
      OnHover(action: action, child: this);
}

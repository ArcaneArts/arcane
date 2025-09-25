import 'dart:ui';

import 'package:arcane/arcane.dart';

/// Defines the different types of gestures that can be detected by [OnGesture].
///
/// These gesture types represent common interactions across different input devices.
///
/// See also:
///  * [doc/component/gesture.md] for more detailed documentation
///  * [OnGesture], which uses these gesture types
enum GestureType {
  /// Primary tap/click (left click on desktop)
  press,
  
  /// Secondary tap/click (right click on desktop)
  secondaryPress,
  
  /// Tertiary tap/click (middle click on desktop)
  tertiaryPress,
  
  /// Long press with primary button
  longPress,
  
  /// Long press with secondary button
  longSecondaryPress,
  
  /// Long press with tertiary button
  longTertiaryPress,
  
  /// Double tap/click
  doublePress,
}

/// A widget that detects mouse hover and executes an action when hover state changes.
///
/// [OnHover] uses Flutter's [MouseRegion] to detect when a pointer enters or exits
/// the widget's area, and calls the provided [action] with a boolean indicating
/// the current hover state.
///
/// See also:
///  * [doc/component/gesture.md] for more detailed documentation
///  * [XOnGestureWidget.onHover], which provides a more fluent API for this widget
class OnHover extends StatelessWidget {
  /// Function called with true when hover begins and false when it ends.
  final void Function(bool hovering) action;
  
  /// The widget to detect hover over.
  final Widget child;

  /// Creates an [OnHover] widget.
  ///
  /// The [action] parameter is called with true when hover begins and false when it ends.
  /// The [child] parameter is the widget that will detect hover events.
  ///
  /// Example:
  /// ```dart
  /// OnHover(
  ///   action: (hovering) {
  ///     setState(() => _isHovered = hovering);
  ///   },
  ///   child: Container(
  ///     color: _isHovered ? Colors.blue : Colors.grey,
  ///     child: Text("Hover to change color"),
  ///   ),
  /// )
  /// ```
  const OnHover({super.key, required this.action, required this.child});

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => action(true),
        onExit: (_) => action(false),
        child: child,
      );
}

/// A widget that detects a specific gesture type and executes an action when it occurs.
///
/// [OnGesture] wraps a child widget with a [GestureDetector] configured to respond
/// to the specified [type] of gesture. When that gesture is detected, the provided
/// [action] is executed.
///
/// See also:
///  * [doc/component/gesture.md] for more detailed documentation
///  * [GestureType], which defines the supported gesture types
///  * The extension methods on [Widget] like [onPressed], which provide a more
///    fluent API for adding gesture detection
class OnGesture extends StatelessWidget {
  /// The type of gesture to detect.
  final GestureType type;
  
  /// The widget that will receive the gesture.
  final Widget child;
  
  /// How to behave during hit testing.
  final HitTestBehavior? behavior;
  
  /// The function to call when the gesture is detected.
  final VoidCallback action;
  
  /// The types of input devices that can trigger this gesture.
  final Set<PointerDeviceKind>? supportedDevices;

  /// Creates an [OnGesture] widget for the specified gesture type.
  ///
  /// The [type] parameter specifies which gesture to detect.
  /// The [child] parameter is the widget that will receive the gesture.
  /// The [action] parameter is the function to call when the gesture is detected.
  ///
  /// The [behavior] parameter can be used to specify how the widget behaves
  /// during hit testing. The [supportedDevices] parameter can limit which
  /// input devices can trigger the gesture.
  const OnGesture(
      {super.key,
      required this.type,
      required this.child,
      this.behavior,
      this.supportedDevices,
      required this.action});

  /// Creates an [OnGesture] widget that detects primary taps/clicks.
  ///
  /// This is equivalent to a normal tap on mobile or left click on desktop.
  const OnGesture.press(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.press;

  /// Creates an [OnGesture] widget that detects secondary taps/clicks.
  ///
  /// This is equivalent to a right click on desktop.
  const OnGesture.secondaryPress(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.secondaryPress;

  /// Creates an [OnGesture] widget that detects tertiary taps/clicks.
  ///
  /// This is equivalent to a middle click on desktop.
  const OnGesture.tertiaryPress(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.tertiaryPress;

  /// Creates an [OnGesture] widget that detects long presses with the primary button.
  const OnGesture.longPress(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.longPress;

  /// Creates an [OnGesture] widget that detects long presses with the secondary button.
  ///
  /// This is equivalent to a long right click on desktop.
  const OnGesture.longSecondaryPress(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.longSecondaryPress;

  /// Creates an [OnGesture] widget that detects long presses with the tertiary button.
  ///
  /// This is equivalent to a long middle click on desktop.
  const OnGesture.longTertiaryPress(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.longTertiaryPress;

  /// Creates an [OnGesture] widget that detects double taps/clicks.
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

/// Extension methods for easily adding gesture detection to any widget.
///
/// These methods provide a more fluent API for adding gesture handlers to widgets,
/// making the code more readable and concise.
///
/// See also:
///  * [doc/component/gesture.md] for more detailed documentation
///  * [OnGesture], which these methods use internally
///  * [OnHover], which is used by the [onHover] method
extension XOnGestureWidget on Widget {
  /// Adds a handler for primary press/tap gestures (equivalent to onTap).
  ///
  /// Example:
  /// ```dart
  /// Text("Tap me").onPressed(() => print("Text was tapped"))
  /// ```
  Widget onPressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.press(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  /// Adds a handler for secondary press gestures (equivalent to right-click).
  ///
  /// Example:
  /// ```dart
  /// Text("Right-click me").onSecondaryPressed(() => print("Right clicked"))
  /// ```
  Widget onSecondaryPressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.secondaryPress(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  /// Adds a handler for tertiary press gestures (equivalent to middle-click).
  ///
  /// Example:
  /// ```dart
  /// Text("Middle-click me").onTertiaryPressed(() => print("Middle clicked"))
  /// ```
  Widget onTertiaryPressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.tertiaryPress(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  /// Adds a handler for long press gestures with the primary button.
  ///
  /// Example:
  /// ```dart
  /// Text("Long press me").onLongPressed(() => print("Long pressed"))
  /// ```
  Widget onLongPressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.longPress(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  /// Adds a handler for long press gestures with the secondary button.
  ///
  /// Example:
  /// ```dart
  /// Text("Long right-click me").onLongSecondaryPressed(() => print("Long right-clicked"))
  /// ```
  Widget onLongSecondaryPressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.longSecondaryPress(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  /// Adds a handler for long press gestures with the tertiary button.
  ///
  /// Example:
  /// ```dart
  /// Text("Long middle-click me").onLongTertiaryPressed(() => print("Long middle-clicked"))
  /// ```
  Widget onLongTertiaryPressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.longTertiaryPress(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  /// Adds a handler for double press/tap gestures.
  ///
  /// Example:
  /// ```dart
  /// Text("Double-tap me").onDoublePressed(() => print("Double-tapped"))
  /// ```
  Widget onDoublePressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.doublePress(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  /// Adds a handler for hover events.
  ///
  /// The [action] parameter is called with true when hover begins and false when it ends.
  ///
  /// Example:
  /// ```dart
  /// Text("Hover over me").onHover((isHovering) {
  ///   print(isHovering ? "Hovering" : "Not hovering");
  /// })
  /// ```
  Widget onHover(void Function(bool hovering) action) =>
      OnHover(action: action, child: this);
}

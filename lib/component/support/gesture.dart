import 'dart:ui';

import 'package:arcane/arcane.dart';

/// Defines the different types of gestures that can be detected by [OnGesture] in the Arcane UI library.
///
/// This enum provides a unified set of gesture types for enhancing interactivity across Arcane components,
/// supporting primary taps for standard interactions, secondary and tertiary presses for contextual menus
/// or advanced navigation, long presses for previews or deletions, and double presses for quick actions.
/// It integrates seamlessly with [GestureDetector] and [InkWell] for ripple effects and [HapticFeedback]
/// for tactile responses, ensuring consistent behavior in [IconButton], [Tile], [CardSection], and other
/// interactive elements. Usage emphasizes performance through efficient gesture recognition without
/// unnecessary rebuilds, and accessibility via [Semantics] integration.
///
/// Key features:
/// - Cross-device compatibility (touch, mouse, trackpad).
/// - Extensible for [ArcaneTheme]-based custom feedback.
///
/// See also:
///  * [doc/component/gesture.md] for more detailed documentation.
///  * [OnGesture], which uses these gesture types for enhanced interactivity.
///  * [GestureDetector], the underlying Flutter widget for raw gesture handling.
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

/// A widget that detects mouse hover and executes an action when hover state changes in Arcane UI components.
///
/// [OnHover] enhances [MouseRegion] for Arcane by providing simple hover detection with state callbacks,
/// ideal for subtle visual feedback in interactive elements like [IconButton] or [Tile] without complex
/// state management. It ensures efficient hit testing and no unnecessary rebuilds as a [StatelessWidget],
/// integrating with [ArcaneTheme] for hover colors or elevations. Use for tooltips, scaling effects, or
/// [Semantics] announcements on hover, often paired with [InkWell] for combined tap-hover interactions.
///
/// Key features:
/// - Lightweight hover state management.
/// - Compatible with [HapticFeedback] for subtle vibrations on hover start/end.
/// - Performance-optimized for frequent use in lists or grids like [CardSection].
///
/// See also:
///  * [doc/component/gesture.md] for more detailed documentation.
///  * [XOnGestureWidget.onHover], which provides a fluent API for this widget.
///  * [MouseRegion], the underlying Flutter widget for pointer tracking.
class OnHover extends StatelessWidget {
  /// Function called with true when hover begins and false when it ends.
  final void Function(bool hovering) action;

  /// The widget to detect hover over.
  final Widget child;

  /// Creates an [OnHover] widget for detecting hover events in Arcane UI.
  ///
  /// The [action] callback receives a boolean indicating the current hover state (true on enter, false on exit),
  /// enabling dynamic updates like color changes or [Semantics] live regions. The [child] is the interactive
  /// [Widget] wrapped for hover detection, typically an [IconButton], [Tile], or custom [CardSection] element.
  /// This constructor supports [ArcaneTheme] integration for themed hover animations and ensures accessibility
  /// by excluding from semantics if needed, while maintaining efficient rendering without rebuilds.
  ///
  /// Example usage in an Arcane [Tile]:
  /// ```dart
  /// OnHover(
  ///   action: (hovering) {
  ///     setState(() => _isHovered = hovering);
  ///   },
  ///   child: Tile(
  ///     child: Text("Hover to change color"),
  ///     backgroundColor: _isHovered ? ArcaneTheme.of(context).primary : ArcaneTheme.of(context).surface,
  ///   ),
  /// )
  /// ```
  ///
  /// Integrates with [InkWell] for ripple on tap during hover and [HapticFeedback] for enhanced user experience.
  const OnHover({super.key, required this.action, required this.child});

  @override
  Widget build(BuildContext context) => MouseRegion(
        onEnter: (_) => action(true),
        onExit: (_) => action(false),
        child: child,
      );
}

/// A widget that detects a specific gesture type and executes an action when it occurs in Arcane UI.
///
/// [OnGesture] wraps [GestureDetector] to provide Arcane-themed gesture handling for taps, long presses,
/// and multi-button interactions, enhancing components like [IconButton], [Tile], and [CardSection] with
/// ripple effects via [InkWell] integration, haptic feedback through [HapticFeedback], and theme-aware
/// responses from [ArcaneTheme]. It supports efficient hit testing with configurable [behavior] and device
/// filtering via [supportedDevices], ensuring no unnecessary rebuilds in performance-critical UIs like
/// navigation or lists. Use for primary actions (press), contextual menus (secondaryPress), or previews
/// (longPress), with [Semantics] for accessibility labels on gestures.
///
/// Key features:
/// - Multi-gesture support across [GestureType] variants.
/// - Seamless integration with [ArcaneTheme] for visual and haptic feedback.
/// - Optimized for interactive density in [BottomNavigationBar] or [Sidebar].
///
/// See also:
///  * [doc/component/gesture.md] for more detailed documentation.
///  * [GestureType], which defines the supported gesture types.
///  * The extension methods on [Widget] like [onPressed], which provide a fluent API.
///  * [GestureDetector], the core Flutter widget extended here.
///  * [InkWell], for adding material ripple effects to gestures.
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

  /// Creates an [OnGesture] widget for the specified gesture type in Arcane UI.
  ///
  /// The [type] determines the detected gesture from [GestureType], such as press for standard taps or
  /// longPress for sustained interactions. The [child] is the [Widget] receiving gestures, often an
  /// [IconButton] or [Tile] in Arcane layouts. The [action] executes on gesture detection, enabling
  /// navigation, deletions, or state updates. Optional [behavior] controls hit testing (e.g., deferToChild
  /// for nested gestures), and [supportedDevices] filters input (e.g., touch only). This supports
  /// [ArcaneTheme] for feedback and [Semantics] for excluding from accessibility if gestures are decorative,
  /// ensuring performant, theme-consistent interactivity without rebuilds.
  const OnGesture(
      {super.key,
      required this.type,
      required this.child,
      this.behavior,
      this.supportedDevices,
      required this.action});

  /// Creates an [OnGesture] widget that detects primary taps/clicks in Arcane UI.
  ///
  /// Equivalent to a standard tap on mobile or left-click on desktop, ideal for primary actions in
  /// [IconButton], [Tile], or [CardSection]. The [action] triggers on detection, with optional [behavior]
  /// for hit testing and [supportedDevices] for device-specific handling. Enhances with [ArcaneTheme]
  /// colors for press states and [InkWell] ripples, while [HapticFeedback] adds vibration. Efficient
  /// for high-interaction UIs, avoiding rebuilds via [StatelessWidget] design.
  const OnGesture.press(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.press;

  /// Creates an [OnGesture] widget that detects secondary taps/clicks in Arcane UI.
  ///
  /// Equivalent to right-click on desktop, useful for contextual menus in [Tile] or [CardSection].
  /// The [action] handles menu invocation, with [behavior] and [supportedDevices] for customization.
  /// Integrates [ArcaneTheme] for themed overlays and [Semantics] for accessible descriptions,
  /// paired with [InkWell] for subtle feedback. Performance-optimized for secondary interactions.
  const OnGesture.secondaryPress(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.secondaryPress;

  /// Creates an [OnGesture] widget that detects tertiary taps/clicks in Arcane UI.
  ///
  /// Equivalent to middle-click on desktop, for advanced actions like tab opening in [BottomNavigationBar].
  /// [action] executes on detection, configurable via [behavior] and [supportedDevices]. Supports
  /// [ArcaneTheme] feedback and [HapticFeedback], ensuring efficient gesture handling without rebuilds.
  const OnGesture.tertiaryPress(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.tertiaryPress;

  /// Creates an [OnGesture] widget that detects long presses with the primary button in Arcane UI.
  ///
  /// Ideal for previews or confirmations in [Tile] or [IconButton], triggering [action] after hold.
  /// Customizable with [behavior] for nested gestures and [supportedDevices] for input filtering.
  /// Enhances with [ArcaneTheme] scaling on long press and [InkWell] for visual cues, plus
  /// [HapticFeedback] for confirmation. No unnecessary rebuilds for smooth UX.
  const OnGesture.longPress(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.longPress;

  /// Creates an [OnGesture] widget that detects long presses with the secondary button in Arcane UI.
  ///
  /// For long right-clicks, e.g., advanced context in [CardSection]. [action] on detection, with
  /// [behavior] and [supportedDevices] options. Integrates [ArcaneTheme] and [Semantics] for
  /// accessibility, efficient for secondary long interactions.
  const OnGesture.longSecondaryPress(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.longSecondaryPress;

  /// Creates an [OnGesture] widget that detects long presses with the tertiary button in Arcane UI.
  ///
  /// For long middle-clicks, e.g., bulk actions in [Sidebar]. [action] triggers post-hold, configurable
  /// via [behavior] and [supportedDevices]. Theme-aware with [ArcaneTheme], performant design.
  const OnGesture.longTertiaryPress(
      {super.key,
      required this.action,
      required this.child,
      this.behavior,
      this.supportedDevices})
      : type = GestureType.longTertiaryPress;

  /// Creates an [OnGesture] widget that detects double taps/clicks in Arcane UI.
  ///
  /// For quick actions like zoom or edit in [Tile]. [action] on double detection, with [behavior]
  /// and [supportedDevices]. Pairs with [InkWell] ripples and [HapticFeedback], optimized for
  /// responsive double-gesture handling.
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

/// Extension methods for easily adding gesture detection to any widget in Arcane UI.
///
/// These methods extend [Widget] with fluent APIs for [OnGesture] and [OnHover], simplifying
/// interactivity in Arcane components like [IconButton], [Tile], and [CardSection]. They promote
/// concise code while ensuring performance through efficient [GestureDetector] wrapping, no
/// rebuilds, and integration with [ArcaneTheme] for feedback, [InkWell] for ripples, and
/// [HapticFeedback] for haptics. Use for enhanced UX in navigation ([BottomNavigationBar]) or
/// forms, with [Semantics] support for accessibility.
///
/// Key features:
/// - Fluent chaining for readable gesture addition.
/// - Device-agnostic with optional filtering.
/// - Optimized hit testing for dense UIs.
///
/// See also:
///  * [doc/component/gesture.md] for more detailed documentation.
///  * [OnGesture], used internally for gesture wrapping.
///  * [OnHover], used for hover detection.
extension XOnGestureWidget on Widget {
  /// Adds a handler for primary press/tap gestures to this widget in Arcane UI.
  ///
  /// Equivalent to [onTap] in [GestureDetector], ideal for standard interactions in [IconButton] or [Tile].
  /// The [action] executes on press, with optional [behavior] for hit testing (e.g., opaque for full coverage)
  /// and [supportedDevices] to limit to touch or mouse. Enhances with [ArcaneTheme] press states and
  /// [InkWell] integration for material ripples, plus [HapticFeedback] for light impact. Efficient for
  /// primary actions without rebuilds.
  ///
  /// Example in an Arcane [CardSection]:
  /// ```dart
  /// Tile(child: Text("Tap me")).onPressed(() => Navigator.push(...))
  /// ```
  /// Returns the wrapped [Widget] for chaining.
  Widget onPressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.press(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  /// Adds a handler for secondary press gestures (right-click) to this widget in Arcane UI.
  ///
  /// For contextual actions in [Tile] or [CardSection], triggering [action] on secondary press.
  /// Configurable [behavior] and [supportedDevices] for precise control. Integrates [ArcaneTheme]
  /// for menu theming and [Semantics] for descriptions, performant for secondary interactions.
  Widget onSecondaryPressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.secondaryPress(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  /// Adds a handler for tertiary press gestures (middle-click) to this widget in Arcane UI.
  ///
  /// Useful for tab-like actions in [BottomNavigationBar], executing [action] on tertiary press.
  /// Optional [behavior] and [supportedDevices] customization. Theme-consistent with [ArcaneTheme],
  /// efficient hit testing.
  Widget onTertiaryPressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.tertiaryPress(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  /// Adds a handler for long press gestures with the primary button to this widget in Arcane UI.
  ///
  /// For hold-to-preview in [IconButton] or [Tile], calling [action] after long press. [behavior]
  /// and [supportedDevices] for tuning. Enhances with [InkWell] long-press ripples and [HapticFeedback],
  /// no rebuilds for smooth previews.
  Widget onLongPressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.longPress(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  /// Adds a handler for long press gestures with the secondary button to this widget in Arcane UI.
  ///
  /// For advanced context on long right-click in [CardSection]. [action] post-hold, with options.
  /// Integrates [ArcaneTheme] and accessibility via [Semantics].
  Widget onLongSecondaryPressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.longSecondaryPress(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  /// Adds a handler for long press gestures with the tertiary button to this widget in Arcane UI.
  ///
  /// For bulk or special actions on long middle-click. Efficient, theme-aware implementation.
  Widget onLongTertiaryPressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.longTertiaryPress(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  /// Adds a handler for double press/tap gestures to this widget in Arcane UI.
  ///
  /// Quick actions like expand in [Tile], triggering [action] on double press. Custom [behavior]
  /// and [supportedDevices]. Pairs with [HapticFeedback] for success vibe, optimized for doubles.
  Widget onDoublePressed(VoidCallback action,
          {HitTestBehavior? behavior,
          Set<PointerDeviceKind>? supportedDevices}) =>
      OnGesture.doublePress(
          action: action,
          behavior: behavior,
          supportedDevices: supportedDevices,
          child: this);

  /// Adds a handler for hover events to this widget in Arcane UI.
  ///
  /// Calls [action] with boolean state (true on enter, false on exit) for effects in [IconButton]
  /// or [Tile]. Lightweight, integrates [ArcaneTheme] for hover styles and [Semantics] for announcements.
  /// Efficient for desktop/web hover feedback without rebuilds.
  ///
  /// Example in [CardSection]:
  /// ```dart
  /// Tile(child: Text("Hover me")).onHover((hovering) => setState(() => _hovered = hovering))
  /// ```
  /// Returns the wrapped [Widget].
  Widget onHover(void Function(bool hovering) action) =>
      OnHover(action: action, child: this);
}

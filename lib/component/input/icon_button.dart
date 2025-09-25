import 'package:arcane/arcane.dart';

/// A customizable button with an icon as its primary content.
///
/// [IconButton] provides a variety of styles, shapes, and behaviors to match
/// your application's design needs. It offers multiple variants like primary,
/// secondary, outline, ghost, link, text, and destructive styles, along with
/// customizable sizing and interaction handling.
///
/// See also:
///  * [doc/component/icon_button.md] for more detailed documentation
class IconButton extends StatelessWidget {
  /// The icon to display in the button.
  final Widget icon;

  /// Function to call when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is enabled.
  final bool? enabled;

  /// Widget to display before the icon.
  final Widget? leading;

  /// Widget to display after the icon.
  final Widget? trailing;

  /// Alignment of the button content.
  final AlignmentGeometry? alignment;

  /// Size of the button (small, normal, large).
  final ButtonSize size;

  /// Density/padding of the button.
  final ButtonDensity density;

  /// Shape of the button (rectangle, rounded, circle).
  final ButtonShape shape;

  /// Focus node for controlling button focus.
  final FocusNode? focusNode;

  /// Whether to disable transition animations.
  final bool disableTransition;

  /// Function called when hover state changes.
  final ValueChanged<bool>? onHover;

  /// Function called when focus state changes.
  final ValueChanged<bool>? onFocus;

  /// Whether the trailing widget should expand.
  final bool trailingExpanded;

  /// Whether to enable tap feedback.
  final bool? enableFeedback;

  /// Called when a pointer that might cause a tap has contacted the screen.
  final GestureTapDownCallback? onTapDown;

  /// Called when a pointer that triggered a tap has stopped contacting the screen.
  final GestureTapUpCallback? onTapUp;

  /// Called when a tap has been canceled.
  final GestureTapCancelCallback? onTapCancel;

  /// Called when a secondary pointer that might cause a tap has contacted the screen.
  final GestureTapDownCallback? onSecondaryTapDown;

  /// Called when a secondary pointer that triggered a tap has stopped contacting the screen.
  final GestureTapUpCallback? onSecondaryTapUp;

  /// Called when a secondary tap has been canceled.
  final GestureTapCancelCallback? onSecondaryTapCancel;

  /// Called when a tertiary pointer that might cause a tap has contacted the screen.
  final GestureTapDownCallback? onTertiaryTapDown;

  /// Called when a tertiary pointer that triggered a tap has stopped contacting the screen.
  final GestureTapUpCallback? onTertiaryTapUp;

  /// Called when a tertiary tap has been canceled.
  final GestureTapCancelCallback? onTertiaryTapCancel;

  /// Called when a long press gesture has started.
  final GestureLongPressStartCallback? onLongPressStart;

  /// Called when a long press gesture is ended.
  final GestureLongPressUpCallback? onLongPressUp;

  /// Called when a long press drag moves.
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;

  /// Called when a long press gesture is completed.
  final GestureLongPressEndCallback? onLongPressEnd;

  /// Called when a secondary long press gesture is ended.
  final GestureLongPressUpCallback? onSecondaryLongPress;

  /// Called when a tertiary long press gesture is ended.
  final GestureLongPressUpCallback? onTertiaryLongPress;

  /// The style variant of the button.
  final AbstractButtonStyle variance;

  /// Creates an [IconButton] with customizable properties.
  ///
  /// The [icon] parameter is required and specifies the icon to display.
  /// By default, the button uses a ghost style with normal size and icon density.
  ///
  /// Example:
  /// ```dart
  /// IconButton(
  ///   icon: Icon(Icons.favorite),
  ///   onPressed: () => print("Favorite button pressed"),
  /// )
  /// ```
  const IconButton({
    super.key,
    required this.icon,
    this.variance = ButtonVariance.ghost,
    this.onPressed,
    this.enabled,
    this.leading,
    this.trailing,
    this.alignment,
    this.size = ButtonSize.normal,
    this.density = ButtonDensity.icon,
    this.shape = ButtonShape.rectangle,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
    this.trailingExpanded = false,
    this.enableFeedback,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onTertiaryTapDown,
    this.onTertiaryTapUp,
    this.onTertiaryTapCancel,
    this.onLongPressStart,
    this.onLongPressUp,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.onSecondaryLongPress,
    this.onTertiaryLongPress,
  });

  /// Creates a primary colored [IconButton].
  ///
  /// The primary style is used for the main action style, using the primary color.
  ///
  /// Example:
  /// ```dart
  /// IconButton.primary(
  ///   icon: Icon(Icons.save),
  ///   onPressed: () => saveData(),
  /// )
  /// ```
  const IconButton.primary({
    super.key,
    required this.icon,
    this.onPressed,
    this.enabled,
    this.leading,
    this.trailing,
    this.alignment,
    this.size = ButtonSize.normal,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
    this.trailingExpanded = false,
    this.enableFeedback,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onTertiaryTapDown,
    this.onTertiaryTapUp,
    this.onTertiaryTapCancel,
    this.onLongPressStart,
    this.onLongPressUp,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.onSecondaryLongPress,
    this.onTertiaryLongPress,
    this.variance = ButtonVariance.primary,
    this.density = ButtonDensity.icon,
    this.shape = ButtonShape.rectangle,
  });

  /// Creates a secondary colored [IconButton].
  ///
  /// The secondary style provides a less emphasized action style.
  ///
  /// Example:
  /// ```dart
  /// IconButton.secondary(
  ///   icon: Icon(Icons.refresh),
  ///   onPressed: () => refreshData(),
  /// )
  /// ```
  const IconButton.secondary({
    super.key,
    required this.icon,
    this.onPressed,
    this.enabled,
    this.leading,
    this.trailing,
    this.alignment,
    this.size = ButtonSize.normal,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
    this.trailingExpanded = false,
    this.enableFeedback,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onTertiaryTapDown,
    this.onTertiaryTapUp,
    this.onTertiaryTapCancel,
    this.onLongPressStart,
    this.onLongPressUp,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.onSecondaryLongPress,
    this.onTertiaryLongPress,
    this.variance = ButtonVariance.secondary,
    this.density = ButtonDensity.icon,
    this.shape = ButtonShape.rectangle,
  });

  /// Creates an outlined [IconButton].
  ///
  /// The outline style provides a button with an outline/border.
  ///
  /// Example:
  /// ```dart
  /// IconButton.outline(
  ///   icon: Icon(Icons.share),
  ///   onPressed: () => shareContent(),
  /// )
  /// ```
  const IconButton.outline({
    super.key,
    required this.icon,
    this.onPressed,
    this.enabled,
    this.leading,
    this.trailing,
    this.alignment,
    this.size = ButtonSize.normal,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
    this.trailingExpanded = false,
    this.enableFeedback,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onTertiaryTapDown,
    this.onTertiaryTapUp,
    this.onTertiaryTapCancel,
    this.onLongPressStart,
    this.onLongPressUp,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.onSecondaryLongPress,
    this.onTertiaryLongPress,
    this.variance = ButtonVariance.outline,
    this.density = ButtonDensity.icon,
    this.shape = ButtonShape.rectangle,
  });

  /// Creates a ghost-styled [IconButton].
  ///
  /// The ghost style provides a minimal button with no background until hovered.
  /// This style is often used for toolbar buttons or actions in cards.
  ///
  /// Example:
  /// ```dart
  /// IconButton.ghost(
  ///   icon: Icon(Icons.more_vert),
  ///   onPressed: () => showMenu(),
  /// )
  /// ```
  const IconButton.ghost({
    super.key,
    required this.icon,
    this.onPressed,
    this.enabled,
    this.leading,
    this.trailing,
    this.alignment,
    this.size = ButtonSize.normal,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
    this.trailingExpanded = false,
    this.enableFeedback,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onTertiaryTapDown,
    this.onTertiaryTapUp,
    this.onTertiaryTapCancel,
    this.onLongPressStart,
    this.onLongPressUp,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.onSecondaryLongPress,
    this.onTertiaryLongPress,
    this.variance = ButtonVariance.ghost,
    this.density = ButtonDensity.icon,
    this.shape = ButtonShape.rectangle,
  });

  /// Creates a link-styled [IconButton].
  ///
  /// The link style resembles a hyperlink.
  ///
  /// Example:
  /// ```dart
  /// IconButton.link(
  ///   icon: Icon(Icons.open_in_new),
  ///   onPressed: () => openLink(),
  /// )
  /// ```
  const IconButton.link({
    super.key,
    required this.icon,
    this.onPressed,
    this.enabled,
    this.leading,
    this.trailing,
    this.alignment,
    this.size = ButtonSize.normal,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
    this.trailingExpanded = false,
    this.enableFeedback,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onTertiaryTapDown,
    this.onTertiaryTapUp,
    this.onTertiaryTapCancel,
    this.onLongPressStart,
    this.onLongPressUp,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.onSecondaryLongPress,
    this.onTertiaryLongPress,
    this.variance = ButtonVariance.link,
    this.density = ButtonDensity.icon,
    this.shape = ButtonShape.rectangle,
  });

  /// Creates a text-styled [IconButton].
  ///
  /// The text style provides minimal styling, similar to plain text.
  ///
  /// Example:
  /// ```dart
  /// IconButton.text(
  ///   icon: Icon(Icons.info),
  ///   onPressed: () => showInfo(),
  /// )
  /// ```
  const IconButton.text({
    super.key,
    required this.icon,
    this.onPressed,
    this.enabled,
    this.leading,
    this.trailing,
    this.alignment,
    this.size = ButtonSize.normal,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
    this.trailingExpanded = false,
    this.enableFeedback,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onTertiaryTapDown,
    this.onTertiaryTapUp,
    this.onTertiaryTapCancel,
    this.onLongPressStart,
    this.onLongPressUp,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.onSecondaryLongPress,
    this.onTertiaryLongPress,
    this.variance = ButtonVariance.text,
    this.density = ButtonDensity.icon,
    this.shape = ButtonShape.rectangle,
  });

  /// Creates a destructive [IconButton].
  ///
  /// The destructive style is designed for actions that delete or can't be undone.
  ///
  /// Example:
  /// ```dart
  /// IconButton.destructive(
  ///   icon: Icon(Icons.delete),
  ///   onPressed: () => deleteItem(),
  /// )
  /// ```
  const IconButton.destructive({
    super.key,
    required this.icon,
    this.onPressed,
    this.enabled,
    this.leading,
    this.trailing,
    this.alignment,
    this.size = ButtonSize.normal,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
    this.trailingExpanded = false,
    this.enableFeedback,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onTertiaryTapDown,
    this.onTertiaryTapUp,
    this.onTertiaryTapCancel,
    this.onLongPressStart,
    this.onLongPressUp,
    this.onLongPressMoveUpdate,
    this.onLongPressEnd,
    this.onSecondaryLongPress,
    this.onTertiaryLongPress,
    this.variance = ButtonVariance.destructive,
    this.density = ButtonDensity.icon,
    this.shape = ButtonShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      enabled: enabled,
      leading: leading,
      trailing: trailing,
      alignment: alignment,
      style: ButtonStyle(
        variance: variance,
        size: size,
        density: density,
        shape: shape,
      ),
      focusNode: focusNode,
      disableTransition: disableTransition,
      onHover: onHover,
      onFocus: onFocus,
      // trailingExpanded: trailingExpanded,
      enableFeedback: enableFeedback,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onSecondaryTapDown: onSecondaryTapDown,
      onSecondaryTapUp: onSecondaryTapUp,
      onSecondaryTapCancel: onSecondaryTapCancel,
      onTertiaryTapDown: onTertiaryTapDown,
      onTertiaryTapUp: onTertiaryTapUp,
      onTertiaryTapCancel: onTertiaryTapCancel,
      onLongPressStart: onLongPressStart,
      onLongPressUp: onLongPressUp,
      onLongPressMoveUpdate: onLongPressMoveUpdate,
      onLongPressEnd: onLongPressEnd,
      onSecondaryLongPress: onSecondaryLongPress,
      onTertiaryLongPress: onTertiaryLongPress,
      child: icon,
    );
  }
}

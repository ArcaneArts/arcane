import 'package:arcane/arcane.dart';

class IconButtonMenu extends StatelessWidget {
  final IconData icon;
  final List<MenuItem> items;

  const IconButtonMenu({super.key, required this.icon, required this.items});

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: IconButton(
          onPressed: () => showDropdown(
              context: context,
              builder: (context) => DropdownMenu(
                    children: items,
                  )),
          icon: Icon(icon),
        ),
      );
}

class OutlineButtonMenu extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool? enabled;
  final Widget? leading;
  final Widget? trailing;
  final AlignmentGeometry? alignment;
  final ButtonSize size;
  final ButtonDensity density;
  final ButtonShape shape;
  final FocusNode? focusNode;
  final bool disableTransition;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocus;
  final bool? enableFeedback;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final GestureTapDownCallback? onSecondaryTapDown;
  final GestureTapUpCallback? onSecondaryTapUp;
  final GestureTapCancelCallback? onSecondaryTapCancel;
  final GestureTapDownCallback? onTertiaryTapDown;
  final GestureTapUpCallback? onTertiaryTapUp;
  final GestureTapCancelCallback? onTertiaryTapCancel;
  final GestureLongPressStartCallback? onLongPressStart;
  final GestureLongPressUpCallback? onLongPressUp;
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;
  final GestureLongPressEndCallback? onLongPressEnd;
  final GestureLongPressUpCallback? onSecondaryLongPress;
  final GestureLongPressUpCallback? onTertiaryLongPress;
  final List<MenuItem> menu;

  const OutlineButtonMenu({
    super.key,
    this.menu = const [],
    required this.child,
    this.onPressed,
    this.enabled,
    this.leading,
    this.trailing,
    this.alignment,
    this.size = ButtonSize.normal,
    this.density = ButtonDensity.normal,
    this.shape = ButtonShape.rectangle,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
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

  @override
  Widget build(BuildContext context) => OutlineButton(
        trailing: trailing,
        leading: leading,
        key: key,
        onPressed: () => showDropdown(
            context: context,
            builder: (context) => DropdownMenu(
                  children: menu,
                )),
        alignment: alignment,
        size: size,
        enabled: enabled,
        focusNode: focusNode,
        density: density,
        disableTransition: disableTransition,
        enableFeedback: enableFeedback,
        onFocus: onFocus,
        onHover: onHover,
        onLongPressEnd: onLongPressEnd,
        onLongPressMoveUpdate: onLongPressMoveUpdate,
        onLongPressStart: onLongPressStart,
        onLongPressUp: onLongPressUp,
        onSecondaryLongPress: onSecondaryLongPress,
        onSecondaryTapCancel: onSecondaryTapCancel,
        onSecondaryTapDown: onSecondaryTapDown,
        onSecondaryTapUp: onSecondaryTapUp,
        onTapCancel: onTapCancel,
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTertiaryLongPress: onTertiaryLongPress,
        onTertiaryTapCancel: onTertiaryTapCancel,
        onTertiaryTapDown: onTertiaryTapDown,
        onTertiaryTapUp: onTertiaryTapUp,
        shape: shape,
        child: child,
      );
}

class TextButtonMenu extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool? enabled;
  final Widget? leading;
  final Widget? trailing;
  final AlignmentGeometry? alignment;
  final ButtonSize size;
  final ButtonDensity density;
  final ButtonShape shape;
  final FocusNode? focusNode;
  final bool disableTransition;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocus;
  final bool? enableFeedback;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final GestureTapDownCallback? onSecondaryTapDown;
  final GestureTapUpCallback? onSecondaryTapUp;
  final GestureTapCancelCallback? onSecondaryTapCancel;
  final GestureTapDownCallback? onTertiaryTapDown;
  final GestureTapUpCallback? onTertiaryTapUp;
  final GestureTapCancelCallback? onTertiaryTapCancel;
  final GestureLongPressStartCallback? onLongPressStart;
  final GestureLongPressUpCallback? onLongPressUp;
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;
  final GestureLongPressEndCallback? onLongPressEnd;
  final GestureLongPressUpCallback? onSecondaryLongPress;
  final GestureLongPressUpCallback? onTertiaryLongPress;
  final List<MenuItem> menu;

  const TextButtonMenu({
    super.key,
    this.menu = const [],
    required this.child,
    this.onPressed,
    this.enabled,
    this.leading,
    this.trailing,
    this.alignment,
    this.size = ButtonSize.normal,
    this.density = ButtonDensity.normal,
    this.shape = ButtonShape.rectangle,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
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

  @override
  Widget build(BuildContext context) => TextButton(
        trailing: trailing,
        leading: leading,
        key: key,
        onPressed: () => showDropdown(
            context: context,
            builder: (context) => DropdownMenu(
                  children: menu,
                )),
        alignment: alignment,
        size: size,
        enabled: enabled,
        focusNode: focusNode,
        density: density,
        disableTransition: disableTransition,
        enableFeedback: enableFeedback,
        onFocus: onFocus,
        onHover: onHover,
        onLongPressEnd: onLongPressEnd,
        onLongPressMoveUpdate: onLongPressMoveUpdate,
        onLongPressStart: onLongPressStart,
        onLongPressUp: onLongPressUp,
        onSecondaryLongPress: onSecondaryLongPress,
        onSecondaryTapCancel: onSecondaryTapCancel,
        onSecondaryTapDown: onSecondaryTapDown,
        onSecondaryTapUp: onSecondaryTapUp,
        onTapCancel: onTapCancel,
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTertiaryLongPress: onTertiaryLongPress,
        onTertiaryTapCancel: onTertiaryTapCancel,
        onTertiaryTapDown: onTertiaryTapDown,
        onTertiaryTapUp: onTertiaryTapUp,
        shape: shape,
        child: child,
      );
}

class SecondaryButtonMenu extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool? enabled;
  final Widget? leading;
  final Widget? trailing;
  final AlignmentGeometry? alignment;
  final ButtonSize size;
  final ButtonDensity density;
  final ButtonShape shape;
  final FocusNode? focusNode;
  final bool disableTransition;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocus;
  final bool? enableFeedback;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final GestureTapDownCallback? onSecondaryTapDown;
  final GestureTapUpCallback? onSecondaryTapUp;
  final GestureTapCancelCallback? onSecondaryTapCancel;
  final GestureTapDownCallback? onTertiaryTapDown;
  final GestureTapUpCallback? onTertiaryTapUp;
  final GestureTapCancelCallback? onTertiaryTapCancel;
  final GestureLongPressStartCallback? onLongPressStart;
  final GestureLongPressUpCallback? onLongPressUp;
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;
  final GestureLongPressEndCallback? onLongPressEnd;
  final GestureLongPressUpCallback? onSecondaryLongPress;
  final GestureLongPressUpCallback? onTertiaryLongPress;
  final List<MenuItem> menu;

  const SecondaryButtonMenu({
    super.key,
    this.menu = const [],
    required this.child,
    this.onPressed,
    this.enabled,
    this.leading,
    this.trailing,
    this.alignment,
    this.size = ButtonSize.normal,
    this.density = ButtonDensity.normal,
    this.shape = ButtonShape.rectangle,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
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

  @override
  Widget build(BuildContext context) => SecondaryButton(
        trailing: trailing,
        leading: leading,
        key: key,
        onPressed: () => showDropdown(
            context: context,
            builder: (context) => DropdownMenu(
                  children: menu,
                )),
        alignment: alignment,
        size: size,
        enabled: enabled,
        focusNode: focusNode,
        density: density,
        disableTransition: disableTransition,
        enableFeedback: enableFeedback,
        onFocus: onFocus,
        onHover: onHover,
        onLongPressEnd: onLongPressEnd,
        onLongPressMoveUpdate: onLongPressMoveUpdate,
        onLongPressStart: onLongPressStart,
        onLongPressUp: onLongPressUp,
        onSecondaryLongPress: onSecondaryLongPress,
        onSecondaryTapCancel: onSecondaryTapCancel,
        onSecondaryTapDown: onSecondaryTapDown,
        onSecondaryTapUp: onSecondaryTapUp,
        onTapCancel: onTapCancel,
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTertiaryLongPress: onTertiaryLongPress,
        onTertiaryTapCancel: onTertiaryTapCancel,
        onTertiaryTapDown: onTertiaryTapDown,
        onTertiaryTapUp: onTertiaryTapUp,
        shape: shape,
        child: child,
      );
}

class PrimaryButtonMenu extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool? enabled;
  final Widget? leading;
  final Widget? trailing;
  final AlignmentGeometry? alignment;
  final ButtonSize size;
  final ButtonDensity density;
  final ButtonShape shape;
  final FocusNode? focusNode;
  final bool disableTransition;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocus;
  final bool? enableFeedback;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final GestureTapDownCallback? onSecondaryTapDown;
  final GestureTapUpCallback? onSecondaryTapUp;
  final GestureTapCancelCallback? onSecondaryTapCancel;
  final GestureTapDownCallback? onTertiaryTapDown;
  final GestureTapUpCallback? onTertiaryTapUp;
  final GestureTapCancelCallback? onTertiaryTapCancel;
  final GestureLongPressStartCallback? onLongPressStart;
  final GestureLongPressUpCallback? onLongPressUp;
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;
  final GestureLongPressEndCallback? onLongPressEnd;
  final GestureLongPressUpCallback? onSecondaryLongPress;
  final GestureLongPressUpCallback? onTertiaryLongPress;
  final List<MenuItem> menu;

  const PrimaryButtonMenu({
    super.key,
    this.menu = const [],
    required this.child,
    this.onPressed,
    this.enabled,
    this.leading,
    this.trailing,
    this.alignment,
    this.size = ButtonSize.normal,
    this.density = ButtonDensity.normal,
    this.shape = ButtonShape.rectangle,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
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

  @override
  Widget build(BuildContext context) => PrimaryButton(
        trailing: trailing,
        leading: leading,
        key: key,
        onPressed: () => showDropdown(
            context: context,
            builder: (context) => DropdownMenu(
                  children: menu,
                )),
        alignment: alignment,
        size: size,
        enabled: enabled,
        focusNode: focusNode,
        density: density,
        disableTransition: disableTransition,
        enableFeedback: enableFeedback,
        onFocus: onFocus,
        onHover: onHover,
        onLongPressEnd: onLongPressEnd,
        onLongPressMoveUpdate: onLongPressMoveUpdate,
        onLongPressStart: onLongPressStart,
        onLongPressUp: onLongPressUp,
        onSecondaryLongPress: onSecondaryLongPress,
        onSecondaryTapCancel: onSecondaryTapCancel,
        onSecondaryTapDown: onSecondaryTapDown,
        onSecondaryTapUp: onSecondaryTapUp,
        onTapCancel: onTapCancel,
        onTapDown: onTapDown,
        onTapUp: onTapUp,
        onTertiaryLongPress: onTertiaryLongPress,
        onTertiaryTapCancel: onTertiaryTapCancel,
        onTertiaryTapDown: onTertiaryTapDown,
        onTertiaryTapUp: onTertiaryTapUp,
        shape: shape,
        child: child,
      );
}

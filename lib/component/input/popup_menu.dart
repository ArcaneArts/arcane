import 'package:arcane/arcane.dart';
import 'package:arcane/generated/arcane_shadcn/src/components/menu/dropdown_menu.dart';

/// A compact [IconButton] wrapper that triggers a dropdown menu for item selection when tapped,
/// ideal for space-constrained input interfaces requiring quick access to options like sorting or filtering.
/// This widget combines [IconButton] with [GestureDetector] for robust tap handling and displays a [DropdownMenu]
/// populated with [MenuItem]s using [showDropdown], integrating seamlessly with other input components
/// such as [MutableText] for dynamic labels or [CycleButton] for related controls in forms.
class IconButtonMenu extends StatelessWidget {
  final IconData icon;
  final List<MenuItem> items;

  /// The list of selectable [MenuItem]s that populate the [DropdownMenu] displayed on button press,
  /// allowing customization of options like actions or choices; defaults to an empty list for safe initialization
  /// without requiring explicit null checks, integrating with [showDropdown] for contextual menus in inputs.
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

/// An [OutlineButton] variant that opens a dropdown menu on activation,
/// suitable for secondary actions in input forms where a bordered button provides clear menu access,
/// such as selecting input modes or validation rules; it extends [OutlineButton] functionality
/// while overriding the press handler to display a [DropdownMenu] with [MenuItem]s via [showDropdown],
/// and integrates with [FieldWrapper] or [ArcaneField] for contextual menus in form inputs.
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

  /// Configurable collection of [MenuItem]s defining the dropdown options for the [OutlineButton],
  /// enabling dynamic menu content such as edit or delete actions; uses an empty default list to handle null safety,
  /// ensuring the menu displays only when items are provided, and works with [DropdownMenu] via [showDropdown].
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

/// A [TextButton] extension that reveals a dropdown menu upon pressing,
/// perfect for subtle input actions like option selection in text-heavy interfaces or [MutableText]-integrated forms;
/// it builds on [TextButton] with menu support, using [showDropdown] to present [DropdownMenu] items,
/// and supports integration with [Popover] or [Tooltip] for enhanced user guidance in complex inputs.
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

  /// Builds a [TextButtonMenu] requiring a child and optional menu (defaults to empty),
  /// configuring text button properties and gesture handlers while setting onPressed to display the menu via [showDropdown];
  /// example usage: `TextButtonMenu(child: Text('More'), menu: [MenuItem(label: 'Copy', onTap: copyText), MenuItem(label: 'Paste', onTap: pasteText)], alignment: Alignment.centerLeft)`,
  /// useful for menu options in [Dialog] or [ArcaneField] contexts.
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

/// A secondary-style [SecondaryButton] that launches a menu for user choices,
/// designed for less prominent input actions like toggling visibility or mode selection in [Selector] or [Search] components;
/// leverages [SecondaryButton] base with [DropdownMenu] integration via [showDropdown] for [MenuItem] handling,
/// supporting null safety in optional params and forwarding to [ArcaneTheme] for consistent styling.
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

  /// Instantiates a [SecondaryButtonMenu] with essential child and menu params (menu defaults empty),
  /// plus extensive [SecondaryButton] options for customization; onPressed is adapted to show the [DropdownMenu],
  /// with null-safe handling via ?? defaults where applicable—usage: `SecondaryButtonMenu(child: Text('Settings'), menu: settingsItems, density: ButtonDensity.compact)`,
  /// ideal for secondary menus in [BottomNavigationBar] or [Sidebar] navigation.
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

/// A primary [PrimaryButton] enhanced with menu capabilities for key input decisions,
/// such as confirming selections in [RadioCards] or initiating actions in [Fab]-linked flows;
/// it utilizes [PrimaryButton] styling and gestures, redirecting presses to [showDropdown] for [DropdownMenu]
/// with [MenuItem]s, ensuring prominent menu access while maintaining [ArcaneTheme] consistency.
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

  /// Forms a [PrimaryButtonMenu] centered on a child widget and menu list (empty by default),
  /// incorporating full [PrimaryButton] configuration for size, shape, and interactions;
  /// the constructor initializes menu display on press using [showDropdown], with safe null handling—example:
  /// `PrimaryButtonMenu(child: Text('Actions'), menu: actionItems, shape: ButtonShape.rounded, onHover: handleHover)`,
  /// suited for primary menu triggers in [Dialog] or [Sheet] overlays.
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

/// A subtle [GhostButton] that unveils a dropdown menu, optimized for ghosted input controls
/// like optional enhancers in [IconButton] or [MutableText] setups, where minimal visual impact is desired;
/// based on [GhostButton], it adapts onPressed to invoke [showDropdown] for [DropdownMenu] with [MenuItem]s,
/// facilitating lightweight menu interactions in [Tooltip] or [Popover]-augmented UIs.
class GhostButtonMenu extends StatelessWidget {
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

  /// Specifies the [MenuItem] options for the [GhostButton]'s subtle dropdown, with null-safe empty default,
  /// configuring the [DropdownMenu] for display via [showDropdown], suited for low-profile menus in [IconButton] or [Tooltip] contexts.
  const GhostButtonMenu({
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
  Widget build(BuildContext context) => GhostButton(
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

import 'package:arcane/arcane.dart';
import 'package:arcane/generated/arcane_shadcn/src/components/menu/dropdown_menu.dart';
import 'package:arcane/generated/arcane_shadcn/src/components/overlay/popover.dart';

/// A container that positions a Floating Action Button in the bottom-right corner of its parent.
///
/// [FabSocket] serves as a convenient wrapper for positioning FAB components
/// (like [Fab], [FabMenu], or [FabGroup]) within a layout, ensuring they appear
/// in the standard bottom-right location with appropriate padding.
///
/// See also:
///  * [doc/component/fab.md] for more detailed documentation
///  * [Fab], which is typically used as a child of this component
///  * [FabMenu] and [FabGroup], which provide more specialized FAB functionality
class FabSocket extends StatelessWidget {
  /// The FAB component to be positioned in the socket.
  ///
  /// This is typically a [Fab], [FabMenu], or [FabGroup] widget.
  final Widget child;

  /// Creates a [FabSocket] widget.
  ///
  /// The [child] parameter is required and specifies the FAB component to position.
  ///
  /// Example:
  /// ```dart
  /// FabSocket(
  ///   child: Fab(
  ///     child: Icon(Icons.add),
  ///     onPressed: () => print("FAB pressed"),
  ///   ),
  /// )
  /// ```
  const FabSocket({super.key, required this.child});

  /// Positions the [child] FAB in the bottom-right corner of the parent widget
  /// using [Align] for alignment and [PaddingAll] for 8-pixel padding on all sides,
  /// providing a standard socket for components like [Fab], [FabMenu], or [FabGroup]
  /// without additional layout complexity.
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.bottomRight,
        child: PaddingAll(
          padding: 8,
          child: child,
        ),
      );
}

/// A basic floating action button with built-in styling.
///
/// [Fab] provides a pre-styled floating action button with a modern appearance,
/// including blur effects. It automatically styles text and icon children to ensure
/// they are appropriately sized.
///
/// If a [leading] widget is provided, on small screens (width < [threshold], default 350),
/// the leading icon is shown as the button content, and the main [child] is displayed
/// in a tooltip when hovering or long-pressing the button.
///
/// If [menu] is non-empty, pressing the button shows a dropdown menu, overriding [onPressed].
///
/// See also:
///  * [doc/component/fab.md] for more detailed documentation
///  * [FabMenu], which extends this component with dropdown menu functionality
///  * [FabGroup], which extends this component with button group functionality
///  * [FabSocket], which can be used to position this component
class Fab extends StatelessWidget {
  /// The content of the button.
  ///
  /// This is typically an icon or text. Text will automatically be styled with
  /// large text, and icons will be automatically enlarged.
  final Widget child;

  /// Optional widget to display before the main content.
  final Widget? leading;

  /// Callback invoked when the button is pressed.
  ///
  /// This function is executed when the user taps the button. If the [menu]
  /// parameter is provided and contains items, the [onPressed] callback is
  /// overridden, and a [DropdownMenu] is displayed instead using [showDropdown].
  /// For standard button behavior without a menu, provide a simple action like
  /// navigating to a new screen or triggering a dialog.
  final VoidCallback? onPressed;

  /// The screen width threshold (in logical pixels) below which the leading
  /// icon is hidden and displayed in a tooltip instead.
  ///
  /// When the screen width is less than this threshold and a [leading] icon
  /// is provided, the button will show only the leading icon, with the main
  /// [child] content available via tooltip.
  ///
  /// Defaults to 350.
  final double threshold;

  /// Optional list of menu items to display in a dropdown when the button is pressed.
  ///
  /// If this list is non-empty, pressing the button will show a dropdown menu with these items,
  /// overriding the [onPressed] callback. If empty, the [onPressed] callback is used as normal.
  final List<MenuItem> menu;

  /// Creates a [Fab] widget.
  ///
  /// The [child] parameter is required and specifies the content of the button.
  /// The [onPressed] parameter is optional and specifies the callback when the button is pressed.
  ///
  /// Example:
  /// ```dart
  /// Fab(
  ///   child: Icon(Icons.add),
  ///   onPressed: () => print("FAB pressed"),
  /// )
  /// ```
  const Fab({
    super.key,
    required this.child,
    this.leading,
    this.onPressed,
    this.threshold = 350,
    this.menu = const [],
  });

  /// Builds the [Fab] widget, applying responsive layout logic based on screen width
  /// and menu configuration while integrating with [Glass] for blur effects, [Card]
  /// for surface styling, [GhostButton] for interactive behavior, and [Tooltip] for
  /// content display on small screens.
  ///
  /// Determines the effective press handler: if [menu] is non-empty, shows a [DropdownMenu]
  /// via [showDropdown]; otherwise, invokes [onPressed]. On screens narrower than [threshold]
  /// with a [leading] icon, displays only the leading icon and uses [Tooltip] to reveal the
  /// main [child] on hover or long press. Automatically styles [child] if it's a [Text] or [Icon]
  /// using extension methods like [large()]. Applies [blurIn] animation for visual enhancement.
  @override
  Widget build(BuildContext context) {
    VoidCallback? effectiveOnPressed;
    if (menu.isNotEmpty) {
      effectiveOnPressed = () => showDropdown(
            context: context,
            builder: (context) => DropdownMenu(children: menu),
          );
    } else {
      effectiveOnPressed = onPressed;
    }

    double width = MediaQuery.of(context).size.width;
    if (leading == null || width >= threshold) {
      return PaddingAll(
        padding: 8,
        child: Glass(
          ignoreContextSignals: true,
          child: Card(
            surfaceOpacity: 0,
            surfaceBlur: 0,
            padding: EdgeInsets.zero,
            child: GhostButton(
              density: ButtonDensity.iconComfortable,
              leading: leading,
              onPressed: effectiveOnPressed,
              child: child is Text
                  ? (child as Text).large()
                  : child is Icon
                      ? (child as Icon).large()
                      : child,
            ),
          ),
        ),
      ).blurIn;
    } else {
      return Tooltip(
        child: Fab(
          onPressed: effectiveOnPressed,
          threshold: threshold,
          menu: menu,
          child: leading!,
        ),
        tooltip: (context) => child,
      );
    }
  }
}

/// A floating action button that displays a group of related buttons when pressed.
///
/// [FabGroup] expands to show multiple buttons when activated, allowing you to provide
/// several related actions in a compact interface. The child buttons can be arranged
/// either horizontally or vertically.
///
/// See also:
///  * [doc/component/fab.md] for more detailed documentation
///  * [Fab], which provides the basic floating action button functionality
///  * [FabSocket], which can be used to position this component
class FabGroup extends StatelessWidget {
  /// The content of the main button.
  final Widget child;

  /// Optional widget to display before the main content.
  final Widget? leading;

  /// Function that returns the list of buttons to display when opened.
  ///
  /// This function should return a list of widgets (typically [Fab] widgets)
  /// that will be shown when the main button is pressed.
  final List<Widget> Function(BuildContext) children;

  /// Whether to display the child buttons horizontally.
  ///
  /// If true, buttons are arranged in a horizontal row.
  /// If false (default), buttons are arranged in a vertical column.
  final bool horizontal;

  /// Creates a [FabGroup] widget.
  ///
  /// The [child] parameter is required and specifies the content of the main button.
  /// The [children] parameter is required and provides the buttons to display when opened.
  ///
  /// Example:
  /// ```dart
  /// FabGroup(
  ///   child: Icon(Icons.add),
  ///   horizontal: true,
  ///   children: (context) => [
  ///     Fab(
  ///       child: Icon(Icons.person_add),
  ///       onPressed: () => addContact(),
  ///     ),
  ///     Fab(
  ///       child: Icon(Icons.photo_camera),
  ///       onPressed: () => takePhoto(),
  ///     ),
  ///   ],
  /// )
  /// ```
  const FabGroup(
      {super.key,
      required this.child,
      this.leading,
      required this.children,
      this.horizontal = false});

  /// Builds the [FabGroup] widget by creating a [Fab] that, when pressed, displays
  /// a [Popover] containing the buttons returned by [children], arranged horizontally
  /// or vertically based on [horizontal].
  ///
  /// Uses a [_PopRef] instance wrapped in a [Pylon] to track the [OverlayCompleter]
  /// for the popover, enabling programmatic dismissal via [dismissFabGroup]. The
  /// popover is positioned with an offset (70 pixels right for vertical, 70 pixels
  /// down for horizontal) and consumes outside taps for automatic closure. Upon
  /// closure, calls [dismissFabGroup] to clean up any remaining pylons. Integrates
  /// with [showPopover] for overlay management and [Row]/[Column] for button layout.
  @override
  Widget build(BuildContext context) {
    return Fab(
      leading: leading,
      onPressed: () {
        _PopRef ref = _PopRef();
        OverlayCompleter o = showPopover(
            consumeOutsideTaps: true,
            context: context,
            offset: horizontal ? const Offset(0, 70) : const Offset(70, 0),
            barrierDismissable: true,
            builder: (context) => Pylon<_PopRef>(
                  value: ref,
                  builder: (context) => horizontal
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: children(context),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: children(context),
                        ),
                ),
            alignment: Alignment.bottomRight);
        ref.completer = o;
        o.future.then((value) {
          context.dismissFabGroup();
        });
      },
      child: child,
    );
  }
}

/// Extension methods for working with [FabGroup] widgets.
extension XPrefFabGroupContext on BuildContext {
  /// Dismisses any open [FabGroup] popover in the current context.
  ///
  /// This can be used to programmatically close an open FAB group
  /// without user interaction.
  void dismissFabGroup() {
    Pylon.visiblePylons(this).whereType<Pylon<_PopRef>>().forEach((element) {
      element.value?.completer?.remove();
    });

    pylonOr<_PopRef>()?.completer?.remove();
  }
}

/// Internal reference class for tracking popovers.
class _PopRef {
  /// The overlay completer for the current popover.
  OverlayCompleter? completer;

  _PopRef();
}

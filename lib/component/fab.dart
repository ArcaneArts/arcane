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

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.bottomRight,
        child: PaddingAll(
          padding: 8,
          child: child,
        ),
      );
}

/// A floating action button that displays a dropdown menu when pressed.
///
/// [FabMenu] combines a [Fab] with a dropdown menu that appears when the button
/// is pressed. This is useful for providing a set of related actions without
/// cluttering the UI with multiple buttons.
///
/// See also:
///  * [doc/component/fab.md] for more detailed documentation
///  * [Fab], which provides the basic floating action button functionality
///  * [FabSocket], which can be used to position this component
class FabMenu extends StatelessWidget {
  /// The content of the button.
  ///
  /// This is typically an icon or text describing the menu's purpose.
  final Widget child;

  /// Optional widget to display before the main content.
  final Widget? leading;

  /// List of menu items to display when the button is pressed.
  final List<MenuItem> items;

  /// Creates a [FabMenu] widget.
  ///
  /// The [child] parameter is required and specifies the content of the button.
  /// The [items] parameter specifies the menu items to display when pressed.
  ///
  /// Example:
  /// ```dart
  /// FabMenu(
  ///   child: Text("Options"),
  ///   leading: Icon(Icons.more_vert),
  ///   items: [
  ///     MenuItem(
  ///       label: "New Document",
  ///       onPressed: () => createNewDocument(),
  ///       icon: Icon(Icons.description),
  ///     ),
  ///     MenuItem(
  ///       label: "New Folder",
  ///       onPressed: () => createNewFolder(),
  ///       icon: Icon(Icons.folder),
  ///     ),
  ///   ],
  /// )
  /// ```
  const FabMenu(
      {super.key, required this.child, this.leading, this.items = const []});

  @override
  Widget build(BuildContext context) => Fab(
        leading: leading,
        onPressed: () => showDropdown(
            context: context,
            builder: (context) => DropdownMenu(
                  children: items,
                )),
        child: child,
      );
}

class MagicFabMenu extends StatelessWidget {
  /// The content of the button.
  ///
  /// This is typically an icon or text describing the menu's purpose.
  final Widget child;

  /// Optional widget to display before the main content.
  final Widget? leading;

  /// List of menu items to display when the button is pressed.
  final List<MenuItem> items;

  /// Creates a [MagicFabMenu] widget.
  ///
  /// The [child] parameter is required and specifies the content of the button.
  /// The [items] parameter specifies the menu items to display when pressed.
  ///
  /// Example:
  /// ```dart
  /// MagicFabMenu(
  ///   child: Text("Options"),
  ///   leading: Icon(Icons.more_vert),
  ///   items: [
  ///     MenuItem(
  ///       label: "New Document",
  ///       onPressed: () => createNewDocument(),
  ///       icon: Icon(Icons.description),
  ///     ),
  ///     MenuItem(
  ///       label: "New Folder",
  ///       onPressed: () => createNewFolder(),
  ///       icon: Icon(Icons.folder),
  ///     ),
  ///   ],
  /// )
  /// ```
  const MagicFabMenu(
      {super.key, required this.child, this.leading, this.items = const []});

  @override
  Widget build(BuildContext context) => MagicFab(
        leading: leading,
        onPressed: () => showDropdown(
            context: context,
            builder: (context) => DropdownMenu(
                  children: items,
                )),
        child: child,
      );
}

/// A basic floating action button with built-in styling.
///
/// [Fab] provides a pre-styled floating action button with a modern appearance,
/// including blur effects. It automatically styles text and icon children to ensure
/// they are appropriately sized.
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

  /// Function to call when the button is pressed.
  final VoidCallback? onPressed;

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
  const Fab({super.key, required this.child, this.leading, this.onPressed});

  @override
  Widget build(BuildContext context) => PaddingAll(
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
              onPressed: onPressed,
              child: child is Text
                  ? (child as Text).large()
                  : child is Icon
                      ? (child as Icon).large()
                      : child,
            ),
          ))).blurIn;
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

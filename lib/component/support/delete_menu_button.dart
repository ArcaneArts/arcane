import 'package:arcane/arcane.dart';

/// [DeleteMenuButton] creates a themed menu button for safe delete actions in Arcane UI applications.
///
/// This lightweight function returns a [MenuButton] configured with a delete icon and label, which upon press opens a [DialogConfirm] for user confirmation before executing the deletion. It emphasizes user safety for destructive operations by requiring explicit confirmation, integrates seamlessly with [ArcaneTheme] for consistent styling (e.g., destructive colors), and provides haptic feedback via the theme. Ideal for toolbars, overflow menus ([PopupMenuButton]), or list actions alongside [DeleteIconButton] in components like [DataTable], [Tile], or [Section]. The design prioritizes performance with no heavy state management, using inline configuration for quick rendering.
///
/// Key features:
/// - Customizable icon (defaults to [Icons.trash]) and text for the menu item.
/// - Dynamic confirmation title incorporating the target item name (`thing`).
/// - Optional description for additional context in the dialog.
/// - Destructive styling and confirmation text for clear intent.
///
/// Usage example:
/// ```dart
/// DeleteMenuButton(
///   context: context,
///   thing: 'User Account',
///   description: 'This action cannot be undone.',
///   onDelete: () => _deleteAccount(),
/// )
/// ```
///
/// Returns a [MenuButton] widget ready for use in Flutter trees.
MenuButton DeleteMenuButton({
  required BuildContext context,
  IconData deleteIcon = Icons.trash,
  String menuText = "Delete",
  required String thing,
  String? description,
  String deleteConfirm = "Delete",
  required VoidCallback onDelete,
}) =>
    MenuButton(
      leading: Icon(deleteIcon),
      onPressed: () => DialogConfirm(
              title: "Delete $thing?",
              destructive: true,
              confirmText: menuText,
              description: description,
              onConfirm: onDelete)
          .open(context),
      child: Text("Delete"),
    );

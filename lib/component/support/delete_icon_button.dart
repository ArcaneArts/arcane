import 'package:arcane/arcane.dart';

/// A lightweight, themed delete action button that provides safe, confirmation-based deletion in Arcane UI.
///
/// Extends [IconButton] with integrated [Confirm] dialogs (via [DialogConfirm]) to prevent accidental deletions, styled via [ArcaneTheme] for consistency. Ideal for item actions in lists like [Tile] rows or [DataTable] cells. Upon press, opens a destructive confirmation dialog with customizable title, description, and text, executing the [onDelete] callback only on user approval. Pair [onDelete] with [Toast] for success/error feedback. Features const construction, null safety, and no state management for optimal performance in dynamic UIs. Default icon is [Icons.trash], but customizable for delete actions.
class DeleteIconButton extends StatelessWidget {
  final IconData deleteIcon;
  final String menuText;
  final String thing;
  final String? description;
  final String deleteConfirm;
  final VoidCallback onDelete;

  /// Creates a [DeleteIconButton] with customizable delete icon, confirmation text, and callback.
  ///
  /// Use named parameters for flexibility: [key] for standard widget identification; [deleteIcon] initializes the button's icon (defaults to [Icons.trash] for standard delete visual); [menuText] sets the confirmation dialog's button text (defaults to "Delete"); [thing] (required) provides the item name interpolated into the dialog title for context (e.g., "Delete User?"); [description] (optional) adds explanatory text to the dialog; [deleteConfirm] reserves text for potential future confirmation overrides (defaults to "Delete", currently unused); [onDelete] (required) defines the callback executed upon user confirmation, ideally handling the actual deletion and optional [Toast] feedback. Supports const construction for performance in lists like [Tile] or [DataTable].
  const DeleteIconButton({
    super.key,
    this.deleteIcon = Icons.trash,
    this.menuText = "Delete",
    required this.thing,
    this.description,
    this.deleteConfirm = "Delete",
    required this.onDelete,
  });

  /// Builds the delete button widget, rendering an [IconButton] that triggers a [Confirm] dialog on press.
  ///
  /// The dialog title interpolates the [thing] for context (e.g., "Delete Item?"), marks as destructive for red styling, uses [menuText] for the confirm button, includes [description] if provided, and calls [onDelete] on confirmation. Ensures user safety by requiring explicit approval before deletion, with async handling via [DialogConfirm.open]. No heavy computations; renders efficiently for repeated use.
  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(deleteIcon),
        onPressed: () => DialogConfirm(
                title: "Delete $thing?",
                destructive: true,
                confirmText: menuText,
                description: description,
                onConfirm: onDelete)
            .open(context),
      );
}

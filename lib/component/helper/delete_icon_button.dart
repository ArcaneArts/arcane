import 'package:arcane/arcane.dart';

IconButton DeleteIconButton({
  required BuildContext context,
  IconData deleteIcon = Icons.trash,
  String menuText = "Delete",
  required String thing,
  String? description,
  String deleteConfirm = "Delete",
  required VoidCallback onDelete,
}) =>
    IconButton(
      icon: Icon(deleteIcon),
      onPressed: () => DialogConfirm(
              title: "Delete $thing?",
              destructive: true,
              confirmText: menuText,
              description: description,
              onConfirm: onDelete)
          .open(context),
    );

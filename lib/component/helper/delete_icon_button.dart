import 'package:arcane/arcane.dart';

class DeleteIconButton extends StatelessWidget {
  final IconData deleteIcon;
  final String menuText;
  final String thing;
  final String? description;
  final String deleteConfirm;
  final VoidCallback onDelete;

  const DeleteIconButton({
    super.key,
    this.deleteIcon = Icons.trash,
    this.menuText = "Delete",
    required this.thing,
    this.description,
    this.deleteConfirm = "Delete",
    required this.onDelete,
  });

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

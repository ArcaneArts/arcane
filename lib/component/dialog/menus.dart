import 'package:arcane/arcane.dart';

class Menus {
  const Menus._();

  static MenuButton deleteConfirmMenu({
    required BuildContext context,
    required String name,
    required String type,
    required VoidCallback onDelete,
  }) =>
      MenuButton(
        leading: Icon(Icons.trash),
        onPressed: () => Dialogs.deleteConfirmation(
            context: context, name: name, type: type, onDelete: onDelete),
        child: Text("Delete $type"),
      );
}

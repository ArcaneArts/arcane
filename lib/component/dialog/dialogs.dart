import 'package:arcane/arcane.dart';

class Dialogs {
  const Dialogs._();

  static Future<void> deleteConfirmation({
    required BuildContext context,
    required String name,
    required String type,
    required VoidCallback onDelete,
  }) =>
      DialogConfirm(
        title: "Delete $type?",
        description:
            "Are you sure you want to delete the $type \"$name\"?\nThis action cannot be undone.",
        destructive: true,
        confirmText: "Delete $type",
        onConfirm: onDelete,
      ).open(context);

  static Future<String?> createNamedDialog({
    required BuildContext context,
    required String type,
    String? description,
    required ValueChanged<String> onConfirm,
  }) =>
      DialogText(
        title: "New $type",
        description: description,
        placeholder: Text("$type Name"),
        confirmText: "Create",
        maxLength: 64,
        onConfirm: (t) {
          if (t.trim().isEmpty) {
            TextToast("$type Name cannot be empty").open(context);
            return;
          }

          onConfirm(t.trim());
        },
      ).open(context);
}

import 'package:arcane/arcane.dart';

class DialogConfirm extends StatelessWidget with ArcaneDialogLauncher {
  final String title;
  final String? description;
  final Widget descriptionWidget;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final List<Widget>? actions;

  const DialogConfirm(
      {super.key,
      required this.title,
      this.description,
      this.descriptionWidget = const SizedBox.shrink(),
      this.confirmText = "Confirm",
      this.cancelText = "Cancel",
      this.actions,
      required this.onConfirm});

  @override
  Widget build(BuildContext context) => ArcaneDialog(
        title: Text(title),
        content: description != null ? Text(description!) : descriptionWidget,
        actions: actions ??
            [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(cancelText),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  onConfirm();
                },
                child: Text(confirmText),
              ),
              if (actions != null) ...actions!,
            ],
      );
}

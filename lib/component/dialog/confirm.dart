import 'package:arcane/arcane.dart';

class DialogConfirm extends StatelessWidget with ArcaneDialogLauncher {
  final String title;
  final String? description;
  final Widget descriptionWidget;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final List<Widget>? actions;
  final bool destructive;

  const DialogConfirm(
      {super.key,
      required this.title,
      this.destructive = false,
      this.description,
      this.descriptionWidget = const SizedBox.shrink(),
      this.confirmText = "Confirm",
      this.cancelText = "Cancel",
      this.actions,
      required this.onConfirm});

  @override
  Widget build(BuildContext context) => ArcaneDialog(
        title: Text(title),
        content: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
                child: description != null
                    ? Text(description!)
                    : descriptionWidget)
          ],
        ).iw,
        actions: actions ??
            [
              OutlineButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(cancelText),
              ),
              destructive
                  ? DestructiveButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        onConfirm();
                      },
                      child: Text(confirmText),
                    )
                  : PrimaryButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        onConfirm();
                      },
                      child: Text(confirmText),
                    ),
              if (actions != null) ...actions!,
            ],
      ).iw;
}

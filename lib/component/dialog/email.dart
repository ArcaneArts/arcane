import 'package:arcane/arcane.dart';
import 'package:flutter/services.dart';

class DialogEmail extends StatefulWidget with ArcaneDialogLauncher {
  final String title;
  final String? description;
  final Widget descriptionWidget;
  final String confirmText;
  final String cancelText;
  final String? hint;
  final String? initialValue;
  final void Function(String email) onConfirm;
  final List<Widget>? actions;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  const DialogEmail({
    super.key,
    required this.title,
    this.description,
    this.descriptionWidget = const SizedBox.shrink(),
    this.confirmText = "Submit",
    this.cancelText = "Cancel",
    this.hint,
    this.initialValue,
    required this.onConfirm,
    this.actions,
    this.maxLines,
    this.minLines,
    this.maxLength,
  });

  @override
  State<DialogEmail> createState() => _DialogEmailState();
}

class _DialogEmailState extends State<DialogEmail> {
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    controller = TextEditingController(
      text: widget.initialValue,
    );
    focusNode = FocusNode();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => focusNode.requestFocus());
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: ArcaneDialog(
          title: Text(widget.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.description != null ||
                  widget.descriptionWidget is! SizedBox)
                widget.description != null
                    ? Text(widget.description!)
                    : widget.descriptionWidget,
              const Gap(16),
              TextField(
                keyboardType: TextInputType.emailAddress,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                maxLength: widget.maxLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                focusNode: focusNode,
                controller: controller,
                placeholder: widget.hint == null ? null : Text(widget.hint!),
                onSubmitted: (value) {
                  Navigator.of(context).pop(true);
                  widget.onConfirm(value);
                },
                leading: const Icon(Icons.mail_ionic),
              ),
            ],
          ),
          actions: [
            OutlineButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(widget.cancelText),
            ),
            SecondaryButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                widget.onConfirm(controller.text);
              },
              child: Text(widget.confirmText),
            ),
            if (widget.actions != null) ...widget.actions!,
          ],
        ).iw,
      );
}

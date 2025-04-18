import 'package:arcane/arcane.dart';
import 'package:flutter/services.dart';

class DialogText extends StatefulWidget with ArcaneDialogLauncher {
  final String title;
  final String? description;
  final Widget descriptionWidget;
  final String confirmText;
  final String cancelText;
  final Widget? placeholder;
  final bool obscureText;
  final String? initialValue;
  final void Function(String result) onConfirm;
  final List<Widget>? actions;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;

  const DialogText(
      {super.key,
      required this.title,
      this.description,
      this.keyboardType,
      this.obscureText = false,
      this.placeholder,
      this.initialValue,
      this.descriptionWidget = const SizedBox.shrink(),
      this.confirmText = "Done",
      this.cancelText = "Cancel",
      this.maxLines = 1,
      this.minLines,
      this.maxLength,
      required this.onConfirm,
      this.actions});

  @override
  State<DialogText> createState() => _DialogTextState();
}

class _DialogTextState extends State<DialogText> {
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
  Widget build(BuildContext context) => SingleChildScrollView(
        child: ArcaneDialog(
          title: Text(widget.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.description != null ||
                  widget.descriptionWidget is! SizedBox)
                widget.description != null
                    ? Text(widget.description!)
                    : widget.descriptionWidget,
              const Gap(16),
              TextField(
                keyboardType: widget.keyboardType,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                maxLength: widget.maxLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                focusNode: focusNode,
                controller: controller,
                placeholder: widget.placeholder,
                onSubmitted: (value) {
                  Navigator.of(context).pop(true);
                  widget.onConfirm(value);
                },
                obscureText: widget.obscureText,
                initialValue: widget.initialValue,
              ),
            ],
          ),
          actions: [
            OutlineButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(widget.cancelText),
            ),
            PrimaryButton(
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

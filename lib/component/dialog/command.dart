import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:flutter/services.dart';

class DialogCommand extends StatefulWidget with ArcaneDialogLauncher {
  final Widget? placeholder;
  final bool obscureText;
  final String? initialValue;
  final void Function(String result) onConfirm;
  final int? maxLength;
  final Set<String> options;
  final TextInputType? keyboardType;
  final Widget? leading;
  final Widget? trailing;

  const DialogCommand(
      {super.key,
      this.options = const {},
      this.keyboardType,
      this.obscureText = false,
      this.placeholder,
      this.initialValue,
      this.maxLength,
      this.leading,
      this.trailing,
      required this.onConfirm});

  @override
  State<DialogCommand> createState() => _DialogCommandState();
}

class _DialogCommandState extends State<DialogCommand> {
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

  List<String> get vOptions => controller.text.trim().isEmpty
      ? []
      : widget.options
          .where((e) => e.toLowerCase().contains(controller.text.toLowerCase()))
          .toList();

  @override
  Widget build(BuildContext context) {
    List<String> validOptions = vOptions;

    double d3 = MediaQuery.of(context).size.height * 0.33;
    double h = 32;

    return PaddingTop(
      padding: min(
          d3, (h * validOptions.length) + (validOptions.isNotEmpty ? 3 : 0)),
      child: ArcaneDialog(
        padding: 4,
        content: ConstrainedBox(
            constraints: BoxConstraints(minWidth: d3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  leading: widget.leading,
                  trailing: widget.trailing,
                  style: Theme.of(context)
                      .typography
                      .h3
                      .copyWith(fontWeight: FontWeight.w100),
                  border: false,
                  keyboardType: widget.keyboardType,
                  maxLength: widget.maxLength,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  focusNode: focusNode,
                  controller: controller,
                  placeholder: widget.placeholder,
                  // sameSizeHintStyle: true, TODO: fix
                  onChanged: (value) => setState(() {}),
                  onSubmitted: (value) {
                    Navigator.of(context).pop(true);

                    if (validOptions.isNotEmpty &&
                        !validOptions.contains(value)) {
                      widget.onConfirm(validOptions.first);
                    } else {
                      widget.onConfirm(value);
                    }
                  },
                  obscureText: widget.obscureText,
                  initialValue: widget.initialValue,
                ),
                if (validOptions.isNotEmpty)
                  PaddingVertical(
                      padding: 1,
                      child: Container(
                        height: 1,
                        color: Theme.of(context).colorScheme.muted,
                      )),
                if (validOptions.isNotEmpty)
                  ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: d3,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...validOptions
                                .map((e) => SizedBox(
                                      height: h,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: GhostButton(
                                            trailing: e == validOptions.first
                                                ? Icon(
                                                    Icons
                                                        .return_down_back_outline_ionic,
                                                    size: 16,
                                                  )
                                                : null,
                                            alignment: Alignment.centerLeft,
                                            child: Text(e),
                                            onPressed: () {
                                              controller.text = e;
                                              widget.onConfirm(e);
                                            },
                                          ))
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ],
                        ),
                      )),
              ],
            )),
      ).iw,
    );
  }
}

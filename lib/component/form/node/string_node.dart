import 'package:arcane/arcane.dart';

class ArcaneStringField extends StatefulWidget {
  final int? minLines;
  final int? maxLines;

  const ArcaneStringField({super.key, this.minLines, this.maxLines});

  @override
  State<ArcaneStringField> createState() => _ArcaneStringFieldState();
}

class _ArcaneStringFieldState extends State<ArcaneStringField> {
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller =
        TextEditingController(text: field.provider.subject.valueOrNull ?? "");
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        save();
      }
    });
  }

  void save() {
    field.provider.setValue(field.meta.effectiveKey, controller.text);
  }

  ArcaneField<String> get field => context.pylon<ArcaneField<String>>();

  @override
  Widget build(BuildContext context) => ArcaneFieldWrapper<String>(
      builder: (context) => TextField(
            controller: controller,
            focusNode: focusNode,
            minLines: widget.minLines,
            maxLines: widget.maxLines ?? 1,
            onEditingComplete: save,
            placeholder: field.meta.placeholder is String
                ? Text(field.meta.placeholder)
                : null,
          ));
}

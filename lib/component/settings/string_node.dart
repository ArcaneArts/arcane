import 'package:arcane/arcane.dart';
import 'package:arcane/component/settings/core.dart';

class KUIString extends StatefulWidget {
  final int? minLines;
  final int? maxLines;

  const KUIString({super.key, this.minLines, this.maxLines});

  @override
  State<KUIString> createState() => _KUIStringState();
}

class _KUIStringState extends State<KUIString> {
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

  KField<String> get field => context.pylon<KField<String>>();

  @override
  Widget build(BuildContext context) => KFieldWrapper<String>(
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

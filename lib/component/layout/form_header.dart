import 'package:arcane/arcane.dart';

class FormHeader extends StatelessWidget {
  final String label;
  final Widget child;

  const FormHeader({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Name").small,
          Gap(8),
          child,
        ],
      );
}

class FormHeaderField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final int? minLines;

  const FormHeaderField(
      {super.key,
      required this.label,
      required this.hint,
      this.controller,
      this.focusNode,
      this.onChanged,
      this.maxLines,
      this.minLines});

  @override
  Widget build(BuildContext context) => FormHeader(
        label: label,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          placeholder: Text(hint),
          onChanged: onChanged,
          maxLines: maxLines,
          minLines: minLines,
        ),
      );
}

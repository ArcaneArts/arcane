import 'package:arcane/arcane.dart';
import 'package:arcane/component/settings/core.dart';

class KUIDateNode extends StatelessWidget {
  final PromptMode mode;

  const KUIDateNode({super.key, this.mode = PromptMode.popover});

  @override
  Widget build(BuildContext context) {
    KField<DateTime> field = context.pylon<KField<DateTime>>();
    return KFieldWrapper<DateTime>(
        builder: (context) => DatePicker(
            mode: mode,
            onChanged: (v) => field.provider.setValue(
                field.meta.effectiveKey, v ?? field.provider.defaultValue),
            value: field.provider.subject.valueOrNull ??
                field.provider.defaultValue));
  }
}

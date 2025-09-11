import 'package:arcane/arcane.dart';
import 'package:arcane/component/settings/core.dart';

class KUITimeNode extends StatelessWidget {
  final PromptMode mode;

  const KUITimeNode({super.key, this.mode = PromptMode.popover});

  @override
  Widget build(BuildContext context) {
    KField<DateTime> field = context.pylon<KField<DateTime>>();
    return KFieldWrapper<DateTime>(
        builder: (context) => TimePicker(
            mode: mode,
            onChanged: (v) => field.provider.setValue(field.meta.effectiveKey,
                v?.toDateTime() ?? field.provider.defaultValue),
            value: TimeOfDay.fromDateTime(field.provider.subject.valueOrNull ??
                field.provider.defaultValue)));
  }
}

import 'package:arcane/arcane.dart';

class ArcaneTimeField extends StatelessWidget {
  final PromptMode mode;
  final ValueChanged<TimeOfDay?>? onChanged;
  final AlignmentGeometry? popoverAlignment;
  final AlignmentGeometry? popoverAnchorAlignment;
  final EdgeInsetsGeometry? popoverPadding;
  final bool? use24HourFormat;
  final bool showSeconds;
  final Widget? dialogTitle;

  const ArcaneTimeField(
      {super.key,
      this.mode = PromptMode.popover,
      this.onChanged,
      this.popoverAlignment,
      this.popoverAnchorAlignment,
      this.popoverPadding,
      this.use24HourFormat,
      this.showSeconds = false,
      this.dialogTitle});

  @override
  Widget build(BuildContext context) {
    ArcaneField<DateTime> field = context.pylon<ArcaneField<DateTime>>();
    return ArcaneFieldWrapper<DateTime>(
        builder: (context) => TimePicker(
            popoverAlignment: popoverAlignment,
            popoverAnchorAlignment: popoverAnchorAlignment,
            popoverPadding: popoverPadding,
            use24HourFormat: use24HourFormat,
            showSeconds: showSeconds,
            dialogTitle: dialogTitle,
            mode: mode,
            onChanged: (v) => field.provider.setValue(field.meta.effectiveKey,
                v?.toDateTime() ?? field.provider.defaultValue),
            value: TimeOfDay.fromDateTime(field.provider.subject.valueOrNull ??
                field.provider.defaultValue)));
  }
}

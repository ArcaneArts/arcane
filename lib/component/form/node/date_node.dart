import 'package:arcane/arcane.dart';

class ArcaneDateField extends StatelessWidget {
  final PromptMode mode;
  final CalendarViewType? initialViewType;
  final Widget? dialogTitle;
  final CalendarView? initialView;
  final AlignmentGeometry? popoverAlignment;
  final AlignmentGeometry? popoverAnchorAlignment;
  final EdgeInsetsGeometry? popoverPadding;
  final DateStateBuilder? stateBuilder;

  const ArcaneDateField(
      {super.key,
      this.mode = PromptMode.popover,
      this.initialViewType,
      this.dialogTitle,
      this.initialView,
      this.popoverAlignment,
      this.popoverAnchorAlignment,
      this.popoverPadding,
      this.stateBuilder});

  @override
  Widget build(BuildContext context) {
    ArcaneField<DateTime> field = context.pylon<ArcaneField<DateTime>>();
    return ArcaneFieldWrapper<DateTime>(
        builder: (context) => DatePicker(
            initialViewType: initialViewType,
            dialogTitle: dialogTitle,
            initialView: initialView,
            popoverAlignment: popoverAlignment,
            popoverAnchorAlignment: popoverAnchorAlignment,
            popoverPadding: popoverPadding,
            stateBuilder: stateBuilder,
            mode: mode,
            onChanged: (v) => field.provider.setValue(
                field.meta.effectiveKey, v ?? field.provider.defaultValue),
            value: field.provider.subject.valueOrNull ??
                field.provider.defaultValue));
  }
}

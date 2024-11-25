import 'package:arcane/arcane.dart';

class DialogDateRange extends StatefulWidget with ArcaneDialogLauncher {
  final String? title;
  final ValueChanged<DateTimeRange> onConfirm;
  final DateStateBuilder? stateBuilder;
  final DateTimeRange? initialRange;
  final String confirmText;
  final String cancelText;

  const DialogDateRange(
      {super.key,
      this.title,
      required this.onConfirm,
      this.stateBuilder,
      this.confirmText = "Done",
      this.cancelText = "Cancel",
      this.initialRange});

  @override
  State<DialogDateRange> createState() => _DialogDateRangeState();
}

class _DialogDateRangeState extends State<DialogDateRange> {
  CalendarValue? value;

  @override
  void initState() {
    value = widget.initialRange != null
        ? RangeCalendarValue(
            widget.initialRange!.start, widget.initialRange!.end)
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ArcaneDialog(
        title: widget.title == null ? null : Text(widget.title!),
        content: LayoutBuilder(
            builder: (context, constraints) => DatePickerDialog(
                stateBuilder: widget.stateBuilder,
                initialView: CalendarView.now(),
                initialValue: widget.initialRange != null
                    ? RangeCalendarValue(
                        widget.initialRange!.start, widget.initialRange!.end)
                    : null,
                initialViewType: CalendarViewType.date,
                selectionMode: CalendarSelectionMode.range,
                viewMode: CalendarSelectionMode.single,
                onChanged: (value) => setState(() {
                      this.value = value;
                    }))),
        actions: [
          OutlineButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(widget.cancelText),
          ),
          PrimaryButton(
            enabled: value != null,
            onPressed: () {
              Navigator.of(context).pop(true);
              RangeCalendarValue v = value!.toRange();
              widget.onConfirm(DateTimeRange(v.start, v.end));
            },
            child: Text(widget.confirmText),
          ),
        ],
      );
}

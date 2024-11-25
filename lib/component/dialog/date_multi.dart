import 'package:arcane/arcane.dart';

class DialogDateMulti extends StatefulWidget with ArcaneDialogLauncher {
  final String? title;
  final ValueChanged<List<DateTime>> onConfirm;
  final DateStateBuilder? stateBuilder;
  final List<DateTime>? initialDates;
  final String confirmText;
  final String cancelText;

  const DialogDateMulti(
      {super.key,
      this.title,
      required this.onConfirm,
      this.stateBuilder,
      this.confirmText = "Done",
      this.cancelText = "Cancel",
      this.initialDates});

  @override
  State<DialogDateMulti> createState() => _DialogDateMultiState();
}

class _DialogDateMultiState extends State<DialogDateMulti> {
  CalendarValue? value;

  @override
  void initState() {
    value = widget.initialDates != null && widget.initialDates!.isNotEmpty
        ? MultiCalendarValue(widget.initialDates!)
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
                initialValue: widget.initialDates != null &&
                        widget.initialDates!.isNotEmpty
                    ? MultiCalendarValue(widget.initialDates!)
                    : null,
                initialViewType: CalendarViewType.date,
                selectionMode: CalendarSelectionMode.multi,
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
              ;
              widget.onConfirm(value!.toMulti().dates);
            },
            child: Text(widget.confirmText),
          ),
        ],
      );
}

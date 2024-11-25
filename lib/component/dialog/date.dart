import 'package:arcane/arcane.dart';

class DialogDate extends StatefulWidget with ArcaneDialogLauncher {
  final String? title;
  final ValueChanged<DateTime> onConfirm;
  final DateStateBuilder? stateBuilder;
  final DateTime? initialDate;
  final String confirmText;
  final String cancelText;

  const DialogDate(
      {super.key,
      this.title,
      required this.onConfirm,
      this.stateBuilder,
      this.confirmText = "Done",
      this.cancelText = "Cancel",
      this.initialDate});

  @override
  State<DialogDate> createState() => _DialogDateState();
}

class _DialogDateState extends State<DialogDate> {
  CalendarValue? value;

  @override
  Widget build(BuildContext context) => ArcaneDialog(
        title: widget.title == null ? null : Text(widget.title!),
        content: LayoutBuilder(
            builder: (context, constraints) => DatePickerDialog(
                stateBuilder: widget.stateBuilder,
                initialView: CalendarView.now(),
                initialValue: widget.initialDate != null
                    ? SingleCalendarValue(widget.initialDate!)
                    : null,
                initialViewType: CalendarViewType.date,
                selectionMode: CalendarSelectionMode.single,
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
              widget.onConfirm(value!.toSingle().date);
            },
            child: Text(widget.confirmText),
          ),
        ],
      );
}

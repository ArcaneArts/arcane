import 'package:arcane/arcane.dart';

class DialogTime extends StatefulWidget with ArcaneDialogLauncher {
  final String? title;
  final ValueChanged<TimeOfDay> onConfirm;
  final TimeOfDay? initialTime;
  final String confirmText;
  final String cancelText;
  final bool use24HourFormat;
  final bool showSeconds;

  const DialogTime(
      {super.key,
      this.title,
      required this.onConfirm,
      this.showSeconds = false,
      this.use24HourFormat = false,
      this.confirmText = "Done",
      this.cancelText = "Cancel",
      this.initialTime});

  @override
  State<DialogTime> createState() => _DialogTimeState();
}

class _DialogTimeState extends State<DialogTime> {
  TimeOfDay? value;

  @override
  void initState() {
    value = widget.initialTime ?? TimeOfDay(hour: 0, minute: 0, second: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ArcaneDialog(
        title: widget.title == null ? null : Text(widget.title!),
        content: LayoutBuilder(
            builder: (context, constraints) => TimePickerDialog(
                initialValue: widget.initialTime,
                showSeconds: widget.showSeconds,
                use24HourFormat: widget.use24HourFormat,
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
              widget.onConfirm(value!);
            },
            child: Text(widget.confirmText),
          ),
        ],
      );
}

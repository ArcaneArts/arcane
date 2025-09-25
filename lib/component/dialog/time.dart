import 'package:arcane/arcane.dart';

/// A customizable time selection dialog widget that integrates seamlessly with the Arcane UI component system.
///
/// This class provides a user-friendly interface for selecting a specific time of day, presented within an
/// [ArcaneDialog] containing a [TimePickerDialog]. It is designed for scenarios requiring precise time input,
/// such as scheduling features or form validations, complementing other input dialogs like [Date] for date selection
/// or [Text] for textual input. Key features include:
/// - Optional title and customizable button labels for better UX.
/// - Support for 24-hour format and seconds display to accommodate various time representation needs.
/// - Pre-selection of an initial time to streamline user interaction.
/// - Confirmation callback to handle the selected [TimeOfDay] in the parent widget.
///
/// Usage example:
/// ```dart
/// DialogTime(
///   title: 'Select Time',
///   initialTime: TimeOfDay.now(),
///   onConfirm: (time) => print('Selected time: $time'),
///   use24HourFormat: true,
///   showSeconds: true,
/// );
/// ```
/// Launch this dialog using [showDialog] or via the [ArcaneDialogLauncher] mixin for consistent dialog management.
class DialogTime extends StatefulWidget with ArcaneDialogLauncher {
  /// Optional title string displayed as a [Text] widget in the dialog's header.
  /// If null, no title is shown.
  final String? title;

  /// Required callback function invoked when the user confirms the selected time.
  /// Receives the final [TimeOfDay] value, allowing the parent widget to process the selection.
  final ValueChanged<TimeOfDay> onConfirm;

  /// Optional initial [TimeOfDay] to pre-select in the time picker.
  /// If not provided, defaults to 00:00:00 (midnight) in the state initialization.
  final TimeOfDay? initialTime;

  /// Text label for the confirm button, displayed on the [PrimaryButton].
  /// Defaults to "Done" for standard confirmation action.
  final String confirmText;

  /// Text label for the cancel button, displayed on the [OutlineButton].
  /// Defaults to "Cancel" to allow users to dismiss without selection.
  final String cancelText;

  /// Flag determining whether the time picker uses 24-hour format (true) or 12-hour with AM/PM (false).
  /// Defaults to false, aligning with common mobile UI conventions.
  final bool use24HourFormat;

  /// Flag to include seconds selection in the [TimePickerDialog].
  /// Defaults to false, as most time inputs do not require second-level precision.
  final bool showSeconds;

  /// Constructs a new [DialogTime] widget instance.
  ///
  /// The [onConfirm] parameter is mandatory and defines the action taken upon user confirmation,
  /// receiving the selected [TimeOfDay]. Optional parameters allow customization:
  /// - [title]: Sets the dialog header text; omits the title if null.
  /// - [initialTime]: Pre-selects a time in the picker for quicker user input.
  /// - [confirmText] and [cancelText]: Customize button labels for localization or branding.
  /// - [use24HourFormat]: Enables 24-hour time display, useful for international apps.
  /// - [showSeconds]: Adds seconds to the picker for applications needing granular time control.
  ///
  /// All optional parameters have sensible defaults to ensure immediate usability.
  const DialogTime({
    super.key,
    this.title,
    required this.onConfirm,
    this.showSeconds = false,
    this.use24HourFormat = false,
    this.confirmText = "Done",
    this.cancelText = "Cancel",
    this.initialTime,
  });

  /// Standard Flutter override to create and return the state object for this widget.
  ///
  /// Returns an instance of [_DialogTimeState], which manages the dialog's internal time selection logic
  /// and UI construction. This method has no parameters and no side effects beyond state instantiation.
  @override
  State<DialogTime> createState() => _DialogTimeState();
}

/// Private state class for [DialogTime], responsible for managing the selected time value
/// and constructing the dialog's user interface.
///
/// This class extends [State<DialogTime>] and handles initialization of the time value,
/// updates via the time picker's callback, and builds the [ArcaneDialog] with embedded [TimePickerDialog]
/// and action buttons. It ensures responsive layout using [LayoutBuilder] and enables/disables
/// the confirm button based on whether a time is selected. Integrates with the broader dialog system
/// similar to states in [Date] or [Email] dialogs.
class _DialogTimeState extends State<DialogTime> {
  /// The currently selected [TimeOfDay] in the dialog.
  ///
  /// Initialized in [initState] from the widget's [initialTime] or defaults to midnight (00:00:00).
  /// Updated dynamically via the [TimePickerDialog]'s onChanged callback using setState.
  /// Used to determine if the confirm button should be enabled and passed to [onConfirm] on submission.
  TimeOfDay? value;

  /// Initializes the state of the [_DialogTimeState].
  ///
  /// Sets the [value] field to the widget's [initialTime] if provided, or to a default [TimeOfDay]
  /// representing 00:00:00 (midnight). This ensures the time picker starts with a meaningful selection.
  /// Calls the superclass [initState] to complete Flutter's lifecycle initialization.
  /// No parameters are accepted, and it has no return value or side effects beyond field assignment.
  @override
  void initState() {
    value = widget.initialTime ?? TimeOfDay(hour: 0, minute: 0, second: 0);
    super.initState();
  }

  /// Builds the widget tree for the time selection dialog.
  ///
  /// Constructs an [ArcaneDialog] with:
  /// - An optional title rendered as [Text] from the widget's [title].
  /// - Content featuring a [TimePickerDialog] wrapped in [LayoutBuilder] for constraint-based sizing,
  ///   passing [initialTime], [showSeconds], [use24HourFormat], and an onChanged callback to update [value].
  /// - Action buttons: An [OutlineButton] for cancellation (pops dialog with false) and a [PrimaryButton]
  ///   for confirmation, enabled only if [value] is not null. On press, pops the dialog with true and
  ///   invokes the widget's [onConfirm] with the selected time.
  ///
  /// This method accepts a [BuildContext] parameter and returns a [Widget] ([ArcaneDialog]).
  /// It triggers UI updates via setState when the time changes and handles navigation pops.
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

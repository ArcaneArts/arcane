import 'package:arcane/arcane.dart';

/// A dialog widget for selecting a single date using a date picker interface.
///
/// This component provides a simple, user-friendly way to choose a specific date,
/// integrating seamlessly with the Arcane UI system. It displays a [DatePickerDialog]
/// within an [ArcaneDialog], allowing users to navigate calendars and select a date.
/// Upon confirmation, it invokes the provided callback with the selected [DateTime].
///
/// Key features:
/// - Supports initial date pre-selection for editing scenarios.
/// - Customizable title, confirm/cancel button texts.
/// - Optional state builder for advanced calendar customization.
/// - Follows Arcane's dialog patterns, similar to [DateRange] for ranges or [DateMulti] for multiple dates.
///
/// Usage:
/// ```dart
/// DialogDate(
///   title: 'Select Date',
///   initialDate: DateTime.now(),
///   onConfirm: (date) => print('Selected: $date'),
/// ).show(context);
/// ```
class DialogDate extends StatefulWidget with ArcaneDialogLauncher {
  /// The optional title displayed at the top of the dialog.
  ///
  /// Type: [String]?
  /// Usage: Provides a descriptive header for the date selection dialog.
  final String? title;

  /// The callback invoked when the user confirms the selected date.
  ///
  /// Type: [ValueChanged]<[DateTime]>
  /// Usage: Receives the chosen [DateTime] for further processing in the app.
  final ValueChanged<DateTime> onConfirm;

  /// An optional builder for customizing the date picker's state.
  ///
  /// Type: [DateStateBuilder]?
  /// Usage: Allows advanced configuration of the calendar's internal state.
  final DateStateBuilder? stateBuilder;

  /// The initial date to pre-select in the picker.
  ///
  /// Type: [DateTime]?
  /// Usage: Sets a starting point for date selection, useful for editing existing dates.
  final DateTime? initialDate;

  /// The text displayed on the confirm button.
  ///
  /// Type: [String]
  /// Usage: Customizes the label for the "Done" action button.
  final String confirmText;

  /// The text displayed on the cancel button.
  ///
  /// Type: [String]
  /// Usage: Customizes the label for the cancel action button.
  final String cancelText;

  /// Constructs a [DialogDate] widget.
  ///
  /// The [onConfirm] callback is required and will be called with the selected date
  /// upon user confirmation. [title] sets the optional dialog header text.
  /// [initialDate] pre-selects a date if provided. [confirmText] and [cancelText]
  /// customize button labels, defaulting to "Done" and "Cancel" respectively.
  /// [stateBuilder] allows custom state management for the date picker.
  const DialogDate(
      {super.key,
      this.title,
      required this.onConfirm,
      this.stateBuilder,
      this.confirmText = "Done",
      this.cancelText = "Cancel",
      this.initialDate});

  /// Creates the state object for this [StatefulWidget].
  ///
  /// Returns an instance of [_DialogDateState] to manage the dialog's internal state.
  @override
  State<DialogDate> createState() => _DialogDateState();
}

/// The state management class for [DialogDate], responsible for handling
/// the selected date value, initialization, and building the dialog UI.
///
/// This private state manages the [CalendarValue] and updates the UI
/// in response to date selections, integrating with [ArcaneDialog] and [DatePickerDialog].
class _DialogDateState extends State<DialogDate> {
  /// The currently selected calendar value, which holds the chosen date.
  ///
  /// Type: [CalendarValue]?
  /// Usage: Nullable until a date is selected; used to enable/disable the confirm button
  /// and pass the final selection to the callback.
  CalendarValue? value;

  /// Initializes the state by setting the initial selected value based on [initialDate].
  ///
  /// If [initialDate] is provided, creates a [SingleCalendarValue] from it;
  /// otherwise, starts with null. This ensures the picker reflects the pre-selected date.
  @override
  void initState() {
    value = widget.initialDate != null
        ? SingleCalendarValue(widget.initialDate!)
        : null;
    super.initState();
  }

  /// Builds the dialog's UI, rendering the [ArcaneDialog] with a [DatePickerDialog]
  /// for date selection and action buttons for confirm/cancel.
  ///
  /// The content uses [LayoutBuilder] to adapt the picker to available space.
  /// Updates the [value] on date changes and handles button interactions,
  /// dismissing the dialog and invoking [onConfirm] on successful selection.
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

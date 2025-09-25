import 'package:arcane/arcane.dart';

/// A stateful dialog widget for multi-date selection in the Arcane UI component system.
///
/// This dialog allows users to select multiple dates using a date picker interface.
/// It integrates with the [ArcaneDialog] for consistent dialog presentation and
/// supports initialization with pre-selected dates. Key features include:
/// - Multi-selection mode for choosing several dates.
/// - Customizable title, confirm/cancel buttons, and state builder for advanced
///   calendar customization.
/// - Callback for handling selected dates upon confirmation.
///
/// Usage example:
/// ```dart
/// DialogDateMulti(
///   title: 'Select Dates',
///   initialDates: [DateTime.now(), DateTime.now().add(const Duration(days: 1))],
///   onConfirm: (dates) {
///     // Handle selected dates
///   },
/// ).show(context);
/// ```
///
/// See also: [DatePickerDialog], [ArcaneDialog], [MultiCalendarValue].
class DialogDateMulti extends StatefulWidget with ArcaneDialogLauncher {
  /// The optional title displayed at the top of the dialog.
  ///
  /// Type: String?
  /// Usage: Provides a descriptive header for the date selection dialog.
  final String? title;

  /// The required callback invoked when the user confirms the date selection.
  ///
  /// Parameters: List<DateTime> - The list of selected dates.
  /// Side effects: Called after dialog dismissal with the chosen dates.
  final ValueChanged<List<DateTime>> onConfirm;

  /// An optional builder for customizing the calendar's state.
  ///
  /// Type: DateStateBuilder?
  /// Usage: Allows advanced configuration of the date picker's appearance and behavior.
  final DateStateBuilder? stateBuilder;

  /// The optional list of pre-selected dates to initialize the picker with.
  ///
  /// Type: List<DateTime>?
  /// Usage: Sets the initial multi-selection state; if empty or null, starts with no selection.
  final List<DateTime>? initialDates;

  /// The text displayed on the confirm button.
  ///
  /// Type: String
  /// Default: "Done"
  final String confirmText;

  /// The text displayed on the cancel button.
  ///
  /// Type: String
  /// Default: "Cancel"
  final String cancelText;

  /// Constructs a [DialogDateMulti] widget.
  ///
  /// Parameters:
  /// - key: Standard Flutter widget key.
  /// - title: Optional dialog title string.
  /// - onConfirm: Required callback for selected dates (defaults to null handling in state).
  /// - stateBuilder: Optional builder for calendar state (defaults to standard).
  /// - confirmText: Confirm button text (defaults to "Done").
  /// - cancelText: Cancel button text (defaults to "Cancel").
  /// - initialDates: Optional initial selected dates (defaults to empty selection).
  ///
  /// Initializes the dialog with provided parameters, setting up the multi-date picker.
  const DialogDateMulti(
      {super.key,
      this.title,
      required this.onConfirm,
      this.stateBuilder,
      this.confirmText = "Done",
      this.cancelText = "Cancel",
      this.initialDates});

  /// Creates the state for this [DialogDateMulti] widget.
  ///
  /// Returns: [_DialogDateMultiState] - The private state managing the dialog's date selection logic.
  @override
  State<DialogDateMulti> createState() => _DialogDateMultiState();
}

/// The private state class managing the multi-date selection dialog's internal logic.
///
/// Handles initialization of selected dates, state updates from the date picker,
/// and building the dialog UI with confirm/cancel actions. Integrates with
/// [DatePickerDialog] for the selection interface and [ArcaneDialog] for presentation.
class _DialogDateMultiState extends State<DialogDateMulti> {
  /// The current selection value from the date picker.
  ///
  /// Type: CalendarValue?
  /// Usage: Tracks the multi-selected dates; null if no selection made.
  CalendarValue? value;

  /// Initializes the state of the dialog.
  ///
  /// Sets the initial value based on [widget.initialDates], creating a [MultiCalendarValue]
  /// if dates are provided, otherwise null. Called once when the state is inserted into the tree.
  @override
  void initState() {
    value = widget.initialDates != null && widget.initialDates!.isNotEmpty
        ? MultiCalendarValue(widget.initialDates!)
        : null;
    super.initState();
  }

  /// Builds the dialog widget.
  ///
  /// Parameters: BuildContext context - The location to build the widget in.
  ///
  /// Returns: Widget - An [ArcaneDialog] containing the date picker and action buttons.
  ///
  /// Constructs the dialog with optional title, a [DatePickerDialog] for multi-date selection,
  /// and buttons for cancel/confirm. Updates state on date changes and handles confirmation callback.
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

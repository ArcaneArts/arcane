import 'package:arcane/arcane.dart';

/// A customizable date range selection dialog for the Arcane Flutter UI framework.
///
/// This widget provides an intuitive interface for users to select a start and end date using a
/// [DatePickerDialog] configured in range selection mode. It integrates seamlessly with the Arcane
/// dialog system by extending [StatefulWidget] and mixing in [ArcaneDialogLauncher], ensuring
/// consistent styling and behavior with other Arcane components like [Dialog], [DateMulti], and [Date].
///
/// Key features:
/// - Pre-selection of an initial date range via [initialRange].
/// - Customizable dialog title, confirm/cancel button texts, and date state via [stateBuilder].
/// - Automatic validation: The confirm button is enabled only when a valid range is selected.
/// - On confirmation, invokes the [onConfirm] callback with a [DateTimeRange] object.
/// - Supports single view mode for focused date range picking, similar to multi-date selection in [DateMulti].
///
/// Usage example:
/// ```dart
/// DialogDateRange(
///   title: 'Select Report Period',
///   initialRange: DateTimeRange(
///     start: DateTime.now().subtract(const Duration(days: 30)),
///     end: DateTime.now(),
///   ),
///   onConfirm: (range) {
///     // Process the selected range, e.g., fetch data for the period
///     print('Selected range: ${range.start} to ${range.end}');
///   },
/// )
/// ```
/// This can be launched via [showDialog] or Arcane's dialog launcher mechanisms.
class DialogDateRange extends StatefulWidget with ArcaneDialogLauncher {
  /// Optional title displayed in the dialog header, providing context for the date range selection.
  final String? title;

  /// Required callback invoked when the user confirms the selection, receiving the chosen [DateTimeRange].
  /// This allows the parent widget to handle the result, such as updating state or triggering data fetches.
  final ValueChanged<DateTimeRange> onConfirm;

  /// Optional builder for customizing the [DateState] in the picker, enabling advanced date configurations
  /// similar to those used in [Date] or [DateMulti] for filtered or highlighted dates.
  final DateStateBuilder? stateBuilder;

  /// Optional initial [DateTimeRange] to pre-populate the picker, setting the starting selection for the user.
  /// If null, the picker starts with no selection.
  final DateTimeRange? initialRange;

  /// Text label for the confirm button, defaults to "Done" for standard Arcane UI consistency.
  final String confirmText;

  /// Text label for the cancel button, defaults to "Cancel" to match Arcane dialog conventions.
  final String cancelText;

  /// Constructs a [DialogDateRange] instance with the specified configuration.
  ///
  /// The [onConfirm] callback is mandatory and handles the selected range post-confirmation.
  /// [title] sets an optional header for the dialog.
  /// [stateBuilder] provides customization for date states, akin to [DateMulti].
  /// [initialRange] pre-selects dates if supplied.
  /// [confirmText] and [cancelText] allow button text overrides, with sensible defaults.
  const DialogDateRange(
      {super.key,
      this.title,
      required this.onConfirm,
      this.stateBuilder,
      this.confirmText = "Done",
      this.cancelText = "Cancel",
      this.initialRange});

  /// Creates and returns the [_DialogDateRangeState] instance to manage the widget's state.
  @override
  State<DialogDateRange> createState() => _DialogDateRangeState();
}

/// Private state class responsible for managing the date range selection logic in [DialogDateRange].
///
/// Handles initialization of the selected value, updates on user interactions, and builds the dialog UI
/// with proper event handling for confirmation and cancellation.
class _DialogDateRangeState extends State<DialogDateRange> {
  /// Current selected value from the date picker, representing the chosen date range as a [CalendarValue].
  /// Initialized from [widget.initialRange] and updated on user selection changes.
  CalendarValue? value;

  /// Initializes the state by setting the initial [value] if an [initialRange] is provided.
  /// Converts the [DateTimeRange] to a [RangeCalendarValue] for the picker's internal use.
  @override
  void initState() {
    value = widget.initialRange != null
        ? RangeCalendarValue(
            widget.initialRange!.start, widget.initialRange!.end)
        : null;
    super.initState();
  }

  /// Builds the dialog widget using [ArcaneDialog] as the container.
  ///
  /// The content features a [DatePickerDialog] in range mode, constrained by available space via [LayoutBuilder].
  /// Updates [value] reactively on date changes. The actions include cancel ([OutlineButton]) which dismisses
  /// without action, and confirm ([PrimaryButton]) which is enabled only if a range is selected, then invokes
  /// [widget.onConfirm] with the [DateTimeRange] after dismissal.
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

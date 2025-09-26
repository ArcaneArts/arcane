import 'package:arcane/arcane.dart';

/// Form field widget for date selection in the Arcane component library, leveraging [DatePicker] for intuitive calendar-based interaction.
///
/// This class extends [StatelessWidget] and integrates with [ArcaneField<DateTime>] to manage form state and validation,
/// supporting both popover and dialog modes via [PromptMode] for flexible user experiences in various device contexts.
/// It allows customization of the initial calendar view (e.g., day, month, year), popover positioning to avoid overlaps,
/// and a [stateBuilder] for dynamic date enabling/disabling based on business rules like exclusions or ranges.
/// Ideal for inputs such as date of birth, due dates, or event scheduling, the widget automatically handles value conversion
/// and provider updates, ensuring consistency with other temporal fields like [ArcaneTimeField] in comprehensive forms.
///
/// The build process fetches the current [DateTime] from the provider, passes it to [DatePicker], and updates on selection
/// with null fallback to default, supporting optional fields. It enhances form usability by respecting theme and locale.
///
/// Usage example:
/// ```dart
/// ArcaneDateField(
///   mode: PromptMode.dialog,
///   initialViewType: CalendarViewType.month,
///   onChanged: (date) {
///     // Handle date change, e.g., validate range or update time field
///   },
///   stateBuilder: (context, date) => DateState.disabled if date.isAfter(DateTime.now()) else DateState.normal,
/// )
/// ```
class ArcaneDateField extends StatelessWidget {
  /// Presentation mode for the date picker, of type [PromptMode], determining popover for inline selection or dialog
  /// for immersive calendar viewing. Defaults to [PromptMode.popover] to preserve form flow and space efficiency.
  /// This field controls the [DatePicker]'s display context within the [ArcaneFieldWrapper], suitable for quick picks
  /// in compact forms or detailed navigation in planning scenarios.
  final PromptMode mode;

  /// Initial view type for the calendar, of type [CalendarViewType?], controlling the starting granularity (e.g., day,
  /// month, year views). If null, uses the picker's default based on context and user gesture. This parameter focuses
  /// the [DatePicker] on relevant periods, improving efficiency for inputs like month selection in reports.
  final CalendarViewType? initialViewType;

  /// Custom title widget for dialog mode, of type [Widget?], providing contextual guidance such as "Choose Event Date"
  /// or branded headers. Ignored in popover mode; enhances user orientation in full-screen [PromptMode.dialog] sessions
  /// integrated with [ArcaneField<DateTime>].
  final Widget? dialogTitle;

  /// Starting calendar view instance, of type [CalendarView?], pre-set to a specific date, month, or year for focused
  /// selection. Useful for contextual defaults, like opening to the current month; if null, defaults to today.
  /// This field customizes the [DatePicker]'s initial state for better UX in time-sensitive Arcane forms.
  final CalendarView? initialView;

  /// Alignment of the popover relative to the field, of type [AlignmentGeometry?], for layout adjustments in tight
  /// spaces or responsive designs. Applies only in popover mode; null uses system default to position the [DatePicker]
  /// overlay without obscuring the [ArcaneFieldWrapper].
  final AlignmentGeometry? popoverAlignment;

  /// Anchor alignment for popover attachment, of type [AlignmentGeometry?], ensuring proper positioning over the input
  /// field. Fine-tunes attachment in edge cases; exclusive to [PromptMode.popover] for precise calendar placement.
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Internal padding for the popover container, of type [EdgeInsetsGeometry?], adding space around the calendar UI
  /// elements. Customizes breathing room for readability on small screens; defaults to standard if null.
  final EdgeInsetsGeometry? popoverPadding;

  /// Custom builder for date states in the [DatePicker], of type [DateStateBuilder?], enabling dynamic enabling,
  /// disabling, or highlighting of dates based on rules (e.g., weekends disabled). Receives context and date;
  /// enhances validation integration with [ArcaneField<DateTime>] provider for business logic in forms.
  final DateStateBuilder? stateBuilder;

  /// Constructs an [ArcaneDateField] instance, initializing it with parameters for date picker configuration.
  ///
  /// This const constructor sets up the widget for efficient Flutter rendering. [mode] defaults to popover for inline use;
  /// [initialViewType] and [initialView] focus the calendar; popover params ([popoverAlignment], etc.) apply in popover
  /// mode for positioning; [stateBuilder] allows rule-based date control. The widget auto-integrates with
  /// [ArcaneField<DateTime>] provider for value handling, supporting optional dates via null/default fallback.
  /// Ideal for quick setup in Arcane forms, with flexibility for advanced scenarios like range previews.
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

  /// Renders the date field by embedding a [DatePicker] within [ArcaneFieldWrapper<DateTime>] for form integration.
  ///
  /// This method fetches the current [DateTime] from the [ArcaneField<DateTime>] provider, applies all custom parameters
  /// (e.g., [initialViewType], [stateBuilder], [mode]), and configures the [onChanged] callback to update the provider
  /// with the selected date or default if cleared. It handles null values gracefully, ensuring optional field support.
  /// Returns a [Widget] that provides calendar interaction consistent with Arcane theming and validation; no side effects
  /// beyond provider updates; optimized for declarative builds.
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

import 'package:arcane/arcane.dart';

/// A specialized form field widget for time selection within the Arcane UI component system.
///
/// This class extends [StatelessWidget] and provides an intuitive interface for users to select [TimeOfDay] values,
/// integrating seamlessly with [ArcaneField<DateTime>] for form state management and [ArcaneFieldWrapper] for consistent
/// styling and validation in the overall form structure. It supports flexible presentation modes via [PromptMode],
/// allowing compact popover overlays for quick inline editing or full-screen dialogs for detailed time input in complex forms.
/// Key features include customizable popover positioning and alignment to fit various layouts, support for 24-hour format
/// to match user preferences, optional seconds display for precise timing needs, and automatic conversion of selected
/// [TimeOfDay] to [DateTime] for standardized storage in the form provider. This widget is particularly ideal for forms
/// requiring temporal inputs such as scheduling appointments, setting timers, or specifying event times, ensuring
/// accessibility, theme consistency, and smooth integration with other Arcane components like [ArcaneDateField] for
/// date-time combinations.
///
/// The widget retrieves the current [DateTime] value from the [ArcaneField] provider, extracts the time portion for display
/// in a [TimePicker], and updates the provider upon user selection or clearance, handling null values by reverting to the
/// provider's default. This enables optional fields and real-time validation within the form ecosystem.
///
/// Usage example:
/// ```dart
/// ArcaneTimeField(
///   mode: PromptMode.dialog,
///   onChanged: (time) {
///     // Handle time change, e.g., trigger validation or update related fields
///   },
///   showSeconds: true,
///   use24HourFormat: true,
///   dialogTitle: Text('Select Appointment Time'),
/// )
/// ```
class ArcaneTimeField extends StatelessWidget {
  /// The presentation mode for the time picker, of type [PromptMode], controlling whether it appears as a compact
  /// popover overlay or a full-screen dialog. This field defaults to [PromptMode.popover] for inline editing within
  /// forms to maintain user flow. Use [PromptMode.dialog] for more comprehensive time selection in complex forms or
  /// when additional contextual controls are beneficial. It influences how the underlying [TimePicker] is rendered
  /// relative to the [ArcaneFieldWrapper], impacting layout and interaction in the Arcane form system.
  final PromptMode mode;

  /// Optional callback of type [ValueChanged<TimeOfDay?>], triggered when the user selects or clears a time value.
  /// It receives the new [TimeOfDay] or null if cleared, enabling real-time form updates, custom validation logic,
  /// or notifications outside the [ArcaneField] provider. This field is useful for reactive behaviors, such as
  /// enabling/disabling dependent fields based on time selection in multi-step forms.
  final ValueChanged<TimeOfDay?>? onChanged;

  /// Alignment for the popover relative to its anchor, of type [AlignmentGeometry], useful for positioning the
  /// time picker in constrained layouts or responsive designs. If null, it defaults to the system's standard alignment.
  /// This field only applies in popover mode and helps ensure the [TimePicker] overlay does not obscure important
  /// form elements within the [ArcaneFieldWrapper].
  final AlignmentGeometry? popoverAlignment;

  /// Alignment of the popover's anchor point, of type [AlignmentGeometry], fine-tuning how the time picker attaches
  /// to the field widget. Commonly used to adjust for edge cases in responsive designs or when the field is positioned
  /// near screen boundaries. This parameter is exclusive to popover mode and enhances usability in the Arcane UI.
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Padding applied inside the popover container, of type [EdgeInsetsGeometry], providing breathing room around the
  /// time picker UI elements. It helps prevent cramped interfaces on smaller screens or in dense forms. If null,
  /// defaults to standard padding; customize for themed spacing in conjunction with [ArcaneFieldWrapper] styles.
  final EdgeInsetsGeometry? popoverPadding;

  /// Flag to enable 24-hour time format (e.g., 14:30) instead of 12-hour with AM/PM, of type [bool?].
  /// When null, it respects the device's locale preferences for cultural consistency. Explicitly setting this ensures
  /// uniform display across users in the Arcane form system, particularly useful for international applications.
  final bool? use24HourFormat;

  /// Determines whether the time picker includes seconds in the selection interface, of type [bool], defaulting to false.
  /// Set to true for precise timing requirements like alarms or logs; false suits general use cases such as event scheduling.
  /// This field affects the granularity of input in the [TimePicker] and subsequent [DateTime] storage via the provider.
  final bool showSeconds;

  /// Custom title widget displayed at the top of the dialog when using dialog mode, of type [Widget?].
  /// It allows adding branding, contextual instructions, or icons, such as "Select Meeting Time", to guide users.
  /// This field is ignored in popover mode and enhances the immersive experience in [PromptMode.dialog] within forms.
  final Widget? dialogTitle;

  /// Constructs an [ArcaneTimeField] instance with the provided configuration parameters.
  ///
  /// This const constructor initializes the widget for efficient rebuilding in Flutter. All popover-related parameters
  /// ([popoverAlignment], [popoverAnchorAlignment], [popoverPadding]) apply only in [PromptMode.popover] and allow
  /// precise control over the overlay's placement and spacing relative to the [ArcaneFieldWrapper]. The [use24HourFormat]
  /// and [showSeconds] fields customize the time input's format and granularity for user preferences. [dialogTitle] is
  /// exclusively used in [PromptMode.dialog] to set a header widget for better context. The widget automatically
  /// retrieves and updates the form value via the associated [ArcaneField<DateTime>] provider, ensuring seamless
  /// integration without manual state management.
  ///
  /// Parameters include defaults for common use cases, promoting consistency in Arcane forms. For example, setting
  /// [mode] to [PromptMode.dialog] is ideal for mobile where full-screen input improves accuracy.
  const ArcaneTimeField(
      {super.key,
      this.mode = PromptMode.popover,
      this.onChanged,
      this.popoverAlignment,
      this.popoverAnchorAlignment,
      this.popoverPadding,
      this.use24HourFormat,
      this.showSeconds = false,
      this.dialogTitle});

  /// Builds the widget tree for the time field, encapsulating a [TimePicker] within an [ArcaneFieldWrapper]
  /// for consistent form styling, validation, and state management.
  ///
  /// This method retrieves the current [DateTime] value from the [ArcaneField<DateTime>] provider in the widget context,
  /// converts it to [TimeOfDay] for display if available, or uses the provider's default value. It constructs the
  /// [TimePicker] with all configured parameters (e.g., [mode], [use24HourFormat], [showSeconds]) and passes an
  /// [onChanged] callback that updates the provider with the selected time converted back to [DateTime], or the default
  /// if cleared. The wrapper ensures the field integrates with the broader form UI, applying metadata like placeholders
  /// and error states. Returns a [Widget] that handles null values gracefully, making it robust for optional time inputs.
  ///
  /// No side effects beyond provider updates; the build is pure and efficient for Flutter's declarative paradigm.
  @override
  Widget build(BuildContext context) {
    ArcaneField<DateTime> field = context.pylon<ArcaneField<DateTime>>();
    return ArcaneFieldWrapper<DateTime>(
        builder: (context) => TimePicker(
            popoverAlignment: popoverAlignment,
            popoverAnchorAlignment: popoverAnchorAlignment,
            popoverPadding: popoverPadding,
            use24HourFormat: use24HourFormat,
            showSeconds: showSeconds,
            dialogTitle: dialogTitle,
            mode: mode,
            onChanged: (v) => field.provider.setValue(field.meta.effectiveKey,
                v?.toDateTime() ?? field.provider.defaultValue),
            value: TimeOfDay.fromDateTime(field.provider.subject.valueOrNull ??
                field.provider.defaultValue)));
  }
}

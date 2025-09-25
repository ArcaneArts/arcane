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

/// A stateful form field for text input in the Arcane form system, supporting multi-line editing and auto-save on blur.
///
/// This class extends [StatefulWidget] and manages a [TextField] wrapped in [ArcaneFieldWrapper], handling focus-based
/// auto-save functionality and placeholder display derived from field metadata. It is optimized for string-based inputs
/// such as descriptions, notes, comments, or longer textual content, with configurable minimum and maximum lines to
/// emulate textarea behavior in forms. Integrates tightly with [ArcaneField<String>] for provider-managed state,
/// validation, and real-time updates, ensuring data persistence without explicit user actions.
///
/// The widget initializes a [TextEditingController] with the current form value and attaches a [FocusNode] listener
/// to save changes automatically when focus is lost, promoting a seamless editing experience. It supports expansion
/// for multi-line input while respecting form constraints, making it versatile for various text-heavy UI scenarios
/// in the Arcane ecosystem, such as user profiles or feedback sections.
///
/// Usage example:
/// ```dart
/// ArcaneStringField(
///   minLines: 3,
///   maxLines: 5,
///   // Metadata like placeholder set via ArcaneField configuration
/// )
/// ```
class ArcaneStringField extends StatefulWidget {
  /// Minimum number of lines to display in the text field, of type [int?], enabling multi-line input from the start.
  /// If null or 1, it behaves as a single-line field; higher values (e.g., 3) create an expandable textarea-like interface.
  /// This field controls the initial height of the [TextField] within the [ArcaneFieldWrapper], improving UX for
  /// expected longer inputs like addresses or messages in Arcane forms.
  final int? minLines;

  /// Maximum number of lines allowed for expansion, of type [int?], preventing overly long inputs that could disrupt
  /// form layout. If null, unlimited expansion is permitted, suitable for free-form notes; set a limit (e.g., 10) for
  /// controlled growth. This parameter applies to the [TextField]'s maxLines property, ensuring responsive design
  /// in conjunction with the form provider's validation rules.
  final int? maxLines;

  const ArcaneStringField({super.key, this.minLines, this.maxLines});

  /// Creates the state object for this [StatefulWidget], returning an instance of [_ArcaneStringFieldState].
  ///
  /// This method is part of Flutter's stateful widget lifecycle and instantiates the private state class responsible
  /// for managing the [TextEditingController], [FocusNode], and build logic. It enables the widget to maintain mutable
  /// state like text input and focus tracking, integrating with [ArcaneField<String>] for persistent form data.
  @override
  State<ArcaneStringField> createState() => _ArcaneStringFieldState();
}

/// Private state class for [ArcaneStringField], managing the text controller, focus handling,
/// and automatic save logic on blur events.
///
/// This class extends [State<ArcaneStringField>] and handles the mutable aspects of the text field, including
/// initialization of the [TextEditingController] with the current value from the [ArcaneField<String>] provider
/// and setting up a [FocusNode] listener to trigger saves when the user unfocuses the field. It ensures the
/// [TextField] accurately reflects and updates the form state, providing a smooth, auto-saving experience
/// without requiring manual commit actions. This internal management supports the declarative nature of
/// Arcane forms while handling imperative input events efficiently.
class _ArcaneStringFieldState extends State<ArcaneStringField> {
  /// Controller for the underlying [TextField], of type [TextEditingController], holding and editing the string value.
  /// It is initialized in [initState] with the current form value or an empty string if null,
  /// allowing direct text manipulation and display within the widget.
  late TextEditingController controller;

  /// Focus node for the text field, of type [FocusNode], used to detect blur events and trigger automatic saves.
  /// Attached in [initState] with a listener that calls [save] when focus is lost, ensuring changes are persisted
  /// to the [ArcaneField<String>] provider without user intervention, enhancing usability in form workflows.
  late FocusNode focusNode;

  /// Initializes the state by setting up the [controller] with the initial value from the [ArcaneField<String>] provider
  /// and attaching a [focusNode] listener to save on unfocus. This method is called once during the widget's lifecycle
  /// and ensures the text field starts with the correct content, integrating seamlessly with the form's state management.
  ///
  /// It retrieves the field via context, sets the controller text to the current value or empty, creates the focus node,
  /// and adds the listener for blur detection. Calls [super.initState()] to comply with Flutter's state lifecycle.
  /// No return value; side effect is preparing the input components for user interaction.
  @override
  void initState() {
    super.initState();
    controller =
        TextEditingController(text: field.provider.subject.valueOrNull ?? "");
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        save();
      }
    });
  }

  /// Saves the current text from the [controller] to the [ArcaneField<String>] provider using the field's effective key.
  ///
  /// This method is invoked automatically on focus loss via the [focusNode] listener or on editing complete, ensuring
  /// data persistence to the form provider without manual user actions. It calls [setValue] on the provider with
  /// the controller's text, updating the form state and potentially triggering validations or UI updates in related
  /// [ArcaneFieldWrapper] components. No parameters; no return value; side effect is form state update.
  void save() {
    field.provider.setValue(field.meta.effectiveKey, controller.text);
  }

  /// Getter for the current [ArcaneField<String>] instance from the widget's context.
  ///
  /// This computed property provides convenient access to the form provider and metadata for value management,
  /// placeholder display, and save operations. It uses [pylon] to retrieve the field, enabling the state to interact
  /// with the broader Arcane form system without direct dependencies. Returns an [ArcaneField<String>] instance;
  /// no side effects.
  ArcaneField<String> get field => context.pylon<ArcaneField<String>>();

  /// Builds the string field UI by wrapping a configurable [TextField] in [ArcaneFieldWrapper<String>].
  ///
  /// This method constructs the widget tree, applying [minLines] and [maxLines] for layout control, using the [controller]
  /// and [focusNode] for input management, and displaying a placeholder from metadata if it's a [String]. It triggers
  /// [save] on editing complete to persist changes. The wrapper ensures integration with form styling and validation.
  /// Returns a [Widget] that handles multi-line expansion and auto-save, suitable for various text input scenarios
  /// in Arcane forms. No side effects beyond standard build; efficient for Flutter's hot reload.
  @override
  Widget build(BuildContext context) => ArcaneFieldWrapper<String>(
      builder: (context) => TextField(
            controller: controller,
            focusNode: focusNode,
            minLines: widget.minLines,
            maxLines: widget.maxLines ?? 1,
            onEditingComplete: save,
            placeholder: field.meta.placeholder is String
                ? Text(field.meta.placeholder)
                : null,
          ));
}

/// Enumeration of display modes for the [ArcaneEnumField] widget in the Arcane form system.
///
/// This enum defines how enum options are presented to the user: as a compact dropdown for space-efficient selection
/// with many choices or interactive cards for fewer, more visual selections with 3 or fewer options. It is used
/// internally by [ArcaneEnumField] to automatically choose the optimal mode based on the number of [options], promoting
/// intuitive UX and layout efficiency. When unspecified, the field defaults to [dropdown] for >3 options and [cards]
/// for ≤3, balancing density and interactivity in forms integrated with [ArcaneFieldWrapper].
enum ArcaneEnumFieldType {
  /// Dropdown mode: Utilizes a [Select] popup menu for space-efficient selection, ideal for forms with 4 or more options.
  /// This variant minimizes vertical space in the [ArcaneFieldWrapper] while providing searchable or scrollable access
  /// to choices, suitable for long lists like categories or statuses in the Arcane UI.
  dropdown,

  /// Cards mode: Renders options as tappable [Card] widgets within a [CardCarousel], best suited for 3 or fewer options.
  /// This approach offers visual appeal and touch-friendly interaction, with built-in highlighting for the selected
  /// item, enhancing usability in compact forms alongside other components like [ArcaneBoolField].
  cards
}

/// Default item builder function for [ArcaneEnumField], converting enum values to simple [Text] widgets.
///
/// This top-level function, of type [Widget Function(BuildContext, T)], is used as a fallback when no custom
/// [itemBuilder] is provided in [ArcaneEnumField]. It displays the enum's string representation (e.g., 'Priority.low')
/// as plain text, ensuring consistent rendering for both dropdown and card modes without additional configuration.
/// It receives the [BuildContext] and the enum item [T extends Enum], returning a [Text] widget for direct use
/// in [SelectItemButton] or [Card] children. This promotes simplicity in form setup while allowing overrides
/// for icons or rich descriptions via custom builders in the Arcane form system.
Widget _defaultItemBuilder<T extends Enum>(BuildContext context, T item) =>
    Text(item.toString());

/// A versatile form field for selecting enum values in the Arcane UI system, supporting both dropdown and card-based interfaces.
///
/// This class extends [StatelessWidget] and wraps selection logic within [ArcaneFieldWrapper<T>], where T is an enum type,
/// updating the [ArcaneField<T>] provider upon choice. It automatically selects the display [mode] based on the number
/// of [options] (>3: [ArcaneEnumFieldType.dropdown], ≤3: [ArcaneEnumFieldType.cards]) for optimal user experience,
/// balancing space efficiency and visual interactivity. Custom [itemBuilder] and [cardBuilder] functions allow tailored
/// rendering, such as adding icons, descriptions, or colors to options, making it perfect for categorical inputs like
/// priority levels, statuses, or themes in forms. In card mode, the selected option is highlighted with borders for
/// immediate feedback, integrating smoothly with other Arcane components like [ArcaneStringField] for hybrid forms.
///
/// The widget retrieves the current enum value from the provider, renders the UI accordingly (e.g., [Select] for dropdown
/// or [CardCarousel] for cards), and handles updates with null fallback to default. It supports dynamic sizing in dropdowns
/// via stacked invisible items for accurate popup width, ensuring responsive design.
///
/// Usage example:
/// ```dart
/// enum Priority { low, medium, high }
///
/// ArcaneEnumField<Priority>(
///   options: Priority.values,
///   itemBuilder: (context, priority) => Text(priority.name.toUpperCase()),
///   cardBuilder: (context, priority, selected) => Card(
///     // Custom styling based on selection
///     child: Text(priority.name),
///   ),
///   mode: ArcaneEnumFieldType.dropdown,
/// )
/// ```
class ArcaneEnumField<T extends Enum> extends StatelessWidget {
  /// Optional mode override for enum display, of type [ArcaneEnumFieldType?]; if null, auto-selects
  /// [ArcaneEnumFieldType.dropdown] for more than 3 [options] or [ArcaneEnumFieldType.cards] for 3 or fewer,
  /// optimizing for screen space and interaction style in the [ArcaneFieldWrapper]. This field allows explicit
  /// control when auto-detection does not match UX needs, such as forcing cards for visual emphasis in simple forms.
  final ArcaneEnumFieldType? mode;

  /// Required list of selectable enum instances, of type [List<T>], covering all relevant choices for the field.
  /// Expects non-empty, unique values for proper functionality; used to populate the dropdown items or card carousel.
  /// The length influences auto-mode selection, integrating with [ArcaneField<T>] for validation of selected values.
  final List<T> options;

  /// Custom builder for rendering individual enum items in both dropdown and cards modes, of type
  /// [Widget Function(BuildContext, T)?]. Receives the [BuildContext] and item; defaults to [_defaultItemBuilder]
  /// which shows the enum name as [Text]. This enables rich UIs like icons or formatted descriptions in Arcane forms.
  final Widget Function(BuildContext, T)? itemBuilder;

  /// Specialized builder for card mode only, of type [Widget Function(BuildContext, T, T)?], receiving context,
  /// the option, and current selected value. It enables visual feedback such as borders, colors, or icons for the
  /// active selection; if null, falls back to [itemBuilder]. This field enhances interactivity in [CardCarousel]
  /// within the [ArcaneFieldWrapper], ideal for touch-based selections.
  final Widget Function(BuildContext, T, T)? cardBuilder;

  /// Constructs an [ArcaneEnumField<T>] instance with the specified configuration for enum selection.
  ///
  /// This const constructor supports generic enum types T and initializes fields for mode, options, and builders.
  /// The [options] list is required and drives the UI generation; [mode] can be null for auto-selection based
  /// on length. Custom [itemBuilder] and [cardBuilder] allow flexible rendering, while the widget integrates
  /// with [ArcaneField<T>] provider for state persistence. Defaults promote ease of use, e.g., auto-mode for
  /// varying option counts, ensuring compatibility with form validation and theming in Arcane.
  const ArcaneEnumField(
      {super.key,
      this.mode,
      required this.options,
      this.itemBuilder,
      this.cardBuilder});

  /// Builds the enum selection UI based on the configured [mode], rendering either a themed [Select] dropdown
  /// or a [CardCarousel] of interactive cards, wrapped in [ArcaneFieldWrapper<T>].
  ///
  /// This method retrieves the current [T] value from the [ArcaneField<T>] provider, determines the mode (auto if null),
  /// and constructs the appropriate widget tree. For dropdown, it uses a [Card] container with [Select<T>] , applying
  /// a stacked [itemBuilder] for dynamic popup sizing via [PopoverConstraint.anchorMaxSize], and populates [SelectPopup]
  /// with [SelectItemButton] children. For cards, it creates a [CardCarousel] with tappable [Card] widgets, using
  /// [cardBuilder] or fallback, highlighting the selected with border and color from theme. On change, updates provider
  /// with new value or default if null. Returns a [Widget] optimized for form integration; no side effects beyond
  /// provider sets; efficient with const elements where possible.
  @override
  Widget build(BuildContext context) {
    ArcaneField<T> field = context.pylon<ArcaneField<T>>();
    return ArcaneFieldWrapper<T>(
        builder: (context) => switch (mode ??
                (options.length > 3
                    ? ArcaneEnumFieldType.dropdown
                    : ArcaneEnumFieldType.cards)) {
              ArcaneEnumFieldType.dropdown => Card(
                  padding: EdgeInsetsGeometry.zero,
                  borderColor: Colors.transparent,
                  borderWidth: 0,
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.card.withOpacity(0.5),
                  child: Select<T>(
                    itemBuilder: (context, item) {
                      return Stack(
                        children: [
                          ...options
                              .where((e) => e.name.length > item.name.length)
                              .map((e) => Opacity(
                                  opacity: 0,
                                  child: itemBuilder?.call(context, e) ??
                                      Text(e.name))),
                          itemBuilder?.call(context, item) ?? Text(item.name)
                        ],
                      );
                    },
                    popupWidthConstraint: PopoverConstraint.anchorMaxSize,
                    onChanged: (value) => field.provider.setValue(
                        field.meta.effectiveKey,
                        value ?? field.provider.defaultValue),
                    value: field.provider.subject.valueOrNull ??
                        field.provider.defaultValue,
                    popup: SelectPopup(
                      items: SelectItemList(
                        children: [
                          ...options.map((i) => SelectItemButton(
                                value: i,
                                child: itemBuilder?.call(context, i) ??
                                    Text(i.name),
                              )),
                        ],
                      ),
                    ).call,
                  ),
                ),
              ArcaneEnumFieldType.cards => CardCarousel(
                  featherColor: Theme.of(context).colorScheme.card,
                  children: [
                    ...options
                        .map((e) =>
                            cardBuilder?.call(
                                context,
                                e,
                                field.provider.subject.valueOrNull ??
                                    field.provider.defaultValue) ??
                            Card(
                              filled: true,
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .card
                                  .withOpacity(0.5),
                              borderWidth:
                                  field.provider.subject.valueOrNull == e
                                      ? 2
                                      : null,
                              borderColor:
                                  field.provider.subject.valueOrNull == e
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5)
                                      : null,
                              onPressed: () => field.provider
                                  .setValue(field.meta.effectiveKey, e),
                              child:
                                  itemBuilder?.call(context, e) ?? Text(e.name),
                            ))
                        .whereType<Widget>()
                        .joinSeparator(Gap(8))
                  ],
                )
            });
  }
}

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

/// Stateful form field for interactive color selection in Arcane forms, powered by [ColorInput] for spectrum tools.
///
/// This class extends [StatefulWidget] and supports alpha transparency editing, screen color picking (if enabled),
/// and throttled updates to optimize performance during live dragging or adjustments. It wraps the input in
/// [ArcaneFieldWrapper<Color>], converting [ColorDerivative] changes to [Color] for storage in the [ArcaneField<Color>]
/// provider. Suited for theme customization, design tools, branding inputs, or any color-based form fields, with
/// configurable popover or dialog modes for versatility across devices. The stateful nature allows immediate visual
/// feedback while debouncing provider writes to prevent excessive rebuilds.
///
/// Usage example:
/// ```dart
/// ArcaneColorField(
///   showAlpha: true,
///   allowPickFromScreen: true,
///   writeThrottle: Duration(milliseconds: 500),
///   mode: PromptMode.dialog,
/// )
/// ```
class ArcaneColorField extends StatefulWidget {
  /// Mode for color input display, of type [PromptMode], popover for quick access or dialog for full tools like sliders.
  /// Defaults to [PromptMode.popover] for inline form editing; use dialog for precise adjustments in complex UIs.
  final PromptMode mode;

  /// Title widget for dialog mode, of type [Widget?], e.g., Text('Select Brand Color') for context.
  /// Ignored in popover; enhances guidance in immersive [ColorInput] sessions within [ArcaneFieldWrapper].
  final Widget? dialogTitle;

  /// Popover alignment relative to the field, of type [AlignmentGeometry?], for precise overlay placement in layouts.
  /// Applies in popover mode; null uses default to avoid overlaps with other form elements.
  final AlignmentGeometry? popoverAlignment;

  /// Anchor alignment for the popover's attachment, of type [AlignmentGeometry?], fine-tuning position over the input.
  /// Exclusive to [PromptMode.popover]; improves usability on varied screen sizes.
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Padding within the popover container, of type [EdgeInsetsGeometry?], spacing around color tools for readability.
  /// Customizes internal layout; defaults to standard if null.
  final EdgeInsetsGeometry? popoverPadding;

  /// Enables alpha channel editing for transparent colors, of type [bool?]; false omits opacity controls in [ColorInput].
  /// When true, allows RGBA selection; null uses default based on context, useful for design forms in Arcane.
  final bool? showAlpha;

  /// Allows picking colors directly from the screen using system tools, of type [bool?], if platform supports it.
  /// Enables eyedropper functionality in [ColorInput]; set false to restrict to manual input for security.
  final bool? allowPickFromScreen;

  /// Duration for throttling color change callbacks, of type [Duration], preventing rapid provider updates during interactions.
  /// Defaults to 1 second for balanced responsiveness; shorter (e.g., 500ms) for real-time previews, longer for performance.
  final Duration writeThrottle;

  const ArcaneColorField(
      {super.key,
      this.writeThrottle = const Duration(seconds: 1),
      this.allowPickFromScreen,
      this.mode = PromptMode.popover,
      this.dialogTitle,
      this.popoverAlignment,
      this.popoverAnchorAlignment,
      this.popoverPadding,
      this.showAlpha});

  /// Creates the state object for this [StatefulWidget], returning an instance of [_ArcaneColorFieldState].
  ///
  /// Part of Flutter's lifecycle; instantiates the private state class responsible for managing [ColorDerivative] values
  /// during interactive editing while throttling writes to prevent excessive rebuilds.
  @override
  State<ArcaneColorField> createState() => _ArcaneColorFieldState();
}

/// Internal state management class for [ArcaneColorField], tracking the live [ColorDerivative] during user editing.
///
/// This class extends [State<ArcaneColorField>] and handles initialization from the [ArcaneField<Color>] provider,
/// immediate UI updates via [setState], and throttled provider writes using a leaky throttle to balance performance
/// and responsiveness. It maintains the current color state separately for smooth dragging in [ColorInput], converting
/// to [Color] only on debounced commits. This separation ensures efficient form updates without lag, supporting
/// features like alpha and screen picking in the Arcane UI system.
class _ArcaneColorFieldState extends State<ArcaneColorField> {
  /// Current color being manipulated during editing, of type [ColorDerivative], providing access to RGB, HSL, and alpha values.
  /// Initialized in [initState] from the provider's [Color] value; updated on [ColorInput] changes for immediate feedback,
  /// then debounced to [toColor()] for provider storage. This field enables full-spectrum editing in the widget.
  late ColorDerivative currentColor;

  /// Initializes the state by deriving the initial [currentColor] from the form provider's [Color] value or default.
  ///
  /// Called once in the lifecycle; retrieves [ArcaneField<Color>] via context, converts value to [ColorDerivative],
  /// and calls [super.initState()]. Prepares for interactive editing; no return value, side effect is state setup.
  @override
  void initState() {
    ArcaneField<Color> field = context.pylon<ArcaneField<Color>>();
    currentColor = ColorDerivative.fromColor(
        field.provider.subject.valueOrNull ?? field.provider.defaultValue);
    super.initState();
  }

  /// Builds the color input UI using [ColorInput] wrapped in [ArcaneFieldWrapper<Color>], applying throttling to [onChanged].
  ///
  /// This method retrieves the [ArcaneField<Color>] , configures [ColorInput] with widget params (e.g., [showAlpha],
  /// [mode]), and sets [onChanged] to update local [currentColor] immediately via [setState] for responsiveness,
  /// then throttles provider set with [toColor()] using [writeThrottle] duration and leaky mode for performance.
  /// Shows labels for clarity; returns a [Widget] for live color preview and editing, integrated with form validation.
  /// Side effects: state updates and debounced provider writes; optimized for frequent interactions.
  @override
  Widget build(BuildContext context) {
    ArcaneField<Color> field = context.pylon<ArcaneField<Color>>();
    return ArcaneFieldWrapper<Color>(
        builder: (context) => ColorInput(
            showLabel: true,
            showAlpha: widget.showAlpha,
            dialogTitle: widget.dialogTitle,
            popoverAlignment: widget.popoverAlignment,
            popoverAnchorAlignment: widget.popoverAnchorAlignment,
            popoverPadding: widget.popoverPadding,
            allowPickFromScreen: widget.allowPickFromScreen,
            mode: widget.mode,
            onChanged: (v) {
              setState(() {
                currentColor = v;
              });

              throttle("colorPicker${widget.key?.hashCode ?? -1}.$identityHash",
                  () {
                field.provider.setValue(field.meta.effectiveKey, v.toColor());
              }, leaky: true, cooldown: widget.writeThrottle);
            },
            color: currentColor));
  }
}

/// Compact boolean toggle field for Arcane forms, rendered as a [Checkbox] with metadata-driven labeling and animation.
///
/// This class extends [StatelessWidget] and provides a space-efficient toggle for boolean values, overriding the default
/// tile scaffold for inline placement within larger forms via [ArcaneFieldWrapper<bool>]. It features animated green
/// check confirmation on toggle to true for visual feedback and optional description display below the checkbox.
/// Integrates directly with [ArcaneField<bool>] for state management, suitable for flags, preferences,
/// or yes/no inputs like "Enable notifications". The minimal column layout ensures it fits seamlessly alongside
/// other fields like [ArcaneStringField] without disrupting form flow.
///
/// The widget uses the provider value to set [CheckboxState], applies icon/name from metadata, and updates on change,
/// with fade animations for the check icon to enhance interactivity in the Arcane UI.
///
/// Usage example:
/// ```dart
/// ArcaneBoolField(), // Relies on ArcaneField meta for name, icon, description
/// ```
class ArcaneBoolField extends StatelessWidget {
  /// Constructs the minimal boolean field widget without arguments.
  ///
  /// This static packed constructor maintains the widgets' default behavior, activating from the [ArcaneField<bool>]
  /// provider's value with no additional configuration. It seamlessly fits as an on/off choice in compact form layouts,
  /// handling checkbox state and theming via [ArcaneFieldWrapper] integration.
  const ArcaneBoolField({super.key});

  /// Builds the boolean field UI as a minimal [Column] with [Checkbox] and optional description, wrapped in [ArcaneFieldWrapper<bool>].
  ///
  /// This method retrieves the [ArcaneField<bool>] and current value, constructs a [Row] for the checkbox with gap:0,
  /// incorporating metadata icon and name as [Text.xSmall], followed by an animated [Icon(Icons.check, green)] that
  /// fades in on true (1s easeOutCirc) and out after delay (3s). Sets [CheckboxState] based on value, with [onChanged]
  /// updating provider to bool equivalent. If description in meta, adds muted [Text.xSmall] below. Overrides tile scaffold
  /// for inline rendering; returns [Widget] for compact toggle; side effects: provider update on tap; animated for UX.
  @override
  Widget build(BuildContext context) {
    ArcaneField<bool> field = context.pylon<ArcaneField<bool>>();
    return ArcaneFieldWrapper<bool>(
        overrideTileScaffold: true,
        builder: (context) {
          bool v = context.pylon<bool>();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: Checkbox(
                          gap: 0,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (field.meta.icon != null)
                                Icon(field.meta.icon!).padRight(4),
                              if (field.meta.name != null) ...[
                                Flexible(child: Text(field.meta.name!).xSmall),
                                Gap(8)
                              ],
                              Icon(Icons.check, size: 12, color: Colors.green)
                                  .animate(key: ValueKey(v))
                                  .fadeIn(
                                      duration: 1.seconds,
                                      curve: Curves.easeOutCirc,
                                      begin: 0)
                                  .fadeOut(
                                      delay: 1.seconds,
                                      begin: 1,
                                      duration: 3.seconds,
                                      curve: Curves.easeOutCirc)
                            ],
                          ).padOnly(top: 8, left: 8, bottom: 8),
                          state: v
                              ? CheckboxState.checked
                              : CheckboxState.unchecked,
                          onChanged: (v) {
                            field.provider.setValue(field.meta.effectiveKey,
                                v == CheckboxState.checked);
                          }))
                ],
              ),
              if (field.meta.description != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Text(field.meta.description!).xSmall.muted)
                  ],
                ).padBottom(8)
            ],
          );
        });
  }
}

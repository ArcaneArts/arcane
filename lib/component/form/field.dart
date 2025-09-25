import 'package:arcane/arcane.dart';

/// A utility class providing static factory methods to create specialized [ArcaneField] instances
/// for common input types in the Arcane UI component system. This class simplifies the creation
/// of form fields for handling user input such as colors, dates, times, booleans, enums, and text.
/// It integrates with the [Form] and [FieldWrapper] components to provide a consistent form-building
/// experience in Flutter applications using the Arcane framework.
///
/// Key features:
/// - Supports direct getter/setter providers for reactive data binding.
/// - Configurable metadata for field labeling and icons.
/// - Specialized builders for each input type, ensuring proper UI rendering and interaction.
/// - Defaults to [PromptMode.popover] for non-intrusive input dialogs.
///
/// Usage example:
/// ```dart
/// ArcaneInput.text(
///   name: 'Username',
///   getter: () => _usernameFuture(),
///   setter: (value) => _setUsername(value),
/// )
/// ```

class ArcaneInput {
  const ArcaneInput._();

  /// Creates a color input field that allows users to select and set a [Color] value.
  /// This field uses a color picker interface, supporting popover or dialog modes for selection.
  /// It fits into the Arcane form system by providing visual color input with optional alpha channel
  /// and screen picking capabilities, often wrapped in a [FieldWrapper] for consistent styling.
  ///
  /// Parameters:
  /// - [name]: Optional display name for the field.
  /// - [description]: Optional descriptive text for the field.
  /// - [icon]: Optional icon to display alongside the field.
  /// - [defaultValue]: Initial color value if none provided by the getter.
  /// - [getter]: Asynchronous function to retrieve the current color value.
  /// - [setter]: Asynchronous function to update the color value.
  /// - [mode]: Display mode for the color picker ([PromptMode.popover] by default).
  /// - [dialogTitle]: Custom title widget for the dialog if used.
  /// - [popoverAlignment], [popoverAnchorAlignment], [popoverPadding]: Positioning and padding for popover mode.
  /// - [showAlpha]: Whether to include alpha channel in the picker (default: false).
  /// - [allowPickFromScreen]: Enable screen color picking (default: false).
  /// - [writeThrottle]: Delay for write operations to prevent excessive updates (default: 1 second).
  ///
  /// Returns: An [ArcaneField<Color>] configured for color input.
  static ArcaneField color({
    String? name,
    String? description,
    IconData? icon,
    Color? defaultValue,
    required Future<Color> Function() getter,
    required Future Function(Color) setter,
    PromptMode mode = PromptMode.popover,
    Widget? dialogTitle,
    AlignmentGeometry? popoverAlignment,
    AlignmentGeometry? popoverAnchorAlignment,
    EdgeInsetsGeometry? popoverPadding,
    bool? showAlpha,
    bool? allowPickFromScreen,
    Duration writeThrottle = const Duration(seconds: 1),
  }) =>
      ArcaneField<Color>(
          meta: ArcaneFieldMetadata(
            name: name,
            description: description,
            icon: icon,
          ),
          provider: ArcaneFieldDirectProvider(
              defaultValue: defaultValue ?? Colors.black,
              getter: (_) => getter(),
              setter: (_, v) => setter(v)),
          builder: (context) => ArcaneColorField(
                popoverAlignment: popoverAlignment,
                popoverAnchorAlignment: popoverAnchorAlignment,
                popoverPadding: popoverPadding,
                showAlpha: showAlpha,
                allowPickFromScreen: allowPickFromScreen,
                writeThrottle: writeThrottle,
                dialogTitle: dialogTitle,
                mode: mode,
              ));

  /// Creates a date input field for selecting and setting [DateTime] values.
  /// This field integrates a calendar view for date selection, supporting popover or full dialog modes.
  /// It is designed for use within [Form] components in the Arcane UI system, allowing customization
  /// of the initial calendar view and state building for dynamic date displays.
  ///
  /// Parameters:
  /// - [name]: Optional display name for the field.
  /// - [description]: Optional descriptive text.
  /// - [icon]: Optional icon for the field.
  /// - [defaultValue]: Initial date (defaults to current date if null).
  /// - [getter]: Async function to fetch the current date.
  /// - [setter]: Async function to update the date.
  /// - [mode]: Picker mode ([PromptMode.popover] default).
  /// - [initialViewType]: Starting calendar view type (e.g., day, month).
  /// - [dialogTitle]: Custom dialog title widget.
  /// - [initialView]: Pre-configured calendar view.
  /// - [popoverAlignment], [popoverAnchorAlignment], [popoverPadding]: Popover positioning.
  /// - [stateBuilder]: Custom builder for date state display.
  ///
  /// Returns: An [ArcaneField<DateTime>] for date input.
  static ArcaneField date({
    String? name,
    String? description,
    IconData? icon,
    DateTime? defaultValue,
    required Future<DateTime> Function() getter,
    required Future Function(DateTime) setter,
    PromptMode mode = PromptMode.popover,
    CalendarViewType? initialViewType,
    Widget? dialogTitle,
    CalendarView? initialView,
    AlignmentGeometry? popoverAlignment,
    AlignmentGeometry? popoverAnchorAlignment,
    EdgeInsetsGeometry? popoverPadding,
    DateStateBuilder? stateBuilder,
  }) =>
      ArcaneField<DateTime>(
          meta: ArcaneFieldMetadata(
            name: name,
            description: description,
            icon: icon,
          ),
          provider: ArcaneFieldDirectProvider(
              defaultValue: defaultValue ?? DateTime.now(),
              getter: (_) => getter(),
              setter: (_, v) => setter(v)),
          builder: (context) => ArcaneDateField(
                mode: mode,
                initialViewType: initialViewType,
                dialogTitle: dialogTitle,
                initialView: initialView,
                popoverAlignment: popoverAlignment,
                popoverAnchorAlignment: popoverAnchorAlignment,
                popoverPadding: popoverPadding,
                stateBuilder: stateBuilder,
              ));

  /// Creates a time input field for selecting and setting [DateTime] values focused on time components.
  /// This field uses a time picker interface, configurable for 12/24-hour format and seconds display.
  /// It complements date fields in [Form] setups within the Arcane component library, enabling precise
  /// time entry via popover or dialog.
  ///
  /// Parameters:
  /// - [name]: Optional field name.
  /// - [description]: Optional description.
  /// - [icon]: Optional icon.
  /// - [defaultValue]: Initial time (defaults to now if null).
  /// - [getter]: Async current time retriever.
  /// - [setter]: Async time updater.
  /// - [mode]: Display mode (default: popover).
  /// - [onChanged]: Callback for time changes.
  /// - [popoverAlignment], [popoverAnchorAlignment], [popoverPadding]: Popover config.
  /// - [use24HourFormat]: Use 24-hour format (default: platform default).
  /// - [showSeconds]: Include seconds (default: false).
  /// - [dialogTitle]: Custom title for dialog.
  ///
  /// Returns: An [ArcaneField<DateTime>] for time input.
  static ArcaneField time({
    String? name,
    String? description,
    IconData? icon,
    DateTime? defaultValue,
    required Future<DateTime> Function() getter,
    required Future Function(DateTime) setter,
    PromptMode mode = PromptMode.popover,
    ValueChanged<TimeOfDay?>? onChanged,
    AlignmentGeometry? popoverAlignment,
    AlignmentGeometry? popoverAnchorAlignment,
    EdgeInsetsGeometry? popoverPadding,
    bool? use24HourFormat,
    bool showSeconds = false,
    Widget? dialogTitle,
  }) =>
      ArcaneField<DateTime>(
          meta: ArcaneFieldMetadata(
            name: name,
            description: description,
            icon: icon,
          ),
          provider: ArcaneFieldDirectProvider(
              defaultValue: defaultValue ?? DateTime.now(),
              getter: (_) => getter(),
              setter: (_, v) => setter(v)),
          builder: (context) => ArcaneTimeField(
                mode: mode,
                onChanged: onChanged,
                popoverAlignment: popoverAlignment,
                popoverAnchorAlignment: popoverAnchorAlignment,
                popoverPadding: popoverPadding,
                use24HourFormat: use24HourFormat,
                showSeconds: showSeconds,
                dialogTitle: dialogTitle,
              ));

  /// Creates a boolean checkbox input field for toggling true/false values.
  /// This simple toggle widget is ideal for binary options in forms, integrating seamlessly
  /// with [FieldWrapper] and [Form] in the Arcane UI ecosystem for consistent boolean input handling.
  ///
  /// Parameters:
  /// - [name]: Optional name.
  /// - [description]: Optional description.
  /// - [icon]: Optional icon.
  /// - [defaultValue]: Initial boolean state (default: false).
  /// - [getter]: Async boolean getter.
  /// - [setter]: Async boolean setter.
  ///
  /// Returns: An [ArcaneField<bool>] using [ArcaneBoolField] builder.
  static ArcaneField checkbox(
          {String? name,
          String? description,
          IconData? icon,
          bool defaultValue = false,
          required Future<bool> Function() getter,
          required Future Function(bool) setter}) =>
      ArcaneField<bool>(
          meta: ArcaneFieldMetadata(
            name: name,
            description: description,
            icon: icon,
          ),
          provider: ArcaneFieldDirectProvider(
              defaultValue: defaultValue,
              getter: (_) => getter(),
              setter: (_, v) => setter(v)),
          builder: (context) => ArcaneBoolField());

  /// Creates an enum selection field for choosing from a list of enum values.
  /// Supports various modes like dropdown or cards, with customizable builders for items and cards.
  /// This field is a core part of Arcane's form input system, allowing typed enum selection
  /// within [Form] widgets, often wrapped by [FieldWrapper] for enhanced UX.
  ///
  /// Parameters:
  /// - [name]: Optional name.
  /// - [description]: Optional description.
  /// - [icon]: Optional icon.
  /// - [mode]: Selection mode (e.g., dropdown, cards).
  /// - [itemBuilder]: Builder for individual enum items.
  /// - [cardBuilder]: Builder for card-based selection previews.
  /// - [defaultValue]: Required initial enum value.
  /// - [options]: Required list of available enum options.
  /// - [getter]: Async enum getter.
  /// - [setter]: Async enum setter.
  ///
  /// Returns: An [ArcaneField<T>] using [ArcaneEnumField] builder.
  static ArcaneField select<T extends Enum>(
          {String? name,
          String? description,
          IconData? icon,
          ArcaneEnumFieldType? mode,
          Widget Function(BuildContext, T)? itemBuilder,
          Widget Function(BuildContext, T, T)? cardBuilder,
          required T defaultValue,
          required List<T> options,
          required Future<T> Function() getter,
          required Future Function(T) setter}) =>
      ArcaneField<T>(
          meta: ArcaneFieldMetadata(
            name: name,
            description: description,
            icon: icon,
          ),
          provider: ArcaneFieldDirectProvider(
              defaultValue: defaultValue,
              getter: (_) => getter(),
              setter: (_, v) => setter(v)),
          builder: (context) => ArcaneEnumField<T>(
                options: options,
                mode: mode,
                itemBuilder: itemBuilder,
                cardBuilder: cardBuilder,
              ));

  /// Convenience method to create a dropdown-style enum selection field.
  /// Delegates to [select] with [ArcaneEnumFieldType.dropdown] mode, providing a compact
  /// dropdown menu for enum choices in Arcane forms.
  ///
  /// Parameters: Same as [select], with mode fixed to dropdown.
  ///
  /// Returns: An [ArcaneField<T>] configured for dropdown enum selection.
  static ArcaneField selectDropdown<T extends Enum>(
          {String? name,
          String? description,
          IconData? icon,
          Widget Function(BuildContext, T)? itemBuilder,
          Widget Function(BuildContext, T, T)? cardBuilder,
          required T defaultValue,
          required List<T> options,
          required Future<T> Function() getter,
          required Future Function(T) setter}) =>
      select<T>(
          mode: ArcaneEnumFieldType.dropdown,
          getter: getter,
          setter: setter,
          name: name,
          options: options,
          defaultValue: defaultValue,
          icon: icon,
          itemBuilder: itemBuilder,
          cardBuilder: cardBuilder,
          description: description);

  /// Convenience method to create a card-based enum selection field.
  /// Delegates to [select] with [ArcaneEnumFieldType.cards] mode, displaying enum options
  /// as selectable cards for a more visual selection experience in Arcane UI forms.
  ///
  /// Parameters: Same as [select], with mode fixed to cards.
  ///
  /// Returns: An [ArcaneField<T>] configured for card enum selection.
  static ArcaneField selectCards<T extends Enum>(
          {String? name,
          String? description,
          IconData? icon,
          Widget Function(BuildContext, T)? itemBuilder,
          Widget Function(BuildContext, T, T)? cardBuilder,
          required T defaultValue,
          required List<T> options,
          required Future<T> Function() getter,
          required Future Function(T) setter}) =>
      select<T>(
          mode: ArcaneEnumFieldType.cards,
          getter: getter,
          setter: setter,
          name: name,
          options: options,
          defaultValue: defaultValue,
          icon: icon,
          itemBuilder: itemBuilder,
          cardBuilder: cardBuilder,
          description: description);

  /// Creates a text input field for string values, supporting single or multi-line input.
  /// This is a fundamental text entry widget in the Arcane form system, configurable for
  /// line constraints and placeholders, typically used within [FieldWrapper] for labeled inputs.
  ///
  /// Parameters:
  /// - [name]: Optional name.
  /// - [description]: Optional description.
  /// - [icon]: Optional icon.
  /// - [placeholder]: Hint text for empty input.
  /// - [minLines], [maxLines]: Line constraints for the text field.
  /// - [defaultValue]: Initial string (default: empty).
  /// - [getter]: Async string getter.
  /// - [setter]: Async string setter.
  ///
  /// Returns: An [ArcaneField<String>] using [ArcaneStringField] builder.
  static ArcaneField<String> text(
          {String? name,
          String? description,
          IconData? icon,
          String? placeholder,
          int? minLines,
          int? maxLines,
          String defaultValue = "",
          required Future<String> Function() getter,
          required Future Function(String) setter}) =>
      ArcaneField<String>(
          meta: ArcaneFieldMetadata(
            name: name,
            description: description,
            icon: icon,
            placeholder: placeholder,
          ),
          provider: ArcaneFieldDirectProvider(
              defaultValue: defaultValue,
              getter: (_) => getter(),
              setter: (_, v) => setter(v)),
          builder: (context) => ArcaneStringField(
                minLines: minLines,
                maxLines: maxLines,
              ));

  /// Convenience method for creating a multi-line text area input.
  /// Delegates to [text] with default min/max lines suitable for longer text entry,
  /// ideal for descriptions or notes in Arcane forms.
  ///
  /// Parameters: Same as [text], with [minLines] default 3 and [maxLines] default 6.
  ///
  /// Returns: An [ArcaneField<String>] configured as a text area.
  static ArcaneField<String> textArea(
          {String? name,
          String? description,
          IconData? icon,
          String? placeholder,
          int? minLines = 3,
          int? maxLines = 6,
          String defaultValue = "",
          required Future<String> Function() getter,
          required Future Function(String) setter}) =>
      ArcaneInput.text(
          getter: getter,
          setter: setter,
          name: name,
          description: description,
          icon: icon,
          placeholder: placeholder,
          minLines: minLines,
          maxLines: maxLines,
          defaultValue: defaultValue);
}

/// A generic form field widget in the Arcane UI component system, representing a single input
/// element that can be bound to data via providers. [ArcaneField] wraps a custom builder
/// with metadata for labeling and icons, integrating with [Form] and [FieldWrapper] to create
/// reactive, typed input fields. It uses the Pylon pattern for efficient rebuilding on data changes.
///
/// Key features:
/// - Type-safe with generic [T] for data binding.
/// - Supports custom builders for diverse input UIs (e.g., [ArcaneColorField], [ArcaneStringField]).
/// - Metadata-driven for consistent field presentation.
/// - Stateless for performance in form layouts.
///
/// Usage example:
/// ```dart
/// ArcaneField<String>(
///   meta: ArcaneFieldMetadata(name: 'Email'),
///   provider: ArcaneFieldDirectProvider(getter: _getEmail, setter: _setEmail),
///   builder: (context) => ArcaneStringField(),
/// )
/// ```

class ArcaneField<T> extends StatelessWidget {
  /// Metadata associated with this field, including name, description, icon, and placeholder.
  /// Used for rendering labels and hints in the UI, typically displayed via [FieldWrapper].
  final ArcaneFieldMetadata meta;

  /// Provider responsible for managing the field's data state, including default value,
  /// getter for current value, and setter for updates. Enables reactive binding in forms.
  final ArcaneFieldProvider<T> provider;

  /// Custom builder function that constructs the actual input widget based on the field context.
  /// Allows for specialized UIs like color pickers or text inputs while maintaining field consistency.
  final PylonBuilder builder;

  /// Returns the runtime type of the field's data [T], useful for dynamic type checking
  /// or serialization in form processing.
  Type get dataRuntimeType => T;

  /// Constructs an [ArcaneField] with required metadata, provider, and builder.
  ///
  /// Parameters:
  /// - [key]: Standard Flutter widget key.
  /// - [meta]: Required field metadata for UI presentation.
  /// - [provider]: Required data provider for value management.
  /// - [builder]: Required builder for the input widget.
  const ArcaneField({
    super.key,
    required this.meta,
    required this.provider,
    required this.builder,
  });

  /// Builds the field widget using the Pylon pattern for efficient, reactive rendering.
  /// Wraps the custom [builder] with the field's value, enabling context-aware input UIs
  /// that respond to data changes without full rebuilds.
  ///
  /// Returns: The rendered input widget.
  @override
  Widget build(BuildContext context) => Pylon<ArcaneField<T>>(
        value: this,
        builder: builder,
      );
}

/// Metadata class holding descriptive information for an [ArcaneField], used to customize
/// its appearance and behavior in forms. This class provides keys, labels, icons, and placeholders
/// that integrate with [FieldWrapper] for labeled, iconified inputs in the Arcane UI system.
///
/// Key features:
/// - Generates effective keys from name if not provided.
/// - Supports dynamic placeholders for input hints.
/// - Immutable design for safe reuse across fields.
class ArcaneFieldMetadata {
  /// Unique identifier for the field, used in form processing or storage.
  /// If null, derived from [name] via lowercase, space-to-underscore replacement.
  final String? key;

  /// Human-readable name for the field, displayed as a label in UI components like [FieldWrapper].
  final String? name;

  /// Descriptive text explaining the field's purpose, shown as help text or tooltips.
  final String? description;

  /// Icon to visually represent the field type, enhancing UX in form layouts.
  final IconData? icon;

  /// Placeholder value or widget for empty input states, guiding user entry.
  final dynamic placeholder;

  /// Constructs metadata with optional parameters for flexible field description.
  ///
  /// Parameters:
  /// - [name]: Field display name.
  /// - [key]: Explicit unique key (overrides auto-generation).
  /// - [icon]: Icon for the field.
  /// - [description]: Help text.
  /// - [placeholder]: Input placeholder.
  const ArcaneFieldMetadata({
    this.name,
    this.key,
    this.icon,
    this.description,
    this.placeholder,
  });

  /// Computes an effective key for the field, prioritizing [key], then transforming [name]
  /// (lowercase, spaces to underscores, slashes to dots), defaulting to "no_key".
  /// Used for identification in forms or data serialization.
  String get effectiveKey =>
      key ??
      name?.toLowerCase().replaceAll(' ', '_').replaceAll("/", ".") ??
      "no_key";
}

import 'package:arcane/arcane.dart';

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

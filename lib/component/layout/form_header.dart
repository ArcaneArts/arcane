import 'package:arcane/arcane.dart';

/// A header component for forms in the Arcane UI system, providing a structured layout for labeling and displaying form elements.
///
/// This [StatelessWidget] creates a minimal vertical column that starts with a small-sized label text, followed by a small gap, and then the provided child widget.
/// It is designed for use in form sections to clearly delineate field groups or input areas, integrating seamlessly with [ArcaneField], [FieldWrapper], and other form-related components.
/// Key features include compact sizing for better space utilization in forms and support for any [Widget] as the child, allowing flexibility in form design.
/// Usage example: Wrap a [TextField] or [Selector] with [FormHeader] to provide contextual labeling within a [Section] or [Carpet] layout.
class FormHeader extends StatelessWidget {
  final String label;
  final Widget child;

  /// Creates a [FormHeader] with a required label and child widget.
  ///
  /// The [label] is displayed as small text at the top, providing context for the [child], which can be any form input like [TextField] or [ArcaneField].
  /// This constructor ensures the header is compact and aligns content to the start, respecting [ArcaneTheme] spacing and typography.
  const FormHeader({super.key, required this.label, required this.child});

  @override

  /// Builds the [FormHeader] as a [Column] with minimal size and start alignment.
  ///
  /// Renders the label using [Text] with small styling, adds a [Gap] of 8 units for spacing, and includes the [child] widget.
  /// This method handles the layout logic to ensure proper vertical stacking without excess space, suitable for embedding in larger form structures like [Section] or [Flow].
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Name").small,
          Gap(8),
          child,
        ],
      );
}

/// A specialized form field widget that combines [FormHeader] with a [TextField] for labeled text input in Arcane forms.
///
/// This [StatelessWidget] extends the basic header functionality by integrating a configurable [TextField], making it ideal for simple text-based inputs within form layouts.
/// It supports standard text field features like controllers, focus management, change callbacks, and line constraints, while maintaining the labeled structure for better UX.
/// Use this in conjunction with [ArcaneFieldProvider] or [FieldWrapper] to handle form state, and it aligns with [ArcaneTheme] for consistent styling.
/// Example: Employ [FormHeaderField] in a [Section] to create self-contained input blocks that include both label and editable field.
class FormHeaderField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final int? minLines;

  /// Constructs a [FormHeaderField] with required label and hint, plus optional text field configurations.
  ///
  /// The [label] sets the header text, while [hint] provides placeholder guidance in the [TextField].
  /// Optional parameters like [controller], [focusNode], [onChanged], [maxLines], and [minLines] allow customization of input behavior and appearance.
  /// This enables integration with form validation or state management systems, such as those using [ArcaneField] or reactive patterns in Arcane apps.
  const FormHeaderField(
      {super.key,
      required this.label,
      required this.hint,
      this.controller,
      this.focusNode,
      this.onChanged,
      this.maxLines,
      this.minLines});

  @override

  /// Builds the [FormHeaderField] by composing a [FormHeader] with an embedded [TextField].
  ///
  /// Delegates the label to [FormHeader] and configures the [TextField] with provided options, using [Text] for the placeholder.
  /// This method ensures the input field is properly spaced and labeled, facilitating easy inclusion in broader form UIs like [Carpet] or [ButtonPanel] sections.
  Widget build(BuildContext context) => FormHeader(
        label: label,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          placeholder: Text(hint),
          onChanged: onChanged,
          maxLines: maxLines,
          minLines: minLines,
        ),
      );
}

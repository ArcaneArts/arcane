import 'package:arcane/arcane.dart';

/// A versatile selector widget for single-item selection from a predefined list,
/// providing a dropdown-like interface with customizable labels and optional
/// unselect capability.
///
/// This component is designed for use in forms and input sections within the
/// Arcane UI system, integrating seamlessly with [ArcaneField], [FieldWrapper],
/// and [ArcaneFieldProvider] for state management. It displays selected values
/// via [MutableText] and presents options in a popup similar to [PopupMenu],
/// but optimized for simple list selections. Use it when users need to choose
/// one option from a set, such as categories or statuses, and pair it with
/// [Search] for larger datasets or [CycleButton] for inline alternatives.
class Selector<T> extends StatelessWidget {
  final bool canUnselect;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final List<T> values;
  final String Function(T) labelBuilder;

  /// Initializes the [Selector] with required values list and label builder,
  /// along with optional current value, change callback, and unselect flag.
  ///
  /// The constructor sets up the widget's state immutably, using the provided
  /// labelBuilder to generate display text for each item. If canUnselect is true,
  /// users can clear the selection by tapping the current value; otherwise,
  /// selection persists until changed. This supports integration with form
  /// providers like [ArcaneFieldProvider] for reactive updates.
  const Selector(
      {super.key,
      this.canUnselect = false,
      this.value,
      this.onChanged,
      required this.values,
      required this.labelBuilder});

  @override

  /// Builds the selector interface using a [Select] widget that triggers a
  /// popup on interaction, rendering each option as a [SelectItemButton]
  /// within a [SurfaceCard] for elevated presentation.
  ///
  /// The method maps the values list to interactive buttons using the
  /// labelBuilder for text content, applies the current value and change
  /// handler for state management, and constrains the popup width to the
  /// anchor element's size via PopoverConstraint.anchorFixedSize. This
  /// ensures responsive behavior in layouts like [Section] or alongside
  /// [IconButton] for enhanced input experiences, with theme-aware styling
  /// from [ArcaneTheme].
  Widget build(BuildContext context) => Select<T>(
      itemBuilder: (context, item) => Text(labelBuilder(item)),
      value: value,
      onChanged: onChanged,
      popupWidthConstraint: PopoverConstraint.anchorFixedSize,
      canUnselect: canUnselect,
      popup: (context) => SurfaceCard(
              child: Column(
            children: [
              ...values.map((e) =>
                  SelectItemButton(value: e, child: Text(labelBuilder(e))))
            ],
          )));
}

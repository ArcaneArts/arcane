import 'package:arcane/arcane.dart';

/// A horizontal row of selectable radio cards for single-selection UI in Arcane applications.
///
/// [RadioCards] provides a compact, card-based radio button interface where each option is rendered
/// via a customizable builder function. It integrates with [RadioGroup] for state management and
/// uses [RadioCard] widgets for individual selections, styled according to [ArcaneTheme].
///
/// Key features:
/// - Supports generic type T for flexible data binding.
/// - Centers items horizontally with minimal padding via [PaddingHorizontal].
/// - Handles selection changes via callback, ensuring mutually exclusive choices.
///
/// Usage example:
/// ```dart
/// RadioCards<String>(
///   items: ['Option A', 'Option B'],
///   value: selected,
///   onChanged: (v) => setState(() => selected = v),
///   builder: (item) => Text(item),
/// )
/// ```
///
/// This component is ideal for settings panels, filters, or forms requiring mutually exclusive choices,
/// often placed within [Section] or [Gutter] layouts for structured presentation.
class RadioCards<T> extends StatelessWidget {
  final Widget Function(T) builder;
  final void Function(T) onChanged;
  final List<T> items;
  final T? value;

  /// Creates a [RadioCards] widget.
  ///
  /// The [builder] function renders each item as a child of [RadioCard], allowing custom UI for options.
  /// [onChanged] is invoked when a selection is made, passing the newly selected value for state updates.
  /// [items] is the list of selectable options to display as radio cards.
  /// [value] is the currently selected item, or null if none is selected, determining the active state.
  ///
  /// Initializes a centered [Row] of [RadioCard] widgets wrapped in [RadioGroup] for unified selection handling,
  /// with [PaddingHorizontal] applied for spacing between cards.
  const RadioCards({
    super.key,
    required this.builder,
    required this.onChanged,
    required this.items,
    this.value,
  });

  /// Builds the radio cards interface as a [StatelessWidget].
  ///
  /// Constructs a [RadioGroup] to manage selection state, containing a [Row] with [MainAxisAlignment.center]
  /// and [CrossAxisAlignment.center] for centered layout. Maps each item in [items] to a [RadioCard]
  /// using the [builder] function, wrapped in [PaddingHorizontal] for consistent spacing.
  ///
  /// On selection change, invokes [onChanged] with the new value. Returns the complete widget tree
  /// for integration into Arcane UI flows, such as within [Section] or form layouts.
  @override
  Widget build(BuildContext context) => RadioGroup<T>(
        value: value,
        onChanged: (v) => onChanged(v),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: items
              .map((item) => PaddingHorizontal(
                  padding: 4,
                  child: RadioCard(
                    value: item,
                    child: builder(item),
                  )))
              .toList(),
        ),
      );
}

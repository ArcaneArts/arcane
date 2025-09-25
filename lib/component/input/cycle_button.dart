import 'package:arcane/arcane.dart';

/// A button that cycles through a list of values with each press.
///
/// The [CycleButton] allows you to define a set of values and cycle through them
/// by pressing the button. Each press will advance to the next value in the cycle
/// and trigger the [onChanged] callback with the new value.
///
/// When the end of the cycle is reached, it will loop back to the first value.
///
/// This widget integrates with [IconButton] for the base interaction and supports
/// various [ButtonStyle] variants through named constructors. The [builder]
/// function enables custom widgets like [Icon] or [MutableText] for each state,
/// making it versatile for input components in forms or toolbars alongside
/// [ArcaneInput] or [GestureDetector] for enhanced touch handling.
///
/// Example usage:
/// ```dart
/// CycleButton<int>(
///   values: {
///     1: Icon(Icons.list),
///     2: Icon(Icons.grid_view),
///     3: Icon(Icons.dashboard),
///   },
///   initialValue: 1,
///   onChanged: (value) {
///     // Update UI based on the value
///     setState(() {
///       displayMode = value;
///     });
///   },
/// )
/// ```
class CycleButton<T> extends StatefulWidget {
  /// The list of values to cycle through, where each [T] represents a state
  /// (e.g., enum, int, or custom object) that determines the button's appearance
  /// and behavior via the [builder].
  ///
  /// Must contain at least one value, and the [initialValue] must be present.
  /// The cycle wraps around after the last value back to the first.
  final List<T> values;

  /// A builder function that constructs the widget (e.g., [Icon], [MutableText])
  /// displayed inside the [IconButton] for the current value.
  ///
  /// Called with the [BuildContext] and current [T] value, allowing dynamic
  /// rendering based on the state. This enables integration with themed components
  /// like those from [ArcaneTheme].
  ///
  /// Example: `(context, value) => Icon(Icons.star if value == true else Icons.star_border)`
  final Widget Function(BuildContext, T) builder;

  /// The starting value in the [values] list when the [CycleButton] is first built.
  ///
  /// Determines the initial widget shown via [builder]. If the [values] list changes
  /// and this value is no longer present, the button resets to this initial value
  /// to maintain valid state.
  final T initialValue;

  /// Optional callback invoked whenever the cycled value changes, passing the new [T] value.
  ///
  /// Use this to update parent state, trigger rebuilds, or integrate with providers
  /// like [ArcaneFieldProvider] in form contexts. No side effects occur if null.
  final Function(T value)? onChanged;

  /// The style of the button.
  final ButtonStyle style;

  /// Size of the button (small, normal, large).
  final ButtonSize size;

  /// Density/padding of the button.
  final ButtonDensity density;

  /// Shape of the button (rectangle, rounded, circle).
  final ButtonShape shape;

  /// Focus node for controlling button focus.
  final FocusNode? focusNode;

  /// Whether to disable transition animations.
  final bool disableTransition;

  /// Function called when hover state changes.
  final ValueChanged<bool>? onHover;

  /// Function called when focus state changes.
  final ValueChanged<bool>? onFocus;

  /// Whether to enable tap feedback.
  final bool? enableFeedback;

  /// Creates a [CycleButton] with the given values and callbacks.
  ///
  /// Initializes a generic [CycleButton] using the provided [style], which defaults
  /// to [ButtonStyle.ghost()] for subtle input toggling. The [values] list must
  /// have at least one entry, and [initialValue] must exist within it to ensure
  /// valid starting state.
  ///
  /// Suitable for custom styling in input scenarios, such as cycling visibility
  /// modes in a [ArcaneInput] toolbar. Assertions enforce non-empty [values]
  /// and valid [initialValue] at construction time, preventing runtime errors.
  ///
  /// Usage example:
  /// ```dart
  /// CycleButton<String>(
  ///   values: ['off', 'low', 'high'],
  ///   initialValue: 'off',
  ///   builder: (context, value) => Text(value.toUpperCase()),
  ///   style: ButtonStyle.outline(),
  ///   onChanged: (newValue) => print('Switched to $newValue'),
  /// )
  /// ```
  CycleButton({
    super.key,
    required this.values,
    required this.builder,
    required this.initialValue,
    this.onChanged,
    this.style = const ButtonStyle.ghost(),
    this.size = ButtonSize.normal,
    this.density = ButtonDensity.icon,
    this.shape = ButtonShape.rectangle,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
    this.enableFeedback,
  })  : assert(values.isNotEmpty, 'Values map must not be empty'),
        assert(values.contains(initialValue),
            'Initial value must be a key in the values map');

  /// Creates a primary-styled [CycleButton].
  ///
  /// Initializes the [CycleButton] with [ButtonStyle.primary()], providing a
  /// prominent appearance suitable for main action toggles, like mode selection
  /// in primary navigation or [ArcaneField] controls.
  ///
  /// All other parameters behave as in the default constructor. The fixed [style]
  /// ensures consistent primary theming from [ArcaneTheme], with assertions
  /// validating [values] and [initialValue].
  ///
  /// Usage: Ideal for high-visibility cycles, e.g., toggling between [IconButton]
  /// states in a toolbar.
  CycleButton.primary({
    super.key,
    required this.values,
    required this.builder,
    required this.initialValue,
    this.onChanged,
    this.size = ButtonSize.normal,
    this.density = ButtonDensity.icon,
    this.shape = ButtonShape.rectangle,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
    this.enableFeedback,
  })  : style = const ButtonStyle.primary(),
        assert(values.isNotEmpty, 'Values map must not be empty'),
        assert(values.contains(initialValue),
            'Initial value must be a key in the values map');

  /// Creates a secondary-styled [CycleButton].
  ///
  /// Initializes the [CycleButton] with [ButtonStyle.secondary()], for less
  /// prominent toggles, such as secondary options in dialogs or [MutableText]
  /// format cycling.
  ///
  /// Parameters follow the default constructor, with fixed secondary styling.
  /// Assertions ensure data integrity at construction.
  CycleButton.secondary({
    super.key,
    required this.values,
    required this.builder,
    required this.initialValue,
    this.onChanged,
    this.size = ButtonSize.normal,
    this.density = ButtonDensity.icon,
    this.shape = ButtonShape.rectangle,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
    this.enableFeedback,
  })  : style = const ButtonStyle.secondary(),
        assert(values.isNotEmpty, 'Values map must not be empty'),
        assert(values.contains(initialValue),
            'Initial value must be a key in the values map');

  /// Creates an outlined [CycleButton].
  ///
  /// Initializes the [CycleButton] with [ButtonStyle.outline()], offering a
  /// bordered look for clear boundaries in dense UIs, like cycling options
  /// in [radio_cards] or form inputs.
  ///
  /// Standard parameter handling with outline-specific theming.
  CycleButton.outline({
    super.key,
    required this.values,
    required this.builder,
    required this.initialValue,
    this.onChanged,
    this.size = ButtonSize.normal,
    this.density = ButtonDensity.icon,
    this.shape = ButtonShape.rectangle,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
    this.enableFeedback,
  })  : style = const ButtonStyle.outline(),
        assert(values.isNotEmpty, 'Values map must not be empty'),
        assert(values.contains(initialValue),
            'Initial value must be a key in the values map');

  /// Creates a ghost-styled [CycleButton].
  ///
  /// Initializes the [CycleButton] with [ButtonStyle.ghost()], for minimal
  /// visual impact, perfect for subtle state changes in [glass] overlays
  /// or background toggles.
  ///
  /// Matches default parameter semantics with ghost transparency.
  CycleButton.ghost({
    super.key,
    required this.values,
    required this.builder,
    required this.initialValue,
    this.onChanged,
    this.size = ButtonSize.normal,
    this.density = ButtonDensity.icon,
    this.shape = ButtonShape.rectangle,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
    this.enableFeedback,
  })  : style = const ButtonStyle.ghost(),
        assert(values.isNotEmpty, 'Values map must not be empty'),
        assert(values.contains(initialValue),
            'Initial value must be a key in the values map');

  /// Creates a destructive [CycleButton].
  ///
  /// Initializes the [CycleButton] with [ButtonStyle.destructive()], using
  /// warning colors for risky cycles, such as delete mode toggles in
  /// [delete_icon_button] integrations.
  ///
  /// Parameter validation and behavior as per default, with destructive styling.
  CycleButton.destructive({
    super.key,
    required this.values,
    required this.builder,
    required this.initialValue,
    this.onChanged,
    this.size = ButtonSize.normal,
    this.density = ButtonDensity.icon,
    this.shape = ButtonShape.rectangle,
    this.focusNode,
    this.disableTransition = false,
    this.onHover,
    this.onFocus,
    this.enableFeedback,
  })  : style = const ButtonStyle.destructive(),
        assert(values.isNotEmpty, 'Values map must not be empty'),
        assert(values.contains(initialValue),
            'Initial value must be a key in the values map');

  @override
  State<CycleButton<T>> createState() => _CycleButtonState<T>();
}

/// The private state manager for [CycleButton], handling value cycling,
/// initialization, and widget updates.
///
/// Manages the current value index, responds to [values] list changes by
/// resetting if necessary, and builds the underlying [IconButton] with
/// the [builder]-generated icon. Integrates [ButtonStyle] properties for
/// consistent theming and interaction feedback.
class _CycleButtonState<T> extends State<CycleButton<T>> {
  /// The currently active value from the [CycleButton.values] list.
  ///
  /// Initialized to [CycleButton.initialValue] and updated on each cycle.
  /// Handles null safety implicitly as [T] is non-nullable, and value is
  /// always valid per assertions and reset logic in [didUpdateWidget].
  late T _currentValue;

  /// Initializes the state by setting the current value to the widget's
  /// [CycleButton.initialValue].
  ///
  /// Called once when the [CycleButton] is inserted into the tree.
  /// No side effects beyond state setup; subsequent cycles trigger
  /// [setState] via [_cycleToNextValue].
  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  /// Responds to changes in the parent [CycleButton] widget properties.
  ///
  /// Specifically monitors [CycleButton.values] for additions/removals.
  /// If the current [_currentValue] is no longer in the updated list,
  /// resets to [CycleButton.initialValue] to ensure valid state and
  /// trigger a rebuild if needed. No callback invocation here.
  ///
  /// This prevents invalid states during dynamic updates, e.g., when
  /// conditionally showing/hiding cycle options in a [ArcaneInput] form.
  @override
  void didUpdateWidget(CycleButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.values != widget.values) {
      // If the current value is no longer in the values, reset to initial value
      if (!widget.values.contains(_currentValue)) {
        _currentValue = widget.initialValue;
      }
    }
  }

  /// Advances the cycle to the next value in [CycleButton.values] and
  /// updates the state.
  ///
  /// Computes the next index modulo the list length for wrapping.
  /// Calls [setState] to rebuild with the new [builder] output, and
  /// invokes [CycleButton.onChanged] with the new value if provided,
  /// enabling parent notifications (e.g., updating a [ArcaneField]).
  ///
  /// Side effects: Triggers UI rebuild and optional callback; no error
  /// handling as indices are always valid.
  void _cycleToNextValue() {
    final currentIndex = widget.values.indexOf(_currentValue);
    final nextIndex = (currentIndex + 1) % widget.values.length;
    setState(() {
      _currentValue = widget.values[nextIndex];
    });
    widget.onChanged?.call(_currentValue);
  }

  /// Builds the [IconButton] representation of the [CycleButton].
  ///
  /// Renders the current [_currentValue] via [CycleButton.builder] as the icon,
  /// passing through all [ButtonStyle], size, density, shape, and interaction
  /// properties from the parent [CycleButton]. The [onPressed] is wired to
  /// [_cycleToNextValue] for cycling on tap.
  ///
  /// Integrates seamlessly with [ArcaneTheme] for styling and [GestureDetector]
  /// behaviors via focus/hover callbacks. Returns a fully interactive button
  /// widget ready for input contexts.
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: widget.builder(context, _currentValue),
      variance: widget.style.variance,
      size: widget.size,
      density: widget.density,
      shape: widget.shape,
      focusNode: widget.focusNode,
      disableTransition: widget.disableTransition,
      onHover: widget.onHover,
      onFocus: widget.onFocus,
      enableFeedback: widget.enableFeedback,
      onPressed: _cycleToNextValue,
    );
  }
}

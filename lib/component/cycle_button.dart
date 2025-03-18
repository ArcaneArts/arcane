import 'package:arcane/arcane.dart';

/// A button that cycles through a list of values with each press.
///
/// The [CycleButton] allows you to define a set of values and cycle through them
/// by pressing the button. Each press will advance to the next value in the cycle
/// and trigger the [onChanged] callback with the new value.
///
/// When the end of the cycle is reached, it will loop back to the first value.
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
  /// Map of values to their corresponding icons/widgets.
  final Map<T, Widget> values;

  /// The initial value to start with.
  final T initialValue;

  /// Called when the value changes.
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
  /// The [values] map must have at least one entry.
  /// The [initialValue] must be a key in the [values] map.
  CycleButton({
    super.key,
    required this.values,
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
        assert(values.containsKey(initialValue),
            'Initial value must be a key in the values map');

  /// Creates a primary-styled [CycleButton].
  CycleButton.primary({
    super.key,
    required this.values,
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
        assert(values.containsKey(initialValue),
            'Initial value must be a key in the values map');

  /// Creates a secondary-styled [CycleButton].
  CycleButton.secondary({
    super.key,
    required this.values,
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
        assert(values.containsKey(initialValue),
            'Initial value must be a key in the values map');

  /// Creates an outlined [CycleButton].
  CycleButton.outline({
    super.key,
    required this.values,
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
        assert(values.containsKey(initialValue),
            'Initial value must be a key in the values map');

  /// Creates a ghost-styled [CycleButton].
  CycleButton.ghost({
    super.key,
    required this.values,
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
        assert(values.containsKey(initialValue),
            'Initial value must be a key in the values map');

  /// Creates a destructive [CycleButton].
  CycleButton.destructive({
    super.key,
    required this.values,
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
        assert(values.containsKey(initialValue),
            'Initial value must be a key in the values map');

  @override
  State<CycleButton<T>> createState() => _CycleButtonState<T>();
}

class _CycleButtonState<T> extends State<CycleButton<T>> {
  late T _currentValue;
  late List<T> _orderedKeys;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _orderedKeys = widget.values.keys.toList();
  }

  @override
  void didUpdateWidget(CycleButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.values != widget.values) {
      _orderedKeys = widget.values.keys.toList();
      // If the current value is no longer in the values, reset to initial value
      if (!widget.values.containsKey(_currentValue)) {
        _currentValue = widget.initialValue;
      }
    }
  }

  void _cycleToNextValue() {
    final currentIndex = _orderedKeys.indexOf(_currentValue);
    final nextIndex = (currentIndex + 1) % _orderedKeys.length;
    setState(() {
      _currentValue = _orderedKeys[nextIndex];
    });
    widget.onChanged?.call(_currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: widget.values[_currentValue]!,
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

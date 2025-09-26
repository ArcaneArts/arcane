import 'package:arcane/arcane.dart';

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

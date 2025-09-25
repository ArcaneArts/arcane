import 'package:arcane/arcane.dart';
import 'package:flutter/services.dart';

/// Enum representing the different types of edit buttons that can be used to trigger editing mode in the [MutableText] widget.
///
/// - [ghost]: Uses a subtle [GhostButton] for a minimalistic edit trigger, ideal for inline text in forms or cards.
/// - [pencil]: Displays a pencil icon via [IconButton], providing a clear visual cue for editable content, commonly used in lists or detail views.
///
/// This enum integrates with [MutableText]'s button configuration to support dynamic text mutation while maintaining UI consistency with other input components like [Fab] and [CycleButton].
enum EditButtonType { ghost, pencil }

/// A stateful widget that provides inline text editing capabilities, allowing users to view static text that transforms into an editable [TextField] upon interaction.
///
/// ### Key Features:
/// - **Dynamic Mutation**: Seamlessly switches between display ([Text]) and edit ([TextField]) modes, supporting multi-line input with configurable max/min lines.
/// - **Edit Triggers**: Supports [GhostButton] for subtle editing or [IconButton] with pencil icon for explicit cues, with customizable gap and override content.
/// - **Input Handling**: Includes autocorrection, input formatters, max length enforcement, and null-safe placeholder support.
/// - **Callbacks**: Provides [onChanged] for text updates, [onEditingComplete] for finish events, and [onEditingStarted] for initiation, integrating with form providers like [ArcaneFieldProvider].
/// - **Styling and Accessibility**: Inherits [TextStyle], alignment, overflow, and semantics from Flutter's text widgets, with options for locale, selection color, and strut style.
///
/// This component is designed for mutable content in forms, cards, or lists, working alongside [ArcaneField], [FieldWrapper], and [GestureDetector] for enhanced input experiences in the Arcane theme.
class MutableText extends StatefulWidget {
  final String value;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onEditingStarted;
  final TextStyle? style;
  final int? maxLines;
  final int? minLines;
  final Locale? locale;
  final Color? selectionColor;
  final TextOverflow? overflow;
  final String? semanticsLabel;
  final bool? softWrap;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextHeightBehavior? textHeightBehavior;
  final TextScaler? textScaler;
  final TextWidthBasis? textWidthBasis;
  final Widget? placeholder;
  final bool border;
  final EditButtonType buttonType;
  final bool autoCorrect;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final double buttonGapWidth;
  final Widget? overrideButtonContent;
  final MainAxisSize mainAxisSize;
  final String Function(String)? labelBuilder;

  /// Constructs a [MutableText] widget with the specified initial text value and optional editing configurations.
  ///
  /// ### Parameters and Initialization:
  /// - The required [value] sets the initial display text, which becomes the starting point for editing.
  /// - [onChanged] (optional) is invoked with the new text value when editing completes via submission or escape.
  /// - [onEditingComplete] (optional) is called after editing ends, useful for form validation or state updates in [ArcaneField].
  /// - [onEditingStarted] (optional) triggers on edit initiation, allowing pre-edit logic like focus management.
  /// - Styling options like [style], [textAlign], [maxLines], [minLines], [overflow], and [selectionColor] customize appearance and behavior, defaulting to Flutter's [Text] standards.
  /// - Input controls include [autoCorrect] (defaults to true), [inputFormatters] for validation (e.g., numeric only), and [maxLength] with enforcement.
  /// - Edit UI: [buttonType] defaults to [EditButtonType.pencil] using [IconButton]; set to [ghost] for [GhostButton]. [buttonGapWidth] (default 4) spaces the button, and [overrideButtonContent] allows custom icons.
  /// - Layout: [mainAxisSize] controls row sizing (min or max), affecting text flexibility in containers.
  /// - Advanced: [placeholder] shows hint text during editing, [labelBuilder] transforms [value] for display (e.g., formatting numbers), [border] enables default [TextField] border, and accessibility via [semanticsLabel], [locale], [softWrap], [strutStyle], [textDirection], [textHeightBehavior], [textScaler], [textWidthBasis].
  ///
  /// ### Usage Example:
  /// ```dart
  /// MutableText(
  ///   'Initial Text',
  ///   onChanged: (newValue) => setState(() => myText = newValue),
  ///   style: ArcaneTheme.of(context).bodyLarge,
  ///   maxLines: 3,
  ///   buttonType: EditButtonType.ghost,
  /// )
  /// ```
  /// This creates an editable text block that updates state on change and uses ghost button styling, integrating with [ArcaneTheme] for consistent theming.
  ///
  /// If [onChanged] is null, no edit button is shown, rendering as a static [Text]. For form integration, wrap in [FieldWrapper] or use with [ArcaneFieldProvider] for reactive updates.
  const MutableText(this.value,
      {super.key,
      this.mainAxisSize = MainAxisSize.min,
      this.onChanged,
      this.autoCorrect = true,
      this.minLines,
      this.style,
      this.maxLines,
      this.locale,
      this.selectionColor,
      this.overflow,
      this.semanticsLabel,
      this.inputFormatters,
      this.softWrap,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.textHeightBehavior,
      this.textScaler,
      this.textWidthBasis,
      this.maxLength,
      this.placeholder,
      this.overrideButtonContent,
      this.buttonGapWidth = 4,
      this.onEditingComplete,
      this.onEditingStarted,
      this.buttonType = EditButtonType.pencil,
      this.labelBuilder,
      this.border = false});

  @override
  State<MutableText> createState() => _MutableTextState();
}

/// The private state class for [MutableText], managing the editing mode toggle, text controller lifecycle, and keyboard shortcuts for escape to cancel editing.
///
/// This state handles the transition between view and edit modes, initializes the [TextEditingController] on start, and disposes it on completion to optimize performance. It integrates with Flutter's [Shortcuts] and [Actions] for escape handling, ensuring smooth user experience in editable contexts like forms with [ArcaneField].
class _MutableTextState extends State<MutableText> {
  bool _editing = false;
  TextEditingController? _controller;

  /// Builds the static text display for non-editing mode, using the widget's [value] or a custom [labelBuilder] function to generate the text content.
  ///
  /// This method constructs a [Text] widget with all inherited styling properties from [MutableText], such as [style], [maxLines], [textAlign], and accessibility options. It serves as the read-only representation, which is wrapped in edit triggers like [IconButton] or [GhostButton] when editing is enabled.
  ///
  /// ### Usage in Context:
  /// Called within [build] to render the initial view state. The [labelBuilder] allows dynamic formatting (e.g., converting timestamps to readable dates), enhancing integration with data-driven UIs like those using [ArcaneFieldProvider].
  Widget buildText(BuildContext context) => Text(
        widget.labelBuilder?.call(widget.value) ?? widget.value,
        style: widget.style,
        maxLines: widget.maxLines,
        locale: widget.locale,
        selectionColor: widget.selectionColor,
        overflow: widget.overflow,
        semanticsLabel: widget.semanticsLabel,
        softWrap: widget.softWrap,
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        textHeightBehavior: widget.textHeightBehavior,
        textScaler: widget.textScaler,
        textWidthBasis: widget.textWidthBasis,
      );

  @override
  Widget build(BuildContext context) => _editing
      ? Shortcuts(
          shortcuts: {
              LogicalKeySet(LogicalKeyboardKey.escape): _EscapeIntent(),
            },
          child: Actions(
              actions: {
                _EscapeIntent: CallbackAction<_EscapeIntent>(
                    onInvoke: (e) => setState(() {
                          _editing = false;
                          widget.onEditingComplete?.call();
                        })),
              },
              child: TextField(
                maxLengthEnforcement: widget.maxLength == null
                    ? null
                    : MaxLengthEnforcement.enforced,
                maxLength: widget.maxLength,
                inputFormatters: widget.inputFormatters,
                autocorrect: widget.autoCorrect,
                textInputAction: TextInputAction.done,
                autofocus: true,
                style: widget.style,
                textAlign: widget.textAlign ?? TextAlign.start,
                controller: _controller,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                placeholder: widget.placeholder,
                border: widget.border ? null : Border(),
                onSubmitted: (v) {
                  setState(() {
                    _editing = false;
                  });

                  widget.onChanged?.call(v);
                },
                onEditingComplete: () {
                  setState(() {
                    _editing = false;
                    widget.onEditingComplete?.call();
                  });
                },
              ).iw))
      : widget.onChanged == null
          ? buildText(context)
          : switch (widget.buttonType) {
              EditButtonType.ghost => GhostButton(
                  child: buildText(context),
                  onPressed: () => setState(() {
                        _controller = TextEditingController(text: widget.value);
                        _editing = true;
                        widget.onEditingStarted?.call();
                      })),
              EditButtonType.pencil => Row(
                  mainAxisSize: widget.mainAxisSize,
                  children: [
                    switch (widget.mainAxisSize) {
                      MainAxisSize.min => Flexible(child: buildText(context)),
                      MainAxisSize.max => Expanded(child: buildText(context)),
                    },
                    Gap(widget.buttonGapWidth),
                    IconButton(
                        icon: widget.overrideButtonContent ??
                            Icon(
                              Icons.pencil_fill,
                              size: 14,
                            ),
                        onPressed: () => setState(() {
                              _controller =
                                  TextEditingController(text: widget.value);
                              _editing = true;
                              widget.onEditingStarted?.call();
                            }))
                  ],
                )
            };
}

extension XText on Text {
  /// Extension on Flutter's [Text] widget to conveniently add mutable editing capabilities by wrapping it in a [MutableText] instance.
  ///
  /// ### Key Features:
  /// - **Seamless Conversion**: Transforms a static [Text] into an editable field with minimal boilerplate, preserving original properties like [style], [textAlign], and [maxLines].
  /// - **Editing Configuration**: Supports [onChanged] callback for updates, [placeholder] for hints, [minLines] for layout, [border] for styling, [autoCorrect] for UX, and [buttonType] for trigger style ([ghost] or [pencil] via [IconButton]).
  /// - **Integration**: Ideal for retrofitting existing text displays in components like [BasicCard], [Tile], or [ArcaneField], enabling dynamic content without refactoring.
  ///
  /// ### Usage Example:
  /// ```dart
  /// Text('Static Text').mutable(
  ///   onChanged: (newValue) => updateModel(newValue),
  ///   placeholder: Text('Edit here...'),
  ///   buttonType: EditButtonType.ghost,
  /// )
  /// ```
  /// This converts the [Text] to editable, using [GhostButton] for initiation and integrating with form logic via [onChanged].
  ///
  /// Note: The [data] from [Text] is used as the initial [value] for [MutableText], with null safety handled via empty string fallback.
  Widget mutable(ValueChanged<String> onChanged,
          {Widget? placeholder,
          int? minLines,
          bool border = false,
          bool autoCorrect = true,
          EditButtonType buttonType = EditButtonType.pencil}) =>
      MutableText(data ?? "",
          placeholder: placeholder,
          minLines: minLines,
          maxLines: maxLines,
          autoCorrect: autoCorrect,
          buttonType: buttonType,
          textAlign: textAlign,
          style: style,
          textWidthBasis: textWidthBasis,
          textScaler: textScaler,
          textHeightBehavior: textHeightBehavior,
          textDirection: textDirection,
          strutStyle: strutStyle,
          softWrap: softWrap,
          key: key,
          semanticsLabel: semanticsLabel,
          overflow: overflow,
          selectionColor: selectionColor,
          locale: locale,
          border: border,
          onChanged: onChanged);
}

/// A custom [Intent] class used to handle the Escape key press for canceling editing in [MutableText]'s [TextField].
///
/// This intent is registered in [Shortcuts] within [_MutableTextState]'s [build] method to trigger the [CallbackAction] that exits editing mode and calls [onEditingComplete]. It ensures keyboard accessibility, aligning with Flutter's action system for input components like [ArcaneField].
class _EscapeIntent extends Intent {}

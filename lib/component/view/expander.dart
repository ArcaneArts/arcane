import 'package:arcane/arcane.dart';

/// A controller that manages the expanded state of an [Expander] widget.
///
/// [ExpanderController] allows for programmatic control of an [Expander]'s state,
/// enabling toggling and direct setting of the expanded state from outside the widget.
///
/// See also:
///  * [doc/component/expander.md] for more detailed documentation
///  * [Expander], which uses this controller
class ExpanderController {
  /// A notifier that tracks the current expanded state.
  final ValueNotifier<bool> expanded;

  /// Creates an [ExpanderController] with an optional initial expanded state.
  ///
  /// By default, the controller starts in the collapsed state (initiallyExpanded = false).
  ExpanderController({bool initiallyExpanded = false})
      : expanded = ValueNotifier(initiallyExpanded);

  /// Toggles between expanded and collapsed states.
  void toggle() => expanded.value = !expanded.value;

  /// Sets the expansion state to the specified value.
  ///
  /// [value] is true for expanded, false for collapsed.
  void setExpanded(bool value) => expanded.value = value;
}

/// A simple state class that represents the current expanded state of an [Expander].
///
/// This state is provided to child components through the [Pylon] mechanism,
/// allowing them to react to expansion state changes.
///
/// See also:
///  * [doc/component/expander.md] for more detailed documentation
///  * [Expander], which uses this state class
class ExpanderState {
  /// Whether the [Expander] is currently expanded.
  final bool expanded;

  /// Creates an [ExpanderState] with the specified expanded value.
  ExpanderState(this.expanded);
}

/// A component that creates a collapsible container with a clickable header.
///
/// [Expander] is useful for creating accordion-style UI elements, FAQ sections,
/// or any content that needs to be shown or hidden based on user interaction.
/// It features smooth animations and can be controlled either through user
/// interaction or programmatically via an [ExpanderController].
///
/// See also:
///  * [doc/component/expander.md] for more detailed documentation
///  * [ExpanderController], which can be used to control this widget
///  * [ExpanderState], which represents this widget's state
class Expander extends StatefulWidget with BoxSignal {
  /// The content to show when expanded.
  final Widget child;
  
  /// The always-visible header that toggles expansion when clicked.
  final Widget header;
  
  /// Whether the content is initially expanded.
  final bool initiallyExpanded;
  
  /// Optional controller for external state management.
  final ExpanderController? controller;
  
  /// Duration of the expansion animation.
  final Duration duration;
  
  /// Animation curve for expansion.
  final Curve curve;
  
  /// Alignment of the animated content.
  final AlignmentGeometry alignment;
  
  /// Duration of the collapse animation.
  final Duration reverseDuration;
  
  /// Cross-axis alignment of the content.
  final CrossAxisAlignment crossAxisAlignment;
  
  /// Space between header and expanded content.
  final double gapPadding;
  
  /// Custom widget to show between header and content instead of gap.
  final Widget? overrideSeparator;

  /// Creates an [Expander] widget.
  ///
  /// The [child] and [header] parameters are required.
  /// The [child] is the content that will be shown when expanded.
  /// The [header] is always visible and toggles expansion when clicked.
  ///
  /// Example:
  /// ```dart
  /// Expander(
  ///   header: Text("Click to expand", style: TextStyle(fontWeight: FontWeight.bold)),
  ///   child: Padding(
  ///     padding: EdgeInsets.symmetric(vertical: 8.0),
  ///     child: Text("This is the expandable content."),
  ///   ),
  /// )
  /// ```
  const Expander({
    super.key,
    required this.child,
    required this.header,
    this.gapPadding = 8,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.initiallyExpanded = false,
    this.controller,
    this.duration = const Duration(milliseconds: 250),
    this.reverseDuration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOutCirc,
    this.alignment = Alignment.topCenter,
    this.overrideSeparator,
  });

  @override
  State<Expander> createState() => _ExpanderState();
}

class _ExpanderState extends State<Expander> {
  bool expanded = false;
  late VoidCallback listener;

  @override
  void initState() {
    if (widget.initiallyExpanded) {
      expanded = true;
    }

    if (widget.controller != null) {
      listener = () => setState(() {
            expanded = widget.controller!.expanded.value;
          });
      widget.controller!.expanded.addListener(listener);
    }

    super.initState();
  }

  /// Sets the expansion state to the specified value.
  void setExpanded(bool value) => setState(() => expanded = value);

  /// Toggles between expanded and collapsed states.
  void toggle() => setState(() => expanded = !expanded);

  /// Collapses the expander.
  void close() => setState(() => expanded = false);

  /// Expands the expander.
  void open() => setState(() => expanded = true);

  @override
  void dispose() {
    widget.controller?.expanded.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedSize(
        duration: widget.duration,
        curve: widget.curve,
        alignment: widget.alignment,
        reverseDuration: widget.reverseDuration,
        child: Pylon<ExpanderState>(
          value: ExpanderState(expanded),
          builder: (context) => expanded
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: widget.crossAxisAlignment,
                  children: [
                    Clickable(
                        child: widget.header,
                        onPressed: () => setState(() => expanded = !expanded)),
                    widget.overrideSeparator ?? Gap(widget.gapPadding),
                    widget.child,
                  ],
                )
              : Clickable(
                  child: widget.header,
                  onPressed: () => setState(() => expanded = !expanded)),
        ),
      );
}

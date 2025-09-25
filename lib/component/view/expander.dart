import 'package:arcane/arcane.dart';

/// A controller that manages the expanded state of an [Expander] widget.
///
/// [ExpanderController] provides programmatic control over an [Expander]'s expansion state,
/// allowing external toggling and direct setting from parent widgets or services.
/// It uses a [ValueNotifier] for reactive updates, ensuring efficient state propagation
/// without unnecessary rebuilds in the widget tree.
///
/// Key features:
/// - Reactive state management via [ValueNotifier], integrating seamlessly with Arcane's
///   reactive patterns like [Pylon] for child notifications.
/// - Simple API for toggle and set operations, with automatic listener notifications.
/// - Supports initial state configuration for consistent UI initialization.
///
/// Usage in Arcane UI:
/// - Integrate with [Section] to create collapsible content blocks in forms or lists.
/// - Use in [FillScreen] or [SliverScreen] for dynamic panels, such as expandable settings
///   groups or FAQ sections within [BasicCard].
/// - Pair with [Gesture] for custom interaction handling or [ArcaneTheme] for styled headers.
///
/// Performance notes:
/// - Minimal overhead; notifies listeners only on state changes, avoiding full rebuilds.
/// - Ideal for large UIs as it decouples state from widget rebuild cycles.
///
/// See also:
///  * [doc/component/expander.md] for more detailed documentation
///  * [Expander], which uses this controller for external control
class ExpanderController {
  /// A notifier that tracks the current expanded state.
  final ValueNotifier<bool> expanded;

  /// Creates an [ExpanderController] with an optional initial expanded state.
  ///
  /// The [initiallyExpanded] parameter determines if the expander starts in the open state.
  /// Defaults to false (collapsed) for compact initial layouts.
  /// Initializes the internal [ValueNotifier] for reactive state tracking.
  ExpanderController({bool initiallyExpanded = false})
      : expanded = ValueNotifier(initiallyExpanded);

  /// Toggles between expanded and collapsed states.
  ///
  /// Updates the internal [ValueNotifier], notifying all listeners for reactive UI updates.
  /// No parameters required; inverts the current state efficiently.
  void toggle() => expanded.value = !expanded.value;

  /// Sets the expansion state to the specified value.
  ///
  /// [value] should be true for expanded or false for collapsed.
  /// Directly assigns to the [ValueNotifier], triggering notifications only if the state changes.
  /// Useful for syncing with external events or user actions.
  void setExpanded(bool value) => expanded.value = value;
}

/// A simple state class that represents the current expanded state of an [Expander].
///
/// [ExpanderState] is an immutable snapshot provided via the [Pylon] mechanism,
/// enabling child widgets to react to expansion changes without direct access to the controller.
///
/// Key features:
/// - Immutable design ensures thread-safety and predictable rebuilds.
/// - Lightweight; only the boolean flag is stored, minimizing memory use.
/// - Integrates with Arcane's [Pylon] for efficient, targeted state propagation to descendants.
///
/// Usage in Arcane UI:
/// - Children of [Expander] can consume this via [Pylon] to conditionally render content
///   or adjust layouts, e.g., in [Section] subcomponents or [BasicCard] bodies.
/// - Useful in [FillScreen] for animating additional UI elements based on expansion,
///   or in [SliverScreen] for scrollable collapsible sections.
///
/// Performance notes:
/// - No overhead from observers; [Pylon] rebuilds only affected subtrees on state change,
///   preventing unnecessary widget tree traversals.
///
/// See also:
///  * [doc/component/expander.md] for more detailed documentation
///  * [Expander], which provides this state to its children
///  * [ExpanderController], the source of state updates
class ExpanderState {
  /// Whether the [Expander] is currently expanded.
  final bool expanded;

  /// Creates an [ExpanderState] with the specified expanded value.
  ///
  /// The [expanded] flag indicates if the [Expander] is currently showing its child content.
  /// Used internally by [Pylon] for state distribution.
  ExpanderState(this.expanded);
}

/// A component that creates a collapsible container with a clickable header.
///
/// [Expander] implements an animated, accordion-style widget for hiding/showing content
/// on demand, ideal for organized, space-efficient UIs in the Arcane framework.
///
/// Key features:
/// - Smooth size transitions via [AnimatedSize], with customizable duration, curve, and alignment.
/// - Clickable header using [Gesture]-like interactions for intuitive toggling.
/// - Optional [ExpanderController] for external state management, supporting programmatic control.
/// - Flexible spacing with [Gap] or custom [overrideSeparator], and cross-axis alignment options.
/// - Exposes [ExpanderState] via [Pylon] for child reactivity without prop drilling.
///
/// Usage in Arcane UI:
/// - Embed in [Section] for collapsible subsections in forms or data displays.
/// - Use within [BasicCard] or [CardSection] in [FillScreen] for expandable details,
///   or in [SliverScreen] for scrollable, nested content like menus or settings panels.
/// - Combine with [ArcaneTheme] for consistent styling, e.g., themed headers with icons,
///   and [Gesture] for advanced tap feedback or long-press actions.
///
/// Performance notes:
/// - Efficient state management with targeted [setState] calls, avoiding full parent rebuilds.
/// - [AnimatedSize] clips and animates only the changing content, suitable for complex children
///   without performance degradation; prefers const constructors for static parts.
///
/// See also:
///  * [doc/component/expander.md] for more detailed documentation
///  * [ExpanderController], for programmatic control
///  * [ExpanderState], the reactive state provided to children
///  * [AnimatedSize], underlying animation primitive
///  * [Pylon], for state distribution to descendants
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
  /// Required parameters:
  /// - [child]: The widget displayed when expanded; supports any content like [Text], [Column],
  ///   or complex layouts such as [DataTable] or [StaticTable].
  /// - [header]: The persistent, clickable widget that toggles expansion; typically [Text],
  ///   [Row] with icons, or themed elements from [ArcaneTheme].
  ///
  /// Optional parameters:
  /// - [initiallyExpanded]: Starts the widget in expanded state (default: false).
  /// - [controller]: [ExpanderController] for external state syncing (default: null).
  /// - [duration]: Expansion animation length (default: 250ms).
  /// - [reverseDuration]: Collapse animation length (default: 250ms).
  /// - [curve]: Easing for expansion (default: Curves.easeOutCirc for smooth deceleration).
  /// - [alignment]: Alignment during size transition (default: Alignment.topCenter).
  /// - [overrideSeparator]: Custom widget between header and child (default: null, uses [Gap]).
  /// - [gapPadding]: Padding value for default separator (default: 8.0).
  /// - [crossAxisAlignment]: Column alignment when expanded (default: CrossAxisAlignment.start).
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

/// The private state class for [Expander], handling internal expansion logic and animations.
///
/// Manages the local expanded flag, controller listeners, and builds the animated UI.
/// Listens to [ExpanderController] if provided, syncing state changes efficiently.
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

  /// Sets the internal expanded state, triggering a targeted rebuild.
  ///
  /// [value]: true to expand, false to collapse.
  /// Called on user interactions or controller updates; uses [setState] for minimal rebuilds.
  void setExpanded(bool value) => setState(() => expanded = value);

  /// Toggles the internal expanded state.
  ///
  /// Inverts the current flag and rebuilds; handles both local and controller-synced states.
  void toggle() => setState(() => expanded = !expanded);

  /// Collapses the expander by setting expanded to false.
  ///
  /// Convenience method for programmatic closing, with rebuild.
  void close() => setState(() => expanded = false);

  /// Expands the expander by setting expanded to true.
  ///
  /// Convenience method for programmatic opening, with rebuild.
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

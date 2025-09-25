import 'package:arcane/arcane.dart';

/// Defines the layout directions and behaviors for [Flow] widgets in the Arcane UI system.
///
/// - [column]: Arranges children vertically like a [Column], ideal for stacked content in forms or lists.
/// - [row]: Arranges children horizontally like a [Row], suitable for inline elements such as buttons or icons.
/// - [stack]: Overlays children like a [Stack], useful for layered UI elements with passthrough fitting.
/// - [wrap]: Flows children into multiple lines like a [Wrap], perfect for dynamic grids or tag clouds with consistent spacing.
enum FlowType { column, row, stack, wrap }

/// A flexible layout widget that arranges child widgets according to a specified [FlowType],
/// providing row, column, stack, or wrap behaviors within the Arcane UI ecosystem.
///
/// Key features include minimal sizing for efficient space usage, centered alignments for visual consistency,
/// and automatic conversion of iterable children to lists. It integrates with [ArcaneTheme] for theming,
/// and pairs well with components like [Section] for structured content, [Carpet] for background flows,
/// [ButtonPanel] for action arrangements, or [FancyIcon] sequences in dynamic interfaces.
class Flow extends StatelessWidget {
  final FlowType type;
  final Iterable<Widget> children;

  /// Creates a horizontal row layout using [FlowType.row].
  ///
  /// Arranges [children] horizontally with minimal main axis size and centered cross-axis alignment,
  /// making it ideal for inline UI elements like navigation items or icon bars in [Section] or [Tabs].
  const Flow.across(
    this.children, {
    super.key,
    this.type = FlowType.row,
  });

  /// Creates a horizontal row layout using [FlowType.row].
  ///
  /// This alias for [Flow.across] provides the same horizontal arrangement of [children],
  /// useful for button rows or label sequences in forms wrapped by [FieldWrapper] or [ArcaneField].
  const Flow.row(
    this.children, {
    super.key,
    this.type = FlowType.row,
  });

  /// Creates a vertical column layout using [FlowType.column].
  ///
  /// Stacks [children] vertically with minimal main axis size and start-aligned cross-axis,
  /// suitable for form fields, list items, or content blocks within [Dialog] or [Sheet] components.
  const Flow.down(
    this.children, {
    super.key,
    this.type = FlowType.column,
  });

  /// Creates a vertical column layout using [FlowType.column].
  ///
  /// This alias for [Flow.down] arranges [children] in a vertical stack,
  /// commonly used for cascading UI elements like [Selector] options or [PopupMenu] items.
  const Flow.col(
    this.children, {
    super.key,
    this.type = FlowType.column,
  });

  /// Creates an overlay stack layout using [FlowType.stack].
  ///
  /// Layers [children] with passthrough fitting, allowing overlapping visuals,
  /// perfect for badges over [FancyIcon], notifications on [Fab], or modal overlays in [Toast].
  const Flow.through(
    this.children, {
    super.key,
    this.type = FlowType.stack,
  });

  /// Creates an overlay stack layout using [FlowType.stack].
  ///
  /// This alias for [Flow.through] overlays [children] for complex layering,
  /// integrating with [ArcaneTheme] for depth effects in [CardSection] or [GlowCard].
  const Flow.stack(
    this.children, {
    super.key,
    this.type = FlowType.stack,
  });

  /// Creates a wrapping layout using [FlowType.wrap].
  ///
  /// Flows [children] horizontally then wraps to new lines with 8-unit spacing and centered alignment,
  /// ideal for tags, chips, or dynamic content in [Search] results or [RadioCards].
  const Flow.around(
    this.children, {
    super.key,
    this.type = FlowType.wrap,
  });

  /// Creates a wrapping layout using [FlowType.wrap].
  ///
  /// This alias for [Flow.around] handles overflowing [children] by wrapping lines,
  /// useful for multi-line arrangements in [MutableText] lists or [CycleButton] options.
  const Flow.wrap(
    this.children, {
    super.key,
    this.type = FlowType.wrap,
  });

  /// Builds the layout widget corresponding to the [type], rendering [Row], [Column], [Stack], or [Wrap].
  ///
  /// Configures minimal sizing and alignments for compact, centered displays; applies 8-unit spacing to wraps.
  /// Converts iterable [children] to lists for widget compatibility, ensuring seamless integration
  /// with Arcane components like [PanelButton] in rows or [IconButton] in stacks without state management.
  @override
  Widget build(BuildContext context) => switch (type) {
        FlowType.row => Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children is List<Widget>
                ? children as List<Widget>
                : children.toList()),
        FlowType.column => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children is List<Widget>
                ? children as List<Widget>
                : children.toList()),
        FlowType.stack => Stack(
            fit: StackFit.passthrough,
            children: children is List<Widget>
                ? children as List<Widget>
                : children.toList(),
          ),
        FlowType.wrap => Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: children is List<Widget>
                ? children as List<Widget>
                : children.toList(),
          ),
      };
}

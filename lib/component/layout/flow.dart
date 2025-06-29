import 'package:arcane/arcane.dart';

enum FlowType { column, row, stack, wrap }

class Flow extends StatelessWidget {
  final FlowType type;
  final Iterable<Widget> children;

  /// Creates a Row
  const Flow.across(
    this.children, {
    super.key,
    this.type = FlowType.row,
  });

  /// Creates a Row
  const Flow.row(
    this.children, {
    super.key,
    this.type = FlowType.row,
  });

  /// Creates a Column
  const Flow.down(
    this.children, {
    super.key,
    this.type = FlowType.column,
  });

  /// Creates a Column
  const Flow.col(
    this.children, {
    super.key,
    this.type = FlowType.column,
  });

  /// Creates a Stack
  const Flow.through(
    this.children, {
    super.key,
    this.type = FlowType.stack,
  });

  /// Creates a Stack
  const Flow.stack(
    this.children, {
    super.key,
    this.type = FlowType.stack,
  });

  /// Creates a Wrap
  const Flow.around(
    this.children, {
    super.key,
    this.type = FlowType.wrap,
  });

  /// Creates a Wrap
  const Flow.wrap(
    this.children, {
    super.key,
    this.type = FlowType.wrap,
  });

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

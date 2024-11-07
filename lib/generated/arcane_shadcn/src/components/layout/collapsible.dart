import 'package:arcane/generated/arcane_shadcn/shadcn_flutter.dart';

class Collapsible extends StatefulWidget {
  final List<Widget> children;
  final bool? isExpanded;
  final ValueChanged<bool>? onExpansionChanged;

  // if onExpansionChanged is null, the CollapsibleState will handle the expansion state

  const Collapsible({
    super.key,
    required this.children,
    this.isExpanded,
    this.onExpansionChanged,
  });

  @override
  State<Collapsible> createState() => CollapsibleState();
}

class CollapsibleState extends State<Collapsible> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded ?? false;
  }

  @override
  void didUpdateWidget(covariant Collapsible oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != null) {
      _isExpanded = widget.isExpanded!;
    }
  }

  void _handleTap() {
    if (widget.onExpansionChanged != null) {
      widget.onExpansionChanged!(_isExpanded);
    } else {
      setState(() {
        _isExpanded = !_isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Data.inherit(
      data:
          CollapsibleStateData(isExpanded: _isExpanded, handleTap: _handleTap),
      child: IntrinsicWidth(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.children,
      )),
    );
  }
}

class CollapsibleStateData {
  final VoidCallback handleTap;
  final bool isExpanded;

  const CollapsibleStateData(
      {required this.isExpanded, required this.handleTap});
}

class CollapsibleTrigger extends StatelessWidget {
  final Widget child;

  const CollapsibleTrigger({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final state = Data.of<CollapsibleStateData>(context);
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Expanded(child: child.small().semiBold()),
      Gap(16 * scaling),
      GhostButton(
        onPressed: state.handleTap,
        child: Icon(
          state.isExpanded ? Icons.unfold_less : Icons.unfold_more,
        ).iconXSmall(),
      ),
    ]).withPadding(horizontal: 16 * scaling);
  }
}

class CollapsibleContent extends StatelessWidget {
  final bool collapsible;
  final Widget child;

  const CollapsibleContent(
      {super.key, this.collapsible = true, required this.child});

  @override
  Widget build(BuildContext context) {
    final state = Data.of<CollapsibleStateData>(context);
    return Offstage(
      offstage: !state.isExpanded && collapsible,
      child: child,
    );
  }
}

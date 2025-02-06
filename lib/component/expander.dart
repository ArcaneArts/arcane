import 'package:arcane/arcane.dart';

class ExpanderController {
  final ValueNotifier<bool> expanded;

  ExpanderController({bool initiallyExpanded = false})
      : expanded = ValueNotifier(initiallyExpanded);

  void toggle() => expanded.value = !expanded.value;

  void setExpanded(bool value) => expanded.value = value;
}

class ExpanderState {
  final bool expanded;

  ExpanderState(this.expanded);
}

class Expander extends StatefulWidget with BoxSignal {
  final Widget child;
  final Widget header;
  final bool initiallyExpanded;
  final ExpanderController? controller;
  final Duration duration;
  final Curve curve;
  final AlignmentGeometry alignment;
  final Duration reverseDuration;
  final CrossAxisAlignment crossAxisAlignment;
  final double gapPadding;
  final Widget? overrideSeparator;

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

  void setExpanded(bool value) => setState(() => expanded = value);

  void toggle() => setState(() => expanded = !expanded);

  void close() => setState(() => expanded = false);

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

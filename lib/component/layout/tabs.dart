import 'dart:async';

import 'package:arcane/arcane.dart';

class Tabbed extends StatefulWidget {
  final Map<dynamic, Widget> tabs;
  final bool indexedStack;
  final int initialIndex;
  final Stream<int>? indexController;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final VerticalDirection tabPlacement;
  final double gap;

  const Tabbed(
      {super.key,
      required this.tabs,
      this.indexedStack = true,
      this.initialIndex = 0,
      this.crossAxisAlignment = CrossAxisAlignment.start,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.mainAxisSize = MainAxisSize.min,
      this.tabPlacement = VerticalDirection.up,
      this.gap = 8,
      this.indexController});

  @override
  State<Tabbed> createState() => _TabbedState();
}

class _TabbedState extends State<Tabbed> {
  int index = 0;
  StreamSubscription<int>? subscription;

  @override
  void initState() {
    index = widget.initialIndex;
    subscription = widget.indexController?.listen((event) => setState(() {
          index = event;
        }));
    super.initState();
  }

  TabChild _buildTab(dynamic input) {
    if (input is TabChild) {
      return input;
    }

    if (input is String) {
      return TabItem(child: Text(input));
    }

    if (input is Widget) {
      return TabItem(child: input);
    }

    throw ArgumentError(
        'Invalid tab type: ${input.runtimeType}. Will accept any TabChild widget, String or Widget');
  }

  Widget _buildTabs(BuildContext context) => Tabs(
      index: index,
      onChanged: (i) => setState(() {
            index = i;
          }),
      children: widget.tabs.keys.map(_buildTab).toList());

  Widget _buildContent(BuildContext context) => widget.indexedStack
      ? IndexedStack(
          index: index,
          children: widget.tabs.values.toList(),
        )
      : widget.tabs.values.elementAt(index);

  @override
  Widget build(BuildContext context) => widget.tabs.isEmpty
      ? Container()
      : widget.tabs.length == 1
          ? widget.tabs.values.first
          : Column(
              mainAxisSize: widget.mainAxisSize,
              crossAxisAlignment: widget.crossAxisAlignment,
              mainAxisAlignment: widget.mainAxisAlignment,
              children: [
                if (widget.tabPlacement == VerticalDirection.up) ...[
                  _buildTabs(context),
                  Gap(widget.gap),
                  _buildContent(context)
                ] else ...[
                  _buildContent(context),
                  Gap(widget.gap),
                  _buildTabs(context)
                ]
              ],
            );
}

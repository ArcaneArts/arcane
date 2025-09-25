import 'dart:async';

import 'package:arcane/arcane.dart';

/// A customizable tabbed interface widget for the Arcane UI system.
///
/// The [Tabbed] widget provides a flexible way to create tabbed layouts, supporting dynamic tab content
/// via a map of labels or widgets to their corresponding views. It uses [Tabs] for navigation and
/// optionally [IndexedStack] to preserve child state during switches, with support for external
/// index control through streams. Tabs can be placed above or below content using [VerticalDirection],
/// and the layout is configurable with alignment, sizing, and spacing options. This component integrates
/// seamlessly with other Arcane elements like [Section], [GlassSection], or [FormHeader] to organize
/// complex interfaces, such as multi-step forms or segmented data displays in [ArcaneTheme]-styled apps.
/// Key features include automatic type conversion for tab inputs ([String] or [Widget] to [TabItem]),
/// empty/single-tab fallbacks, and stream-driven reactivity for dynamic UIs.
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

  /// Creates a [Tabbed] widget with the specified tabs and configuration.
  ///
  /// The [tabs] parameter is a map where keys represent tab labels (accepting [TabChild], [String],
  /// or [Widget], which are converted to [TabItem] if needed) and values are the corresponding content
  /// widgets displayed when the tab is selected. [indexedStack] determines whether to use [IndexedStack]
  /// (true, default) to maintain state across tab switches or show only the active child (false) for
  /// performance in simple cases. [initialIndex] sets the starting tab (default 0). [indexController]
  /// is an optional stream for external control of the active index, enabling reactive updates from
  /// parent widgets or services. Layout properties like [crossAxisAlignment], [mainAxisAlignment],
  /// [mainAxisSize], [tabPlacement] (up for tabs above content, down for below), and [gap] (spacing
  /// between tabs and content, default 8) allow precise arrangement within the [Column] structure.
  /// If [tabs] is empty, renders an empty [Container]; if single tab, shows only the content directly.
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

/// The state management class for [Tabbed], responsible for tracking the active tab index,
/// handling initialization, and responding to internal or external index changes via streams.
///
/// This private state maintains the current [index] and [subscription] to the [indexController]
/// stream, ensuring reactive updates. It builds the tab navigation using [Tabs] and content
/// via [IndexedStack] or direct selection, with conditional placement based on [tabPlacement].
/// Integrates with [ArcaneTheme] for styling consistency and supports fallbacks for edge cases
/// like empty or single-tab configurations.
class _TabbedState extends State<Tabbed> {
  int index = 0;
  StreamSubscription<int>? subscription;

  /// Initializes the tab state by setting the initial index and subscribing to the external
  /// index controller stream if provided.
  ///
  /// Listens to [widget.indexController] events and triggers [setState] to update the [index],
  /// enabling dynamic tab switching from external sources like user actions or data streams.
  /// Called during widget lifecycle; ensures the UI reflects the [initialIndex] on mount.
  @override
  void initState() {
    index = widget.initialIndex;
    subscription = widget.indexController?.listen((event) => setState(() {
          index = event;
        }));
    super.initState();
  }

  /// Builds a [TabChild] from the dynamic tab input, handling type conversion for flexibility.
  ///
  /// Accepts [TabChild] directly, converts [String] to [TabItem] with [Text] child, or wraps
  /// [Widget] in [TabItem]. Throws [ArgumentError] for invalid types, ensuring only supported
  /// inputs are used in [Tabs]. This method supports seamless integration of simple labels
  /// or complex widgets as tab headers in Arcane UIs.
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

  /// Constructs the tab navigation bar using [Tabs] with the current [index] and change handler.
  ///
  /// Maps tab keys through [_buildTab] to generate [TabChild] children for [Tabs], which handles
  /// selection visuals and callbacks. The [onChanged] updates the local [index] via [setState],
  /// triggering rebuilds. Relies on [ArcaneTheme] for styling and integrates with the overall
  /// tabbed layout in [build].
  Widget _buildTabs(BuildContext context) => Tabs(
      index: index,
      onChanged: (i) => setState(() {
            index = i;
          }),
      children: widget.tabs.keys.map(_buildTab).toList());

  /// Builds the tab content area, using [IndexedStack] for state preservation or direct selection.
  ///
  /// If [widget.indexedStack] is true, renders all tab contents in [IndexedStack] at the current
  /// [index] to maintain widget state (e.g., form inputs or scroll positions). Otherwise, shows
  /// only the active content via [elementAt] for lighter memory usage. Outputs a [Widget] for
  /// inclusion in the [Column] layout, supporting integration with [Gap] for spacing.
  Widget _buildContent(BuildContext context) => widget.indexedStack
      ? IndexedStack(
          index: index,
          children: widget.tabs.values.toList(),
        )
      : widget.tabs.values.elementAt(index);

  /// Renders the complete tabbed interface based on the current state and widget configuration.
  ///
  /// Handles edge cases: empty [tabs] returns [Container], single tab shows content directly.
  /// For multiple tabs, builds a [Column] with configurable [mainAxisSize], [crossAxisAlignment],
  /// and [mainAxisAlignment]. Conditionally places [_buildTabs] above or below [_buildContent]
  /// using [widget.tabPlacement], separated by [Gap] of [widget.gap]. Ensures responsive layout
  /// within [ArcaneTheme] and supports use in scrollable views like [SliverGutter] or [Flow].
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

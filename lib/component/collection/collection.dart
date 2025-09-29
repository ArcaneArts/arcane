import 'package:arcane/arcane.dart';

/// A versatile collection widget designed for managing and displaying groups of items within the Arcane UI component system.
///
/// The [Collection] widget serves as a flexible container for rendering lists of widgets, supporting both static children and dynamic builder patterns. It intelligently handles sliver-based layouts by detecting if children include sliver widgets such as [Section], nested [Collection], or other slivers via [Widget.isSliver]. This makes it ideal for use in scrollable views like [CustomScrollView] or as part of larger sliver compositions.
///
/// Key features:
/// - Supports static list of [Widget] children for simple, predefined content.
/// - Provides builder mode for efficient rendering of large or dynamic lists using [IndexedWidgetBuilder].
/// - Custom builder mode utilizes [MultiSliver] for advanced sliver-based item generation.
/// - Automatically chooses between [SListView] for non-sliver children and [MultiSliver] for sliver-compatible content.
/// - Integrates with [Pylon] for reactive state management in dynamic collections.
///
/// Usage example:
/// ```dart
/// Collection(
///   children: [
///     Section(title: 'Items'),
///     CardCarousel(items: itemList),
///   ],
/// )
/// ```
/// Or for dynamic lists:
/// ```dart
/// Collection.builder(
///   builder: (context, index) => ListTile(title: Text('Item $index')),
///   childCount: 100,
/// )
/// ```

class Collection extends StatelessWidget with SliverSignal {
  /// The list of static child widgets to render within the collection.
  ///
  /// This field holds the predefined widgets that will be displayed when using the default constructor.
  /// It is ignored in builder modes. Defaults to an empty list.
  final List<Widget> children;

  /// An optional builder function for dynamically generating child widgets at specific indices.
  ///
  /// Used in builder and custom modes to create items on demand. The function takes a [BuildContext]
  /// and index, returning the corresponding [Widget] for that position.
  final IndexedWidgetBuilder? builder;

  /// The total number of children when using a builder.
  ///
  /// Required for custom builders to determine the extent of [MultiSliver] children. Optional for
  /// standard builder mode, where it builds until the builder returns null.
  final int? childCount;

  /// Indicates whether a custom builder is used, enabling [MultiSliver] for sliver-based rendering.
  ///
  /// Set to true in the [Collection.custom] constructor, allowing each built item to be a sliver.
  final bool customBuilder;

  /// The default constructor for creating a [Collection] with a static list of child widgets.
  ///
  /// This constructor initializes the widget for rendering a fixed set of [Widget] children. It sets
  /// the builder-related fields to null and disables custom builder mode, making it suitable for
  /// simple, non-dynamic lists. The [children] parameter accepts a list of widgets that will be
  /// rendered, defaulting to an empty list if not provided.
  ///
  /// Example:
  /// ```dart
  /// Collection(children: [
  ///   Text('Item 1'),
  ///   Text('Item 2'),
  /// ])
  /// ```
  const Collection({super.key, this.children = const []})
      : childCount = null,
        builder = null,
        customBuilder = false;

  /// Creates a [Collection] using a builder for dynamic child generation.
  ///
  /// This constructor enables the builder pattern for efficient rendering of potentially large lists.
  /// It requires an [IndexedWidgetBuilder] to generate widgets on demand and optionally specifies the
  /// [childCount] for the total number of items. Custom builder mode is disabled, using
  /// [SListView.builder] internally.
  ///
  /// The [builder] function is called for each index to produce a child widget. If [childCount] is
  /// provided, it limits the number of built items; otherwise, it builds indefinitely until a null
  /// is returned from the builder.
  ///
  /// Example:
  /// ```dart
  /// Collection.builder(
  ///   builder: (context, index) => ListTile(title: Text('Item $index')),
  ///   childCount: 100,
  /// )
  /// ```
  const Collection.builder({super.key, required this.builder, this.childCount})
      : children = const [],
        customBuilder = false;

  /// Creates a custom [Collection] using a builder with [MultiSliver] support.
  ///
  /// This constructor is for advanced scenarios where sliver-based rendering is needed for each
  /// child. It requires both [builder] and [childCount], as [MultiSliver] needs a fixed number of
  /// sliver children. An assertion ensures [childCount] is provided. This mode generates a list of
  /// slivers using the builder and wraps them in [MultiSliver].
  ///
  /// Suitable for collections where each item is a sliver widget, such as nested [Section]s or other
  /// slivers.
  ///
  /// Example:
  /// ```dart
  /// Collection.custom(
  ///   builder: (context, index) => SliverToBoxAdapter(
  ///     child: ListTile(title: Text('Item $index')),
  ///   ),
  ///   childCount: 50,
  /// )
  /// ```
  const Collection.custom(
      {super.key, required this.builder, required this.childCount})
      : children = const [],
        customBuilder = true,
        assert(childCount != null,
            'childCount must be provided for custom builders as MultiSlivers are being used to build the list');

  /// Builds the [Collection] widget based on the provided configuration.
  ///
  /// This method determines the appropriate rendering strategy by examining the configuration:
  /// - If a [builder] is provided and [customBuilder] is true, it generates a fixed number of slivers
  ///   using [List.generate] and wraps them in [MultiSliver] for sliver contexts.
  /// - If a [builder] is provided but [customBuilder] is false, it delegates to [SListView.builder]
  ///   for standard, non-sliver list rendering.
  /// - If no [builder] is used (static [children]), it inspects the children to check if any is a
  ///   [Section], [Collection], or a sliver via [Widget.isSliver]. If sliver-compatible, it renders
  ///   with [MultiSliver]; otherwise, it uses [SListView] for a scrollable list of box widgets.
  ///
  /// This adaptive approach ensures compatibility with both sliver and non-sliver layouts, optimizing
  /// performance and preventing layout errors in scrollable parents.
  @override
  Widget build(BuildContext context) {
    if (builder != null) {
      if (customBuilder) {
        return MultiSliver(
          children: List.generate(childCount!, (i) => builder!(context, i)),
        );
      }

      return SListView.builder(builder: builder);
    }

    if (children.any((element) =>
        element is Section ||
        element is Collection ||
        element.isSliver(context))) {
      return MultiSliver(children: children);
    } else {
      return SListView(
        children: children,
      );
    }
  }
}

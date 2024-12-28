import 'package:arcane/arcane.dart';

class Collection extends StatelessWidget with SliverSignal {
  final List<Widget> children;
  final IndexedWidgetBuilder? builder;
  final int? childCount;
  final bool customBuilder;

  const Collection({super.key, this.children = const []})
      : childCount = null,
        builder = null,
        customBuilder = false;

  const Collection.builder({super.key, required this.builder, this.childCount})
      : children = const [],
        customBuilder = false;

  const Collection.custom(
      {super.key, required this.builder, required this.childCount})
      : children = const [],
        customBuilder = true,
        assert(childCount != null,
            'childCount must be provided for custom builders as MultiSlivers are being used to build the list');

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

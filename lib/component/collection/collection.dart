import 'package:arcane/arcane.dart';

class Collection extends StatelessWidget {
  final List<Widget> children;
  final IndexedWidgetBuilder? builder;
  final int? childCount;

  const Collection({super.key, this.children = const []})
      : childCount = null,
        builder = null;

  const Collection.builder({super.key, required this.builder, this.childCount})
      : children = const [];

  @override
  Widget build(BuildContext context) {
    if (builder != null) {
      return SListView.builder(
        builder: builder!,
        childCount: childCount,
      );
    }

    return SListView(children: children);
  }
}

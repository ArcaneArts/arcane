import 'package:arcane/arcane.dart';

extension XWidgetArcane on Widget {
  Widget get asSliver {
    if (this is ListView) {
      return (this as ListView).asSliver;
    } else if (this is GridView) {
      return (this as GridView).asSliver;
    } else {
      return SliverToBoxAdapter(child: this);
    }
  }
}

extension XSliverListTransformer on ListView {
  SliverList get asSliver => SliverList(key: key, delegate: childrenDelegate);
}

extension XSliverGridTransformer on GridView {
  SliverGrid get asSliver => SliverGrid(
      key: key, gridDelegate: gridDelegate, delegate: childrenDelegate);
}

extension XStringArcane on String {
  Text get text => Text(this);
}

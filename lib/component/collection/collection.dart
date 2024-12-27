import 'package:arcane/arcane.dart';

class Section extends StatelessWidget with SliverSignal {
  final Widget child;
  final Widget? title;
  final Widget? subtitle;
  final Widget? header;
  final String? titleText;
  final String? subtitleText;
  final String? headerText;
  final List<Widget> leading;
  final List<Widget> trailing;
  final BarBackButtonMode backButton;
  final Widget? customHeader;
  final bool expandable;
  final bool initiallyExpanded;

  const Section(
      {super.key,
      this.customHeader,
      this.initiallyExpanded = true,
      this.expandable = false,
      required this.child,
      this.backButton = BarBackButtonMode.never,
      this.title,
      this.subtitle,
      this.header,
      this.titleText,
      this.subtitleText,
      this.headerText,
      this.leading = const [],
      this.trailing = const []});

  @override
  Widget build(BuildContext context) => customHeader != null
      ? GlassSection(
          sliver: child.isSliver(context)
              ? child
              : child.toSliver(context, fillRemaining: false),
          header: customHeader!)
      : BarSection(
          expandable: expandable,
          initiallyExpanded: initiallyExpanded,
          titleText: titleText,
          subtitleText: subtitleText,
          headerText: headerText,
          title: title,
          subtitle: subtitle,
          header: header,
          leading: leading,
          trailing: trailing,
          backButton: backButton,
          sliver: child.isSliver(context)
              ? child
              : child.toSliver(context, fillRemaining: false));
}

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

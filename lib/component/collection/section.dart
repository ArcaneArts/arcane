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

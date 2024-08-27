import 'package:arcane/arcane.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class GlassSection extends StatelessWidget {
  final Widget sliver;
  final Widget header;

  const GlassSection({super.key, required this.sliver, required this.header});

  @override
  Widget build(BuildContext context) => SliverStickyHeader.builder(
        builder: (context, state) => Glass(
          disabled: !state.isPinned,
          blur: Theme.of(context).surfaceBlur ?? 16,
          child: header,
        ),
        sliver: sliver,
      );
}

class BarSection extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? header;
  final String? titleText;
  final String? subtitleText;
  final String? headerText;
  final List<Widget> leading;
  final List<Widget> trailing;
  final Widget sliver;

  const BarSection(
      {super.key,
      this.title,
      required this.sliver,
      this.subtitle,
      this.header,
      this.titleText,
      this.subtitleText,
      this.headerText,
      this.leading = const [],
      this.trailing = const []});

  @override
  Widget build(BuildContext context) => SliverStickyHeader.builder(
        builder: (context, state) => Bar(
          useGlass: state.isPinned,
          title: title,
          header: header,
          subtitle: subtitle,
          titleText: titleText,
          subtitleText: subtitleText,
          headerText: headerText,
          leading: leading,
          trailing: trailing,
        ),
        sliver: sliver,
      );
}

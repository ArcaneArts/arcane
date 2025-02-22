import 'package:arcane/arcane.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class GlassSection extends StatelessWidget {
  final Widget sliver;
  final Widget header;

  const GlassSection({super.key, required this.sliver, required this.header});

  @override
  Widget build(BuildContext context) => SliverStickyHeader.builder(
        builder: (context, state) => Glass(
          ignoreContextSignals: true,
          disabled: !state.isPinned,
          blur: Theme.of(context).surfaceBlur ?? 16,
          child: header,
        ),
        sliver: sliver,
      );
}

class ExpansionBarSection extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? header;
  final String? titleText;
  final String? subtitleText;
  final String? headerText;
  final List<Widget> leading;
  final List<Widget> trailing;
  final Widget sliver;
  final BarBackButtonMode backButton;
  final bool initiallyExpanded;

  ExpansionBarSection(
      {super.key,
      this.backButton = BarBackButtonMode.never,
      this.title,
      required this.sliver,
      this.subtitle,
      this.header,
      this.titleText,
      this.subtitleText,
      this.headerText,
      this.leading = const [],
      this.trailing = const [],
      this.initiallyExpanded = true});

  @override
  Widget build(BuildContext context) => MutablePylon<ExpansionBarState>(
        local: true,
        value: ExpansionBarState(initiallyExpanded),
        builder: (context) {
          Widget icon = context.streamPylon<ExpansionBarState>().buildNullable(
              (state) => (state?.expanded ?? true)
                  ? const Icon(Icons.chevron_up_ionic)
                  : const Icon(Icons.chevron_down_ionic));

          return SliverStickyHeader.builder(
            builder: (context, state) => GhostButton(
                density: ButtonDensity.compact,
                onPressed: () => context.modPylon<ExpansionBarState>(
                    (i) => ExpansionBarState(!i.expanded)),
                child: Bar(
                  ignoreContextSignals: true,
                  useGlass: state.isPinned,
                  backButton: backButton,
                  title: context.isSidebarExpandedOrAbsent ? title : icon,
                  header: header,
                  subtitle: subtitle,
                  titleText: titleText,
                  subtitleText: subtitleText,
                  headerText: headerText,
                  leading: leading,
                  trailing: [
                    ...trailing,
                    if (context.isSidebarExpandedOrAbsent) icon
                  ],
                )),
            sliver: SliverAnimatedPaintExtent(
                duration: Duration(milliseconds: 333),
                curve: Curves.easeOutCirc,
                child: context
                    .streamPylon<ExpansionBarState>()
                    .buildNullable((state) => SliverVisibility(
                          visible: (state?.expanded ?? true),
                          sliver: sliver,
                        ))),
          );
        },
      );
}

class ExpansionBarState {
  final bool expanded;

  const ExpansionBarState(this.expanded);
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
  final BarBackButtonMode backButton;
  final bool expandable;
  final bool initiallyExpanded;

  const BarSection(
      {super.key,
      this.backButton = BarBackButtonMode.never,
      this.title,
      required this.sliver,
      this.subtitle,
      this.header,
      this.titleText,
      this.subtitleText,
      this.headerText,
      this.leading = const [],
      this.expandable = false,
      this.initiallyExpanded = true,
      this.trailing = const []});

  const BarSection.expandable(
      {super.key,
      this.backButton = BarBackButtonMode.never,
      this.title,
      required this.sliver,
      this.subtitle,
      this.header,
      this.titleText,
      this.subtitleText,
      this.headerText,
      this.leading = const [],
      this.initiallyExpanded = true,
      this.trailing = const []})
      : expandable = true;

  @override
  Widget build(BuildContext context) => expandable
      ? ExpansionBarSection(
          title: title,
          subtitle: subtitle,
          header: header,
          titleText: titleText,
          subtitleText: subtitleText,
          headerText: headerText,
          leading: leading,
          trailing: trailing,
          sliver: sliver,
          backButton: backButton,
          initiallyExpanded: initiallyExpanded,
        )
      : SliverStickyHeader.builder(
          builder: (context, state) => Bar(
            ignoreContextSignals: true,
            useGlass: state.isPinned,
            backButton: backButton,
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

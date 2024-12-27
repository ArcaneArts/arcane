import 'package:arcane/arcane.dart';

class ArcaneScreen extends AbstractStatelessScreen {
  final Widget child;
  final PylonBuilder? sidebar;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final ScrollController? sidebarController;

  const ArcaneScreen({
    super.overrideBackgroundColor,
    super.key,
    super.background,
    super.fab,
    super.footer,
    super.header,
    super.gutter,
    super.loadingProgress,
    super.loadingProgressIndeterminate,
    super.showLoadingSparks,
    super.foreground,
    this.sidebar,
    this.scrollController,
    this.sidebarController,
    this.physics,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => child.isSliver(context)
      ? SliverScreen(
          sliver: child,
          overrideBackgroundColor: overrideBackgroundColor,
          fab: fab,
          footer: footer,
          header: header,
          gutter: gutter,
          loadingProgress: loadingProgress,
          loadingProgressIndeterminate: loadingProgressIndeterminate,
          showLoadingSparks: showLoadingSparks,
          foreground: foreground,
          background: background,
          sidebar: sidebar,
          scrollController: scrollController,
          sidebarController: sidebarController,
          physics: physics,
        )
      : FillScreen(
          overrideBackgroundColor: overrideBackgroundColor,
          fab: fab,
          footer: footer,
          header: header,
          gutter: gutter,
          loadingProgress: loadingProgress,
          loadingProgressIndeterminate: loadingProgressIndeterminate,
          showLoadingSparks: showLoadingSparks,
          foreground: foreground,
          background: background,
          sidebar: sidebar,
          child: child,
        );
}

abstract class AbstractStatefulScreen extends StatefulWidget {
  final Widget? fab;
  final bool? gutter;
  final Widget? header;
  final Widget? footer;
  final Widget? foreground;
  final Widget? background;
  final double? loadingProgress;
  final bool loadingProgressIndeterminate;
  final bool showLoadingSparks;
  final Color? overrideBackgroundColor;

  const AbstractStatefulScreen({
    super.key,
    this.overrideBackgroundColor,
    this.fab,
    this.foreground,
    this.background,
    this.gutter,
    this.header,
    this.footer,
    this.loadingProgress,
    this.loadingProgressIndeterminate = false,
    this.showLoadingSparks = false,
  });
}

abstract class AbstractStatelessScreen extends StatelessWidget {
  final Widget? fab;
  final bool? gutter;
  final Widget? header;
  final Widget? footer;
  final Widget? foreground;
  final Widget? background;
  final double? loadingProgress;
  final bool loadingProgressIndeterminate;
  final bool showLoadingSparks;
  final Color? overrideBackgroundColor;

  const AbstractStatelessScreen({
    super.key,
    this.overrideBackgroundColor,
    this.fab,
    this.foreground,
    this.background,
    this.gutter,
    this.header,
    this.footer,
    this.loadingProgress,
    this.loadingProgressIndeterminate = false,
    this.showLoadingSparks = false,
  });
}

class InjectScreenFooter extends StatelessWidget {
  final PylonBuilder footer;
  final PylonBuilder builder;

  static InjectScreenFooter? getFooter(BuildContext context) =>
      context.pylonOr<InjectScreenFooter>();

  static Widget? getFooterWidget(BuildContext context) =>
      getFooter(context)?.footer(context);

  const InjectScreenFooter(
      {super.key, required this.footer, required this.builder});

  @override
  Widget build(BuildContext context) => Pylon<InjectScreenFooter?>(
        local: true,
        value: this,
        builder: builder,
      );
}

import 'package:arcane/arcane.dart';

abstract class AbstractStatefulScreen extends StatefulWidget {
  final Widget? fab;
  final bool gutter;
  final double minContentFraction;
  final double minContentWidth;
  final Widget? header;
  final Widget? footer;
  final Widget? foreground;
  final Widget? background;
  final double? loadingProgress;
  final bool loadingProgressIndeterminate;
  final bool showLoadingSparks;

  const AbstractStatefulScreen({
    super.key,
    this.fab,
    this.foreground,
    this.background,
    this.gutter = true,
    this.minContentWidth = 500,
    this.minContentFraction = 0.75,
    this.header,
    this.footer,
    this.loadingProgress,
    this.loadingProgressIndeterminate = false,
    this.showLoadingSparks = false,
  });
}

abstract class AbstractStatelessScreen extends StatelessWidget {
  final Widget? fab;
  final bool gutter;
  final double minContentFraction;
  final double minContentWidth;
  final Widget? header;
  final Widget? footer;
  final Widget? foreground;
  final Widget? background;
  final double? loadingProgress;
  final bool loadingProgressIndeterminate;
  final bool showLoadingSparks;

  const AbstractStatelessScreen({
    super.key,
    this.fab,
    this.foreground,
    this.background,
    this.gutter = true,
    this.minContentWidth = 500,
    this.minContentFraction = 0.75,
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
  Widget build(BuildContext context) => Pylon<InjectScreenFooter>(
        local: true,
        value: this,
        builder: builder,
      );
}

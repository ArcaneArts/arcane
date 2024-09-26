import 'package:arcane/arcane.dart';

class InjectFooter extends StatelessWidget {
  final PylonBuilder footer;
  final PylonBuilder builder;

  const InjectFooter({super.key, required this.footer, required this.builder});

  static Widget? getFooter(BuildContext context) =>
      context.pylonOr<InjectFooter>();

  @override
  Widget build(BuildContext context) => Pylon<InjectFooter>(
        local: true,
        value: this,
        builder: builder,
      );
}

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

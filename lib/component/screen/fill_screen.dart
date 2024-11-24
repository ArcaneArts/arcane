import 'package:arcane/arcane.dart';

class FillScreen extends AbstractStatelessScreen {
  final Widget child;

  const FillScreen({
    super.key,
    super.background,
    super.fab,
    super.footer,
    super.header,
    super.gutter,
    super.loadingProgress,
    super.loadingProgressIndeterminate,
    super.minContentFraction,
    super.minContentWidth,
    super.showLoadingSparks,
    super.foreground,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double gutterWidth = gutter && width > minContentWidth
        ? (width * ((1 - minContentFraction) / 2)) - 25
        : 0;

    Widget? footer = this.footer ?? InjectScreenFooter.getFooterWidget(context);

    return Scaffold(
        primary: context.pylonOr<NavigationType>() != NavigationType.drawer,
        child: MaybeStack(
          fit: StackFit.expand,
          children: [
            if (background != null) background!,
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (header != null)
                  SafeBar(
                      top: true,
                      builder: (context) => GlassStopper(
                          builder: (context) => header!, stopping: false)),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: MaybeStack(
                        fit: StackFit.passthrough,
                        children: [
                          child.padOnly(left: gutterWidth, right: gutterWidth),
                          if (fab != null) FabSocket(child: fab!),
                          if (foreground != null) foreground!,
                        ],
                      ),
                    ),
                    if (footer != null)
                      SafeBar(
                          bottom: true,
                          builder: (context) => GlassStopper(
                              builder: (context) => footer, stopping: false)),
                  ],
                ))
              ],
            )
          ],
        ));
  }
}

import 'package:arcane/arcane.dart';

class FillScreen extends AbstractStatelessScreen {
  final Widget child;
  final PylonBuilder? sidebar;

  const FillScreen({
    super.overrideBackgroundColor,
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
    this.sidebar,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double gutterWidth = gutter && width > minContentWidth
        ? (width * ((1 - minContentFraction) / 2)) - 25
        : 0;

    Widget? footer = this.footer ?? InjectScreenFooter.getFooterWidget(context);
    PylonBuilder? sidebar =
        this.sidebar ?? context.pylonOr<ArcaneSidebarInjector>()?.builder;
    return Scaffold(
        overrideBackgroundColor: overrideBackgroundColor,
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
                      child: Stack(
                        fit: StackFit.passthrough,
                        children: [
                          Positioned.fill(
                              child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (sidebar != null) sidebar(context),
                              Expanded(
                                  child: child.padOnly(
                                      left: gutterWidth, right: gutterWidth)),
                            ],
                          )),
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

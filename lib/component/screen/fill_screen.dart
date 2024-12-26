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
    super.showLoadingSparks,
    super.foreground,
    this.sidebar,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget? footer = this.footer ?? InjectScreenFooter.getFooterWidget(context);
    PylonBuilder? isidebar = context.pylonOr<ArcaneSidebarInjector>()?.builder;
    PylonBuilder? sidebar = this.sidebar ?? isidebar;
    return Scaffold(
        overrideBackgroundColor: overrideBackgroundColor,
        primary: context.pylonOr<NavigationType>() != NavigationType.drawer,
        child: MaybeStack(
          fit: StackFit.expand,
          children: [
            if (background != null)
              PylonRemove<ArcaneSidebarInjector>(
                  builder: (context) => background!),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (header != null)
                  SafeBar(
                      top: true,
                      builder: (context) => GlassStopper(
                          builder: (context) =>
                              PylonRemove<ArcaneSidebarInjector>(
                                  builder: (context) => header!),
                          stopping: false)),
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
                                child: PylonRemove<ArcaneSidebarInjector>(
                                    builder: (context) => Gutter(
                                        enabled: gutter,
                                        child: footer != null
                                            ? child.toBox(context)
                                            : child
                                                .toBox(context)
                                                .bottomEdgeBlur(
                                                    autoMode: true))),
                              ),
                            ],
                          )),
                          if (fab != null)
                            FabSocket(
                                child: PylonRemove<ArcaneSidebarInjector>(
                                    builder: (context) => fab!)),
                          if (foreground != null)
                            PylonRemove<ArcaneSidebarInjector>(
                                builder: (context) => foreground!),
                        ],
                      ),
                    ),
                    if (footer != null)
                      SafeBar(
                          bottom: true,
                          builder: (context) => GlassStopper(
                              builder: (context) =>
                                  PylonRemove<ArcaneSidebarInjector>(
                                      builder: (context) => footer),
                              stopping: false)),
                  ],
                ))
              ],
            )
          ],
        ));
  }
}

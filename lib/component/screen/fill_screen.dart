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
  Widget build(BuildContext context) => Scaffold(
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
                child: MaybeStack(
                  fit: StackFit.passthrough,
                  children: [
                    child,
                    if (fab != null) FabSocket(child: fab!),
                    if (foreground != null) foreground!,
                  ],
                ),
              ),
              if (footer != null)
                SafeBar(
                    bottom: true,
                    builder: (context) => GlassStopper(
                        builder: (context) => footer!, stopping: false)),
            ],
          )
        ],
      ));
}

import 'package:arcane/arcane.dart';

bool v = false;
String? vv;
void main() {
  runApp(const ExampleArcaneApp());
}

class ExampleArcaneApp extends StatelessWidget {
  const ExampleArcaneApp({super.key});

  @override
  Widget build(BuildContext context) => ArcaneApp(
        home: ExampleNavigationScreen(),
        theme: ArcaneTheme(
            scheme: ContrastedColorScheme.fromScheme(ColorSchemes.zinc)),
      );
}

class ExampleNavigationScreen extends StatelessWidget {
  const ExampleNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) => FillScreen(
        child: SizedBox.shrink(),
        fab: FabGroup(
          child: Icon(Icons.menu_ionic),
          children: [
            FabGroup(
              horizontal: true,
              child: Icon(Icons.menu_ionic),
              children: [
                FabGroup(
                  child: Icon(Icons.menu_ionic),
                  children: [
                    FabGroup(
                      horizontal: true,
                      child: Icon(Icons.menu_ionic),
                      children: [
                        Fab(
                            child: Icon(Icons.airplane),
                            onPressed: () {
                              context.dismissOverlay();
                            }),
                        Fab(
                            child: Icon(Icons.activity),
                            onPressed: () {
                              context.dismissOverlay();
                            }),
                        Fab(
                            child: Icon(Icons.alarm),
                            onPressed: () {
                              context.dismissOverlay();
                            })
                      ],
                    ),
                    Fab(
                        child: Icon(Icons.activity),
                        onPressed: () {
                          context.dismissOverlay();
                        }),
                    Fab(
                        child: Icon(Icons.alarm),
                        onPressed: () {
                          context.dismissOverlay();
                        })
                  ],
                ),
                Fab(
                    child: Icon(Icons.activity),
                    onPressed: () {
                      context.dismissOverlay();
                    }),
                Fab(
                    child: Icon(Icons.alarm),
                    onPressed: () {
                      context.dismissOverlay();
                    })
              ],
            ),
            Fab(
                child: Icon(Icons.activity),
                onPressed: () {
                  context.dismissOverlay();
                }),
            Fab(
                child: Icon(Icons.alarm),
                onPressed: () {
                  context.dismissOverlay();
                })
          ],
        ),
      );
}

class FabGroup extends StatelessWidget {
  final Widget child;
  final Widget? leading;
  final List<Widget> children;
  final bool horizontal;

  const FabGroup(
      {super.key,
      required this.child,
      this.leading,
      this.children = const [],
      this.horizontal = false})
      : assert(children.length > 0, "FabGroup must have at least one child");

  @override
  Widget build(BuildContext context) {
    List<Widget> c = children.toList();

    return Fab(
      leading: leading,
      onPressed: () {
        showPopover(
            consumeOutsideTaps: true,
            context: context,
            offset: horizontal ? const Offset(0, 70) : const Offset(70, 0),
            barrierDismissable: true,
            builder: (context) => horizontal
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: c,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: c,
                  ),
            alignment: Alignment.bottomRight);
      },
      child: child,
    );
  }
}

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
          children: (context) => [
            Fab(
                child: Icon(Icons.activity),
                onPressed: () {
                  context.dismissFabGroup();
                }),
            Fab(
                child: Icon(Icons.alarm),
                onPressed: () {
                  context.dismissFabGroup();
                })
          ],
        ),
      );
}

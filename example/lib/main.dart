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
        gutter: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GoogleSignInButton(),
              Gap(8),
              AppleSignInButton(),
              Gap(8),
              EmailPasswordSignIn()
            ],
          ),
        ),
      );
}

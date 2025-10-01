import 'dart:async';

import 'package:arcane/arcane.dart';
import 'package:example/home.dart';

bool v = false;
String? vv;
void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    runApp("example", const ExampleArcaneApp());
  }, (error, stackTrace) {
    print("Error: $error");
    print("Stack: $stackTrace");
  });
}

class ExampleArcaneApp extends StatelessWidget {
  const ExampleArcaneApp({super.key});

  @override
  Widget build(BuildContext context) => const ArcaneApp(
      home: HomeScreen(),
      showPerformanceOverlay: false,
      theme: ArcaneTheme(
          themeMode: ThemeMode.dark, surfaceEffect: BlurSurfaceEffect()));
}

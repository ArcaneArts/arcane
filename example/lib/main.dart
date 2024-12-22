import 'dart:async';

import 'package:arcane/arcane.dart';
import 'package:example/model/note.dart';
import 'package:example/screen/home.dart';

bool v = false;
String? vv;
void main() {
  setupNotes();

  runZonedGuarded(() {
    runApp(ExampleArcaneApp());
  }, (error, stackTrace) {
    print("Error: $error");
    print("Stack: $stackTrace");
  });
}

class ExampleArcaneApp extends StatelessWidget {
  const ExampleArcaneApp({super.key});

  @override
  Widget build(BuildContext context) => ArcaneApp(
        arcaneRoutes: [
          HomeScreen(),
        ],
        theme: ArcaneTheme(
            themeMode: ThemeMode.system,
            scheme: ContrastedColorScheme.fromScheme(ColorSchemes.zinc)),
      );
}

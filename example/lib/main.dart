import 'dart:async';

import 'package:arcane/arcane.dart';
import 'package:example/screen/home.dart';
import 'package:flutter/services.dart';

bool v = false;
String? vv;
void main() {
  runZonedGuarded(() {
    runApp(ExampleArcaneApp());
  }, (error, stackTrace) {
    print("Error: $error");
    print("Stack: $stackTrace");
  });
}

class ExampleArcaneApp extends StatelessWidget {
  const ExampleArcaneApp({super.key});

  void didShortcut() {
    print("YOU DID IT");
  }

  @override
  Widget build(BuildContext context) => ArcaneShortcuts(
          shortcuts: {
            LogicalKeySet(
              LogicalKeyboardKey.control,
              LogicalKeyboardKey.alt,
              LogicalKeyboardKey.keyF,
            ): didShortcut
          },
          child: ArcaneApp(
            home: HomeScreen(),
            showPerformanceOverlay: false,
            theme: ArcaneTheme(
                scrollBehavior: const ArcaneScrollBehavior(
                    physics: ClampingScrollPhysics()),
                themeMode: ThemeMode.system,
                scheme: ContrastedColorScheme.fromScheme(ColorSchemes.violet)),
          ));
}

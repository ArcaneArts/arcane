import 'dart:async';

import 'package:arcane/arcane.dart';
import 'package:example/model/note.dart';
import 'package:example/screen/home.dart';
import 'package:fast_log/fast_log.dart';
import 'package:flutter/services.dart';

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
            arcaneRoutes: [HomeScreen(), AScreen(), A404Screen()],
            onUnknownRoute: (r) {
              actioned("UNKNOWN ROUTE HIT");
              MaterialPageRoute(builder: (context) => HomeScreen());
            },
            theme: ArcaneTheme(
                themeMode: ThemeMode.system,
                scheme: ContrastedColorScheme.fromScheme(ColorSchemes.violet)),
          ));
}

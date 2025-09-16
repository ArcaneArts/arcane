import 'dart:async';

import 'package:arcane/arcane.dart';
import 'package:flutter/services.dart';

bool v = false;
String? vv;
void main() {
  runZonedGuarded(() {
    runApp("example", const ExampleArcaneApp());
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
                  themeMode: ThemeMode.system,
                  blurMode: ArcaneBlurMode.backdropFilter)));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => ArcaneScreen(
          child: Collection(
        children: [
          CardSection(
            title: Text("Test"),
            leadingIcon: Icons.airplane,
            children: [
              Container(
                child: Tabbed(tabs: {
                  "Tab 1": Text("content1"),
                  "Tab 2": Text("content2"),
                }),
              )
            ],
          )
        ],
      ).padSliverBy(horizontal: 16, vertical: 16));
}

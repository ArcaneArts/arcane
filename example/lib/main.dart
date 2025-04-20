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
                scheme: ContrastedColorScheme.fromScheme(ColorSchemes.violet)),
          ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FillScreen(
        child: TextButton(
      child: Text("Open Sheet"),
      onPressed: () => Sheet(builder: (context) => SheetScreen()).open(context),
    ));
  }
}

class SheetScreen extends StatelessWidget {
  const SheetScreen({super.key});

  @override
  Widget build(BuildContext context) => ArcaneScreen(
      gutter: false,
      title: "This is a sheet",
      actions: const [
        IconButtonMenu(
            icon: Icons.activity_thin,
            items: [MenuButton(child: Text("Do Thing"))])
      ],
      child: Collection(
        children: [
          Section(
              titleText: "Section One",
              child: SListView.builder(
                builder: (context, i) => ListTile(
                  titleText: "Entry $i",
                  leadingIcon: Icons.activity_thin,
                ),
                childCount: 10,
              )),
          Section(
              titleText: "Section One",
              child: SGridView.builder(
                builder: (context, i) => BasicCard(
                  onPressed: () =>
                      DialogText(title: "GGG", onConfirm: (t) {}).open(context),
                  title: Text("Entry $i"),
                ),
                childCount: 10,
              ))
        ],
      ));
}

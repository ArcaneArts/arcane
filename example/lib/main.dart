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
  Widget build(BuildContext context) => ArcaneShortcuts(shortcuts: {
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.alt,
          LogicalKeyboardKey.keyF,
        ): didShortcut
      }, child: ArcaneApp(home: HomeScreen(), showPerformanceOverlay: false));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ArcaneScreen(
      title: "Form Example with some long text\n",
      subtitle: "Some Subtitle Text or some shit",
      actions: [IconButton(icon: Icon(Icons.dots_three_vertical))],
      fab: FabMenu(
        child: Text("Entry"),
        leading: Icon(Icons.play_circle),
        items: [
          MenuButton(child: Text("AAAA")),
          MenuButton(child: Text("AAAA")),
          MenuButton(child: Text("AAAA"))
        ],
      ),
      child: Collection(
        children: [
          Collection(
            children: [
              ...List.generate(
                  5,
                  (i) => MagicTile(
                        leading: Icon(Icons.address_book,
                            color: randomColor(i, targetLuminance: 0.8)),
                        title: Text("Some entry $i"),
                        subtitle: Text("This is a subtitle for entry $i"),
                      ))
            ],
          ),
          Section(
              titleText: "Some Section",
              subtitleText: "fsdfjsdfjd",
              child: Collection(
                children: [
                  ...List.generate(
                      35,
                      (i) => MagicTile(
                            onPressed: () =>
                                DialogConfirm(title: "title", onConfirm: () {})
                                    .open(context),
                            trailing: Icon(Icons.address_book,
                                color: randomColor(i * 192283,
                                    targetLuminance: 0.8)),
                            leading: Icon(Icons.address_book,
                                color: randomColor(i, targetLuminance: 0.8)),
                            title: Text("Some entry $i"),
                            subtitle: Text("This is a subtitle for entry $i"),
                          ))
                ],
              ))
        ],
      ),
    );
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

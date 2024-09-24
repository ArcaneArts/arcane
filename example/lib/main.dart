import 'package:arcane/arcane.dart';
import 'package:example/screen/buttons.dart';
import 'package:example/screen/dialogs.dart';
import 'package:example/screen/menus.dart';
import 'package:example/screen/nav_tabs.dart';
import 'package:example/screen/sheets.dart';
import 'package:example/screen/text.dart';
import 'package:example/screen/tiles.dart';
import 'package:example/screen/toasts.dart';

bool v = false;
String? vv;
void main() {
  runApp(const ExampleArcaneApp());
}

class ExampleArcaneApp extends StatelessWidget {
  const ExampleArcaneApp({super.key});

  @override
  Widget build(BuildContext context) => ArcaneApp(
        home: const Home(),
        theme: ArcaneTheme(
            themeMode: ThemeMode.system, scheme: ColorSchemes.red()),
      );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) => Screen(
      header: const Bar(
        titleText: "Arcane",
      ),
      sliver: SListView(children: [
        Tile(
          leading: const Icon(Icons.text_aa),
          title: const Text("Text"),
          subtitle: const Text("Text sizes & styles"),
          onPressed: () => Arcane.push(context, const ExampleText()),
        ),
        Tile(
          leading: const Icon(Icons.gift),
          title: const Text("Buttons"),
          subtitle: const Text("Button styles w/o icons"),
          onPressed: () => Arcane.push(context, const ExampleButtons()),
        ),
        Tile(
          leading: const Icon(Icons.cards),
          title: const Text("Tiles"),
          subtitle: const Text("List Tiles"),
          onPressed: () => Arcane.push(context, const ExampleTiles()),
        ),
        Tile(
          leading: const Icon(Icons.diamond),
          title: const Text("Dialogs"),
          subtitle: const Text("Dialog confirms and whatnot"),
          onPressed: () => Arcane.push(context, const ExampleDialogs()),
        ),
        Tile(
          leading: const Icon(Icons.file),
          title: const Text("Sheets"),
          subtitle: const Text("Modal sheets"),
          onPressed: () => Arcane.push(context, const ExampleSheets()),
        ),
        Tile(
          leading: const Icon(Icons.bell),
          title: const Text("Toast"),
          subtitle: const Text("Toast notifications"),
          onPressed: () => Arcane.push(context, const ExampleToasts()),
        ),
        Tile(
          leading: const Icon(Icons.menu_ionic),
          title: const Text("Menus"),
          subtitle: const Text("Context & Dropdown Menus"),
          onPressed: () => Arcane.push(context, const ExampleMenus()),
        ),
        Tile(
          leading: const Icon(Icons.table),
          title: const Text("Nav Screen"),
          subtitle: const Text("Rails & Bottom Bars"),
          onPressed: () => Arcane.push(context, const ExampleNavTabs()),
        )
      ]));
}

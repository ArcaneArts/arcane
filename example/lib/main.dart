import 'package:arcane/arcane.dart';
import 'package:example/showcase/buttons.dart';
import 'package:example/showcase/cards.dart';
import 'package:example/showcase/text.dart';
import 'package:example/util/showcase.dart';

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
            themeMode: ThemeMode.system,
            scheme: ContrastedColorScheme.fromScheme(ColorSchemes.blue)),
      );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool searching = false;
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool listed = false;

  List<ArcaneShowcase> get valid => searching
      ? showcases.where((element) => element.matches(controller.text)).toList()
      : showcases;

  @override
  Widget build(BuildContext context) => SliverScreen(
      header: Bar(
        headerText: searching ? null : "Arcane",
        title: searching
            ? TextField(
                controller: controller,
                onChanged: (v) {
                  setState(() {});
                },
                onSubmitted: (v) {},
                placeholder: const Text("Search"),
              )
            : const Text("Tome of Style"),
        trailing: [
          searching
              ? IconButton(
                  icon: const Icon(Icons.x),
                  onPressed: () {
                    setState(() {
                      searching = false;
                      controller.clear();
                    });
                  })
              : IconButton(
                  icon: const Icon(Icons.search_ionic),
                  onPressed: () {
                    setState(() {
                      searching = true;
                      focusNode.requestFocus();
                    });
                  }),
        ],
      ),
      sliver: MultiSliver(
        children: [
          ...valid
              .whereType<SliverScreenArcaneShowcase>()
              .map((e) => BarSection(
                    leading: [
                      if (e.icon != null) Icon(e.icon),
                    ],
                    titleText: e.name,
                    subtitleText: e.description,
                    sliver: e.buildSliver(context),
                  )),
          SGridView(
            children: [
              ...valid
                  .where((e) => e is! SliverScreenArcaneShowcase)
                  .map((e) => e.buildCard(context))
            ],
          ),
        ],
      ));
}

const List<ArcaneShowcase> showcases = [
  TextShowcase(),
  ButtonsShowcase(),
  CardsShowcase()
];

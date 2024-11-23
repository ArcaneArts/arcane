import 'package:arcane/arcane.dart';
import 'package:arcane/component/dialog/command.dart';
import 'package:example/chat/chat.dart';
import 'package:example/chat/model/message.dart';
import 'package:example/chat/model/user.dart';
import 'package:example/showcase/buttons.dart';
import 'package:example/showcase/cards.dart';
import 'package:example/showcase/text.dart';
import 'package:example/util/showcase.dart';
import 'package:rxdart/rxdart.dart';

bool v = false;
String? vv;
void main() {
  runApp(const ExampleArcaneApp());
}

BehaviorSubject<List<MyMessage>> messages = BehaviorSubject.seeded([]);
List<MyUser> users = [
  MyUser(id: "0", name: "Dan"),
  MyUser(id: "1", name: "Alice"),
  MyUser(id: "2", name: "Bob"),
  MyUser(id: "3", name: "Charlie"),
];

class ExampleArcaneApp extends StatelessWidget {
  const ExampleArcaneApp({super.key});

  @override
  Widget build(BuildContext context) => ArcaneApp(
        home: ChatScreen(
            streamBuffer: 1000,
            style: MediaQuery.of(context).size.width < 600
                ? ChatStyle.bubbles
                : ChatStyle.tiles,
            provider: MyChatProvider(users: users, messages: messages),
            sender: "0"),
        theme: ArcaneTheme(
            scheme: ContrastedColorScheme.fromScheme(ColorSchemes.zinc)),
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
                placeholder: "Search",
              )
            : const Text("Tome of Style"),
        trailing: [
          IconButton(
              icon: Icon(Icons.address_book),
              onPressed: () => DialogText(
                    onConfirm: (_) {},
                    title: "Arcane",
                    hint: "This is the hint",
                  ).open(context)),
          searching
              ? IconButton(
                  icon: const Icon(Icons.x),
                  onPressed: () {
                    setState(() {
                      searching = false;
                      controller.clear();
                    });
                    DialogCommand(
                      onConfirm: (_) {},
                    ).open(context);
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

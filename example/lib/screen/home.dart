import 'package:arcane/arcane.dart';

List<String> list = List.generate(5, (index) => "Item $index");

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => ArcaneScreen(
        fab: Fab(
            child: const Icon(Icons.plus),
            onPressed: () {
              setState(() {
                list.add(
                    "Item ${list.length} ${DateTime.now().toIso8601String()}");
              });
            }),
        header: Bar(
          titleText: "Thing",
          trailing: [],
        ),
        child: Collection(
          children: [
            Section(
                headerText: "Section 1",
                child: SGridView.builder(
                  builder: (context, i) => Card(
                    child: Text("Item $i"),
                    onPressed: () => DialogConfirm(
                      title: "Confirm",
                      onConfirm: () {},
                    ).open(context),
                    fillColor: [Colors.blue, Colors.red, Colors.green][i % 3],
                    filled: true,
                  ),
                  childCount: 10,
                ))
          ],
        ),
      );
}

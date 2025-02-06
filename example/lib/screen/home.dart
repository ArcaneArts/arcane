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
          titleText: "Test",
          trailing: [],
        ),
        child: Collection(
          children: [
            Card(
              child: ListTile(
                title: Text("Title"),
                subtitle: Text("Subtitle"),
                leading: Icon(Icons.activity),
                children: [
                  ListTile(
                    title: Text("Title"),
                    subtitle: Text("Subtitle"),
                    leading: Icon(Icons.activity),
                    trailing: Icon(Icons.airplane),
                  ),
                  ListTile(
                    title: Text("Title"),
                    subtitle: Text("Subtitle"),
                    leading: Icon(Icons.activity),
                    trailing: Icon(Icons.airplane),
                  ),
                  ListTile(
                    title: Text("Title"),
                    subtitle: Text("Subtitle"),
                    leading: Icon(Icons.activity),
                    trailing: Icon(Icons.airplane),
                  ),
                  ListTile(
                    title: Text("Title"),
                    subtitle: Text("Subtitle"),
                    leading: Icon(Icons.activity),
                    trailing: Icon(Icons.airplane),
                  )
                ],
              ),
            )
          ],
        ),
      );
}

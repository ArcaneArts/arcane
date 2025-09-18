import 'package:arcane/arcane.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ArcaneScreen(
          child: Collection(
        children: [
          Card(
              // plug it in
              child: ListTile(
            title: Text("This is a title"),
            subtitleText: "xdfdsdf asdf asdfas df asdf",
            leading: Icon(Icons.diamond),
          )).pad(16).shimmer(loading: false)
        ],
      ));
}

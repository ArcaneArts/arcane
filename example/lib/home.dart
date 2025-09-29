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

  MainAxisSize mainAxisSize = MainAxisSize.max;

  @override
  Widget build(BuildContext context) => ArcaneScreen(
          child: Collection(
        children: [
          Card(
            titleText: "Test",
            subtitleText: "Tested",
            leadingIcon: Icons.activity_bold,
            child: Text("Derp"),
            thumbHash: "3PcNNYSFeXh/d3eld0iHZoZgVwh2",
          )
        ],
      ));
}

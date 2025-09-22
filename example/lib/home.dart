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
  Widget build(BuildContext context) => FillScreen(
      header: Bar(
        title: Text("Derp?"),
      ),
      child: Center(
        child: PrimaryButton(
          child: Text("Dialog"),
          onPressed: () =>
              DialogText(title: "D", onConfirm: (x) {}).open(context),
        ).iw.ih,
      ));
}

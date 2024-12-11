import 'package:arcane/arcane.dart';
import 'package:example/screen/notes.dart';

class HomeScreen extends StatelessWidget with ArcaneRoute {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => FillScreen(
      header: Bar(titleText: "Home"),
      child: Center(
        child: PrimaryButton(
            child: Text("Open Notes"),
            onPressed: () => Arcane.push(context, NotesScreen())),
      ));

  @override
  String get path => "/";
}

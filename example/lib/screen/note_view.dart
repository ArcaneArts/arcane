import 'package:arcane/arcane.dart';
import 'package:example/model/note.dart';

class NoteScreen extends StatelessWidget with ArcaneRoute {
  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) => PylonPort<Note>(
      tag: "note",
      error: const FillScreen(child: Center(child: Text("Error"))),
      loading: const FillScreen(
          child: Center(
        child: Text("Loading"),
      )),
      builder: (context) => FillScreen(
          header: Bar(
            titleText: context.note.name,
          ),
          child: Text(context.note.description)));

  @override
  String get path => "/notes/view";
}

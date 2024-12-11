import 'package:arcane/arcane.dart';
import 'package:example/model/note.dart';
import 'package:example/widget/note_tile.dart';

class NotesScreen extends StatelessWidget with ArcaneRoute {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) => SliverScreen(
      header: Bar(headerText: "Notes Screen"),
      sliver: SListView.builder(
          builder: (context, i) => Pylon<Note>(
                value: notes[i],
                builder: (context) => NoteTile(),
              ),
          childCount: notes.length));

  @override
  String get path => "/notes";
}

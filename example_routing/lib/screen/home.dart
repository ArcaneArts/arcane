import 'package:arcane/arcane.dart';
import 'package:example_routing/db.dart';
import 'package:example_routing/models.dart';
import 'package:example_routing/widget/note_tile.dart';

class HomeScreen extends StatelessWidget with ArcaneRoute {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => DB
      .streamNotes(context.user.id)
      .build(
        (notes) => ArcaneScreen(
          fab: Fab(
            child: Icon(Icons.plus),
            onPressed: () {
              DB.createNote(context.user.id, "n${notes.length + 1}");
            },
          ),
          child: Collection(
            children: [
              for (NoteData note in notes)
                Pylon<NoteData>(value: note, builder: (context) => NoteTile()),
            ],
          ),
        ),
        loading: ArcaneScreen(
          child: Center(child: CircularProgressIndicator()),
        ),
      );

  @override
  String get path => "/";
}

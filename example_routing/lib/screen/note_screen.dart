import 'package:arcane/arcane.dart';
import 'package:example_routing/db.dart';
import 'package:example_routing/models.dart';

class NoteScreen extends StatelessWidget with ArcaneRoute {
  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) => PylonPort<NoteData>(
    tag: "id",
    builder:
        (context) => DB
            .getNote(context.user.id, context.note.id)
            .build(
              (note) => ArcaneScreen(child: Text("Note ${note.id}")),
              loading: ArcaneScreen(child: CircularProgressIndicator()),
            ),
  );

  @override
  String get path => "/note";
}

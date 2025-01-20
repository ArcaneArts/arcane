import 'package:arcane/arcane.dart';
import 'package:example_routing/models.dart';
import 'package:example_routing/screen/note_screen.dart';

class NoteTile extends StatelessWidget with BoxSignal {
  const NoteTile({super.key});

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text("Note ${context.note.id}"),
    onPressed: () => Arcane.push(context, NoteScreen()),
  );
}

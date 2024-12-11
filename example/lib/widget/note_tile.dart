import 'package:arcane/arcane.dart';
import 'package:example/model/note.dart';
import 'package:example/screen/note_view.dart';

// A list tile showing a note
class NoteTile extends StatelessWidget {
  const NoteTile({super.key});

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(context.note.name),
        subtitle: Text(context.note.description),
        onPressed: () => Arcane.push(context, NoteScreen()),
      );
}

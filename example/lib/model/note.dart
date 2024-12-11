// Temporary storage of the "data"
import 'package:arcane/arcane.dart';

List<Note> notes = [];

// Temporary function to add a note
void addNote(String title, String note) => notes.add(Note(
      id: notes.length,
      name: title,
      description: note,
    ));

void setupNotes() {
  // Add some "notes"
  for (int i = 0; i < 100; i++) {
    addNote("Hello Note ${notes.length}",
        "This is the content of note ${notes.length}");
  }

  registerPylonCodec(const Note(id: -1, name: "", description: ""));
}

// A note class representing our data model
class Note implements PylonCodec<Note> {
  final int id;
  final String name;
  final String description;

  const Note({
    required this.id,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'id': id,
        'description': description,
      };

  factory Note.fromMap(Map<String, dynamic> map) => Note(
        name: map['name'],
        description: map['description'],
        id: map['id'],
      );

  @override
  String pylonEncode(Note value) => value.id.toString();

  @override
  Future<Note> pylonDecode(String value) async => notes[int.parse(value)];
}

// Accessor for the note
extension XContextPylonNotes on BuildContext {
  Note get note => pylon<Note>();
}

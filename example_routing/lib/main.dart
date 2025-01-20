import 'package:arcane/arcane.dart';
import 'package:example_routing/models.dart';
import 'package:example_routing/screen/home.dart';
import 'package:example_routing/screen/note_screen.dart';

void main() {
  registerPylonCodec(NoteData(title: "", content: "", id: ""));
  runApp(const NoteApp(), usePathStrategy: true, setupMetaSEO: true);
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) => Pylon<NoteUser>(
    value: NoteUser(name: "Dan", id: "123"),
    builder:
        (context) => ArcaneApp(
          home: HomeScreen(),
          arcaneRoutes: [HomeScreen(), NoteScreen()],
        ),
  );
}

import 'package:arcane/arcane.dart';
import 'package:arcane/component/chat/chat_message.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedValue;

  Consumer? c;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ArcaneScreen(
        title: "Test Images",
        child: Collection(
          children: [
            ChatBubble(
              content: Markdown("This is a ~~message~~\n\n\n\nTest"),
              header: Text("This is a footer"),
              footer: Text("This is a footer"),
              leading: Icon(Icons.user),
              trailing: Icon(Icons.user),
            )
          ],
        ),
      );
}

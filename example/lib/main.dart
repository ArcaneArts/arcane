import 'package:arcane/arcane.dart';
import 'package:arcane/component/screen.dart';

void main() {
  runApp(const ExampleArcaneApp());
}

class ExampleArcaneApp extends StatelessWidget {
  const ExampleArcaneApp({super.key});

  @override
  Widget build(BuildContext context) => const ArcaneApp(
        home: Home(),
      );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) => Screen(
        headers: [Bar(title: const Text("Arcane\n\n\n"))],
        children: [
          Text("Aaaaaaaaaaaaaaaaaaaaaa",
              style: TextStyle(fontSize: 20, color: Colors.red)),
          Text("Aaaaaaaaaaaaaaaaaaaaaa"),
          Text("Aaaaaaaaaaaaaaaaaaaaaa"),
          Text("Aaaaaaaaaaaaaaaaaaaaaa"),
          Text("Aaaaaaaaaaaaaaaaaaaaaa"),
          Text("Aaaaaaaaaaaaaaaaaaaaaa"),
          Text("Aaaaaaaaaaaaaaaaaaaaaa"),
          Text("Aaaaaaaaaaaaaaaaaaaaaa"),
          Text("Aaaaaaaaaaaaaaaaaaaaaa"),
          Text("Aaaaaaaaaaaaaaaaaaaaaa"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
          Text("A"),
        ],
      );
}

import 'package:arcane/arcane.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FillScreen(
          child: Stack(
        fit: StackFit.expand,
        children: [Markdown("# Test ")],
      ));
}

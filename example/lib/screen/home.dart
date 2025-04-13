import 'package:arcane/arcane.dart';

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
        child: SGridView.builder(
          builder: (context, i) => ImageView(
              thumbHash: "VggKDYAW6lZvdYd6d2iZh/p4GE/k",
              // blurHash: "L69l^WqE05Nx*~S%Q-oM03Nd?t\$\$",
              url: Future.value("https://picsum.photos/seed/$i/100/100")),
        ),
      );
}

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
  Widget build(BuildContext context) => FillScreen(
          child: Center(
        child: Row(
          children: [
            Icon(Icons.airplane),
            Icon(RadixIcons.alignBottom),
            Icon(BootstrapIcons.airplane),
            Icon(LucideIcons.flipHorizontal2)
          ],
        ),
      ));
}

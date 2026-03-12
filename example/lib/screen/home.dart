import 'package:arcane/arcane.dart';
import 'package:example/screen/settings.dart';
import 'package:example/screen/showcase.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => NavigationScreen(tabs: [
        NavTab(
            icon: Icons.list,
            builder: (context) => ShowcasesScreen(showcases: [])),
        NavTab(icon: Icons.gear_six, builder: (context) => SettingsScreen()),
      ]);
}

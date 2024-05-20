import 'package:arcane/arcane.dart';
import 'package:example/screen/settings.dart';

// A basic home screen. Note the ArcaneStatelessScreen it extends
class HomeScreen extends ArcaneStatelessScreen {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
                onPressed: () =>
                    const SettingsScreen().open(context), // open arcane screens
                icon: const Icon(Icons.settings))
          ],
        ),
      );

  // We override toPath to let the router know where to find this screen
  @override
  String toPath() => "/";
}

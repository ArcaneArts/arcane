import 'package:arcane/arcane.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) => FillScreen(
          child: Center(
        child: PrimaryButton(
          child: const Text("Press Me"),
          onPressed: () =>
              DialogConfirm(title: "Config?", onConfirm: () {}).open(context),
        ),
      ));
}

class SomeCustomDialog extends StatelessWidget with ArcaneDialogLauncher {
  const SomeCustomDialog({super.key});

  @override
  Widget build(BuildContext context) => const ArcaneDialog(
        content: Text("Shit goes here"),
      );
}

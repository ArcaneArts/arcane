import 'package:arcane/arcane.dart';

class ButtonExample4 extends StatelessWidget {
  const ButtonExample4({super.key});

  @override
  Widget build(BuildContext context) {
    return GhostButton(
      onPressed: () {},
      child: const Text('Ghost'),
    );
  }
}

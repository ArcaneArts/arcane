import 'package:arcane/arcane.dart';

class ButtonExample14 extends StatelessWidget {
  const ButtonExample14({super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonGroup(
      children: [
        PrimaryButton(
          child: const Text('Primary'),
          onPressed: () {},
        ),
        SecondaryButton(
          child: const Text('Secondary'),
          onPressed: () {},
        ),
        DestructiveButton(
          child: const Text('Destructive'),
          onPressed: () {},
        ),
        OutlineButton(
          child: const Text('Outlined'),
          onPressed: () {},
        ),
        GhostButton(
          child: const Text('Ghost'),
          onPressed: () {},
        ),
        IconButton.primary(
          icon: const Icon(Icons.plus),
          onPressed: () {},
        ),
      ],
    );
  }
}

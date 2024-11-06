import 'package:arcane/arcane.dart';

class ButtonExample8 extends StatelessWidget {
  const ButtonExample8({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 8,
      spacing: 8,
      children: [
        IconButton.primary(
          onPressed: () {},
          density: ButtonDensity.icon,
          icon: const Icon(Icons.plus),
        ),
        IconButton.secondary(
          onPressed: () {},
          density: ButtonDensity.icon,
          icon: const Icon(Icons.plus),
        ),
        IconButton.outline(
          onPressed: () {},
          density: ButtonDensity.icon,
          icon: const Icon(Icons.plus),
        ),
        IconButton.ghost(
          onPressed: () {},
          density: ButtonDensity.icon,
          icon: const Icon(Icons.plus),
        ),
        IconButton.text(
          onPressed: () {},
          density: ButtonDensity.icon,
          icon: const Icon(Icons.plus),
        ),
        IconButton.destructive(
          onPressed: () {},
          density: ButtonDensity.icon,
          icon: const Icon(Icons.plus),
        ),
      ],
    );
  }
}

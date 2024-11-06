import 'package:arcane/arcane.dart';

class AppBarExample1 extends StatelessWidget {
  const AppBarExample1({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedContainer(
      clipBehavior: Clip.antiAlias,
      child: AppBar(
        header: const Text('This is Header'),
        title: const Text('This is Title'),
        subtitle: const Text('This is Subtitle'),
        leading: [
          OutlineButton(
            density: ButtonDensity.icon,
            onPressed: () {},
            child: const Icon(Icons.chevron_back_ionic),
          ),
        ],
        trailing: [
          OutlineButton(
            density: ButtonDensity.icon,
            onPressed: () {},
            child: const Icon(Icons.search_ionic),
          ),
          OutlineButton(
            density: ButtonDensity.icon,
            onPressed: () {},
            child: const Icon(Icons.dots_three_vertical),
          ),
        ],
      ),
    );
  }
}

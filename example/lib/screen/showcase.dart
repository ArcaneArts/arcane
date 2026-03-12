import 'package:arcane/arcane.dart';

class ShowcasesScreen extends StatelessWidget {
  final List<Showcase> showcases;

  const ShowcasesScreen({super.key, required this.showcases});

  @override
  Widget build(BuildContext context) => Screen(
        title: "Showcases",
        child: Collection(
          children: [
            ...showcases.map((i) => MagicTile(
                  titleText: i.name,
                  onPressed: () => Arcane.push(context, i.screen),
                ))
          ],
        ),
      );
}

class Showcase {
  final String name;
  final Widget screen;

  Showcase(this.name, this.screen);
}

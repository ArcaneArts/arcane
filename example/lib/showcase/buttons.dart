import 'package:arcane/arcane.dart';
import 'package:example/util/showcase.dart';

class ButtonsShowcase extends SliverScreenArcaneShowcase {
  const ButtonsShowcase({
    super.name = "Buttons",
    super.description = "A button clearly indicates a call to action.",
    super.icon = Icons.text_aa,
  });

  @override
  Widget buildSliver(BuildContext context) => SGridView(
        childAspectRatio: 5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: [
          GhostButton(
            onPressed: () {},
            density: ButtonDensity.icon,
            child: const Icon(Icons.activity),
          ),
          GhostButton(
            child: const Text("Ghost Button"),
            onPressed: () {},
          ),
          GhostButton(
            onPressed: () {},
            leading: const Icon(Icons.activity),
            child: Text("Ghost w Icon"),
          ),
          TextButton(
            onPressed: () {},
            density: ButtonDensity.icon,
            child: Icon(Icons.activity),
          ),
          TextButton(
            child: const Text("Text Button"),
            onPressed: () {},
          ),
          TextButton(
            onPressed: () {},
            leading: const Icon(Icons.activity),
            child: Text("Text w Icon"),
          ),
          OutlineButton(
            onPressed: () {},
            density: ButtonDensity.icon,
            child: Icon(Icons.activity),
          ),
          OutlineButton(
            child: const Text("Outline Button"),
            onPressed: () {},
          ),
          OutlineButton(
            onPressed: () {},
            leading: const Icon(Icons.activity),
            child: Text("Outline w Icon"),
          ),
          SecondaryButton(
            onPressed: () {},
            density: ButtonDensity.icon,
            child: Icon(Icons.activity),
          ),
          SecondaryButton(
            child: const Text("Secondary Button"),
            onPressed: () {},
          ),
          SecondaryButton(
            onPressed: () {},
            leading: const Icon(Icons.activity),
            child: Text("Secondary w Icon"),
          ),
          PrimaryButton(
            onPressed: () {},
            density: ButtonDensity.icon,
            child: Icon(Icons.activity),
          ),
          PrimaryButton(
            child: const Text("Primary Button"),
            onPressed: () {},
          ),
          PrimaryButton(
            onPressed: () {},
            leading: const Icon(Icons.activity),
            child: Text("Primary w Icon"),
          ),
        ],
      );
}

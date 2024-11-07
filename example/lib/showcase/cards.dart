import 'package:arcane/arcane.dart';
import 'package:example/util/showcase.dart';

class CardsShowcase extends SliverScreenArcaneShowcase {
  const CardsShowcase({
    super.name = "Cards",
    super.description = "A showcase of cards",
    super.icon = Icons.cards,
  });

  @override
  Widget buildSliver(BuildContext context) => SGridView(
        childAspectRatio: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: [
          const Card(
            child: Center(
              child: Basic(
                leading: Icon(Icons.activity),
                title: Text("Arcane"),
                subtitle: Text("A style library for Flutter"),
              ),
            ),
          ),
          Card(
            onPressed: () => const TextToast("Pressed").open(context),
            child: const Basic(
              leading: Icon(Icons.activity),
              title: Text("Clickable"),
              subtitle: Text("A Clickable card"),
            ),
          )
        ],
      );
}

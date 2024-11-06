import 'package:arcane/arcane.dart';
import 'package:example/util/showcase.dart';

class TextShowcase extends SliverScreenArcaneShowcase {
  const TextShowcase({
    super.name = "Text",
    super.description = "A run of text with a single style.",
    super.icon = Icons.text_aa,
  });

  @override
  Widget buildSliver(BuildContext context) => SListView(
        children: [
          Text("x9 Large", style: Theme.of(context).typography.x9Large),
          Text("x8 Large", style: Theme.of(context).typography.x8Large),
          Text("x7 Large", style: Theme.of(context).typography.x7Large),
          Text("x6 Large", style: Theme.of(context).typography.x6Large),
          Text("x5 Large", style: Theme.of(context).typography.x5Large),
          Text("x4 Large", style: Theme.of(context).typography.x4Large),
          Text("x3 Large", style: Theme.of(context).typography.x3Large),
          Text("x2 Large", style: Theme.of(context).typography.x2Large),
          Text("Large", style: Theme.of(context).typography.large),
          Text("Medium", style: Theme.of(context).typography.medium),
          Text("Small", style: Theme.of(context).typography.small),
          Text("xSmall", style: Theme.of(context).typography.xSmall),
          const Divider(
            height: 16,
            child: Text("Headlines"),
          ),
          Text("Heading 1", style: Theme.of(context).typography.h1),
          Text("Heading 2", style: Theme.of(context).typography.h2),
          Text("Heading 3", style: Theme.of(context).typography.h3),
          Text("Heading 4", style: Theme.of(context).typography.h4),
          const Divider(
            height: 16,
            child: Text("Modifiers"),
          ),
          Text("Lead", style: Theme.of(context).typography.lead),
          Text("Bold", style: Theme.of(context).typography.bold),
          Text("Black", style: Theme.of(context).typography.black),
          Text("Muted", style: Theme.of(context).typography.textMuted),
        ],
      );
}

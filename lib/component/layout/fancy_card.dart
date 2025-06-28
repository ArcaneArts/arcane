import 'package:arcane/arcane.dart';

class FancyCard extends StatelessWidget with BoxSignal {
  final IconData icon;
  final String title;
  final List<Widget> trailing;
  final List<Widget> children;

  const FancyCard({
    super.key,
    required this.icon,
    required this.title,
    this.trailing = const [],
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) => Card(
          child: Column(children: [
        Row(
          children: [
            Gap(8),
            Icon(icon),
            Gap(16),
            Text(title).xLarge.muted,
            Spacer(),
            ...trailing,
          ],
        ),
        ...children
      ]));
}

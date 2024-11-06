import 'package:arcane/arcane.dart';

class BadgeExample4 extends StatelessWidget {
  const BadgeExample4({super.key});

  @override
  Widget build(BuildContext context) {
    return const DestructiveBadge(
      child: Text('Destructive'),
    );
  }
}

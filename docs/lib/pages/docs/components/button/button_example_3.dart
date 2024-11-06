import 'package:arcane/arcane.dart';

class ButtonExample3 extends StatelessWidget {
  const ButtonExample3({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      onPressed: () {},
      child: const Text('Outlined'),
    );
  }
}

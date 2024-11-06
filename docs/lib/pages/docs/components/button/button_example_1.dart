import 'package:arcane/arcane.dart';

class ButtonExample1 extends StatelessWidget {
  const ButtonExample1({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: () {},
      child: const Text('Primary'),
    );
  }
}

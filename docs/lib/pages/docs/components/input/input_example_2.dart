import 'package:arcane/arcane.dart';

class InputExample2 extends StatelessWidget {
  const InputExample2({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      initialValue: 'Hello World!',
      placeholder: 'Enter your message',
    );
  }
}

import 'package:arcane/arcane.dart';

class LinearProgressExample1 extends StatelessWidget {
  const LinearProgressExample1({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 200,
      child: LinearProgressIndicator(),
    );
  }
}

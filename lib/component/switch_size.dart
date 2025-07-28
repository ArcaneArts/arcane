import 'package:arcane/arcane.dart';

class SwitchSize extends StatelessWidget {
  final Map<double, Widget> sizes;

  const SwitchSize({super.key, required this.sizes});

  @override
  Widget build(BuildContext context) {
    assert(sizes.isNotEmpty, "Sizes map cannot be empty");
    double width = MediaQuery.of(context).size.width;
    List<double> sk = sizes.keys.toList();
    sk.sort((a, b) => a.compareTo(b));
    for (double i in sk) {
      if (width <= i) {
        return sizes[i]!;
      }
    }

    return sizes[sk.last]!;
  }
}

class BigSmall extends StatelessWidget {
  final Widget big;
  final Widget small;

  const BigSmall({super.key, required this.big, required this.small});

  @override
  Widget build(BuildContext context) =>
      MediaQuery.of(context).size.width > 700 ? big : small;
}

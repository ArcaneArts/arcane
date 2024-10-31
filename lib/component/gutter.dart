import 'dart:math';

import 'package:arcane/arcane.dart';

class SliverGutter extends StatelessWidget {
  final Widget sliver;

  const SliverGutter({super.key, required this.sliver});

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    double p = min(
        max(0, 25 + ((MediaQuery.of(context).size.width * 0.25) - 250)),
        s.width / 3);
    return p > 0
        ? SliverPadding(
            sliver: sliver, padding: EdgeInsets.symmetric(horizontal: p))
        : sliver;
  }
}

class Gutter extends StatelessWidget {
  final Key? treeKey;
  final Widget child;

  const Gutter({super.key, required this.child, this.treeKey});

  @override
  Widget build(BuildContext context) => Adaptive(
        treeKey: treeKey,
        builders: {
          const AdaptiveSize.mobile(): (context) => child,
          const AdaptiveSize.tablet(): (context) => Builder(
                builder: (context) => PaddingHorizontal(
                  padding: max(0,
                      25 + ((MediaQuery.of(context).size.width * 0.25) - 250)),
                  child: child,
                ),
              ),
          const AdaptiveSize.desktop(): (context) => Builder(
                builder: (context) => PaddingHorizontal(
                  padding:
                      80 + ((MediaQuery.of(context).size.width * 0.25) - 300),
                  child: child,
                ),
              ),
        },
      );
}

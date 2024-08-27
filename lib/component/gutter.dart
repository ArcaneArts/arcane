import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:padded/padded.dart';

class Gutter extends StatelessWidget {
  final Widget child;

  const Gutter({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Adaptive(
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

import 'dart:math';

import 'package:arcane/arcane.dart';

double _defaultGutterCalc(double screenWidth) {
  double d =
      max(0, min(max(0, 25 + ((screenWidth * 0.25) - 250)), screenWidth / 3));
  print("$screenWidth -> $d");
  return d;
}

class GutterTheme {
  /// The value returned is both applied on the left and right.
  final double Function(double screenWidth) gutterCalc;

  const GutterTheme({this.gutterCalc = _defaultGutterCalc});

  GutterTheme copyWith({double Function(double screenWidth)? gutterCalc}) =>
      GutterTheme(gutterCalc: gutterCalc ?? this.gutterCalc);
}

class SliverGutter extends StatelessWidget {
  final Widget sliver;
  final bool enabled;

  const SliverGutter({super.key, required this.sliver, this.enabled = true});

  @override
  Widget build(BuildContext context) => SliverPadding(
      sliver: sliver,
      padding: EdgeInsets.symmetric(
          horizontal: enabled
              ? Arcane.themeOf(context)
                  .gutter
                  .gutterCalc(MediaQuery.of(context).size.width)
              : 0));
}

class Gutter extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const Gutter({super.key, required this.child, this.enabled = true});

  @override
  Widget build(BuildContext context) => PaddingHorizontal(
      padding: enabled
          ? Arcane.themeOf(context)
              .gutter
              .gutterCalc(MediaQuery.of(context).size.width)
          : 0,
      child: child);
}

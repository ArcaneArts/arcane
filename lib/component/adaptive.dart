import 'package:arcane/arcane.dart';

typedef AdaptiveBuilder = Widget Function(BuildContext context);

class AdaptiveSize {
  final double? minWidth;
  final double? minHeight;

  const AdaptiveSize({this.minWidth, this.minHeight});
  const AdaptiveSize.mobile() : this(minWidth: 0, minHeight: 0);
  const AdaptiveSize.tablet() : this(minWidth: 800, minHeight: 0);
  const AdaptiveSize.desktop() : this(minWidth: 1200, minHeight: 600);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdaptiveSize &&
        other.minWidth == minWidth &&
        other.minHeight == minHeight;
  }

  @override
  int get hashCode => minWidth.hashCode ^ minHeight.hashCode;

  @override
  String toString() =>
      'AdaptiveSize(minWidth: $minWidth, minHeight: $minHeight)';
}

class Adaptive extends StatelessWidget {
  final Map<AdaptiveSize, AdaptiveBuilder> builders;

  const Adaptive({super.key, required this.builders})
      : assert(builders.length > 0, 'At least one builder must be provided');

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;

          AdaptiveSize? last;

          for (var entry in builders.entries) {
            double w = entry.key.minWidth ?? 0;
            double h = entry.key.minHeight ?? 0;

            if (width >= w && height >= h) {
              last = entry.key;
            } else {
              break;
            }
          }

          return builders[last ?? builders.entries.first.key]!(context);
        },
      );
}

import 'package:arcane/arcane.dart';

class MaybeStack extends StatelessWidget {
  final StackFit fit;
  final AlignmentGeometry alignment;
  final List<Widget> children;
  final Clip clipBehavior;
  final TextDirection? textDirection;

  const MaybeStack({
    super.key,
    this.fit = StackFit.loose,
    this.alignment = AlignmentDirectional.topStart,
    this.children = const [],
    this.clipBehavior = Clip.hardEdge,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) => children.isEmpty
      ? const SizedBox.shrink()
      : children.length > 1
          ? Stack(
              fit: fit,
              alignment: alignment,
              textDirection: textDirection,
              clipBehavior: clipBehavior,
              children: children,
            )
          : children.first;
}

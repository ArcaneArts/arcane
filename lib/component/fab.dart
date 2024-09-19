import 'package:arcane/arcane.dart';

class Fab extends StatelessWidget {
  final Widget child;
  final Widget? leading;
  final VoidCallback? onPressed;

  const Fab({super.key, required this.child, this.leading, this.onPressed});

  @override
  Widget build(BuildContext context) => PaddingAll(
      padding: 8,
      child: SurfaceCard(
        padding: EdgeInsets.zero,
        child: GhostButton(
          density: ButtonDensity.iconComfortable,
          leading: leading,
          onPressed: onPressed,
          child: child is Text
              ? (child as Text).large()
              : child is Icon
                  ? (child as Icon).large()
                  : child,
        ),
      ));
}

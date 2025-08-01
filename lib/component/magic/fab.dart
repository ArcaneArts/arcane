import 'package:arcane/arcane.dart';

class MagicFab extends StatelessWidget with BoxSignal {
  final Widget child;
  final Widget? leading;
  final VoidCallback? onPressed;
  final double threshold;

  const MagicFab(
      {super.key,
      required this.child,
      this.leading,
      this.onPressed,
      this.threshold = 350});

  @override
  Widget build(BuildContext context) {
    if (leading == null) {
      return Fab(onPressed: onPressed, child: child);
    }

    return MediaQuery.of(context).size.width < threshold
        ? Tooltip(
            key: ValueKey("fab.mini"),
            child: Fab(
              onPressed: onPressed,
              child: leading ?? child,
            ),
            tooltip: (context) => child)
        : Fab(
            key: ValueKey("fab.expanded"),
            onPressed: onPressed,
            leading: leading,
            child: child,
          );
  }
}

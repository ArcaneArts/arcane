import 'package:arcane/arcane.dart';

class FabMenu extends StatelessWidget {
  final Widget child;
  final Widget? leading;
  final List<MenuItem> items;

  const FabMenu(
      {super.key, required this.child, this.leading, this.items = const []});

  @override
  Widget build(BuildContext context) => Fab(
        leading: leading,
        onPressed: () => showDropdown(
            context: context,
            builder: (context) => DropdownMenu(
                  children: items,
                )),
        child: child,
      );
}

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
      )).blurIn;
}

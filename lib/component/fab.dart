import 'package:arcane/arcane.dart';
import 'package:arcane/generated/arcane_shadcn/src/components/menu/dropdown_menu.dart';
import 'package:arcane/generated/arcane_shadcn/src/components/overlay/popover.dart';

class FabSocket extends StatelessWidget {
  final Widget child;

  const FabSocket({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.bottomRight,
        child: PaddingAll(
          padding: 8,
          child: child,
        ),
      );
}

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

class FabGroup extends StatelessWidget {
  final Widget child;
  final Widget? leading;
  final List<Widget> Function(BuildContext) children;
  final bool horizontal;

  const FabGroup(
      {super.key,
      required this.child,
      this.leading,
      required this.children,
      this.horizontal = false});

  @override
  Widget build(BuildContext context) {
    return Fab(
      leading: leading,
      onPressed: () {
        _PopRef ref = _PopRef();
        OverlayCompleter o = showPopover(
            consumeOutsideTaps: true,
            context: context,
            offset: horizontal ? const Offset(0, 70) : const Offset(70, 0),
            barrierDismissable: true,
            builder: (context) => Pylon<_PopRef>(
                  value: ref,
                  builder: (context) => horizontal
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: children(context),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: children(context),
                        ),
                ),
            alignment: Alignment.bottomRight);
        ref.completer = o;
        o.future.then((value) {
          context.dismissFabGroup();
        });
      },
      child: child,
    );
  }
}

extension XPrefFabGroupContext on BuildContext {
  void dismissFabGroup() {
    Pylon.visiblePylons(this).whereType<Pylon<_PopRef>>().forEach((element) {
      element.value?.completer?.remove();
    });

    pylonOr<_PopRef>()?.completer?.remove();
  }
}

class _PopRef {
  OverlayCompleter? completer;

  _PopRef();
}

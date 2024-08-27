import 'package:arcane/arcane.dart';

class PopupMenu extends StatelessWidget {
  final Widget? icon;
  final Widget? child;
  final List<MenuItem> items;

  const PopupMenu({super.key, this.icon, this.child, required this.items});

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: GhostButton(
          onPressed: () {
            _showDropdown(
                context: context,
                builder: (context) => Theme(
                      data: Theme.of(context).copyWith(
                        surfaceBlur: 18,
                        surfaceOpacity: 0.5,
                      ),
                      child: DropdownMenu(
                        children: items,
                        surfaceOpacity: 0.5,
                        surfaceBlur: 18,
                      ),
                    ));
          },
          leading: icon,
          density: icon != null && child != null
              ? ButtonDensity.normal
              : ButtonDensity.icon,
          child: child ?? Container(),
        ),
      );
}

void _showDropdown({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  final theme = Theme.of(context);
  final scaling = theme.scaling;
  final GlobalKey key = GlobalKey();
  showPopover(
    context: context,
    alignment: Alignment.topCenter,
    offset: const Offset(0, 4) * scaling,
    consumeOutsideTaps: false,
    regionGroupId: key,
    modal: false,
    dismissBackdropFocus: true,
    builder: (context) {
      return Data.inherit(
        data: DropdownMenuData(key),
        child: builder(context),
      );
    },
  );
}

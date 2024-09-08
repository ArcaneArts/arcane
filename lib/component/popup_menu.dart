import 'package:arcane/arcane.dart';

class PopupMenu extends StatelessWidget {
  final IconData icon;
  final List<MenuItem> items;

  const PopupMenu({super.key, required this.icon, required this.items});

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: IconButton(
            onPressed: () {
              _showDropdown(
                  context: context,
                  builder: (context) => Theme(
                        data: Theme.of(context).copyWith(
                          surfaceBlur: 18,
                          surfaceOpacity: 0.5,
                        ),
                        child: DropdownMenu(
                          surfaceOpacity: 0.5,
                          surfaceBlur: 18,
                          children: items,
                        ),
                      ));
            },
            icon: icon),
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

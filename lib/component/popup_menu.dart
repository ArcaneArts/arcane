import 'package:arcane/arcane.dart';

class PopupMenu extends StatelessWidget {
  final IconData icon;
  final List<MenuItem> items;

  const PopupMenu({super.key, required this.icon, required this.items});

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: IconButton(
          onPressed: () => showDropdown(
              context: context,
              builder: (context) => DropdownMenu(
                    children: items,
                  )),
          icon: Icon(icon),
        ),
      );
}

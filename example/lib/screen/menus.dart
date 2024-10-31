import 'package:arcane/arcane.dart';

class ExampleMenus extends StatelessWidget {
  const ExampleMenus({super.key});

  @override
  Widget build(BuildContext context) => SliverScreen(
        fab: const FabMenu(items: [
          MenuButton(child: Text("Item 1")),
          MenuButton(child: Text("Item 2")),
        ], child: Icon(Icons.menu_ionic)),
        header: const Bar(
          titleText: "Menus",
          trailing: [
            PopupMenu(icon: Icons.dots_three, items: [
              MenuButton(child: Text("Item 1")),
              MenuButton(child: Text("Item 2")),
              MenuButton(
                subMenu: [
                  MenuButton(child: Text("Item 5")),
                  MenuButton(child: Text("Item 6")),
                  MenuButton(child: Text("Item 7")),
                  MenuButton(
                    subMenu: [MenuButton(child: Text("Item 8")), MenuButton(child: Text("Item 9")), MenuButton(child: Text("Item 10"))],
                    child: Text("Group 2"),
                  )
                ],
                child: Text("Group 1"),
              ),
              MenuButton(child: Text("Item 4"))
            ])
          ],
        ),
        sliver: SListView(
          children: const [
            ContextMenu(
                items: [
                  MenuButton(child: Text("Im a menu item")),
                  MenuButton(
                    subMenu: [
                      MenuButton(child: Text("Im a sub menu item")),
                      MenuButton(child: Text("Im a sub menu item 2")),
                      MenuButton(child: Text("Im a sub menu item 3")),
                    ],
                    child: Text("Im a menu item too!"),
                  ),
                ],
                child: Tile(
                  leading: Icon(Icons.activity_light),
                  title: Text("Right Click Me!"),
                  subtitle: Text("Or long press on mobile"),
                )),
            ContextMenu(
                items: [
                  MenuButton(child: Text("Im a menu item")),
                  MenuButton(
                    subMenu: [
                      MenuButton(child: Text("Im a sub menu item")),
                      MenuButton(child: Text("Im a sub menu item 2")),
                      MenuButton(child: Text("Im a sub menu item 3")),
                    ],
                    child: Text("Im a menu item too!"),
                  ),
                ],
                child: Tile(
                  leading: Icon(Icons.activity_light),
                  title: Text("Right Click Me!"),
                  subtitle: Text("Or long press on mobile"),
                ))
          ],
        ),
      );
}

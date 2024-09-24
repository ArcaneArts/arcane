import 'package:arcane/arcane.dart';

class ExampleNavTabs extends StatefulWidget {
  const ExampleNavTabs({super.key});

  @override
  State<ExampleNavTabs> createState() => _ExampleNavTabsState();
}

class _ExampleNavTabsState extends State<ExampleNavTabs> {
  int index = 0;

  @override
  Widget build(BuildContext context) => NavScreen(tabs: [
        NavTab(
            header: Bar(
              titleText: "Home",
            ),
            icon: Icons.house,
            selectedIcon: Icons.house_fill,
            label: "Home",
            fab: Fab(
              leading: Icon(Icons.plus),
              child: Text("Note"),
              onPressed: () {},
            ),
            sliver: SliverFillRemaining(
              child: Text("Derp"),
            )),
        NavTab(
            header: Bar(
              titleText: "Activity",
            ),
            fab: Fab(
              child: Text("I am Fab"),
              onPressed: () {},
            ),
            icon: Icons.activity,
            selectedIcon: Icons.activity_fill,
            label: "Activity",
            fill: Container(
              color: Colors.red,
              child: Center(
                child: Text("Im a fill"),
              ),
            )),
        NavTab(
            fab: Fab(
              child: Icon(Icons.plus),
              onPressed: () {},
            ),
            header: Bar(
              titleText: "Contacts",
            ),
            icon: Icons.address_book,
            selectedIcon: Icons.address_book_fill,
            label: "Contacts",
            sliver: SliverFillRemaining(
              child: Text("Derp"),
            ))
      ]);
}

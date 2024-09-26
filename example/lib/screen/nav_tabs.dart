import 'package:arcane/arcane.dart';

class ExampleNavTabs extends StatefulWidget {
  const ExampleNavTabs({super.key});

  @override
  State<ExampleNavTabs> createState() => _ExampleNavTabsState();
}

class _ExampleNavTabsState extends State<ExampleNavTabs> {
  int index = 0;

  @override
  Widget build(BuildContext context) => NavigationScreen(
          onIndexChanged: (index) => setState(() => this.index = index),
          index: index,
          tabs: [
            NavTab(
                icon: Icons.house,
                selectedIcon: Icons.house_fill,
                label: "Home",
                builder: (context, footer) => FillScreen(
                    footer: footer,
                    header: Bar(
                      titleText: "Home",
                    ),
                    child: Center(
                      child: Text("Home Screen"),
                    ))),
            NavTab(
                icon: Icons.activity,
                selectedIcon: Icons.activity_fill,
                label: "Activity",
                builder: (context, footer) => FillScreen(
                    header: Bar(
                      titleText: "Activity",
                    ),
                    footer: footer,
                    child: Center(
                      child: Text("Activity Screen"),
                    ))),
            NavTab(
                icon: Icons.address_book,
                selectedIcon: Icons.address_book_fill,
                label: "Contacts",
                builder: (context, footer) => FillScreen(
                    header: Bar(
                      titleText: "Contacts",
                    ),
                    footer: footer,
                    child: Center(
                      child: Text("Contacts Screen"),
                    )))
          ]);
}

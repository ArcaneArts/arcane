import 'package:arcane/arcane.dart';

class ExampleNavTabs extends StatefulWidget {
  const ExampleNavTabs({super.key});

  @override
  State<ExampleNavTabs> createState() => _ExampleNavTabsState();
}

class _TypePicker extends StatelessWidget {
  final NavigationType type;
  final ValueChanged<NavigationType> onChanged;

  const _TypePicker({super.key, required this.type, required this.onChanged});

  @override
  Widget build(BuildContext context) =>
      PopupMenu(icon: (Icons.package), items: [
        ...NavigationType.values.map((e) => MenuCheckbox(
            onChanged: (context, v) => onChanged(e),
            value: e == type,
            child: Text(e.name)))
      ]);
}

class _ExampleNavTabsState extends State<ExampleNavTabs> {
  int index = 0;
  NavigationType type = NavigationType.navigationRail;

  @override
  Widget build(BuildContext context) => NavigationScreen(
          type: type,
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
                      trailing: [
                        _TypePicker(
                            type: type,
                            onChanged: (t) => setState(() => type = t))
                      ],
                    ),
                    child: CenterBody(
                      icon: Icons.alien,
                      message: "The Message",
                      actionText: "Action",
                      onActionPressed: () {},
                    ))),
            NavTab(
                icon: Icons.activity,
                selectedIcon: Icons.activity_fill,
                label: "Activity",
                builder: (context, footer) => FillScreen(
                    header: Bar(
                      titleText: "Activity",
                      trailing: [
                        _TypePicker(
                            type: type,
                            onChanged: (t) => setState(() => type = t))
                      ],
                    ),
                    footer: footer,
                    child: const Center(
                      child: Text("Activity Screen"),
                    ))),
            NavTab(
                icon: Icons.address_book,
                selectedIcon: Icons.address_book_fill,
                label: "Contacts",
                builder: (context, footer) => FillScreen(
                    header: Bar(
                      titleText: "Contacts",
                      trailing: [
                        _TypePicker(
                            type: type,
                            onChanged: (t) => setState(() => type = t))
                      ],
                    ),
                    footer: footer,
                    child: const Center(
                      child: Text("Contacts Screen"),
                    )))
          ]);
}

import 'package:arcane/arcane.dart';

bool v = false;
String? vv;
void main() {
  runApp(const ExampleArcaneApp());
}

class ExampleArcaneApp extends StatelessWidget {
  const ExampleArcaneApp({super.key});

  @override
  Widget build(BuildContext context) => const ArcaneApp(
        home: Home(),
        themeMode: ThemeMode.system,
      );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;

  @override
  Widget build(BuildContext context) => Screen(
          header: Bar(
            titleText: "Arcane",
            trailing: [
              PopupMenu(
                icon: Icon(Icons.more_vert),
                items: [
                  MenuLabel(child: Text("Label")),
                  MenuButton(
                    child: Text("Hello"),
                  ),
                  MenuButton(child: Text("World")),
                  MenuButton(
                    subMenu: [
                      MenuButton(
                        child: Text('Email'),
                      ),
                      MenuButton(
                        child: Text('Message'),
                      ),
                      MenuDivider(),
                      MenuButton(
                        child: Text('More...'),
                      ),
                    ],
                    child: Text('Invite users'),
                  ),
                ],
              )
            ],
          ),
          footer: ButtonBar(selectedIndex: index, buttons: [
            IconTab(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_rounded,
              onPressed: () => setState(() {
                index = 0;

                DialogText(
                  title: "Hello",
                  description: "Please enter your name",
                  hint: "Sir Derpington III",
                  onConfirm: (x) => print("Entered $x"),
                ).show(context);
              }),
            ),
            IconTab(
              icon: Icons.featured_play_list_outlined,
              selectedIcon: Icons.featured_play_list_rounded,
              onPressed: () => setState(() {
                index = 1;

                DialogConfirm(
                  title: "You Sure?",
                  descriptionWidget: SizedBox(
                    width: 500,
                    child: PopupMenu(
                      items: [
                        MenuButton(child: Text("Hello")),
                        MenuButton(child: Text("Hello")),
                        MenuButton(child: Text("Hello")),
                        MenuButton(child: Text("Hello")),
                      ],
                      child: Icon(Icons.more_vert),
                    ),
                  ),
                  confirmText: "Custom Yes",
                  cancelText: "Custom No",
                  onConfirm: () => print("Confirmed"),
                ).show(context);
              }),
            ),
            IconTab(
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings_rounded,
              onPressed: () => setState(() {
                index = 2;
              }),
            ),
          ]),
          slivers: [
            SliverToBoxAdapter(
              child: StatefulBuilder(
                  builder: (context, setState) => Tile(
                        leading: Icon(Icons.ac_unit),
                        title: Text("List Tile"),
                        trailing: Selector<String>(
                          labelBuilder: (e) => e,
                          value: vv,
                          onChanged: (v) {
                            setState(() {
                              vv = v;
                            });
                          },
                          values: ["Hello", "World", "Something Else"],
                        ),
                        subtitle: Text("This is a regular list tile"),
                      )),
            ),
            Tile(
              trailing: Icon(Icons.ac_unit),
              leading: Icon(Icons.ac_unit),
              title: Text("Derp"),
              subtitle: Text("Derp Subtitle " * 100),
              sliver: true,
            ),
            Tile(
              leading: Icon(Icons.ac_unit),
              title: Text("Derp"),
              subtitle: Text("Derp Subtitle " * 100),
              sliver: true,
            ),
            BarSection(
                titleText: "New Section",
                sliver: MultiSliver(
                  children: [
                    Tile(
                      trailing: Icon(Icons.ac_unit),
                      leading: Icon(Icons.ac_unit),
                      title: Text("Derp"),
                      subtitle: Text("Derp Subtitle " * 100),
                      sliver: true,
                    ),
                    Tile(
                      leading: Icon(Icons.ac_unit),
                      title: Text("Derp"),
                      subtitle: Text("Derp Subtitle " * 100),
                      sliver: true,
                    ),
                    Tile(
                      leading: Icon(Icons.ac_unit),
                      title: Text("Derp"),
                      subtitle: Text("Derp Subtitle " * 100),
                      sliver: true,
                    ),
                  ],
                ))
          ]);
}

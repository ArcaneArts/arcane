import 'package:arcane/arcane.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  MainAxisSize mainAxisSize = MainAxisSize.max;

  @override
  Widget build(BuildContext context) => Screen(
      fab: Fab(
        child: Text("Derp"),
        leading: Icon(Icons.plus),
      ),
      header: Bar(titleText: "Header", trailing: [
        IconButton(
          icon: Icon(Icons.activity),
          onPressed: () {
            DialogConfirmText(
                    title: "Text", verificationText: "Derp", onConfirm: () {})
                .open(context);
          },
        )
      ]),
      child: MultiSliver(
        children: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            sliver: SGridView.builder(
              childCount: 16,
              crossAxisSpacing: 8,
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 8,
              builder: (context, index) => ContextMenu(
                  child: Card(
                    filled: true,
                    fillColor: randomColor(index),
                    child: Center(
                      child: Basic(
                        title: Text("Item s1 $index"),
                        subtitle: Text(
                          "Subtitle or something",
                        ),
                      ),
                    ),
                  ),
                  items: [
                    MenuButton(child: Text("Action 1"), onPressed: () {}),
                    MenuButton(child: Text("Action 2"), onPressed: () {}),
                    MenuButton(child: Text("Action 3"), onPressed: () {}),
                    MenuDivider(),
                    MenuButton(child: Text("Action 4"), onPressed: () {}),
                  ]),
            ),
          ),
          BarSection(
              titleText: "Grid Section",
              subtitleText: "Subtitle or something",
              trailing: [
                IconButton(
                  icon: Icon(Icons.add_circle_ionic),
                  onPressed: () {},
                )
              ],
              sliver: SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                sliver: SListView.builder(
                  childCount: 24,
                  builder: (context, index) => MagicTile(
                    leadingIcon: Icons.activity_light,
                    title: Text(
                      "Item $index",
                      style:
                          TextStyle(color: randomColor(index, radiant: true)),
                    ),
                    subtitle: Text("Subtitle or something"),
                  ),
                ),
              ))
        ],
      ));
}

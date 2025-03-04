import 'package:arcane/arcane.dart';

List<String> list = List.generate(5, (index) => "Item $index");

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => MutablePylon<int>(
        rebuildChildren: true,
        local: true,
        value: 0,
        builder: (context) => NavigationScreen(
          type: NavigationType.bottomNavigationBar,
          index: context.pylon<int>(),
          onIndexChanged: (index) => context.setPylon<int>(index),
          tabs: <NavItem>[
            NavTab(
                label: "Sliver Screen",
                icon: Icons.airplane,
                selectedIcon: Icons.airplane_fill,
                builder: (context) => SliverScreen(
                    gutter: false,
                    header: const Bar(
                      titleText: "This is bar 1",
                    ),
                    sliver: SListView.builder(
                      childCount: 1000,
                      builder: (context, i) => BasicCard(
                        title: MutableText(
                          "This is title $i sd jfjsdf jsdfjajdgjasdfgjajdfgjsdfjg jdfgj dfgjdf jgjsdf jgsdjfgjd fgj jdgj dejfgjdf jg",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          onChanged: (_) {},
                        ),
                      ).padBottom(8),
                    ))),
            NavTab(
                label: "Sliver Screen",
                icon: Icons.airplane,
                selectedIcon: Icons.airplane_fill,
                builder: (context) => SliverScreen(
                    gutter: false,
                    header: const Bar(
                      titleText: "This is bar 1",
                    ),
                    sliver: SListView.builder(
                      childCount: 1000,
                      builder: (context, i) => BasicCard(
                        title: Text("Tile $i"),
                      ).padBottom(8),
                    ))),
            NavTab(
                label: "Sliver Screen",
                icon: Icons.airplane,
                selectedIcon: Icons.airplane_fill,
                builder: (context) => SliverScreen(
                    gutter: false,
                    header: const Bar(
                      titleText: "This is bar 1",
                    ),
                    sliver: SListView.builder(
                      childCount: 1000,
                      builder: (context, i) => BasicCard(
                        title: Text("Tile $i"),
                      ).padBottom(8),
                    ))),
            NavTab(
                label: "Fill Screen",
                icon: Icons.activity,
                selectedIcon: Icons.activity_fill,
                builder: (context) => const FillScreen(
                    gutter: false,
                    header: Bar(
                      titleText: "This is bar 2",
                    ),
                    // using fill screen
                    child: CenterBody(
                        icon: Icons.activity, message: "This is Fill Screen"))),
            NavTab(
                label: "Sliver Fill",
                icon: Icons.activity,
                selectedIcon: Icons.activity_fill,
                builder: (context) => const SliverScreen(
                    gutter: false,
                    header: Bar(
                      titleText: "This is bar 5",
                    ),
                    // using fill screen
                    sliver: SliverFill(
                      child: CenterBody(
                          icon: Icons.activity,
                          message: "This is a Sliver Filled"),
                    ))),
          ].toList(),
          sidebarHeader: (context) => const ArcaneSidebarHeader(
            titleText: "Header",
            subtitleText: "Subtitle",
            trailing: [
              Icon(Icons.search_ionic),
            ],
          ),
          sidebarFooter: (context) => ArcaneSidebarFooter(
            content: const Text("Footer"),
          ),
        ),
      );
}

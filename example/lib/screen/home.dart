import 'package:arcane/arcane.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedValue;

  Consumer? c;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MutablePylon<int>(
        rebuildChildren: true,
        local: true,
        value: 0,
        builder: (context) => NavigationScreen(
          type: NavigationType.sidebar,
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
                        title: Text("Tile $i s djfjsdf jsdjfjsdjf sjdf jfsdj"),
                      ).padBottom(8),
                    )).shimmer(loading: false)),
            NavTab(
                label: "Fill Screen",
                icon: Icons.activity,
                selectedIcon: Icons.activity_fill,
                builder: (context) => const FillScreen(
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
          sidebarHeader: (context) => !context.isSidebarExpanded
              ? SizedBox.shrink()
              : const ArcaneSidebarHeader(
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

import 'package:arcane/arcane.dart';
import 'package:example/screen/note_view.dart';

// We need a builder to actually build our nav tabs into custom widgets
extension XNavTabBuilder on NavTab {
  Widget buildButton(BuildContext context, NavigationScreen nav, int tabIndex,
          int currentIndex) =>
      ArcaneSidebarButton(
        icon: Icon(tabIndex == currentIndex ? selectedIcon ?? icon : icon),
        label: label ?? "Item ${tabIndex + 1}",
        selected: tabIndex == currentIndex,
        onTap: () {
          if (tabIndex != currentIndex) {
            nav.onIndexChanged?.call(tabIndex);
          }
        },
      );
}

// Define our tabs as variables because
// We need to reference them directly when linking ui
NavTab s1 = NavTab(
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
        )));

NavTab s2 = NavTab(
    label: "Fill Screen",
    icon: Icons.activity,
    selectedIcon: Icons.activity_fill,
    builder: (context) => const FillScreen(
        header: Bar(
          titleText: "This is bar 2",
        ),
        child: Center(
          child: TestContent(),
        )));

NavTab s3 = NavTab(
    label: "Sliver Fill",
    icon: Icons.activity,
    selectedIcon: Icons.activity_fill,
    builder: (context) => const SliverScreen(
        header: Bar(
          titleText: "This is bar 5",
        ),
        sliver: SliverFill(
          child: CenterBody(
              icon: Icons.activity, message: "This is a Sliver Filled"),
        )));

NavTab s4 = NavTab(
    label: "Sliver Fill 2",
    icon: Icons.activity,
    selectedIcon: Icons.activity_fill,
    builder: (context) => const SliverScreen(
        header: Bar(
          titleText: "This is bar 6",
        ),
        sliver: SliverFill(
          child: CenterBody(
              icon: Icons.activity, message: "This is a Sliver Filled 2"),
        )));

NavTab s5 = NavTab(
    label: "Sliver Fill 3",
    icon: Icons.activity,
    selectedIcon: Icons.activity_fill,
    builder: (context) => const SliverScreen(
        header: Bar(
          titleText: "This is bar 7",
        ),
        sliver: SliverFill(
          child: CenterBody(
              icon: Icons.activity, message: "This is a Sliver Filled 3"),
        )));

NavTab s6 = NavTab(
    label: "Sliver Screen 2",
    icon: Icons.airplane,
    selectedIcon: Icons.airplane_fill,
    builder: (context) => SliverScreen(
        gutter: false,
        header: const Bar(
          titleText: "This is bar 11",
        ),
        sliver: SListView.builder(
          childCount: 1000,
          builder: (context, i) => BasicCard(
            title: Text("Tile 2 $i"),
          ).padBottom(8),
        )));

NavTab s7 = NavTab(
    label: "Sliver Screen 3",
    icon: Icons.airplane,
    selectedIcon: Icons.airplane_fill,
    builder: (context) => SliverScreen(
        gutter: false,
        header: const Bar(
          titleText: "This is bar 12",
        ),
        sliver: SListView.builder(
          childCount: 1000,
          builder: (context, i) => BasicCard(
            title: Text("Tile 3 $i"),
          ).padBottom(8),
        )));

NavTab s8 = NavTab(
    label: "User Screen",
    icon: Icons.activity,
    selectedIcon: Icons.activity_fill,
    builder: (context) => const FillScreen(
        header: Bar(
          titleText: "This is bar 69",
        ),
        child:
            CenterBody(icon: Icons.activity, message: "This is User Screen")));

// Define our tabs in order to define out indexes
List<NavTab> _tabs = [s1, s2, s3, s4, s5, s6, s7, s8];

// Define our screen as a stateless widget
class HomeScreen extends StatelessWidget with ArcaneRoute {
  const HomeScreen({super.key});

  @override
  // We're using mutable pylons here to store the current index
  // instead of a full stateful widget
  Widget build(BuildContext context) => MutablePylon<int>(
        rebuildChildren: true,
        local: true,
        value: 0,
        builder: (context) => NavigationScreen(
          // Set the nav screen to custom
          type: NavigationType.custom,
          index: context.pylon<int>(),
          onIndexChanged: (index) => context.setPylon<int>(index),

          // We need to define a custom builder for the nav bar
          customNavigationBuilder: (context, nav, index) => Scaffold(
            child: Pylon<ArcaneSidebarInjector>(
              // Using a ArcaneSidebar but with a sliver instead of direct children
              value: ArcaneSidebarInjector((context) => ArcaneSidebar.sliver(
                  collapsedWidth: 54,
                  // Construct a multisliver of sections
                  sliver: (context) => MultiSliver(
                        children: [
                          ExpansionBarSection(
                            title: context.isSidebarExpanded
                                ? const Text("Section 1")
                                : const SizedBox.shrink(),
                            sliver: SListView(
                              children: [
                                // Use our extension to build our buttons with their respective
                                // Indexes and the current index. "index" is the CURRENT index
                                s1.buildButton(
                                    context, nav, _tabs.indexOf(s1), index),
                                s2.buildButton(
                                    context, nav, _tabs.indexOf(s2), index),
                                s3.buildButton(
                                    context, nav, _tabs.indexOf(s3), index),
                              ],
                            ),
                          ),
                          // Add a cute divider here
                          const SliverToBoxAdapter(
                            child: Divider(),
                          ),
                          ExpansionBarSection(
                            title: context.isSidebarExpanded
                                ? const Text("Section 2")
                                : const SizedBox.shrink(),
                            sliver: SListView(
                              children: [
                                s4.buildButton(
                                    context, nav, _tabs.indexOf(s4), index),
                                s5.buildButton(
                                    context, nav, _tabs.indexOf(s5), index),
                              ],
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: Divider(),
                          ),
                          ExpansionBarSection(
                            title: context.isSidebarExpanded
                                ? const Text("Section 3")
                                : const SizedBox.shrink(),
                            sliver: SListView(
                              children: [
                                s6.buildButton(
                                    context, nav, _tabs.indexOf(s6), index),
                                s7.buildButton(
                                    context, nav, _tabs.indexOf(s7), index),
                              ],
                            ),
                          )
                        ],
                      ),
                  // This demonstrates you can make tabs out of anything even a
                  // user button in the footer
                  footer: (context) => ArcaneSidebarFooter(
                        content: IconButton(
                          icon: Icon(index == _tabs.indexOf(s8)
                              ? Icons.user_circle_fill
                              : Icons.user_circle),
                          onPressed: () {
                            DialogText(
                              title: "Confirm",
                              onConfirm: (_) {},
                            ).open(context);
                            // nav.onIndexChanged?.call(_tabs.indexOf(s8));
                          },
                        ),
                      ))),
              // Finally conect our nav screen builders to the screen
              builder: nav.tabs[index].builder,
            ),
          ),

          // Reference our tabs here
          tabs: _tabs,
        ),
      );

  @override
  String get path => "/";

  @override
  ArcanePageMeta? get pageMeta => ArcanePageMeta(
        author: "Dan",
        charset: "UTF-8",
        description: "This is the home screen",
        facebookAppID: "123456789",
        image: "https://example/image.png",
        keywords: ["a", "b", "c"],
        robotsName: RobotsName.google,
        robotsContent: "index, follow",
        themeColor: const Color(0xFF1269DB),
        title: "Home",
        twitterCard: TwitterCard.summary,
        type: "website",
        url: "https://otherplace.com",
      );
}

class DataExample {
  final int aInt;
  final String aString;
  final double aDouble;
  final bool? aBool;
  final Color aColor;

  const DataExample({
    this.aInt = 0,
    this.aString = "",
    this.aDouble = 0.0,
    this.aBool = false,
    this.aColor = const Color(0xFF000000),
  });

  DataExample copyWith({
    int? aInt,
    String? aString,
    double? aDouble,
    bool? aBool,
    Color? aColor,
  }) =>
      DataExample(
        aInt: aInt ?? this.aInt,
        aString: aString ?? this.aString,
        aDouble: aDouble ?? this.aDouble,
        aBool: aBool,
        aColor: aColor ?? this.aColor,
      );

  String toString() =>
      "DataExample(aInt: $aInt, aString: $aString, aDouble: $aDouble, aBool: $aBool, aColor: $aColor)";
}

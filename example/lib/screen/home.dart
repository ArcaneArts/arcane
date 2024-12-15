import 'package:arcane/arcane.dart';

class HomeScreen extends StatelessWidget with ArcaneRoute {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => MutablePylon<int>(
        rebuildChildren: true,
        local: true,
        value: 0,
        builder: (context) => NavigationScreen(
          type: NavigationType.sidebar,
          index: context.pylon<int>(),
          onIndexChanged: (index) => context.setPylon<int>(index),
          tabs: [
            NavTab(
                label: "Home",
                icon: Icons.airplane,
                selectedIcon: Icons.airplane_fill,
                builder: (context) => SliverScreen(
                    header: Bar(
                      titleText: "This is bar 1",
                    ),
                    sliver: SListView.builder(
                      childCount: 1000,
                      builder: (context, i) => Tile(
                        title: Text("Tile $i"),
                      ),
                    ))),
            NavDivider(),
            NavTab(
                label: "Fill",
                icon: Icons.activity,
                selectedIcon: Icons.activity_fill,
                builder: (context) => FillScreen(
                    header: Bar(
                      titleText: "This is bar 2",
                    ),
                    // using fill screen
                    child: CenterBody(
                        icon: Icons.activity,
                        message: "Notice there is no app bar here"))),
            NavTab(
                label: "Another",
                icon: Icons.address_book,
                selectedIcon: Icons.address_book_fill,
                builder: (context) => FillScreen(
                    header: Bar(
                      titleText: "This is bar 3",
                    ),
                    // using fill screen
                    child: CenterBody(
                        icon: Icons.activity, message: "Another screen"))),
          ],
          sidebarFooter: (context) => ArcaneSidebarFooter(),
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

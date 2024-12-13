import 'package:arcane/arcane.dart';
import 'package:example/screen/notes.dart';

class HomeScreen extends StatelessWidget with ArcaneRoute {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => SidebarScreen(
      sidebar: (context) => ArcaneSidebar(
            children: (context) => List.generate(
                100,
                (i) => ArcaneSidebarButton(
                      icon: Icon(Icons.accessibility_ionic),
                      onTap: () {},
                      selected: i == 4,
                      label: "Item $i",
                    )),
            footer: (context) => ArcaneSidebarFooter(
              content: Text("Im a footer"),
            ),
          ),
      header: Bar(
        titleText: "Home",
        trailing: [
          IconButton(
            icon: Icon(Icons.accessibility_ionic),
            onPressed: () => Arcane.push(context, NotesScreen()),
          )
        ],
      ),
      sliver: SListView(
        children: List.generate(100, (i) => Text("Item $i")),
      ));

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

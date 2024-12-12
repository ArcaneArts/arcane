import 'package:arcane/arcane.dart';
import 'package:example/screen/notes.dart';

class HomeScreen extends StatelessWidget with ArcaneRoute {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => FillScreen(
      header: Bar(
        titleText: "Home",
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
                child: Text("Open Notes"),
                onPressed: () {
                  Arcane.push(context, NotesScreen());
                }),
            Gap(8),
            Divider(),
            Gap(8),
            ArcaneForm<DataExample>(
              initialData: DataExample(),
              onSubmitted: (t) {
                print("Submitted $t");
              },
              children: [
                ArcaneFormString<DataExample>(
                    label: "String",
                    subLabel: "This is a sublabel helper text (optional)",
                    reader: (t) => t.aString,
                    placeholder: "Optional Placeholder",
                    writer: (t, s) => t.copyWith(aString: s)),
                ArcaneFormInteger<DataExample>(
                    showButtons: true,
                    maxValue: 100,
                    minValue: 0,
                    placeholder: "Optional Placeholder",
                    label: "Integer",
                    subLabel: "The description of the note",
                    reader: (t) => t.aInt,
                    writer: (t, s) => t.copyWith(aInt: s)),
                ArcaneFormBool<DataExample>(
                    reader: (t) => t.aBool,
                    writer: (t, b) => t.copyWith(aBool: b ?? false),
                    label: "A Boolean")
              ],
            )
          ],
        ),
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
  final bool aBool;
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
        aBool: aBool ?? this.aBool,
        aColor: aColor ?? this.aColor,
      );

  String toString() =>
      "DataExample(aInt: $aInt, aString: $aString, aDouble: $aDouble, aBool: $aBool, aColor: $aColor)";
}

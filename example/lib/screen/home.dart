import 'package:arcane/arcane.dart';
import 'package:example/screen/notes.dart';

class HomeScreen extends StatelessWidget with ArcaneRoute {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => FillScreen(
      header: Bar(titleText: "Home"),
      child: Center(
        child: PrimaryButton(
            child: Text("Open Notes"),
            onPressed: () {
              Arcane.push(context, NotesScreen());
            }),
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

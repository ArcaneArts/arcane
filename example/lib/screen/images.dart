import 'package:arcane/arcane.dart';

class ExampleImages extends StatelessWidget {
  const ExampleImages({super.key});

  @override
  Widget build(BuildContext context) => FillScreen(
        header: Bar(
          titleText: "Images",
        ),
        child: Center(
          child: ImageView(
              cacheKey: "ffff",
              style: ImageStyle(),
              blurHash: r'KRASz$ofs^ogfffPs]fRWQ',
              //thumbHash: "XyMGHwD5d2hpp2d9hHaKdHd4mYAp9mcN",
              url:
                  "https://raw.githubusercontent.com/ArcaneArts/arcane/refs/heads/main/79207749.webp"),
        ),
      );
}

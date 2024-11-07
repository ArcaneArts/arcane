This is a modified fork of shadcn_flutter and includes resources & merged code from Phosphor Icons & Ionicons. It is designed for quickly creating apps. 

#### [Documentation](https://tome.arcane.art) | [Pub.dev](https://pub.dev/packages/arcane) | [GitHub](https://github.com/ArcaneArts/arcane)

## Forked / Modified Packages
- [shadcn_flutter](https://pub.dev/packages/shadcn_flutter) for general widgets & overall UI. 
- [phosphor_flutter](https://pub.dev/packages/phosphor_flutter) & [ionicons](https://pub.dev/packages/ionicons) for icons
- [blurme](https://pub.dev/packages/blurme) for blur effects (needed to modify) license unneeded as it says "Use however you want".

## Initial Setup
Note: This guide below only showcases new features & changes. Please refer to [shadcn_flutter docs](https://sunarya-thito.github.io/shadcn_flutter/) to see how to use that package through arcane.

main.dart
```dart
void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ArcaneApp(
      theme: ArcaneTheme(scheme: ContrastedColorScheme.fromScheme(ColorSchemes.zinc)),
      home: HomeScreen()
  );
}
```

pubspec.yaml
```yaml
dependencies: 
  arcane: VERSION
flutter:
  uses-material-design: true
  fonts:
    - family: RadixIcons
      fonts:
      - asset: "packages/arcane/resources/icons/RadixIcons.otf"
    - family: BootstrapIcons
      fonts:
        - asset: "packages/arcane/resources/icons/BootstrapIcons.otf"
    - family: "GeistSans"
      fonts:
        - asset: "packages/arcane/resources/fonts/Geist-Black.otf"
          weight: 800
        - asset: "packages/arcane/resources/fonts/Geist-Bold.otf"
          weight: 700
        - asset: "packages/arcane/resources/fonts/Geist-Light.otf"
          weight: 300
        - asset: "packages/arcane/resources/fonts/Geist-Medium.otf"
          weight: 500
        - asset: "packages/arcane/resources/fonts/Geist-SemiBold.otf"
          weight: 600
        - asset: "packages/arcane/resources/fonts/Geist-Thin.otf"
          weight: 100
        - asset: "packages/arcane/resources/fonts/Geist-UltraBlack.otf"
          weight: 900
        - asset: "packages/arcane/resources/fonts/Geist-UltraLight.otf"
          weight: 200
        - asset: "packages/arcane/resources/fonts/Geist-Regular.otf"
          weight: 400
    - family: "GeistMono"
      fonts:
        - asset: "packages/arcane/resources/fonts/GeistMono-Black.otf"
          weight: 800
        - asset: "packages/arcane/resources/fonts/GeistMono-Bold.otf"
          weight: 700
        - asset: "packages/arcane/resources/fonts/GeistMono-Light.otf"
          weight: 300
        - asset: "packages/arcane/resources/fonts/GeistMono-Medium.otf"
          weight: 500
        - asset: "packages/arcane/resources/fonts/GeistMono-Regular.otf"
          weight: 400
        - asset: "packages/arcane/resources/fonts/GeistMono-SemiBold.otf"
          weight: 600
        - asset: "packages/arcane/resources/fonts/GeistMono-Thin.otf"
          weight: 100
        - asset: "packages/arcane/resources/fonts/GeistMono-UltraBlack.otf"
          weight: 900
        - asset: "packages/arcane/resources/fonts/GeistMono-UltraLight.otf"
          weight: 200
```
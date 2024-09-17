This is a modified fork of shadcn_flutter and includes resources & merged code from Phosphor Icons & Ionicons. It is designed for quickly creating apps. 

## Forked / Modified Packages
- [shadcn_flutter](https://pub.dev/packages/shadcn_flutter) for general widgets & overall UI. Their license is included in the lib/shadcn folder.
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
      theme: ArcaneTheme(scheme: ColorSchemes.zinc()),
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

## Screens

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Screen(
    header: Bar(titleText: "Home"),
    slivers: [
      // It is ideal to use slivers in screens
    ]
  );
}
```

### Sectioned Lists
Sectioned lists allow each section to contain sticky headers.
```dart
Screen(
    header: Bar(titleText: "Home"),
    slivers: [
      // Bar section is a bar header with a sliver content
      // Bar sections are slivers as they have sticky headers
      BarSection(
        titleText: "Header Title",
        sliver: SliverList(...)
      ),

      // You can also make your own custom header instead of bars
      GlassSection(
        header: Text("Header Title"),
        sliver: SliverList(...)
      )
    ]
)
```

You can also nest sections inside of sections

```dart
Screen(
    header: Bar(titleText: "Home"),
    slivers: [
      BarSection(
          titleText: "Outer Section",
          sliver: MultiSliver(children: [
              // The outer section + inner section 
              // will stack their headers on top of each other
              BarSection(
                  titleText: "Inner Section",
                  sliver: SliverList(...)
              ),
          ])    
      ),
      BarSection(
          titleText: "Inner Section",
          sliver: SliverList(...)
      ),
    ]
)
```

## Tiles
List tiles similar to material.

```dart
Tile(
    title: Text("Title"),
    subtitle: Text("Subtitle"),
    leading: Icon(Icons.ac_unit),
    trailing: Icon(Icons.ac_unit),
    onTap: () => print("Tapped")
)
```

```dart
SwitchTile(
    title: Text("Checkbox Tile"),
    leading: Icon(Icons.plus),
    subtitle: Text("Subtitle"),
    value: true,
)
```

```dart
CheckboxTile(
    title: Text("Checkbox Tile"),
    leading: Icon(Icons.plus),
    trailing: Icon(Icons.x),
    subtitle: Text("But with a trailing widget"),
    value: true,
)
```

## Menus
Quick access to shadcn popup menus & modified context menus

```dart
PopupMenu(
    icon: Icons.dots_3,
    items: [
        MenuButton(child: Text("Click Me"), onTap: (_) => print("Clicked")),
        MenuButton(child: Text("Hover Me"), subMenu: [
            // more menu items
        ]),  
    ]
)
```

## Dialogs
Fast dialog access, compatible with Pylon

```dart
=> DialogConfirm(
    title: "Are you sure?",
    description: "This action cannot be undone",
    onConfirm: () => print("Confirmed"),
    confirmText: "Delete Forever",
).open(context);
```

```dart
=> DialogText(
    title: "Input Dialog",
    description: "This is a text description",
    confirmText: "Yes",
    cancelText: "Nope",
    onConfirm: (x) => print("Input $x"),
).open(context)
```

## Toast
Compatible with Pylon

```dart
TextToast("This is a toast").open(context);
```

```dart
=> Toast(
    builder: (context) => const Text("Bottom Left"),
).open(context);
```

## Sheets
Compatible with Pylon

```dart
Sheet(builder: (context) => const TheScreen()).open(context)
```
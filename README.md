This is a modified fork of shadcn_flutter and includes resources & merged code from Phosphor Icons & Ionicons. It is designed for quickly creating apps. 

#### [Documentation](https://tome.arcane.art) | [Pub.dev](https://pub.dev/packages/arcane) | [GitHub](https://github.com/ArcaneArts/arcane)

## Forked / Modified Packages
- [shadcn_flutter](https://pub.dev/packages/shadcn_flutter) for general widgets & overall UI. 
- [phosphor_flutter](https://pub.dev/packages/phosphor_flutter) & [ionicons](https://pub.dev/packages/ionicons) for icons
- [blurme](https://pub.dev/packages/blurme) for blur effects (needed to modify) license unneeded as it says "Use however you want".

## Initial Setup

Please read the [Installation](https://tome.arcane.art/#/installation) guide for more information.

# Addon Packages
- [arcane_fluf](https://pub.dev/packages/arcane_crud) for using flutterfire stack (which utilizes: )
  - [arcane_auth](https://pub.dev/packages/arcane_auth) for firebase authentication
  - [arcane_user](https://pub.dev/packages/arcane_user) for user data models in firestore
  - [arcane_fire](https://pub.dev/packages/arcane_fire) for initializing firebase with arcane

```dart
void main() => runApp("mtg_tesseract", ArcaneWindow(
  windowColor: Colors.transparent,
  child: ArcaneFluf(
          options: DefaultFirebaseOptions.currentPlatform,
          onRegisterCrud: $registerCrud,
          onRegisterUserService: () => services().register<UserService>(() => UserService()),
    child: MyCustomInitializer(
      ///////////
      child: const TesseractApp()
    )
  )
));
```
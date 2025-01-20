import 'package:arcane/arcane.dart';

class Arcane {
  static ArcaneAppState? $app;
  static ArcaneAppState get app => $app!;
  static ArcaneTheme get globalTheme => $app!.currentTheme;
  static ArcaneTheme themeOf(BuildContext context) =>
      context.pylonOr<ArcaneTheme>() ?? globalTheme;

  static void pop<T extends Object?>(BuildContext context, [T? result]) =>
      Navigator.pop(context, result);

  static Future<T?> push<T extends Object?>(
          BuildContext context, Widget child) =>
      Pylon.push<T?>(context, child,
          type: PylonRouteType.material, settings: RouteSettings(name: null));

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
          BuildContext context, Widget child) =>
      Pylon.pushReplacement<T?, TO?>(context, child,
          type: PylonRouteType.material, settings: RouteSettings(name: null));

  static Future<T?> pushAndRemoveUntil<T extends Object?>(
          BuildContext context, Widget child, RoutePredicate predicate) =>
      Pylon.pushAndRemoveUntil<T?>(context, child,
          predicate: predicate,
          type: PylonRouteType.material,
          settings: RouteSettings(name: null));

  static void closeDrawer(BuildContext context) =>
      DrawerOverlay.maybeFind(context)?.overlay.closeLast();

  static void closeMenus(BuildContext context) =>
      Data.maybeOf<MenuGroupData>(context)?.closeAll();
}

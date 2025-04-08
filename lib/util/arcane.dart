import 'dart:async';

import 'package:arcane/arcane.dart';
import 'package:arcane/generated/arcane_shadcn/src/events.dart';
import 'package:serviced/serviced.dart';

class Arcane {
  static int _lastHaptic = 0;

  static Future<bool> haptic(HapticsType? type, {bool force = false}) {
    if (type != null &&
        kHapticsAvailable &&
        Arcane.globalTheme.haptics.enabled &&
        (DateTime.timestamp().millisecondsSinceEpoch - _lastHaptic < 100 ||
            force)) {
      _lastHaptic = DateTime.timestamp().millisecondsSinceEpoch;
      return Haptics.vibrate(type).then((_) => true).catchError((e) => false);
    }

    return Future.value(false);
  }

  static Future<bool> hapticViewChange() =>
      haptic(Arcane.globalTheme.haptics.viewChangeType);
  static Future<bool> hapticAction() =>
      haptic(Arcane.globalTheme.haptics.actionType);
  static Future<bool> hapticSelect() =>
      haptic(Arcane.globalTheme.haptics.selectType);
  static Future<bool> hapticButton() =>
      haptic(Arcane.globalTheme.haptics.buttonType);

  static Future<void> registerInitializer(
      String name, Future<void> Function() run) {
    Completer<void> c = Completer();
    $registerInitTask(
        InitTask(name, () async => run().then((_) => c.complete())));
    return c.future;
  }

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

class ArcaneShadEvents implements ShadcnEvents {
  @override
  void onButtonPressed(BuildContext context, AbstractButtonStyle style) {
    Arcane.hapticButton();
  }

  @override
  void onDialogOpened(BuildContext context) {
    Arcane.hapticViewChange();
  }

  @override
  void onMenuOpened(BuildContext context) {
    Arcane.hapticViewChange();
  }

  @override
  void onMenuSelection(BuildContext context) {
    Arcane.hapticSelect();
  }

  @override
  void onToastOpened(BuildContext context) {
    Arcane.hapticViewChange();
  }

  @override
  void onTooltipOpened(BuildContext context) {
    Arcane.hapticSelect();
  }

  @override
  void onTabChanged(BuildContext context) {
    Arcane.hapticViewChange();
  }
}

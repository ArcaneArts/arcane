import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:flutter/cupertino.dart' as c;
import 'package:flutter/material.dart' as m;
import 'package:pylon/pylon.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toxic_flutter/toxic_flutter.dart';

class Arcane {
  static void pop<T extends Object?>(BuildContext context, [T? result]) =>
      Navigator.pop(context, result);

  static Future<T?> push<T extends Object?>(
          BuildContext context, Widget child) =>
      Pylon.push(context, child);
}

enum ThemeMode {
  system,
  light,
  dark,
}

BehaviorSubject<int> _appUpdate = BehaviorSubject<int>.seeded(0);
bool _initialized = false;

class ArcaneApp extends StatelessWidget {
  final m.ThemeData? materialTheme;
  final c.CupertinoThemeData? cupertinoTheme;
  final GlobalKey<NavigatorState>? navigatorKey;
  final AdaptiveScaling? scaling;
  final Widget? home;
  final Map<String, WidgetBuilder>? routes;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final InitialRouteListFactory? onGenerateInitialRoutes;
  final RouteFactory? onUnknownRoute;
  final NotificationListenerCallback<NavigationNotification>?
      onNavigationNotification;
  final List<NavigatorObserver>? navigatorObservers;
  final RouteInformationProvider? routeInformationProvider;
  final RouteInformationParser<Object>? routeInformationParser;
  final RouterDelegate<Object>? routerDelegate;
  final BackButtonDispatcher? backButtonDispatcher;
  final RouterConfig<Object>? routerConfig;
  final TransitionBuilder? builder;
  final String title;
  final GenerateAppTitle? onGenerateTitle;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;
  final Color? color;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool showPerformanceOverlay;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final String? restorationScopeId;
  final ScrollBehavior scrollBehavior;
  final bool debugShowMaterialGrid;
  final bool disableBrowserContextMenu;
  final ThemeMode themeMode;

  const ArcaneApp({
    super.key,
    this.themeMode = ThemeMode.system,
    this.navigatorKey,
    this.home,
    Map<String, WidgetBuilder> this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.onNavigationNotification,
    List<NavigatorObserver> this.navigatorObservers =
        const <NavigatorObserver>[],
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.lightTheme,
    this.darkTheme,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = false,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior = const ArcaneScrollBehavior(),
    this.materialTheme,
    this.cupertinoTheme,
    this.scaling,
    this.disableBrowserContextMenu = true,
  })  : routeInformationProvider = null,
        routeInformationParser = null,
        routerDelegate = null,
        backButtonDispatcher = null,
        routerConfig = null;

  const ArcaneApp.router({
    super.key,
    this.themeMode = ThemeMode.system,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.routerConfig,
    this.backButtonDispatcher,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.onNavigationNotification,
    this.color,
    this.lightTheme,
    this.darkTheme,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior = const ArcaneScrollBehavior(),
    this.materialTheme,
    this.cupertinoTheme,
    this.scaling,
    this.disableBrowserContextMenu = true,
  })  : assert(routerDelegate != null || routerConfig != null),
        navigatorObservers = null,
        navigatorKey = null,
        onGenerateRoute = null,
        home = null,
        onGenerateInitialRoutes = null,
        onUnknownRoute = null,
        routes = null,
        initialRoute = null;

  bool get _usesRouter => routerDelegate != null || routerConfig != null;

  ThemeData get realLightTheme =>
      lightTheme ??
      ThemeData(
          colorScheme: ColorSchemes.lightZinc(),
          surfaceOpacity: 0.5,
          surfaceBlur: 16,
          radius: 0.5);

  ThemeData get realDarkTheme =>
      darkTheme ??
      ThemeData(
          colorScheme: ColorSchemes.darkZinc(),
          surfaceOpacity: 0.5,
          surfaceBlur: 16,
          radius: 0.5);

  bool get isDark => currentTheme.brightness == Brightness.dark;

  ThemeData get currentTheme => switch (themeMode) {
        ThemeMode.light => realLightTheme,
        ThemeMode.dark => realDarkTheme,
        ThemeMode.system =>
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                  m.Brightness.light
              ? realLightTheme
              : realDarkTheme,
      };

  void _init() {
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () => updateApp();
  }

  m.ThemeData get arcaneMaterialTheme =>
      (isDark ? m.ThemeData.dark() : m.ThemeData.light()).copyWith(
          pageTransitionsTheme: m.PageTransitionsTheme(
              builders: Map.fromEntries(
        m.TargetPlatform.values
            .map((e) => MapEntry(e, const m.CupertinoPageTransitionsBuilder())),
      )));

  static void updateApp() => _appUpdate.add(_appUpdate.value + 1);

  @override
  Widget build(BuildContext context) {
    _init();
    return _appUpdate.build((_) => _usesRouter
        ? ShadcnApp.router(
            routeInformationProvider: routeInformationProvider,
            routeInformationParser: routeInformationParser,
            routerDelegate: routerDelegate,
            routerConfig: routerConfig,
            backButtonDispatcher: backButtonDispatcher,
            builder: builder,
            title: title,
            onGenerateTitle: onGenerateTitle,
            onNavigationNotification: onNavigationNotification,
            color: color,
            theme: currentTheme,
            locale: locale,
            localizationsDelegates: localizationsDelegates,
            localeListResolutionCallback: localeListResolutionCallback,
            localeResolutionCallback: localeResolutionCallback,
            supportedLocales: supportedLocales,
            debugShowMaterialGrid: debugShowMaterialGrid,
            showPerformanceOverlay: showPerformanceOverlay,
            showSemanticsDebugger: showSemanticsDebugger,
            debugShowCheckedModeBanner: debugShowCheckedModeBanner,
            shortcuts: shortcuts,
            actions: actions,
            restorationScopeId: restorationScopeId,
            scrollBehavior: scrollBehavior,
            materialTheme: materialTheme,
            cupertinoTheme: cupertinoTheme,
            scaling: scaling,
            disableBrowserContextMenu: disableBrowserContextMenu,
          )
        : ShadcnApp(
            navigatorKey: navigatorKey,
            home: home,
            routes: routes ?? {},
            initialRoute: initialRoute,
            onGenerateRoute: onGenerateRoute,
            onGenerateInitialRoutes: onGenerateInitialRoutes,
            onUnknownRoute: onUnknownRoute,
            onNavigationNotification: onNavigationNotification,
            navigatorObservers: navigatorObservers ?? [],
            builder: builder,
            title: title,
            onGenerateTitle: onGenerateTitle,
            color: color,
            theme: currentTheme,
            locale: locale,
            localizationsDelegates: localizationsDelegates,
            localeListResolutionCallback: localeListResolutionCallback,
            localeResolutionCallback: localeResolutionCallback,
            supportedLocales: supportedLocales,
            debugShowMaterialGrid: debugShowMaterialGrid,
            showPerformanceOverlay: showPerformanceOverlay,
            showSemanticsDebugger: showSemanticsDebugger,
            debugShowCheckedModeBanner: debugShowCheckedModeBanner,
            shortcuts: shortcuts,
            actions: actions,
            restorationScopeId: restorationScopeId,
            scrollBehavior: scrollBehavior,
            materialTheme: materialTheme ?? arcaneMaterialTheme,
            cupertinoTheme: cupertinoTheme,
            scaling: scaling,
            disableBrowserContextMenu: disableBrowserContextMenu,
          ));
  }
}

class ArcaneScrollBehavior extends m.MaterialScrollBehavior {
  final bool allowMouseDragging;

  const ArcaneScrollBehavior({this.allowMouseDragging = true});

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        if (allowMouseDragging) PointerDeviceKind.mouse,
      };
}

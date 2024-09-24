import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:flutter/material.dart' as m;

class Arcane {
  static ArcaneAppState? _app;
  static ArcaneAppState get app => _app!;

  static void pop<T extends Object?>(BuildContext context, [T? result]) =>
      Navigator.pop(context, result);

  static Future<T?> push<T extends Object?>(
          BuildContext context, Widget child) =>
      Pylon.push(context, child, type: PylonRouteType.material);
}

class ArcaneApp extends StatefulWidget {
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
  final bool debugShowMaterialGrid;
  final bool disableBrowserContextMenu;
  final AbstractArcaneTheme? theme;

  const ArcaneApp({
    super.key,
    this.theme,
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
    this.scaling,
    this.disableBrowserContextMenu = true,
  })  : routeInformationProvider = null,
        routeInformationParser = null,
        routerDelegate = null,
        backButtonDispatcher = null,
        routerConfig = null;

  const ArcaneApp.router({
    super.key,
    this.theme,
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

  @override
  State<ArcaneApp> createState() => ArcaneAppState();
}

class ArcaneAppState extends State<ArcaneApp> {
  late AbstractArcaneTheme _theme;

  @override
  void initState() {
    Arcane._app = this;
    super.initState();
    _theme = widget.theme ?? AbstractArcaneTheme.defaultArcaneTheme;
  }

  void setTheme(AbstractArcaneTheme theme) {
    setState(() {
      _theme = theme;
    });
  }

  void updateApp() {
    setState(() {});
  }

  bool get usesRouter =>
      widget.routerDelegate != null || widget.routerConfig != null;

  AbstractArcaneTheme get currentTheme => _theme;

  @override
  Widget build(BuildContext context) => usesRouter
      ? ShadcnApp.router(
          routeInformationProvider: widget.routeInformationProvider,
          routeInformationParser: widget.routeInformationParser,
          routerDelegate: widget.routerDelegate,
          routerConfig: widget.routerConfig,
          backButtonDispatcher: widget.backButtonDispatcher,
          builder: widget.builder,
          title: widget.title,
          onGenerateTitle: widget.onGenerateTitle,
          onNavigationNotification: widget.onNavigationNotification,
          color: widget.color,
          theme: currentTheme.getArcaneTheme(),
          locale: widget.locale,
          localizationsDelegates: widget.localizationsDelegates,
          localeListResolutionCallback: widget.localeListResolutionCallback,
          localeResolutionCallback: widget.localeResolutionCallback,
          supportedLocales: widget.supportedLocales,
          debugShowMaterialGrid: widget.debugShowMaterialGrid,
          showPerformanceOverlay: widget.showPerformanceOverlay,
          showSemanticsDebugger: widget.showSemanticsDebugger,
          debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
          shortcuts: widget.shortcuts,
          actions: widget.actions,
          restorationScopeId: widget.restorationScopeId,
          scrollBehavior: currentTheme.scrollBehavior,
          materialTheme: currentTheme.getMaterialTheme(),
          cupertinoTheme: currentTheme.getCupertinoTheme(),
          scaling: widget.scaling,
          disableBrowserContextMenu: widget.disableBrowserContextMenu,
        )
      : ShadcnApp(
          navigatorKey: widget.navigatorKey,
          home: widget.home,
          routes: widget.routes ?? {},
          initialRoute: widget.initialRoute,
          onGenerateRoute: widget.onGenerateRoute,
          onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
          onUnknownRoute: widget.onUnknownRoute,
          onNavigationNotification: widget.onNavigationNotification,
          navigatorObservers: widget.navigatorObservers ?? [],
          builder: widget.builder,
          title: widget.title,
          onGenerateTitle: widget.onGenerateTitle,
          color: widget.color,
          theme: currentTheme.getArcaneTheme(),
          locale: widget.locale,
          localizationsDelegates: widget.localizationsDelegates,
          localeListResolutionCallback: widget.localeListResolutionCallback,
          localeResolutionCallback: widget.localeResolutionCallback,
          supportedLocales: widget.supportedLocales,
          debugShowMaterialGrid: widget.debugShowMaterialGrid,
          showPerformanceOverlay: widget.showPerformanceOverlay,
          showSemanticsDebugger: widget.showSemanticsDebugger,
          debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
          shortcuts: widget.shortcuts,
          actions: widget.actions,
          restorationScopeId: widget.restorationScopeId,
          scrollBehavior: currentTheme.scrollBehavior,
          materialTheme: currentTheme.getMaterialTheme(),
          cupertinoTheme: currentTheme.getCupertinoTheme(),
          scaling: widget.scaling,
          disableBrowserContextMenu: widget.disableBrowserContextMenu,
        );
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
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.trackpad,
        // The VoiceAccess sends pointer events with unknown type when scrolling
        // scrollables.
        PointerDeviceKind.unknown,
      };
}

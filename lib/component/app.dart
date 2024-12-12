import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:arcane/util/io_web_noop.dart' show usePathUrlStrategy
    if (dart.library.html) 'package:flutter_web_plugins/url_strategy.dart';
import 'package:fast_log/fast_log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as m;

void runApp(Widget app,
    {bool usePathStrategy = true, bool setupMetaSEO = true}) async {
  if (kIsWeb) {
    if (usePathStrategy) {
      try {
        usePathUrlStrategy();
      } catch (e) {}
    }
    if (setupMetaSEO) {
      try {
        MetaSEO().config();
      } catch (e) {}
    }
  }
  m.runApp(app);
}

class Arcane {
  static ArcaneAppState? _app;
  static ArcaneAppState get app => _app!;

  static void pop<T extends Object?>(BuildContext context, [T? result]) =>
      Navigator.pop(context, result);

  static Future<T?> push<T extends Object?>(
          BuildContext context, Widget child) =>
      Pylon.push(context, child,
          type: PylonRouteType.material,
          settings:
              RouteSettings(name: child is ArcaneRoute ? child.path : null));

  static void closeDrawer(BuildContext context) =>
      DrawerOverlay.maybeFind(context)?.overlay.closeLast();
}

class ArcaneApp extends StatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKey;
  final AdaptiveScaling? scaling;
  final Widget? home;
  final Map<String, WidgetBuilder>? routes;
  final String initialRoute;
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
  final List<ArcaneRoute> arcaneRoutes;

  const ArcaneApp({
    super.key,
    this.theme,
    this.navigatorKey,
    this.home,
    this.arcaneRoutes = const <ArcaneRoute>[],
    Map<String, WidgetBuilder> this.routes = const <String, WidgetBuilder>{},
    this.initialRoute = "/",
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
        initialRoute = "/",
        arcaneRoutes = const <ArcaneRoute>[];

  @override
  State<ArcaneApp> createState() => ArcaneAppState();
}

class ArcaneAppState extends State<ArcaneApp> {
  RouteFactory? routeFactory;
  late AbstractArcaneTheme _theme;
  late Map<String, WidgetBuilder> dynamicRoutes;
  bool usesArcaneRouting = false;

  @override
  void initState() {
    dynamicRoutes = {};
    routeFactory = widget.onGenerateRoute;
    Arcane._app = this;
    super.initState();
    _theme = widget.theme ?? AbstractArcaneTheme.defaultArcaneTheme;
    buildDynamicRoutes();
  }

  void buildDynamicRoutes() {
    if (usesRouter ||
        (widget.home is! ArcaneRoute && widget.arcaneRoutes.isEmpty)) {
      return;
    }

    info("=== Building Dynamic Route Map ===");

    dynamicRoutes = {...(widget.routes ?? {})};

    for (ArcaneRoute route in widget.arcaneRoutes) {
      dynamicRoutes[route.path] = (context) => route;
      verbose("${route.path} -> ${route.runtimeType}");
    }

    if (!dynamicRoutes.containsKey(widget.initialRoute) &&
        widget.home is ArcaneRoute) {
      dynamicRoutes[widget.initialRoute] = (context) => widget.home!;
      verbose("${widget.initialRoute} -> ${widget.home!.runtimeType}");
    }

    routeFactory = (RouteSettings settings) {
      if (settings.name?.isNotEmpty ?? false) {
        String route = Uri.parse(settings.name!).path;

        if (dynamicRoutes.containsKey(route)) {
          return MaterialPageRoute(
              builder: dynamicRoutes[route]!, settings: settings);
        }
      }

      return null;
    };

    usesArcaneRouting = true;
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
  void didUpdateWidget(ArcaneApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.theme != widget.theme) {
      _theme = widget.theme ?? AbstractArcaneTheme.defaultArcaneTheme;
    }
  }

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
          home: usesArcaneRouting ? null : widget.home,
          routes: {
            ...dynamicRoutes,
            ...widget.routes ?? {},
          },
          initialRoute: widget.initialRoute,
          onGenerateRoute: routeFactory,
          onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
          onUnknownRoute: usesArcaneRouting
              ? widget.onUnknownRoute ??
                  (rs) => MaterialPageRoute(
                      builder: dynamicRoutes[widget.initialRoute]!,
                      settings: RouteSettings(name: widget.initialRoute))
              : widget.onUnknownRoute,
          onNavigationNotification: widget.onNavigationNotification,
          navigatorObservers: [
            ...widget.navigatorObservers ?? [],
            ArcaneRoutingNavigationObserver(
              routes: widget.arcaneRoutes,
            )
          ],
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

class ArcaneRoutingNavigationObserver extends NavigatorObserver {
  final List<ArcaneRoute> routes;

  ArcaneRoutingNavigationObserver({this.routes = const <ArcaneRoute>[]});

  void _applyRouteIfExists(Route<dynamic>? route) {
    if (route == null || route.settings.name == null) return;
    String routeName = Uri.parse(route.settings.name!).path;
    ArcaneRoute? art = routes.select((i) => i.path == routeName);
    if (art != null) {
      art.$applyRoute();
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _applyRouteIfExists(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _applyRouteIfExists(previousRoute);
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _applyRouteIfExists(previousRoute);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _applyRouteIfExists(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
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
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.unknown,
      };
}

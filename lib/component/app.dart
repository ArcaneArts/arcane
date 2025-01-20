import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:arcane/util/shaders.dart';
import 'package:fast_log/fast_log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as m;

void runApp(Widget app, {bool setupMetaSEO = true}) async {
  setupArcaneDebug();
  ArcaneShader.loadAll();
  if (kIsWeb) {
    if (setupMetaSEO) {
      try {
        MetaSEO().config();
        actioned("SEO Engine Configured for Browser");
      } catch (e) {}
    }
  }

  m.runApp(app);
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
  final ArcaneTheme? theme;

  const ArcaneApp({
    super.key,
    this.theme,
    this.navigatorKey,
    this.home,
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
        initialRoute = "/";

  @override
  State<ArcaneApp> createState() => ArcaneAppState();
}

class ArcaneAppState extends State<ArcaneApp> {
  RouteFactory? routeFactory;
  late ArcaneTheme _theme;

  @override
  void initState() {
    routeFactory = widget.onGenerateRoute;
    Arcane.$app = this;
    super.initState();
    _theme = widget.theme ?? const ArcaneTheme();
    actionedAnnounce(
        "${(widget.title.trim().isEmpty ? null : widget.title) ?? "Arcane App"} Initialized");
  }

  void setTheme(ArcaneTheme theme) {
    setState(() {
      _theme = theme;
      actionedAnnounce("Theme Changed");
    });
  }

  void updateApp() {
    setState(() {});
    actionedAnnounce("App wide setState()");
  }

  bool get usesRouter =>
      widget.routerDelegate != null || widget.routerConfig != null;

  ArcaneTheme get currentTheme => _theme;

  @override
  void didUpdateWidget(ArcaneApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.theme != widget.theme) {
      _theme = widget.theme ?? const ArcaneTheme();
    }
  }

  @override
  Widget build(BuildContext context) => Pylon<ArcaneTheme?>(
        value: _theme,
        builder: (context) => usesRouter
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
                theme: currentTheme.shadThemeData,
                locale: widget.locale,
                localizationsDelegates: widget.localizationsDelegates,
                localeListResolutionCallback:
                    widget.localeListResolutionCallback,
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
                materialTheme: currentTheme.materialThemeData,
                cupertinoTheme: currentTheme.cupertinoThemeData,
                scaling: widget.scaling,
                disableBrowserContextMenu: widget.disableBrowserContextMenu,
              )
            : ShadcnApp(
                navigatorKey: widget.navigatorKey,
                home: widget.home,
                routes: {
                  ...widget.routes ?? {},
                },
                initialRoute: widget.initialRoute,
                onGenerateRoute: routeFactory,
                onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
                onUnknownRoute: widget.onUnknownRoute,
                onNavigationNotification: widget.onNavigationNotification,
                navigatorObservers: [...widget.navigatorObservers ?? []],
                builder: widget.builder,
                title: widget.title,
                onGenerateTitle: widget.onGenerateTitle,
                color: widget.color,
                theme: currentTheme.shadThemeData,
                locale: widget.locale,
                localizationsDelegates: widget.localizationsDelegates,
                localeListResolutionCallback:
                    widget.localeListResolutionCallback,
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
                materialTheme: currentTheme.materialThemeData,
                cupertinoTheme: currentTheme.cupertinoThemeData,
                scaling: widget.scaling,
                disableBrowserContextMenu: widget.disableBrowserContextMenu,
              ),
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
        PointerDeviceKind.unknown,
      };
}

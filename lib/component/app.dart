import 'dart:math';
import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:arcane/util/shaders.dart';
import 'package:fast_log/fast_log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as m;
import 'package:hive_flutter/adapters.dart';
import 'package:serviced/serviced.dart';

/// Initializes and runs an Arcane app.
///
/// This function sets up required Arcane components before launching the app:
/// - Sets up debug utilities
/// - Loads all shaders
/// - Configures SEO for web applications
///
/// For more details, see the [ArcaneApp documentation](../doc/component/app.md#setup).
///
/// @param app The widget to run as the root of the widget tree
/// @param setupMetaSEO Whether to configure SEO metadata for web applications
void runApp(String appId, Widget app, {bool setupMetaSEO = true}) async {
  $appId = appId;
  setupArcaneDebug();
  $registerInitTask(InitTask("Arcane Hive", () async {
    await Hive.initFlutter(appId);
    await Future.wait([
      Hive.openBox(
        "$appId.hb",
        encryptionCipher: HiveAesCipher(
          Random("$appId.hb".hashCode ^ 0x33EF69DF3D9).nextInts(32),
        ),
      ).then((box) => hotBox = box),
      Hive.openLazyBox(
        "$appId.cb",
        encryptionCipher: HiveAesCipher(
          Random("$appId.cb".hashCode ^ 0x73DE39333A).nextInts(32),
        ),
      ).then((box) => coldBox = box),
    ]);
  }));
  $registerInitTask(
      InitTask("Arcane Shaders", () async => ArcaneShader.loadAll()));

  if (kIsWeb) {
    if (setupMetaSEO) {
      $registerInitTask(InitTask("Meta SEO", () async {
        try {
          MetaSEO().config();
          actioned("SEO Engine Configured for Browser");
        } catch (e) {}
      }));
    }
  }

  MagicInitializer.getInitializers(app).forEach($registerInitTask);
  await $executeInitTasks();
  await services().waitForStartup();
  m.runApp(app);
}

String $appId = "undefined_arcane";

mixin MagicInitializer {
  Widget get child;
  InitTask get $initializer;

  static Iterable<InitTask> getInitializers(Widget p) sync* {
    if (p is MagicInitializer) {
      yield (p as MagicInitializer).$initializer;
      yield* getInitializers((p as MagicInitializer).child);
      return;
    }

    try {
      Widget widget = (p as dynamic).child;
      yield* getInitializers(widget);
    } catch (e) {
      return;
    }
  }
}

/// A root widget for Arcane applications providing theming and navigation capabilities.
///
/// ArcaneApp serves as a wrapper around ShadcnApp with additional Arcane-specific
/// functionality. It provides theming, navigation, and other app-level configurations.
///
/// For complete documentation, see [ArcaneApp documentation](../doc/component/app.md).
///
/// There are two ways to use ArcaneApp:
///
/// 1. Standard navigation (using [ArcaneApp])
/// 2. Router-based navigation (using [ArcaneApp.router])
class ArcaneApp extends StatefulWidget {
  /// Key for the application's navigator
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Controls the adaptation of UI elements based on screen size
  final AdaptiveScaling? scaling;

  /// The widget to be displayed at the root route "/"
  final Widget? home;

  /// Mapping of route names to widget builders
  final Map<String, WidgetBuilder>? routes;

  /// The initial route when the app is first loaded
  final String initialRoute;

  /// Factory for generating routes dynamically
  final RouteFactory? onGenerateRoute;

  /// Factory for generating initial routes
  final InitialRouteListFactory? onGenerateInitialRoutes;

  /// Factory for handling unknown routes
  final RouteFactory? onUnknownRoute;

  /// Callback for navigation notifications
  final NotificationListenerCallback<NavigationNotification>?
      onNavigationNotification;

  /// List of observers for the navigator
  final List<NavigatorObserver>? navigatorObservers;

  /// Provider of route information for the Router API
  final RouteInformationProvider? routeInformationProvider;

  /// Parser for route information for the Router API
  final RouteInformationParser<Object>? routeInformationParser;

  /// Delegate for routing decisions in the Router API
  final RouterDelegate<Object>? routerDelegate;

  /// Dispatcher for back button events
  final BackButtonDispatcher? backButtonDispatcher;

  /// Router configuration
  final RouterConfig<Object>? routerConfig;

  /// Builder for wrapping the entire app with additional widgets
  final TransitionBuilder? builder;

  /// Title of the application
  final String title;

  /// Generator for the app title
  final GenerateAppTitle? onGenerateTitle;

  /// Primary color for the app
  final Color? color;

  /// The app's locale
  final Locale? locale;

  /// Delegates for localizing the app
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Callback for resolving a list of locales
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// Callback for resolving a locale
  final LocaleResolutionCallback? localeResolutionCallback;

  /// The locales supported by the app
  final Iterable<Locale> supportedLocales;

  /// Whether to show performance overlay
  final bool showPerformanceOverlay;

  /// Whether to show semantics debugger
  final bool showSemanticsDebugger;

  /// Whether to show the debug banner
  final bool debugShowCheckedModeBanner;

  /// Keyboard shortcuts for the app
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// Actions that can be invoked by intents
  final Map<Type, Action<Intent>>? actions;

  /// Restoration scope ID for state restoration
  final String? restorationScopeId;

  /// Whether to show the Material grid
  final bool debugShowMaterialGrid;

  /// Whether to disable the browser's context menu (on web)
  final bool disableBrowserContextMenu;

  /// The theme configuration for the app
  final ArcaneTheme? theme;

  /// Creates an ArcaneApp with standard navigation.
  ///
  /// This constructor uses Flutter's standard navigation system with routes and a navigator.
  /// For more information, see [Standard Navigation](../doc/component/app.md#standard-navigation).
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

  /// Creates an ArcaneApp with the Router API for navigation.
  ///
  /// This constructor uses Flutter's Router API for more advanced routing capabilities.
  /// For more information, see [Router-based Navigation](../doc/component/app.md#router-based-navigation).
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

/// The state for the ArcaneApp widget.
///
/// Manages the app's theme and provides methods for updating the theme and refreshing the app.
/// For details, see [App State Management](../doc/component/app.md#app-state-management).
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

  /// Updates the app's theme.
  ///
  /// This method changes the theme of the entire application and triggers a rebuild.
  /// For more information, see [Changing Themes](../doc/component/app.md#changing-themes).
  ///
  /// @param theme The new theme to apply to the app
  void setTheme(ArcaneTheme theme) {
    setState(() {
      _theme = theme;
      actionedAnnounce("Theme Changed");
    });
  }

  /// Forces a rebuild of the entire application.
  ///
  /// This method calls setState() without any changes, which triggers a rebuild
  /// of the entire widget tree. Use this method when you need to refresh the app
  /// but aren't changing any specific state.
  void updateApp() {
    setState(() {});
    actionedAnnounce("App wide setState()");
  }

  /// Whether the app uses the Router API for navigation.
  bool get usesRouter =>
      widget.routerDelegate != null || widget.routerConfig != null;

  /// The current theme of the application.
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

/// Custom scroll behavior for Arcane applications.
///
/// Provides a consistent scrolling experience across different platforms and input devices.
/// For more information, see [Scrolling Behavior](../doc/component/app.md#scrolling-behavior).
class ArcaneScrollBehavior extends m.MaterialScrollBehavior {
  final ScrollPhysics physics;

  /// Whether to allow mouse dragging for scrolling.
  final bool allowMouseDragging;

  /// Creates a new ArcaneScrollBehavior instance.
  ///
  /// @param allowMouseDragging Whether to allow dragging with a mouse to scroll content
  const ArcaneScrollBehavior(
      {this.allowMouseDragging = true,
      this.physics = const BouncingScrollPhysics()});

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) => physics;

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

extension _XRand on Random {
  List<int> nextInts(int count) => List.generate(count, (_) => nextInt(256));
}

late Box hotBox;
late LazyBox coldBox;

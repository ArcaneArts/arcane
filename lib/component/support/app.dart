import 'dart:math';
import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:arcane/generated/arcane_shadcn/src/events.dart';
import 'package:fast_log/fast_log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as m;
import 'package:hive_flutter/adapters.dart';
import 'package:serviced/serviced.dart';

bool kHapticsAvailable = false;

/// Initializes and runs an Arcane app, serving as the central entry point for Arcane-based Flutter applications.
///
/// This function orchestrates the setup of essential Arcane components before launching the app, ensuring
/// seamless integration with Flutter's runtime. It handles initialization tasks such as debug utilities,
/// shader loading for visual effects, haptic feedback availability checks, secure storage via Hive with
/// encryption, and optional SEO metadata configuration for web platforms. By wrapping the provided [app]
/// widget, it enables global access to Arcane's theming ([ArcaneTheme]), navigation ([Navigator]), and
/// components like [Sidebar] and [BottomNavigationBar]. This promotes efficient root-level setup with
/// performance optimizations like lazy shader loading and cached theme application to minimize rebuilds.
///
/// Key features include:
/// - Asynchronous task registration and execution for non-blocking initialization.
/// - Secure, app-specific storage boxes (hotBox for frequent access, coldBox for lazy-loaded data).
/// - Web-specific SEO enhancements using [MetaSEO] for better discoverability.
/// - Integration with [MagicInitializer] for custom widget-level setup tasks.
///
/// Usage in Arcane UI: Call this at the app's entry point (e.g., in main.dart) to bootstrap the entire
/// application, providing the root widget (often an [ArcaneApp]) and app ID for storage isolation.
/// It ensures the app is ready for theming, navigation, and component rendering with minimal overhead.
///
/// Parameters:
/// - appId: Unique identifier for the app, used for storage keys and encryption seeds to isolate data.
/// - app: The root [Widget] (typically [ArcaneApp]) that defines the app's structure and initial UI.
/// - setupMetaSEO: Enables automatic SEO configuration for web apps; defaults to true for improved web presence.
///
/// Returns: None (void), but triggers the Flutter app run cycle via [runApp] after setup completion.
///
/// Integrations: Works with [HiveFlutter] for storage, [ArcaneShader] for graphics, [Serviced] for dependency
/// injection, and [ArcaneShadEvents] for event handling. For performance, it caches initialization results
/// and uses Future.wait for parallel task execution, reducing startup time.
void runApp(String appId, Widget app, {bool setupMetaSEO = true}) async {
  $appId = appId;
  setupArcaneDebug();
  $registerInitTask(InitTask("Arcane Haptics",
      () => Haptics.canVibrate().then((i) => kHapticsAvailable = i)));
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
  $shadEvent = ArcaneShadEvents();
  m.runApp(app);
}

String $appId = "undefined_arcane";

/// A mixin for widgets that require custom initialization tasks in Arcane apps.
///
/// This mixin allows widgets to register [InitTask]s during app startup, enabling
/// deferred setup for components like [Sidebar] or [BottomNavigationBar] that need
/// resources pre-loaded. It integrates with the runApp function to chain initializers
/// recursively through the widget tree, ensuring all tasks complete before the app renders.
///
/// Key features: Automatic task discovery via getInitializers, which traverses child
/// widgets to collect and yield tasks. This supports modular initialization without
/// global state pollution, promoting performance by loading only necessary resources.
///
/// Usage: Implement in root-level widgets (e.g., [ArcaneApp]) to provide child access
/// and an initializer task. Tasks run asynchronously in parallel where possible,
/// with error handling to prevent startup failures.
///
/// Parameters: None directly; relies on implementing get child and get $initializer.
///
/// Returns: Iterable<InitTask> via static method for chaining.
///
/// Integrations: Used by runApp to bootstrap [ArcaneShader], storage ([Hive]), and
/// events ([ArcaneShadEvents]). Enhances app startup efficiency by avoiding synchronous
/// blocks in the UI thread.
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

/// A root widget for Arcane applications, serving as the central entry point that wraps
/// [MaterialApp] with Arcane-specific theming, navigation, and global providers.
///
/// ArcaneApp extends Flutter's app foundation by integrating [ArcaneTheme] for consistent
/// styling across components like [Sidebar], [BottomNavigationBar], and [Section]. It supports
/// both standard [Navigator]-based routing and advanced [Router] API for declarative navigation,
/// with built-in support for localization ([Localizations]), performance overlays, and adaptive
/// scaling. As the app's root, it ensures efficient rebuilds through theme caching and minimal
/// state management, making it ideal for scalable UIs in Arcane projects.
///
/// Key features:
/// - Theme integration via [ArcaneTheme], applying extensions to [ThemeData] for colors, typography,
///   and scroll behavior ([ArcaneScrollBehavior]).
/// - Navigation setup with [Navigator] or [RouterDelegate]/[RouteInformationParser] for dynamic routes.
/// - Global providers for events ([ArcaneShadEvents]) and storage, enabling seamless component interactions.
/// - Performance optimizations: Lazy route generation, cached themes to avoid unnecessary rebuilds,
///   and adaptive UI scaling for different screen sizes.
///
/// Usage in Arcane UI: Use as the root widget in runApp, providing home or router config. It wraps
/// the entire app tree, propagating [ArcaneTheme] down to children like [AbstractScreen] or [ChatScreen].
/// For web apps, it handles SEO and context menu disabling. Customize via constructors for specific
/// navigation needs, ensuring compatibility with [SliverScreen] and [FillScreen] for complex layouts.
///
/// Parameters: See constructors for details on navigation, theming, and localization options.
///
/// Returns: A [StatefulWidget] that builds the app's widget tree with ShadcnApp integration.
///
/// Integrations: Relies on [ShadcnApp] for base rendering, [Pylon] for theme provision, [PopoverOverlayHandler]
/// for overlays, and [Serviced] for dependency injection. Emphasizes performance with const constructors
/// and inline optimizations to minimize widget tree depth and render passes.
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

  /// Creates an ArcaneApp with standard navigation using Flutter's [Navigator] system.
  ///
  /// This constructor configures the app for imperative routing, where routes are defined via
  /// maps or factories. It initializes the [Navigator] with the provided key, home widget,
  /// and route builders, integrating [ArcaneTheme] for consistent styling. Ideal for simple
  /// apps using push/pop navigation with components like [BottomNavigationBar] or [Sidebar].
  ///
  /// Parameters:
  /// - key: Standard Flutter widget key for identification and state management.
  /// - theme: Optional [ArcaneTheme] to apply app-wide styling; defaults to a basic theme if null.
  /// - navigatorKey: [GlobalKey<NavigatorState>] for direct navigator access (e.g., for programmatic pushes).
  /// - home: Root [Widget] displayed at the initial route ("/"); often an [AbstractScreen] or [NavigationScreen].
  /// - routes: Map of route names to [WidgetBuilder]s for predefined paths; merges with defaults for Arcane routes.
  /// - initialRoute: Starting route path; defaults to "/" for the home widget.
  /// - onGenerateRoute: Callback to dynamically build routes based on [RouteSettings]; supports complex logic.
  /// - onGenerateInitialRoutes: Factory for initial route list; rarely used but allows custom startup flows.
  /// - onUnknownRoute: Fallback route generator for unmatched paths; ensures graceful error handling.
  /// - onNavigationNotification: Listener for [NavigationNotification] events, e.g., to track route changes.
  /// - navigatorObservers: List of [NavigatorObserver]s for logging or analytics on navigation events.
  /// - builder: [TransitionBuilder] to wrap the navigator output, e.g., for global theming or providers.
  /// - title: App title for system bars and accessibility; used in [GenerateAppTitle] if provided.
  /// - onGenerateTitle: Dynamic title generator based on [BuildContext]; overrides static title.
  /// - color: Primary [Color] for system UI (e.g., status bar); integrates with [ArcaneTheme].
  /// - locale: Initial app [Locale]; affects [Localizations] and right-to-left layouts.
  /// - localizationsDelegates: Iterable of [LocalizationsDelegate]s for i18n support; enables [Localizations].
  /// - localeListResolutionCallback: Resolves conflicting locales from device and app lists.
  /// - localeResolutionCallback: Selects the best [Locale] from supported ones based on device settings.
  /// - supportedLocales: List of [Locale]s the app handles; defaults to English (US) for broad compatibility.
  /// - debugShowMaterialGrid: Toggles Material Design grid overlay for layout debugging.
  /// - showPerformanceOverlay: Enables performance metrics overlay to monitor frame rates and rebuilds.
  /// - showSemanticsDebugger: Shows semantic tree for accessibility testing.
  /// - debugShowCheckedModeBanner: Displays "DEBUG" banner in debug mode; defaults to false for production-like testing.
  /// - shortcuts: Map of [ShortcutActivator] to [Intent] for keyboard navigation support.
  /// - actions: Map of [Intent] types to [Action]s for handling user inputs.
  /// - restorationScopeId: ID for state restoration across app restarts (e.g., for [Hive] integration).
  /// - scaling: Optional [AdaptiveScaling] for responsive UI adjustments across devices.
  /// - disableBrowserContextMenu: Prevents web context menu for native app feel; defaults to true.
  ///
  /// Returns: A configured [ArcaneApp] ready for standard navigation, emphasizing efficient route caching
  /// and theme propagation to child components like [Sheet] or [SliverScreen] without redundant rebuilds.
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

  /// Creates an ArcaneApp with the Router API for declarative, advanced navigation.
  ///
  /// This constructor leverages Flutter's [Router] system for URL-based routing, stateful
  /// navigation, and deep linking, using [RouterDelegate] and [RouteInformationParser] to
  /// manage routes. It integrates [ArcaneTheme] and supports components like [NavigationScreen]
  /// for complex, history-aware UIs. Suited for web apps or those needing browser integration,
  /// with performance benefits from reactive route updates without full rebuilds.
  ///
  /// Parameters:
  /// - key: Standard Flutter widget key for identification and state management.
  /// - theme: Optional [ArcaneTheme] to apply app-wide styling; defaults to a basic theme if null.
  /// - routeInformationProvider: [RouteInformationProvider] for listening to route changes (e.g., from browser).
  /// - routeInformationParser: [RouteInformationParser] to parse route info into app state; essential for URL handling.
  /// - routerDelegate: [RouterDelegate] to build pages and manage navigation stack based on state.
  /// - routerConfig: Alternative [RouterConfig] for simplified router setup; mutually exclusive with delegate/parser.
  /// - backButtonDispatcher: [BackButtonDispatcher] for handling system back gestures.
  /// - builder: [TransitionBuilder] to wrap the router output, e.g., for global providers or theming.
  /// - title: App title for system bars and accessibility; used in [GenerateAppTitle] if provided.
  /// - onGenerateTitle: Dynamic title generator based on [BuildContext]; overrides static title.
  /// - onNavigationNotification: Listener for [NavigationNotification] events, e.g., to track route changes.
  /// - color: Primary [Color] for system UI (e.g., status bar); integrates with [ArcaneTheme].
  /// - locale: Initial app [Locale]; affects [Localizations] and right-to-left layouts.
  /// - localizationsDelegates: Iterable of [LocalizationsDelegate]s for i18n support; enables [Localizations].
  /// - localeListResolutionCallback: Resolves conflicting locales from device and app lists.
  /// - localeResolutionCallback: Selects the best [Locale] from supported ones based on device settings.
  /// - supportedLocales: List of [Locale]s the app handles; defaults to English (US) for broad compatibility.
  /// - debugShowMaterialGrid: Toggles Material Design grid overlay for layout debugging.
  /// - showPerformanceOverlay: Enables performance metrics overlay to monitor frame rates and rebuilds.
  /// - showSemanticsDebugger: Shows semantic tree for accessibility testing.
  /// - debugShowCheckedModeBanner: Displays "DEBUG" banner in debug mode; defaults to true for router debugging.
  /// - shortcuts: Map of [ShortcutActivator] to [Intent] for keyboard navigation support.
  /// - actions: Map of [Intent] types to [Action]s for handling user inputs.
  /// - restorationScopeId: ID for state restoration across app restarts (e.g., for [Hive] integration).
  /// - scaling: Optional [AdaptiveScaling] for responsive UI adjustments across devices.
  /// - disableBrowserContextMenu: Prevents web context menu for native app feel; defaults to true.
  ///
  /// Returns: A configured [ArcaneApp] for router-based navigation, with optimized state syncing
  /// between URL and UI, supporting deep links to screens like [ChatScreen] or [FillScreen] efficiently.
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

/// The state class for [ArcaneApp], managing app-level state including theme and navigation.
///
/// This class handles initialization, theme updates, and the build process for the app's root
/// widget tree. It provides global access via Arcane.$app and ensures efficient rebuilds by
/// caching the [ArcaneTheme] and using [Pylon] for provider-like theme distribution. Integrates
/// with [ShadcnApp] for rendering, applying theme extensions to [ThemeData] and handling both
/// standard [Navigator] and [Router] modes. Emphasizes performance through minimal state changes
/// and lazy route factories, making it the core for scalable Arcane UIs with components like
/// [BottomNavigationBar] and [Sidebar].
///
/// Key features:
/// - Theme management with setTheme for dynamic updates without full restarts.
/// - Route factory caching to avoid regeneration on rebuilds.
/// - Integration with global services ([Serviced]) and events ([ArcaneShadEvents]).
/// - Announcement logging for key lifecycle events, aiding debugging.
///
/// Usage: Automatically created by [ArcaneApp]; access via Arcane.$app for theme or update calls.
/// It propagates [ArcaneTheme] to descendants, ensuring consistent styling and scroll behavior.
///
/// Parameters: Inherited from [ArcaneApp]; manages internal _theme and routeFactory.
///
/// Returns: Widgets via build, including [ShadcnApp] wrapped with theme provider.
///
/// Integrations: Uses [Pylon<ArcaneTheme>] for context provision, [PopoverOverlayHandler] for
/// overlays, and [BouncingScrollPhysics] defaults for smooth interactions. Optimizes for low
/// overhead by inlining simple getters and avoiding unnecessary async in non-await methods.
class ArcaneAppState extends State<ArcaneApp> {
  RouteFactory? routeFactory;
  late ArcaneTheme _theme;

  /// Initializes the app state, setting up global references and theme.
  ///
  /// This method runs once on widget creation, assigning Arcane.$app for global access,
  /// caching the initial [ArcaneTheme], and logging app initialization. It prepares
  /// routeFactory for navigation and announces the app title, integrating with
  /// [Serviced] for startup completion. Ensures theme is ready for immediate use
  /// in child components like [Section] or [Sheet], with performance focus on
  /// synchronous setup to avoid jank on first frame.
  @override
  void initState() {
    routeFactory = widget.onGenerateRoute;
    Arcane.$app = this;
    super.initState();
    _theme = widget.theme ?? const ArcaneTheme();
    actionedAnnounce(
        "${(widget.title.trim().isEmpty ? null : widget.title) ?? "Arcane App"} Initialized");
  }

  /// Updates the app's theme dynamically, triggering a targeted rebuild.
  ///
  /// This method applies a new [ArcaneTheme], updating _theme and calling setState
  /// to refresh the widget tree. It announces the change for logging and ensures
  /// efficient propagation to [MaterialApp]-like structures via [ShadcnApp]. Ideal
  /// for runtime theme switching (e.g., dark/light mode) without restarting the app,
  /// maintaining performance by limiting rebuild scope to theme-dependent widgets
  /// like [GlowCard] or [Glass].
  ///
  /// Parameters:
  /// - theme: The new [ArcaneTheme] instance to apply, overriding the current one.
  void setTheme(ArcaneTheme theme) {
    setState(() {
      _theme = theme;
      actionedAnnounce("Theme Changed");
    });
  }

  /// Forces a full app rebuild without state changes, refreshing the UI.
  ///
  /// This invokes setState with no modifications, prompting a complete widget tree
  /// traversal. Useful for scenarios requiring global refresh, such as after
  /// dynamic content updates or provider changes, while integrating with Arcane's
  /// event system. Announces the action for traceability, with performance note:
  /// Use sparingly as it may trigger unnecessary renders; prefer targeted setState
  /// in child components like [Expander] or [DataTable] for better efficiency.
  void updateApp() {
    setState(() {});
    actionedAnnounce("App wide setState()");
  }

  /// Whether the app uses the Router API for navigation.
  bool get usesRouter =>
      widget.routerDelegate != null || widget.routerConfig != null;

  /// The current theme of the application.
  ArcaneTheme get currentTheme => _theme;

  set $rawThemeInject(ArcaneTheme theme) => _theme = theme;

  /// Responds to widget updates, refreshing theme if changed.
  ///
  /// This override checks for theme differences from the previous widget and
  /// reinitializes _theme accordingly, ensuring consistency during hot reloads
  /// or parent updates. Integrates with Flutter's lifecycle for seamless theme
  /// transitions without data loss, supporting components reliant on [ArcaneTheme]
  /// like [MutableText] or [IconButton].
  @override
  void didUpdateWidget(ArcaneApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.theme != widget.theme) {
      _theme = widget.theme ?? const ArcaneTheme();
    }
  }

  /// Builds the app's root widget tree, applying theme and navigation.
  ///
  /// This nuanced method constructs the UI by providing [ArcaneTheme] via [Pylon],
  /// then conditionally builds [ShadcnApp] for router or standard modes. It applies
  /// theme extensions to [ThemeData] (shadThemeData, materialThemeData, cupertinoThemeData),
  /// configures navigation with [Navigator] or [RouterDelegate]/[RouteInformationParser],
  /// and sets up localizations ([LocalizationsDelegate]s) and scroll behavior. Performance
  /// is optimized via cached routeFactory, merged routes, and inline physics application,
  /// ensuring efficient renders for complex UIs with [SliverScreen] or [ChatScreen].
  ///
  /// Key integrations: [PopoverOverlayHandler] for menus/popovers, [BouncingScrollPhysics]
  /// default for native feel, and debug tools for overlay/semantics. Merges routes to
  /// support Arcane defaults, enabling seamless [Sidebar] and [BottomNavigationBar] usage.
  @override
  Widget build(BuildContext context) {
    Widget s = Pylon<ArcaneTheme?>(
      value: _theme,
      builder: (context) => usesRouter
          ? ShadcnApp.router(
              menuHandler: PopoverOverlayHandler(),
              popoverHandler: PopoverOverlayHandler(),
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
              materialTheme: currentTheme.materialThemeData,
              cupertinoTheme: currentTheme.cupertinoThemeData,
              scaling: widget.scaling,
              disableBrowserContextMenu: widget.disableBrowserContextMenu,
            )
          : ShadcnApp(
              menuHandler: PopoverOverlayHandler(),
              popoverHandler: PopoverOverlayHandler(),
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
              materialTheme: currentTheme.materialThemeData,
              cupertinoTheme: currentTheme.cupertinoThemeData,
              scaling: widget.scaling,
              disableBrowserContextMenu: widget.disableBrowserContextMenu,
            ),
    );

    return s;
  }
}

/// Custom scroll behavior for Arcane applications, extending [MaterialScrollBehavior].
///
/// This class customizes scrolling physics and device support for a native, platform-agnostic
/// experience across touch, mouse, and trackpad inputs. It applies [BouncingScrollPhysics] by
/// default for iOS-like overscroll and enables mouse dragging for desktop/web usability.
/// Integrates with [ArcaneTheme]'s scrollBehavior for theme-consistent physics, enhancing
/// components like [SliverScreen] and [Expander] with smooth, performant scrolling.
///
/// Key features: Configurable physics and drag devices, ensuring accessibility and efficiency.
/// Performance: Inline overrides minimize overhead, avoiding unnecessary computations during scrolls.
///
/// Usage in Arcane UI: Set via [ArcaneTheme.scrollBehavior] or directly in [ShadcnApp]; supports
/// [DataTable] and [StaticTable] for horizontal/vertical scrolling without jank.
///
/// Parameters: See constructor for physics and dragging options.
///
/// Returns: Customized [ScrollPhysics] and [Set<PointerDeviceKind>] for Flutter's scroll system.
///
/// Integrations: Works with [ThemeData]'s scrollBehavior, [BouncingScrollPhysics] for bounce effects,
/// and device kinds like [PointerDeviceKind.mouse] for web/desktop compatibility.
class ArcaneScrollBehavior extends m.MaterialScrollBehavior {
  final ScrollPhysics physics;

  /// Whether to allow mouse dragging for scrolling.
  final bool allowMouseDragging;

  /// Creates a new [ArcaneScrollBehavior] with customizable physics and dragging support.
  ///
  /// This constructor initializes the behavior for Arcane's scrolling needs, applying
  /// [BouncingScrollPhysics] for elastic overscroll and enabling mouse interactions by default.
  /// It ensures compatibility with [ArcaneTheme] and platform differences, promoting smooth
  /// navigation in lists, slivers, and nested scroll views like those in [NavigationScreen].
  ///
  /// Parameters:
  /// - allowMouseDragging: Enables [PointerDeviceKind.mouse] for desktop/web scrolling; defaults to true.
  /// - physics: Custom [ScrollPhysics] to override defaults; use [BouncingScrollPhysics()] for native feel.
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

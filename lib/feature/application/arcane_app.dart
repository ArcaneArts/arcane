import 'package:arcane/arcane.dart';
import 'package:flutter/scheduler.dart';
import 'package:rxdart/rxdart.dart';

class ArcaneApp extends StatefulWidget {
  final String title;
  final Widget Function() home;
  final Map<String, Widget Function()> pages;
  final ThemeData Function(ThemeData theme)? themeModifier;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final TransitionBuilder? builder;
  final GenerateAppTitle? onGenerateTitle;
  final Color? color;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  final Map<LogicalKeySet, Intent>? shortcuts;
  final ScrollBehavior? scrollBehavior;
  final ThemeData? highContrastTheme;
  final ThemeData? highContrastDarkTheme;
  final Map<Type, Action<Intent>>? actions;
  final bool debugShowMaterialGrid;
  final bool useInheritedMediaQuery;
  final TextDirection directionality;
  final Widget Function(BuildContext context, Widget child) backgroundBuilder;
  final Widget Function(BuildContext context, Widget child) foregroundBuilder;
  final Widget? background;

  const ArcaneApp(
      {super.key,
      required this.home,
      required this.title,
      this.pages = const {},
      this.themeModifier,
      this.scaffoldMessengerKey,
      this.useInheritedMediaQuery = false,
      this.builder,
      this.onGenerateTitle,
      this.color,
      this.locale,
      this.localizationsDelegates,
      this.localeListResolutionCallback,
      this.localeResolutionCallback,
      this.supportedLocales = const <Locale>[Locale('en', 'US')],
      this.debugShowMaterialGrid = false,
      this.showPerformanceOverlay = false,
      this.checkerboardRasterCacheImages = false,
      this.checkerboardOffscreenLayers = false,
      this.showSemanticsDebugger = false,
      this.debugShowCheckedModeBanner = true,
      this.shortcuts,
      this.scrollBehavior,
      this.highContrastTheme,
      this.highContrastDarkTheme,
      this.actions,
      this.directionality = TextDirection.ltr,
      this.backgroundBuilder = _passthroughBuilder,
      this.foregroundBuilder = _passthroughBuilder,
      this.background});

  @override
  State<ArcaneApp> createState() => _ArcaneAppState();
}

class _ArcaneAppState extends State<ArcaneApp> {
  @override
  void initState() {
    Arcane.app.updateTempContext(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => OpalWrapper(
      background: widget.background,
      backgroundBuilder: widget.backgroundBuilder,
      foregroundBuilder: widget.foregroundBuilder,
      directionality: widget.directionality,
      themeMode: Arcane.themeMode,
      darkTheme: Arcane.app.darkTheme,
      lightTheme: Arcane.app.lightTheme,
      themeMods: Arcane.app.themeMods,
      darkThemeMods: Arcane.app.darkThemeMods,
      lightThemeMods: Arcane.app.lightThemeMods,
      builder: (context, light, dark, mode) => MaterialApp.router(
            routerConfig: Arcane.buildRouterConfig(),
            scaffoldMessengerKey: widget.scaffoldMessengerKey,
            builder: widget.builder,
            title: widget.title,
            onGenerateTitle: widget.onGenerateTitle,
            color: widget.color,
            locale: widget.locale,
            localizationsDelegates: widget.localizationsDelegates,
            localeListResolutionCallback: widget.localeListResolutionCallback,
            localeResolutionCallback: widget.localeResolutionCallback,
            supportedLocales: widget.supportedLocales,
            showPerformanceOverlay: widget.showPerformanceOverlay,
            checkerboardRasterCacheImages: widget.checkerboardRasterCacheImages,
            checkerboardOffscreenLayers: widget.checkerboardOffscreenLayers,
            showSemanticsDebugger: widget.showSemanticsDebugger,
            debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
            shortcuts: widget.shortcuts,
            scrollBehavior: widget.scrollBehavior,
            highContrastTheme: widget.highContrastTheme,
            highContrastDarkTheme: widget.highContrastDarkTheme,
            actions: widget.actions,
            debugShowMaterialGrid: widget.debugShowMaterialGrid,
            useInheritedMediaQuery: widget.useInheritedMediaQuery,
            theme: light,
            darkTheme: dark,
            themeMode: mode,
          ));
}

Widget _passthroughBuilder(BuildContext context, Widget child) => child;

typedef ThemeMod = ThemeData Function(ThemeData theme);

class OpalWrapper extends StatefulWidget {
  final Widget Function(BuildContext context, ThemeData lightTheme,
      ThemeData darkTheme, ThemeMode themeMode) builder;
  final TextDirection directionality;
  final Widget Function(BuildContext context, Widget child) backgroundBuilder;
  final Widget Function(BuildContext context, Widget child) foregroundBuilder;
  final Widget? background;
  final List<ThemeMod> themeMods;
  final List<ThemeMod> darkThemeMods;
  final List<ThemeMod> lightThemeMods;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;
  final ThemeMode themeMode;

  static OpalWrapperState of(BuildContext context) =>
      context.findAncestorStateOfType<OpalWrapperState>()!;

  const OpalWrapper(
      {super.key,
      required this.builder,
      this.themeMods = const [],
      this.lightThemeMods = const [],
      this.darkThemeMods = const [],
      this.lightTheme,
      this.darkTheme,
      this.themeMode = ThemeMode.system,
      this.directionality = TextDirection.ltr,
      this.backgroundBuilder = _passthroughBuilder,
      this.foregroundBuilder = _passthroughBuilder,
      this.background});

  @override
  State<OpalWrapper> createState() => OpalWrapperState();
}

class OpalWrapperState extends State<OpalWrapper> {
  late Opal controller;
  late BehaviorSubject<Opal> _controllerStream;

  @override
  void initState() {
    controller = Opal(
      lightThemeData: widget.lightTheme ?? ThemeData.light(),
      darkThemeData: widget.darkTheme ?? ThemeData.dark(),
      themeMode: widget.themeMode,
      themeMods: widget.themeMods,
      darkThemeMods: widget.darkThemeMods,
      lightThemeMods: widget.lightThemeMods,
      listener: () => _controllerStream.add(controller),
    );
    _controllerStream = BehaviorSubject.seeded(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      _controllerStream.build((controller) => Directionality(
          textDirection: widget.directionality,
          child: Theme(
              data: controller.theme,
              child: widget.backgroundBuilder(
                  context,
                  Stack(
                    fit: StackFit.expand,
                    children: [
                      if (widget.background != null) widget.background!,
                      widget.foregroundBuilder(
                          context,
                          widget.builder(context, controller.light,
                              controller.dark, controller.themeMode.value)),
                    ],
                  )))));
}

class Opal {
  late ValueNotifier<ThemeData> lightThemeData;
  late ValueNotifier<ThemeData> darkThemeData;
  late ValueNotifier<ThemeMode> themeMode;
  late ValueNotifier<List<ThemeMod>> themeMods;
  late ValueNotifier<List<ThemeMod>> darkThemeMods;
  late ValueNotifier<List<ThemeMod>> lightThemeMods;
  late ValueNotifier<double> backgroundOpacity;
  late ValueNotifier<double> themeColorMixture;
  late BehaviorSubject<String> _backgroundSeed;

  Opal({
    required ThemeData lightThemeData,
    required ThemeData darkThemeData,
    required ThemeMode themeMode,
    List<ThemeMod> darkThemeMods = const [],
    List<ThemeMod> lightThemeMods = const [],
    double themeColorMixture = 0.25,
    double backgroundOpacity = 0.85,
    List<ThemeMod> themeMods = const [],
    required VoidCallback listener,
  }) {
    this.darkThemeMods = ValueNotifier(darkThemeMods)..addListener(listener);
    this.lightThemeMods = ValueNotifier(lightThemeMods)..addListener(listener);
    this.lightThemeData = ValueNotifier(lightThemeData)..addListener(listener);
    this.darkThemeData = ValueNotifier(darkThemeData)..addListener(listener);
    this.themeMode = ValueNotifier(themeMode)..addListener(listener);
    this.themeMods = ValueNotifier(themeMods)..addListener(listener);
    this.themeColorMixture = ValueNotifier(themeColorMixture)
      ..addListener(listener);
    this.backgroundOpacity = ValueNotifier(backgroundOpacity)
      ..addListener(listener);
    _backgroundSeed = BehaviorSubject.seeded("/");
  }

  static Opal of(BuildContext context) => OpalWrapper.of(context).controller;

  void setBackgroundSeed(String seed) => _backgroundSeed.add(seed);

  Stream<String> get backgroundSeedStream => _backgroundSeed.stream;

  ThemeData modifyTheme(ThemeData theme, {List<ThemeMod>? overrideMods}) {
    ThemeData t = theme;

    for (final mod in overrideMods ?? themeMods.value) {
      t = mod(t);
    }

    return t;
  }

  ThemeData get light => modifyTheme(modifyTheme(lightThemeData.value),
      overrideMods: lightThemeMods.value);

  ThemeData get dark => modifyTheme(modifyTheme(darkThemeData.value),
      overrideMods: darkThemeMods.value);

  ThemeData get theme => isDark() ? dark : light;

  bool isDark() =>
      themeMode.value == ThemeMode.dark ||
      (themeMode.value == ThemeMode.system && isPlatformDark());

  bool isPlatformDark() =>
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark;
}

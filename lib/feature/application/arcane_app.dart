import 'package:arcane/arcane.dart';
import 'package:arcane/feature/service/bloc_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget _passthroughBuilder(BuildContext context, Widget child) => child;

class ArcaneApp extends StatefulWidget {
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
  final Widget Function(BuildContext context, Widget child)? foregroundBuilder;
  final Widget? background;
  final Widget? titleBar;

  const ArcaneApp(
      {super.key,
      this.titleBar,
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
      this.foregroundBuilder,
      this.background});

  @override
  State<ArcaneApp> createState() => _ArcaneAppState();
}

class _ArcaneAppState extends State<ArcaneApp> {
  late GoRouter router;

  @override
  void initState() {
    Arcane.app.updateTempContext(context);
    router = Arcane.buildRouterConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => OpalWrapper(
      background: widget.background,
      backgroundBuilder: widget.backgroundBuilder,
      foregroundBuilder: widget.foregroundBuilder ??
          (context, child) => Arcane.isWindowManaged
              ? Directionality(
                  textDirection: widget.directionality,
                  child: Column(
                    children: [
                      (widget.titleBar ??
                          ArcaneTitleBar(
                            leading: SvgPicture.string(
                              Arcane.app.svgLogo,
                              width: 28,
                              height: 28,
                            ),
                            title: Text(Arcane.app.title),
                          )),
                      Flexible(child: child)
                    ],
                  ))
              : child,
      directionality: widget.directionality,
      themeMode: Arcane.themeMode,
      darkTheme: Arcane.app.initialDarkTheme,
      lightTheme: Arcane.app.initialLightTheme,
      themeMods: Arcane.app.themeMods,
      darkThemeMods: Arcane.app.darkThemeMods,
      lightThemeMods: Arcane.app.lightThemeMods,
      builder: (context, light, dark, mode) => MultiBlocProvider(
          providers: svc<BlocService>().onRegisterProviders().toList(),
          child: MaterialApp.router(
            routerConfig: router,
            scaffoldMessengerKey: widget.scaffoldMessengerKey,
            builder: widget.builder,
            title: Arcane.app.title,
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
          )));
}

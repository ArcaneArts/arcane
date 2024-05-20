import 'package:arcane/arcane.dart';
import 'package:flutter/scheduler.dart';

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

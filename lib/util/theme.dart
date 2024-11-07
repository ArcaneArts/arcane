import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:flutter/cupertino.dart' as c;
import 'package:flutter/material.dart' as m;

class ContrastedColorScheme {
  final ColorScheme light;
  final ColorScheme dark;

  const ContrastedColorScheme({required this.light, required this.dark});

  static ContrastedColorScheme fromScheme(
          ColorScheme Function(ThemeMode mode) func) =>
      ContrastedColorScheme(
        light: func(ThemeMode.light),
        dark: func(ThemeMode.dark),
      );

  ColorScheme scheme(Brightness brightness) =>
      brightness == Brightness.light ? light : dark;
}

extension XWidgetEffect on Widget {
  Widget get blurIn => animate()
      .fadeIn(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutExpo,
      )
      .blurXY(
        begin: 36,
        end: 0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCirc,
      );
}

extension _XTB on Brightness {
  ThemeMode get themeMode => switch (this) {
        Brightness.light => ThemeMode.light,
        Brightness.dark => ThemeMode.dark,
      };
}

extension XThemeModeToBrightness on ThemeMode {
  Brightness get brightness => switch (this) {
        ThemeMode.light => Brightness.light,
        ThemeMode.dark => Brightness.dark,
        ThemeMode.system =>
          WidgetsBinding.instance.platformDispatcher.platformBrightness,
      };
}

class ArcaneTheme extends AbstractArcaneTheme {
  final double radius;
  final ContrastedColorScheme? scheme;
  final double surfaceOpacity;
  final double surfaceBlur;

  const ArcaneTheme({
    this.scheme,
    this.radius = 0.4,
    this.surfaceOpacity = 0.66,
    this.surfaceBlur = 18,
    super.themeMode = ThemeMode.system,
  });

  @override
  ThemeData buildTheme(Brightness brightness) => ThemeData(
        colorScheme: (scheme ??
                ContrastedColorScheme(
                    light: ColorSchemes.lightZinc(),
                    dark: ColorSchemes.darkZinc()))
            .scheme(brightness),
        radius: radius,
        surfaceOpacity: surfaceOpacity,
        surfaceBlur: surfaceBlur,
      );

  @override
  m.ThemeData buildMaterialTheme(Brightness brightness) =>
      (brightness == Brightness.dark
          ? m.ThemeData.dark()
          : m.ThemeData.light());

  @override
  c.CupertinoThemeData buildCupertinoTheme(Brightness brightness) =>
      c.CupertinoThemeData(brightness: brightness);
}

abstract class AbstractArcaneTheme {
  static final AbstractArcaneTheme defaultArcaneTheme =
      ArcaneTheme(scheme: ContrastedColorScheme.fromScheme(ColorSchemes.zinc));

  final ThemeMode themeMode;

  const AbstractArcaneTheme({this.themeMode = ThemeMode.system});

  m.MaterialScrollBehavior get scrollBehavior => const ArcaneScrollBehavior();

  ThemeData buildTheme(Brightness brightness);

  m.ThemeData buildMaterialTheme(Brightness brightness);

  c.CupertinoThemeData buildCupertinoTheme(Brightness brightness);

  m.ThemeData colorMaterialTheme(ThemeData arcane, m.ThemeData theme) =>
      theme.copyWith(
          colorScheme: theme.colorScheme
              .copyWith(surface: arcane.colorScheme.background),
          pageTransitionsTheme: m.PageTransitionsTheme(builders: {
            ...Map.fromEntries(
              m.TargetPlatform.values.map((e) => MapEntry(
                  e,
                  const m.ZoomPageTransitionsBuilder(
                      allowSnapshotting: true,
                      allowEnterRouteSnapshotting: true))),
            ),
            // TargetPlatform.iOS: const m.CupertinoPageTransitionsBuilder(),
          }));

  ThemeData getArcaneTheme() => buildTheme(themeMode.brightness);

  m.ThemeData getMaterialTheme() => colorMaterialTheme(
      getArcaneTheme(), buildMaterialTheme(themeMode.brightness));

  c.CupertinoThemeData getCupertinoTheme() =>
      buildCupertinoTheme(themeMode.brightness);
}

import 'dart:convert';
import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart' as c;
import 'package:flutter/material.dart' as m;
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:tinycolor2/tinycolor2.dart';

class ArcaneTheme {
  final double radius;
  final ArcaneShimmerTheme shimmer;
  final ContrastedColorScheme? scheme;
  final ScrollPhysics physics;
  final double surfaceOpacity;
  final double surfaceBlur;
  final double scaling;
  final double contrast;
  final double spin;
  final ArcaneBlurMode blurMode;
  final ArcaneLiquidGlass liquidGlass;
  final double defaultHeaderHeight;
  final ChatTheme chat;
  final ToastTheme toast;
  final GutterTheme gutter;
  final EdgeTheme edge;
  final CardCarouselTheme cardCarousel;
  final NavigationTheme navigationScreen;
  final ArcaneHaptics haptics;
  final m.MaterialScrollBehavior scrollBehavior;
  final ThemeMode themeMode;
  final m.ThemeData Function(ArcaneTheme theme, Brightness brightness)
      materialThemeBuilder;
  final c.CupertinoThemeData Function(ArcaneTheme theme, Brightness brightness)
      cupertinoThemeBuilder;
  final ThemeData Function(ArcaneTheme theme, Brightness brightness)
      shadThemeBuilder;

  const ArcaneTheme({
    this.liquidGlass = const ArcaneLiquidGlass(),
    this.physics = const BouncingScrollPhysics(),
    this.shimmer = const ArcaneShimmerTheme(),
    this.blurMode = ArcaneBlurMode.liquidGlass,
    this.edge = const EdgeTheme(),
    this.haptics = const ArcaneHaptics(),
    this.defaultHeaderHeight = 0,
    this.toast = const ToastTheme(),
    this.cardCarousel = const CardCarouselTheme(),
    this.navigationScreen = const NavigationTheme(),
    this.scrollBehavior = const ArcaneScrollBehavior(),
    this.chat = const ChatTheme(),
    this.gutter = const GutterTheme(),
    this.materialThemeBuilder = _defaultMaterialThemeBuilder,
    this.cupertinoThemeBuilder = _defaultCupertinoThemeBuilder,
    this.shadThemeBuilder = _defaultShadThemeBuilder,
    this.scheme,
    this.contrast = 0.0,
    this.spin = 0.0,
    this.scaling = 1.0,
    this.radius = 0.4,
    this.surfaceOpacity = 0.6,
    this.surfaceBlur = 8,
    this.themeMode = ThemeMode.system,
  });

  ArcaneTheme copyWith({
    double? radius,
    double? defaultHeaderHeight,
    ContrastedColorScheme? scheme,
    double? surfaceOpacity,
    double? surfaceBlur,
    double? scaling,
    double? contrast,
    double? spin,
    ChatTheme? chat,
    EdgeTheme? edge,
    ToastTheme? toast,
    CardCarouselTheme? cardCarousel,
    GutterTheme? gutter,
    NavigationTheme? navigationScreen,
    m.MaterialScrollBehavior? scrollBehavior,
    ThemeMode? themeMode,
    m.ThemeData Function(ArcaneTheme theme, Brightness brightness)?
        materialThemeBuilder,
    c.CupertinoThemeData Function(ArcaneTheme theme, Brightness brightness)?
        cupertinoThemeBuilder,
    ThemeData Function(ArcaneTheme theme, Brightness brightness)?
        shadThemeBuilder,
  }) =>
      ArcaneTheme(
        edge: edge ?? this.edge,
        toast: toast ?? this.toast,
        defaultHeaderHeight: defaultHeaderHeight ?? this.defaultHeaderHeight,
        cardCarousel: cardCarousel ?? this.cardCarousel,
        navigationScreen: navigationScreen ?? this.navigationScreen,
        radius: radius ?? this.radius,
        scheme: scheme ?? this.scheme,
        surfaceOpacity: surfaceOpacity ?? this.surfaceOpacity,
        surfaceBlur: surfaceBlur ?? this.surfaceBlur,
        scaling: scaling ?? this.scaling,
        contrast: contrast ?? this.contrast,
        spin: spin ?? this.spin,
        chat: chat ?? this.chat,
        gutter: gutter ?? this.gutter,
        scrollBehavior: scrollBehavior ?? this.scrollBehavior,
        themeMode: themeMode ?? this.themeMode,
        materialThemeBuilder: materialThemeBuilder ?? this.materialThemeBuilder,
        cupertinoThemeBuilder:
            cupertinoThemeBuilder ?? this.cupertinoThemeBuilder,
        shadThemeBuilder: shadThemeBuilder ?? this.shadThemeBuilder,
      );

  static ArcaneTheme of(BuildContext context) => Arcane.themeOf(context);

  ThemeData get shadThemeData => shadThemeBuilder(this, themeMode.brightness);

  m.ThemeData get materialThemeData =>
      materialThemeBuilder(this, themeMode.brightness);

  c.CupertinoThemeData get cupertinoThemeData =>
      cupertinoThemeBuilder(this, themeMode.brightness);
}

class ArcaneLiquidGlass {
  /// The shape of this glass.
  ///
  /// This is the shape of the glass that will be rendered.
  final LiquidShape? shape;

  /// Whether this glass should be rendered "inside" of the glass, or on top.
  ///
  /// If it is rendered inside, it will be on top of [blur], but the color tint
  /// of the glass will affect the child, and it will also be refracted.
  final bool glassContainsChild;

  /// The clip behavior of this glass.
  ///
  /// Defaults to [Clip.none], so [child] will not be clipped.
  final Clip clipBehavior;

  final LiquidGlassSettings? settings;

  const ArcaneLiquidGlass({
    this.shape,
    this.glassContainsChild = false,
    this.clipBehavior = Clip.hardEdge,
    this.settings = const LiquidGlassSettings(
      glassColor: Color.fromARGB(0, 0, 0, 0),
      thickness: 20,
      saturation: 1,
      lightness: 1,
      refractiveIndex: 1.61,
      chromaticAberration: 0,
      blend: 20,
      blur: 8,
      lightAngle: 0,
      lightIntensity: 0,
      ambientStrength: 0,
    ),
  });
}

class ArcaneHaptics {
  final bool enabled;
  final HapticsType? viewChangeType;
  final HapticsType? actionType;
  final HapticsType? selectType;
  final HapticsType? buttonType;

  const ArcaneHaptics({
    this.enabled = true,
    this.viewChangeType = HapticsType.medium,
    this.actionType = HapticsType.heavy,
    this.selectType = HapticsType.light,
    this.buttonType = HapticsType.medium,
  });
}

m.ThemeData _defaultMaterialThemeBuilder(
    ArcaneTheme theme, Brightness brightness) {
  m.ThemeData mat = (brightness == Brightness.dark
      ? m.ThemeData.dark()
      : m.ThemeData.light());
  return mat.copyWith(
      colorScheme: mat.colorScheme.copyWith(
          surface:
              theme.shadThemeBuilder(theme, brightness).colorScheme.background),
      pageTransitionsTheme: m.PageTransitionsTheme(builders: {
        ...Map.fromEntries(
          m.TargetPlatform.values.map(
              (e) => MapEntry(e, const m.FadeForwardsPageTransitionsBuilder())),
        ),
        // TargetPlatform.iOS: const m.CupertinoPageTransitionsBuilder(),
      }));
}

c.CupertinoThemeData _defaultCupertinoThemeBuilder(
        ArcaneTheme theme, Brightness brightness) =>
    c.CupertinoThemeData(brightness: brightness);

ThemeData _defaultShadThemeBuilder(ArcaneTheme theme, Brightness brightness) =>
    ThemeData(
      colorScheme: (theme.scheme ??
              ContrastedColorScheme(
                  light: ColorSchemes.lightZinc(),
                  dark: ColorSchemes.darkZinc()))
          .scheme(brightness)
          .spin(theme.spin)
          .contrast(theme.contrast),
      radius: theme.radius,
      scaling: theme.scaling,
      surfaceOpacity: theme.surfaceOpacity,
      surfaceBlur:
          theme.blurMode == ArcaneBlurMode.disabled ? 0 : theme.surfaceBlur,
    );

class ArcaneShimmerTheme {
  final Duration duration;
  final Color? baseColor;
  final Color? highlightColor;

  const ArcaneShimmerTheme({
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor,
    this.highlightColor,
  });
}

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

  ContrastedColorScheme spin(double degrees) => ContrastedColorScheme(
        light: light.spin(degrees),
        dark: dark.spin(degrees),
      );

  ContrastedColorScheme filterColors(
          Map<String, Color> Function(Map<String, Color>) filter) =>
      ContrastedColorScheme(
        light: light.filterColors(filter),
        dark: dark.filterColors(filter),
      );
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

class ArcaneThemeOverride extends StatelessWidget {
  final ArcaneTheme Function(ArcaneTheme theme) mutator;
  final PylonBuilder builder;

  const ArcaneThemeOverride(
      {super.key, required this.mutator, required this.builder});

  @override
  Widget build(BuildContext context) => Pylon<ArcaneTheme?>(
      builder: builder, value: mutator(Arcane.themeOf(context)));
}

Color randomColor(dynamic seed,
    {bool radiant = false, double? targetLuminance, int maxIter = 50}) {
  bool dark = Arcane.globalTheme.shadThemeData.brightness == Brightness.dark;

  Color color = RandomColor.getColorObject(Options(
      seed: seed == null
          ? null
          : sha256
              .convert(utf8.encode(seed.toString()))
              .bytes
              .fold(192844 ^ (seed?.hashCode ?? 485), (a, b) => (a ?? 0) ^ b),
      luminosity: dark ? Luminosity.dark : Luminosity.light));

  if (192844 ^ (seed?.hashCode ?? 485) % 2 == 0) {
    color = color.spin(90);
  }

  if (targetLuminance != null) {
    int g = 0;
    while ((color.computeLuminance() - targetLuminance).abs() > 0.05 &&
        g++ < maxIter) {
      if (color.computeLuminance() < targetLuminance) {
        color = color.lighten(1);
      } else {
        color = color.darken(1);
      }
    }

    return color;
  }

  if (dark && !radiant) {
    int g = 0;
    while (color.computeLuminance() > 0.08 && g++ < maxIter) {
      color = color.darken(1);
    }
  } else if (dark && radiant) {
    int g = 0;
    while (color.computeLuminance() < 0.15 && g++ < maxIter) {
      color = color.lighten(1);
    }
  }

  return color;
}

import 'dart:ui';

import 'package:arcane/arcane.dart';

class ArcaneColorSchemes {
  static ColorScheme lightOLED() {
    return ColorScheme(
      brightness: Brightness.light,
      background: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      foreground: const HSLColor.fromAHSL(1, 240.0, 0.1, 0.04).toColor(),
      card: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 240.0, 0.1, 0.04).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 240.0, 0.1, 0.04).toColor(),
      primary: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.09).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      secondary: const HSLColor.fromAHSL(1, 330.0, 0.80, 0.50).toColor(),
      secondaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      muted: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.95).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.35).toColor(),
      accent: const HSLColor.fromAHSL(1, 30.0, 0.90, 0.50).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.80, 0.50).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.80).toColor(),
      input: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.80).toColor(),
      ring: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.0).toColor(),
      chart1: const HSLColor.fromAHSL(1, 12.0, 0.76, 0.61).toColor(),
      chart2: const HSLColor.fromAHSL(1, 173.0, 0.58, 0.39).toColor(),
      chart3: const HSLColor.fromAHSL(1, 197.0, 0.37, 0.24).toColor(),
      chart4: const HSLColor.fromAHSL(1, 43.0, 0.74, 0.66).toColor(),
      chart5: const HSLColor.fromAHSL(1, 27.0, 0.87, 0.67).toColor(),
    );
  }

  static ColorScheme darkOLED() {
    return ColorScheme(
      brightness: Brightness.dark,
      background: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.0).toColor(),
      foreground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      card: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.0).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.0).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      primary: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.0).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      secondary: const HSLColor.fromAHSL(1, 330.0, 0.80, 0.40).toColor(),
      secondaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      muted: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.10).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.35).toColor(),
      accent: const HSLColor.fromAHSL(1, 30.0, 0.90, 0.40).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.80, 0.40).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.15).toColor(),
      input: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.15).toColor(),
      ring: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      chart1: const HSLColor.fromAHSL(1, 220.0, 0.7, 0.5).toColor(),
      chart2: const HSLColor.fromAHSL(1, 173.0, 0.58, 0.39).toColor(),
      chart3: const HSLColor.fromAHSL(1, 197.0, 0.37, 0.24).toColor(),
      chart4: const HSLColor.fromAHSL(1, 43.0, 0.74, 0.66).toColor(),
      chart5: const HSLColor.fromAHSL(1, 27.0, 0.87, 0.67).toColor(),
    );
  }

  static ColorScheme oled(ThemeMode mode) {
    return mode == ThemeMode.light ? lightOLED() : darkOLED();
  }
}

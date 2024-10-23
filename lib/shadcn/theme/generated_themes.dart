import 'dart:ui';

import 'package:arcane/arcane.dart';

class ContrastedColorScheme {
  final ColorScheme light;
  final ColorScheme dark;

  const ContrastedColorScheme({required this.light, required this.dark});

  ColorScheme scheme(Brightness brightness) =>
      brightness == Brightness.light ? light : dark;
}

class ColorSchemes {
  static ColorScheme lightZinc() {
    return ColorScheme(
      brightness: Brightness.light,
      background: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      foreground: const HSLColor.fromAHSL(1, 240.0, 0.1, 0.04).toColor(),
      card: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 240.0, 0.1, 0.04).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 240.0, 0.1, 0.04).toColor(),
      primary: const HSLColor.fromAHSL(1, 240.0, 0.06, 0.1).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      secondary: const HSLColor.fromAHSL(1, 240.0, 0.05, 0.85).toColor(),
      secondaryForeground:
          const HSLColor.fromAHSL(1, 240.0, 0.06, 0.1).toColor(),
      muted: const HSLColor.fromAHSL(1, 240.0, 0.05, 0.96).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 240.0, 0.04, 0.46).toColor(),
      accent: const HSLColor.fromAHSL(1, 240.0, 0.05, 0.96).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 240.0, 0.06, 0.1).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.84, 0.6).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 240.0, 0.06, 0.7).toColor(),
      input: const HSLColor.fromAHSL(1, 240.0, 0.06, 0.9).toColor(),
      ring: const HSLColor.fromAHSL(1, 240.0, 0.06, 0.1).toColor(),
      chart1: const HSLColor.fromAHSL(1, 12.0, 0.76, 0.61).toColor(),
      chart2: const HSLColor.fromAHSL(1, 173.0, 0.58, 0.39).toColor(),
      chart3: const HSLColor.fromAHSL(1, 197.0, 0.37, 0.24).toColor(),
      chart4: const HSLColor.fromAHSL(1, 43.0, 0.74, 0.66).toColor(),
      chart5: const HSLColor.fromAHSL(1, 27.0, 0.87, 0.67).toColor(),
    );
  }

  static ColorScheme darkZinc() {
    return ColorScheme(
      brightness: Brightness.dark,
      background: const HSLColor.fromAHSL(1, 240.0, 0.1, 0.04).toColor(),
      foreground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      card: const HSLColor.fromAHSL(1, 240.0, 0.1, 0.04).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      popover: const HSLColor.fromAHSL(1, 240.0, 0.1, 0.04).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      primary: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 240.0, 0.06, 0.1).toColor(),
      secondary: const HSLColor.fromAHSL(1, 240.0, 0.04, 0.16).toColor(),
      secondaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      muted: const HSLColor.fromAHSL(1, 240.0, 0.04, 0.16).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 240.0, 0.05, 0.65).toColor(),
      accent: const HSLColor.fromAHSL(1, 240.0, 0.04, 0.16).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.63, 0.31).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 240.0, 0.04, 0.16).toColor(),
      input: const HSLColor.fromAHSL(1, 240.0, 0.04, 0.16).toColor(),
      ring: const HSLColor.fromAHSL(1, 240.0, 0.05, 0.84).toColor(),
      chart1: const HSLColor.fromAHSL(1, 220.0, 0.7, 0.5).toColor(),
      chart2: const HSLColor.fromAHSL(1, 160.0, 0.6, 0.45).toColor(),
      chart3: const HSLColor.fromAHSL(1, 30.0, 0.8, 0.55).toColor(),
      chart4: const HSLColor.fromAHSL(1, 280.0, 0.65, 0.6).toColor(),
      chart5: const HSLColor.fromAHSL(1, 340.0, 0.75, 0.55).toColor(),
    );
  }

  static ContrastedColorScheme zinc() {
    return ContrastedColorScheme(
      light: lightZinc(),
      dark: darkZinc(),
    );
  }

  static ColorScheme lightSlate() {
    return ColorScheme(
      brightness: Brightness.light,
      background: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      foreground: const HSLColor.fromAHSL(1, 222.2, 0.84, 0.05).toColor(),
      card: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 222.2, 0.84, 0.05).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      popoverForeground:
          const HSLColor.fromAHSL(1, 222.2, 0.84, 0.05).toColor(),
      primary: const HSLColor.fromAHSL(1, 222.2, 0.47, 0.11).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 210.0, 0.4, 0.98).toColor(),
      secondary: const HSLColor.fromAHSL(1, 210.0, 0.4, 0.85).toColor(),
      secondaryForeground:
          const HSLColor.fromAHSL(1, 222.2, 0.47, 0.11).toColor(),
      muted: const HSLColor.fromAHSL(1, 210.0, 0.4, 0.96).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 215.4, 0.16, 0.47).toColor(),
      accent: const HSLColor.fromAHSL(1, 210.0, 0.4, 0.96).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 222.2, 0.47, 0.11).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.84, 0.6).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 210.0, 0.4, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 214.3, 0.32, 0.7).toColor(),
      input: const HSLColor.fromAHSL(1, 214.3, 0.32, 0.91).toColor(),
      ring: const HSLColor.fromAHSL(1, 222.2, 0.84, 0.05).toColor(),
      chart1: const HSLColor.fromAHSL(1, 12.0, 0.76, 0.61).toColor(),
      chart2: const HSLColor.fromAHSL(1, 173.0, 0.58, 0.39).toColor(),
      chart3: const HSLColor.fromAHSL(1, 197.0, 0.37, 0.24).toColor(),
      chart4: const HSLColor.fromAHSL(1, 43.0, 0.74, 0.66).toColor(),
      chart5: const HSLColor.fromAHSL(1, 27.0, 0.87, 0.67).toColor(),
    );
  }

  static ColorScheme darkSlate() {
    return ColorScheme(
      brightness: Brightness.dark,
      background: const HSLColor.fromAHSL(1, 222.2, 0.84, 0.05).toColor(),
      foreground: const HSLColor.fromAHSL(1, 210.0, 0.4, 0.98).toColor(),
      card: const HSLColor.fromAHSL(1, 222.2, 0.84, 0.05).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 210.0, 0.4, 0.98).toColor(),
      popover: const HSLColor.fromAHSL(1, 222.2, 0.84, 0.05).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 210.0, 0.4, 0.98).toColor(),
      primary: const HSLColor.fromAHSL(1, 210.0, 0.4, 0.98).toColor(),
      primaryForeground:
          const HSLColor.fromAHSL(1, 222.2, 0.47, 0.11).toColor(),
      secondary: const HSLColor.fromAHSL(1, 217.2, 0.33, 0.18).toColor(),
      secondaryForeground:
          const HSLColor.fromAHSL(1, 210.0, 0.4, 0.98).toColor(),
      muted: const HSLColor.fromAHSL(1, 217.2, 0.33, 0.18).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 215.0, 0.2, 0.65).toColor(),
      accent: const HSLColor.fromAHSL(1, 217.2, 0.33, 0.18).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 210.0, 0.4, 0.98).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.63, 0.31).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 210.0, 0.4, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 217.2, 0.33, 0.18).toColor(),
      input: const HSLColor.fromAHSL(1, 217.2, 0.33, 0.18).toColor(),
      ring: const HSLColor.fromAHSL(1, 212.7, 0.27, 0.84).toColor(),
      chart1: const HSLColor.fromAHSL(1, 220.0, 0.7, 0.5).toColor(),
      chart2: const HSLColor.fromAHSL(1, 160.0, 0.6, 0.45).toColor(),
      chart3: const HSLColor.fromAHSL(1, 30.0, 0.8, 0.55).toColor(),
      chart4: const HSLColor.fromAHSL(1, 280.0, 0.65, 0.6).toColor(),
      chart5: const HSLColor.fromAHSL(1, 340.0, 0.75, 0.55).toColor(),
    );
  }

  static ContrastedColorScheme slate() {
    return ContrastedColorScheme(
      light: lightSlate(),
      dark: darkSlate(),
    );
  }

  static ColorScheme lightStone() {
    return ColorScheme(
      brightness: Brightness.light,
      background: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      foreground: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      card: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      primary: const HSLColor.fromAHSL(1, 24.0, 0.1, 0.1).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      secondary: const HSLColor.fromAHSL(1, 60.0, 0.05, 0.85).toColor(),
      secondaryForeground: const HSLColor.fromAHSL(1, 24.0, 0.1, 0.1).toColor(),
      muted: const HSLColor.fromAHSL(1, 60.0, 0.05, 0.96).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 25.0, 0.05, 0.45).toColor(),
      accent: const HSLColor.fromAHSL(1, 60.0, 0.05, 0.96).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 24.0, 0.1, 0.1).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.84, 0.6).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 20.0, 0.06, 0.7).toColor(),
      input: const HSLColor.fromAHSL(1, 20.0, 0.06, 0.9).toColor(),
      ring: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      chart1: const HSLColor.fromAHSL(1, 12.0, 0.76, 0.61).toColor(),
      chart2: const HSLColor.fromAHSL(1, 173.0, 0.58, 0.39).toColor(),
      chart3: const HSLColor.fromAHSL(1, 197.0, 0.37, 0.24).toColor(),
      chart4: const HSLColor.fromAHSL(1, 43.0, 0.74, 0.66).toColor(),
      chart5: const HSLColor.fromAHSL(1, 27.0, 0.87, 0.67).toColor(),
    );
  }

  static ColorScheme darkStone() {
    return ColorScheme(
      brightness: Brightness.dark,
      background: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      foreground: const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      card: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      popover: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      primary: const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 24.0, 0.1, 0.1).toColor(),
      secondary: const HSLColor.fromAHSL(1, 12.0, 0.07, 0.15).toColor(),
      secondaryForeground:
          const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      muted: const HSLColor.fromAHSL(1, 12.0, 0.07, 0.15).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 24.0, 0.05, 0.64).toColor(),
      accent: const HSLColor.fromAHSL(1, 12.0, 0.07, 0.15).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.63, 0.31).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 12.0, 0.07, 0.15).toColor(),
      input: const HSLColor.fromAHSL(1, 12.0, 0.07, 0.15).toColor(),
      ring: const HSLColor.fromAHSL(1, 24.0, 0.06, 0.83).toColor(),
      chart1: const HSLColor.fromAHSL(1, 220.0, 0.7, 0.5).toColor(),
      chart2: const HSLColor.fromAHSL(1, 160.0, 0.6, 0.45).toColor(),
      chart3: const HSLColor.fromAHSL(1, 30.0, 0.8, 0.55).toColor(),
      chart4: const HSLColor.fromAHSL(1, 280.0, 0.65, 0.6).toColor(),
      chart5: const HSLColor.fromAHSL(1, 340.0, 0.75, 0.55).toColor(),
    );
  }

  static ContrastedColorScheme stone() {
    return ContrastedColorScheme(
      light: lightStone(),
      dark: darkStone(),
    );
  }

  static ColorScheme lightGray() {
    return ColorScheme(
      brightness: Brightness.light,
      background: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      foreground: const HSLColor.fromAHSL(1, 224.0, 0.71, 0.04).toColor(),
      card: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 224.0, 0.71, 0.04).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      popoverForeground:
          const HSLColor.fromAHSL(1, 224.0, 0.71, 0.04).toColor(),
      primary: const HSLColor.fromAHSL(1, 220.9, 0.39, 0.11).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 210.0, 0.2, 0.98).toColor(),
      secondary: const HSLColor.fromAHSL(1, 220.0, 0.14, 0.85).toColor(),
      secondaryForeground:
          const HSLColor.fromAHSL(1, 220.9, 0.39, 0.11).toColor(),
      muted: const HSLColor.fromAHSL(1, 220.0, 0.14, 0.96).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 220.0, 0.09, 0.46).toColor(),
      accent: const HSLColor.fromAHSL(1, 220.0, 0.14, 0.96).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 220.9, 0.39, 0.11).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.84, 0.6).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 210.0, 0.2, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 220.0, 0.13, 0.7).toColor(),
      input: const HSLColor.fromAHSL(1, 220.0, 0.13, 0.91).toColor(),
      ring: const HSLColor.fromAHSL(1, 224.0, 0.71, 0.04).toColor(),
      chart1: const HSLColor.fromAHSL(1, 12.0, 0.76, 0.61).toColor(),
      chart2: const HSLColor.fromAHSL(1, 173.0, 0.58, 0.39).toColor(),
      chart3: const HSLColor.fromAHSL(1, 197.0, 0.37, 0.24).toColor(),
      chart4: const HSLColor.fromAHSL(1, 43.0, 0.74, 0.66).toColor(),
      chart5: const HSLColor.fromAHSL(1, 27.0, 0.87, 0.67).toColor(),
    );
  }

  static ColorScheme darkGray() {
    return ColorScheme(
      brightness: Brightness.dark,
      background: const HSLColor.fromAHSL(1, 224.0, 0.71, 0.04).toColor(),
      foreground: const HSLColor.fromAHSL(1, 210.0, 0.2, 0.98).toColor(),
      card: const HSLColor.fromAHSL(1, 224.0, 0.71, 0.04).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 210.0, 0.2, 0.98).toColor(),
      popover: const HSLColor.fromAHSL(1, 224.0, 0.71, 0.04).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 210.0, 0.2, 0.98).toColor(),
      primary: const HSLColor.fromAHSL(1, 210.0, 0.2, 0.98).toColor(),
      primaryForeground:
          const HSLColor.fromAHSL(1, 220.9, 0.39, 0.11).toColor(),
      secondary: const HSLColor.fromAHSL(1, 215.0, 0.28, 0.17).toColor(),
      secondaryForeground:
          const HSLColor.fromAHSL(1, 210.0, 0.2, 0.98).toColor(),
      muted: const HSLColor.fromAHSL(1, 215.0, 0.28, 0.17).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 217.9, 0.11, 0.65).toColor(),
      accent: const HSLColor.fromAHSL(1, 215.0, 0.28, 0.17).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 210.0, 0.2, 0.98).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.63, 0.31).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 210.0, 0.2, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 215.0, 0.28, 0.17).toColor(),
      input: const HSLColor.fromAHSL(1, 215.0, 0.28, 0.17).toColor(),
      ring: const HSLColor.fromAHSL(1, 216.0, 0.12, 0.84).toColor(),
      chart1: const HSLColor.fromAHSL(1, 220.0, 0.7, 0.5).toColor(),
      chart2: const HSLColor.fromAHSL(1, 160.0, 0.6, 0.45).toColor(),
      chart3: const HSLColor.fromAHSL(1, 30.0, 0.8, 0.55).toColor(),
      chart4: const HSLColor.fromAHSL(1, 280.0, 0.65, 0.6).toColor(),
      chart5: const HSLColor.fromAHSL(1, 340.0, 0.75, 0.55).toColor(),
    );
  }

  static ContrastedColorScheme gray() {
    return ContrastedColorScheme(
      light: lightGray(),
      dark: darkGray(),
    );
  }

  static ColorScheme lightNeutral() {
    return ColorScheme(
      brightness: Brightness.light,
      background: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      foreground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.04).toColor(),
      card: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.04).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.04).toColor(),
      primary: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.09).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      secondary: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.85).toColor(),
      secondaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.09).toColor(),
      muted: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.96).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.45).toColor(),
      accent: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.96).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.09).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.84, 0.6).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.7).toColor(),
      input: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.9).toColor(),
      ring: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.04).toColor(),
      chart1: const HSLColor.fromAHSL(1, 12.0, 0.76, 0.61).toColor(),
      chart2: const HSLColor.fromAHSL(1, 173.0, 0.58, 0.39).toColor(),
      chart3: const HSLColor.fromAHSL(1, 197.0, 0.37, 0.24).toColor(),
      chart4: const HSLColor.fromAHSL(1, 43.0, 0.74, 0.66).toColor(),
      chart5: const HSLColor.fromAHSL(1, 27.0, 0.87, 0.67).toColor(),
    );
  }

  static ColorScheme darkNeutral() {
    return ColorScheme(
      brightness: Brightness.dark,
      background: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.04).toColor(),
      foreground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      card: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.04).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.04).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      primary: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.09).toColor(),
      secondary: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.15).toColor(),
      secondaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      muted: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.15).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.64).toColor(),
      accent: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.15).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.63, 0.31).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.15).toColor(),
      input: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.15).toColor(),
      ring: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.83).toColor(),
      chart1: const HSLColor.fromAHSL(1, 220.0, 0.7, 0.5).toColor(),
      chart2: const HSLColor.fromAHSL(1, 160.0, 0.6, 0.45).toColor(),
      chart3: const HSLColor.fromAHSL(1, 30.0, 0.8, 0.55).toColor(),
      chart4: const HSLColor.fromAHSL(1, 280.0, 0.65, 0.6).toColor(),
      chart5: const HSLColor.fromAHSL(1, 340.0, 0.75, 0.55).toColor(),
    );
  }

  static ContrastedColorScheme neutral() {
    return ContrastedColorScheme(
      light: lightNeutral(),
      dark: darkNeutral(),
    );
  }

  static ColorScheme lightRed() {
    return ColorScheme(
      brightness: Brightness.light,
      background: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      foreground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.04).toColor(),
      card: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.04).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.04).toColor(),
      primary: const HSLColor.fromAHSL(1, 0.0, 0.72, 0.51).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.86, 0.97).toColor(),
      secondary: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.85).toColor(),
      secondaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.09).toColor(),
      muted: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.96).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.45).toColor(),
      accent: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.96).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.09).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.84, 0.6).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.7).toColor(),
      input: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.9).toColor(),
      ring: const HSLColor.fromAHSL(1, 0.0, 0.72, 0.51).toColor(),
      chart1: const HSLColor.fromAHSL(1, 12.0, 0.76, 0.61).toColor(),
      chart2: const HSLColor.fromAHSL(1, 173.0, 0.58, 0.39).toColor(),
      chart3: const HSLColor.fromAHSL(1, 197.0, 0.37, 0.24).toColor(),
      chart4: const HSLColor.fromAHSL(1, 43.0, 0.74, 0.66).toColor(),
      chart5: const HSLColor.fromAHSL(1, 27.0, 0.87, 0.67).toColor(),
    );
  }

  static ColorScheme darkRed() {
    return ColorScheme(
      brightness: Brightness.dark,
      background: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.04).toColor(),
      foreground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      card: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.04).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.04).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      primary: const HSLColor.fromAHSL(1, 0.0, 0.72, 0.51).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.86, 0.97).toColor(),
      secondary: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.15).toColor(),
      secondaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      muted: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.15).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.64).toColor(),
      accent: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.15).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.63, 0.31).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.15).toColor(),
      input: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.15).toColor(),
      ring: const HSLColor.fromAHSL(1, 0.0, 0.72, 0.51).toColor(),
      chart1: const HSLColor.fromAHSL(1, 220.0, 0.7, 0.5).toColor(),
      chart2: const HSLColor.fromAHSL(1, 160.0, 0.6, 0.45).toColor(),
      chart3: const HSLColor.fromAHSL(1, 30.0, 0.8, 0.55).toColor(),
      chart4: const HSLColor.fromAHSL(1, 280.0, 0.65, 0.6).toColor(),
      chart5: const HSLColor.fromAHSL(1, 340.0, 0.75, 0.55).toColor(),
    );
  }

  static ContrastedColorScheme red() {
    return ContrastedColorScheme(
      light: lightRed(),
      dark: darkRed(),
    );
  }

  static ColorScheme lightRose() {
    return ColorScheme(
      brightness: Brightness.light,
      background: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      foreground: const HSLColor.fromAHSL(1, 240.0, 0.1, 0.04).toColor(),
      card: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 240.0, 0.1, 0.04).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 240.0, 0.1, 0.04).toColor(),
      primary: const HSLColor.fromAHSL(1, 346.8, 0.77, 0.5).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 355.7, 1.0, 0.97).toColor(),
      secondary: const HSLColor.fromAHSL(1, 240.0, 0.05, 0.85).toColor(),
      secondaryForeground:
          const HSLColor.fromAHSL(1, 240.0, 0.06, 0.1).toColor(),
      muted: const HSLColor.fromAHSL(1, 240.0, 0.05, 0.96).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 240.0, 0.04, 0.46).toColor(),
      accent: const HSLColor.fromAHSL(1, 240.0, 0.05, 0.96).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 240.0, 0.06, 0.1).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.84, 0.6).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 240.0, 0.06, 0.7).toColor(),
      input: const HSLColor.fromAHSL(1, 240.0, 0.06, 0.9).toColor(),
      ring: const HSLColor.fromAHSL(1, 346.8, 0.77, 0.5).toColor(),
      chart1: const HSLColor.fromAHSL(1, 12.0, 0.76, 0.61).toColor(),
      chart2: const HSLColor.fromAHSL(1, 173.0, 0.58, 0.39).toColor(),
      chart3: const HSLColor.fromAHSL(1, 197.0, 0.37, 0.24).toColor(),
      chart4: const HSLColor.fromAHSL(1, 43.0, 0.74, 0.66).toColor(),
      chart5: const HSLColor.fromAHSL(1, 27.0, 0.87, 0.67).toColor(),
    );
  }

  static ColorScheme darkRose() {
    return ColorScheme(
      brightness: Brightness.dark,
      background: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      foreground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.95).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.09).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.95).toColor(),
      card: const HSLColor.fromAHSL(1, 24.0, 0.1, 0.1).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.95).toColor(),
      primary: const HSLColor.fromAHSL(1, 346.8, 0.77, 0.5).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 355.7, 1.0, 0.97).toColor(),
      secondary: const HSLColor.fromAHSL(1, 240.0, 0.04, 0.16).toColor(),
      secondaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      muted: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.15).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 240.0, 0.05, 0.65).toColor(),
      accent: const HSLColor.fromAHSL(1, 12.0, 0.07, 0.15).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.63, 0.31).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 0.0, 0.86, 0.97).toColor(),
      border: const HSLColor.fromAHSL(1, 240.0, 0.04, 0.16).toColor(),
      input: const HSLColor.fromAHSL(1, 240.0, 0.04, 0.16).toColor(),
      ring: const HSLColor.fromAHSL(1, 346.8, 0.77, 0.5).toColor(),
      chart1: const HSLColor.fromAHSL(1, 220.0, 0.7, 0.5).toColor(),
      chart2: const HSLColor.fromAHSL(1, 160.0, 0.6, 0.45).toColor(),
      chart3: const HSLColor.fromAHSL(1, 30.0, 0.8, 0.55).toColor(),
      chart4: const HSLColor.fromAHSL(1, 280.0, 0.65, 0.6).toColor(),
      chart5: const HSLColor.fromAHSL(1, 340.0, 0.75, 0.55).toColor(),
    );
  }

  static ContrastedColorScheme rose() {
    return ContrastedColorScheme(
      light: lightRose(),
      dark: darkRose(),
    );
  }

  static ColorScheme lightOrange() {
    return ColorScheme(
      brightness: Brightness.light,
      background: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      foreground: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      card: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      primary: const HSLColor.fromAHSL(1, 24.6, 0.95, 0.53).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      secondary: const HSLColor.fromAHSL(1, 60.0, 0.05, 0.85).toColor(),
      secondaryForeground: const HSLColor.fromAHSL(1, 24.0, 0.1, 0.1).toColor(),
      muted: const HSLColor.fromAHSL(1, 60.0, 0.05, 0.96).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 25.0, 0.05, 0.45).toColor(),
      accent: const HSLColor.fromAHSL(1, 60.0, 0.05, 0.96).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 24.0, 0.1, 0.1).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.84, 0.6).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 20.0, 0.06, 0.7).toColor(),
      input: const HSLColor.fromAHSL(1, 20.0, 0.06, 0.9).toColor(),
      ring: const HSLColor.fromAHSL(1, 24.6, 0.95, 0.53).toColor(),
      chart1: const HSLColor.fromAHSL(1, 12.0, 0.76, 0.61).toColor(),
      chart2: const HSLColor.fromAHSL(1, 173.0, 0.58, 0.39).toColor(),
      chart3: const HSLColor.fromAHSL(1, 197.0, 0.37, 0.24).toColor(),
      chart4: const HSLColor.fromAHSL(1, 43.0, 0.74, 0.66).toColor(),
      chart5: const HSLColor.fromAHSL(1, 27.0, 0.87, 0.67).toColor(),
    );
  }

  static ColorScheme darkOrange() {
    return ColorScheme(
      brightness: Brightness.dark,
      background: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      foreground: const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      card: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      popover: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      primary: const HSLColor.fromAHSL(1, 20.5, 0.9, 0.48).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      secondary: const HSLColor.fromAHSL(1, 12.0, 0.07, 0.15).toColor(),
      secondaryForeground:
          const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      muted: const HSLColor.fromAHSL(1, 12.0, 0.07, 0.15).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 24.0, 0.05, 0.64).toColor(),
      accent: const HSLColor.fromAHSL(1, 12.0, 0.07, 0.15).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.72, 0.51).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 12.0, 0.07, 0.15).toColor(),
      input: const HSLColor.fromAHSL(1, 12.0, 0.07, 0.15).toColor(),
      ring: const HSLColor.fromAHSL(1, 20.5, 0.9, 0.48).toColor(),
      chart1: const HSLColor.fromAHSL(1, 220.0, 0.7, 0.5).toColor(),
      chart2: const HSLColor.fromAHSL(1, 160.0, 0.6, 0.45).toColor(),
      chart3: const HSLColor.fromAHSL(1, 30.0, 0.8, 0.55).toColor(),
      chart4: const HSLColor.fromAHSL(1, 280.0, 0.65, 0.6).toColor(),
      chart5: const HSLColor.fromAHSL(1, 340.0, 0.75, 0.55).toColor(),
    );
  }

  static ContrastedColorScheme orange() {
    return ContrastedColorScheme(
      light: lightOrange(),
      dark: darkOrange(),
    );
  }

  static ColorScheme lightGreen() {
    return ColorScheme(
      brightness: Brightness.light,
      background: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      foreground: const HSLColor.fromAHSL(1, 240.0, 0.1, 0.04).toColor(),
      card: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 240.0, 0.1, 0.04).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 240.0, 0.1, 0.04).toColor(),
      primary: const HSLColor.fromAHSL(1, 142.1, 0.76, 0.36).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 355.7, 1.0, 0.97).toColor(),
      secondary: const HSLColor.fromAHSL(1, 240.0, 0.05, 0.85).toColor(),
      secondaryForeground:
          const HSLColor.fromAHSL(1, 240.0, 0.06, 0.1).toColor(),
      muted: const HSLColor.fromAHSL(1, 240.0, 0.05, 0.96).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 240.0, 0.04, 0.46).toColor(),
      accent: const HSLColor.fromAHSL(1, 240.0, 0.05, 0.96).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 240.0, 0.06, 0.1).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.84, 0.6).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 240.0, 0.06, 0.7).toColor(),
      input: const HSLColor.fromAHSL(1, 240.0, 0.06, 0.9).toColor(),
      ring: const HSLColor.fromAHSL(1, 142.1, 0.76, 0.36).toColor(),
      chart1: const HSLColor.fromAHSL(1, 12.0, 0.76, 0.61).toColor(),
      chart2: const HSLColor.fromAHSL(1, 173.0, 0.58, 0.39).toColor(),
      chart3: const HSLColor.fromAHSL(1, 197.0, 0.37, 0.24).toColor(),
      chart4: const HSLColor.fromAHSL(1, 43.0, 0.74, 0.66).toColor(),
      chart5: const HSLColor.fromAHSL(1, 27.0, 0.87, 0.67).toColor(),
    );
  }

  static ColorScheme darkGreen() {
    return ColorScheme(
      brightness: Brightness.dark,
      background: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      foreground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.95).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.09).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.95).toColor(),
      card: const HSLColor.fromAHSL(1, 24.0, 0.1, 0.1).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.95).toColor(),
      primary: const HSLColor.fromAHSL(1, 142.1, 0.71, 0.45).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 144.9, 0.8, 0.1).toColor(),
      secondary: const HSLColor.fromAHSL(1, 240.0, 0.04, 0.16).toColor(),
      secondaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      muted: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.15).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 240.0, 0.05, 0.65).toColor(),
      accent: const HSLColor.fromAHSL(1, 12.0, 0.07, 0.15).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.98).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.63, 0.31).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 0.0, 0.86, 0.97).toColor(),
      border: const HSLColor.fromAHSL(1, 240.0, 0.04, 0.16).toColor(),
      input: const HSLColor.fromAHSL(1, 240.0, 0.04, 0.16).toColor(),
      ring: const HSLColor.fromAHSL(1, 142.4, 0.72, 0.29).toColor(),
      chart1: const HSLColor.fromAHSL(1, 220.0, 0.7, 0.5).toColor(),
      chart2: const HSLColor.fromAHSL(1, 160.0, 0.6, 0.45).toColor(),
      chart3: const HSLColor.fromAHSL(1, 30.0, 0.8, 0.55).toColor(),
      chart4: const HSLColor.fromAHSL(1, 280.0, 0.65, 0.6).toColor(),
      chart5: const HSLColor.fromAHSL(1, 340.0, 0.75, 0.55).toColor(),
    );
  }

  static ContrastedColorScheme green() {
    return ContrastedColorScheme(
      light: lightGreen(),
      dark: darkGreen(),
    );
  }

  static ColorScheme lightBlue() {
    return ColorScheme(
      brightness: Brightness.light,
      background: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      foreground: const HSLColor.fromAHSL(1, 222.2, 0.84, 0.05).toColor(),
      card: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 222.2, 0.84, 0.05).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      popoverForeground:
          const HSLColor.fromAHSL(1, 222.2, 0.84, 0.05).toColor(),
      primary: const HSLColor.fromAHSL(1, 221.2, 0.83, 0.53).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 210.0, 0.4, 0.98).toColor(),
      secondary: const HSLColor.fromAHSL(1, 210.0, 0.4, 0.85).toColor(),
      secondaryForeground:
          const HSLColor.fromAHSL(1, 222.2, 0.47, 0.11).toColor(),
      muted: const HSLColor.fromAHSL(1, 210.0, 0.4, 0.96).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 215.4, 0.16, 0.47).toColor(),
      accent: const HSLColor.fromAHSL(1, 210.0, 0.4, 0.96).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 222.2, 0.47, 0.11).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.84, 0.6).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 210.0, 0.4, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 214.3, 0.32, 0.7).toColor(),
      input: const HSLColor.fromAHSL(1, 214.3, 0.32, 0.91).toColor(),
      ring: const HSLColor.fromAHSL(1, 221.2, 0.83, 0.53).toColor(),
      chart1: const HSLColor.fromAHSL(1, 12.0, 0.76, 0.61).toColor(),
      chart2: const HSLColor.fromAHSL(1, 173.0, 0.58, 0.39).toColor(),
      chart3: const HSLColor.fromAHSL(1, 197.0, 0.37, 0.24).toColor(),
      chart4: const HSLColor.fromAHSL(1, 43.0, 0.74, 0.66).toColor(),
      chart5: const HSLColor.fromAHSL(1, 27.0, 0.87, 0.67).toColor(),
    );
  }

  static ColorScheme darkBlue() {
    return ColorScheme(
      brightness: Brightness.dark,
      background: const HSLColor.fromAHSL(1, 222.2, 0.84, 0.05).toColor(),
      foreground: const HSLColor.fromAHSL(1, 210.0, 0.4, 0.98).toColor(),
      card: const HSLColor.fromAHSL(1, 222.2, 0.84, 0.05).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 210.0, 0.4, 0.98).toColor(),
      popover: const HSLColor.fromAHSL(1, 222.2, 0.84, 0.05).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 210.0, 0.4, 0.98).toColor(),
      primary: const HSLColor.fromAHSL(1, 217.2, 0.91, 0.6).toColor(),
      primaryForeground:
          const HSLColor.fromAHSL(1, 222.2, 0.47, 0.11).toColor(),
      secondary: const HSLColor.fromAHSL(1, 217.2, 0.33, 0.18).toColor(),
      secondaryForeground:
          const HSLColor.fromAHSL(1, 210.0, 0.4, 0.98).toColor(),
      muted: const HSLColor.fromAHSL(1, 217.2, 0.33, 0.18).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 215.0, 0.2, 0.65).toColor(),
      accent: const HSLColor.fromAHSL(1, 217.2, 0.33, 0.18).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 210.0, 0.4, 0.98).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.63, 0.31).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 210.0, 0.4, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 217.2, 0.33, 0.18).toColor(),
      input: const HSLColor.fromAHSL(1, 217.2, 0.33, 0.18).toColor(),
      ring: const HSLColor.fromAHSL(1, 224.3, 0.76, 0.48).toColor(),
      chart1: const HSLColor.fromAHSL(1, 220.0, 0.7, 0.5).toColor(),
      chart2: const HSLColor.fromAHSL(1, 160.0, 0.6, 0.45).toColor(),
      chart3: const HSLColor.fromAHSL(1, 30.0, 0.8, 0.55).toColor(),
      chart4: const HSLColor.fromAHSL(1, 280.0, 0.65, 0.6).toColor(),
      chart5: const HSLColor.fromAHSL(1, 340.0, 0.75, 0.55).toColor(),
    );
  }

  static ContrastedColorScheme blue() {
    return ContrastedColorScheme(
      light: lightBlue(),
      dark: darkBlue(),
    );
  }

  static ColorScheme lightYellow() {
    return ColorScheme(
      brightness: Brightness.light,
      background: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      foreground: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      card: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      primary: const HSLColor.fromAHSL(1, 47.9, 0.96, 0.53).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 26.0, 0.83, 0.14).toColor(),
      secondary: const HSLColor.fromAHSL(1, 60.0, 0.05, 0.85).toColor(),
      secondaryForeground: const HSLColor.fromAHSL(1, 24.0, 0.1, 0.1).toColor(),
      muted: const HSLColor.fromAHSL(1, 60.0, 0.05, 0.96).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 25.0, 0.05, 0.45).toColor(),
      accent: const HSLColor.fromAHSL(1, 60.0, 0.05, 0.96).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 24.0, 0.1, 0.1).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.84, 0.6).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 20.0, 0.06, 0.7).toColor(),
      input: const HSLColor.fromAHSL(1, 20.0, 0.06, 0.9).toColor(),
      ring: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      chart1: const HSLColor.fromAHSL(1, 12.0, 0.76, 0.61).toColor(),
      chart2: const HSLColor.fromAHSL(1, 173.0, 0.58, 0.39).toColor(),
      chart3: const HSLColor.fromAHSL(1, 197.0, 0.37, 0.24).toColor(),
      chart4: const HSLColor.fromAHSL(1, 43.0, 0.74, 0.66).toColor(),
      chart5: const HSLColor.fromAHSL(1, 27.0, 0.87, 0.67).toColor(),
    );
  }

  static ColorScheme darkYellow() {
    return ColorScheme(
      brightness: Brightness.dark,
      background: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      foreground: const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      card: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      popover: const HSLColor.fromAHSL(1, 20.0, 0.14, 0.04).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      primary: const HSLColor.fromAHSL(1, 47.9, 0.96, 0.53).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 26.0, 0.83, 0.14).toColor(),
      secondary: const HSLColor.fromAHSL(1, 12.0, 0.07, 0.15).toColor(),
      secondaryForeground:
          const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      muted: const HSLColor.fromAHSL(1, 12.0, 0.07, 0.15).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 24.0, 0.05, 0.64).toColor(),
      accent: const HSLColor.fromAHSL(1, 12.0, 0.07, 0.15).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.63, 0.31).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 60.0, 0.09, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 12.0, 0.07, 0.15).toColor(),
      input: const HSLColor.fromAHSL(1, 12.0, 0.07, 0.15).toColor(),
      ring: const HSLColor.fromAHSL(1, 35.5, 0.92, 0.33).toColor(),
      chart1: const HSLColor.fromAHSL(1, 220.0, 0.7, 0.5).toColor(),
      chart2: const HSLColor.fromAHSL(1, 160.0, 0.6, 0.45).toColor(),
      chart3: const HSLColor.fromAHSL(1, 30.0, 0.8, 0.55).toColor(),
      chart4: const HSLColor.fromAHSL(1, 280.0, 0.65, 0.6).toColor(),
      chart5: const HSLColor.fromAHSL(1, 340.0, 0.75, 0.55).toColor(),
    );
  }

  static ContrastedColorScheme yellow() {
    return ContrastedColorScheme(
      light: lightYellow(),
      dark: darkYellow(),
    );
  }

  static ColorScheme lightViolet() {
    return ColorScheme(
      brightness: Brightness.light,
      background: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      foreground: const HSLColor.fromAHSL(1, 224.0, 0.71, 0.04).toColor(),
      card: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 224.0, 0.71, 0.04).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      popoverForeground:
          const HSLColor.fromAHSL(1, 224.0, 0.71, 0.04).toColor(),
      primary: const HSLColor.fromAHSL(1, 262.1, 0.83, 0.58).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 210.0, 0.2, 0.98).toColor(),
      secondary: const HSLColor.fromAHSL(1, 220.0, 0.14, 0.85).toColor(),
      secondaryForeground:
          const HSLColor.fromAHSL(1, 220.9, 0.39, 0.11).toColor(),
      muted: const HSLColor.fromAHSL(1, 220.0, 0.14, 0.96).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 220.0, 0.09, 0.46).toColor(),
      accent: const HSLColor.fromAHSL(1, 220.0, 0.14, 0.96).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 220.9, 0.39, 0.11).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.84, 0.6).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 210.0, 0.2, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 220.0, 0.13, 0.7).toColor(),
      input: const HSLColor.fromAHSL(1, 220.0, 0.13, 0.91).toColor(),
      ring: const HSLColor.fromAHSL(1, 262.1, 0.83, 0.58).toColor(),
      chart1: const HSLColor.fromAHSL(1, 12.0, 0.76, 0.61).toColor(),
      chart2: const HSLColor.fromAHSL(1, 173.0, 0.58, 0.39).toColor(),
      chart3: const HSLColor.fromAHSL(1, 197.0, 0.37, 0.24).toColor(),
      chart4: const HSLColor.fromAHSL(1, 43.0, 0.74, 0.66).toColor(),
      chart5: const HSLColor.fromAHSL(1, 27.0, 0.87, 0.67).toColor(),
    );
  }

  static ColorScheme darkViolet() {
    return ColorScheme(
      brightness: Brightness.dark,
      background: const HSLColor.fromAHSL(1, 224.0, 0.71, 0.04).toColor(),
      foreground: const HSLColor.fromAHSL(1, 210.0, 0.2, 0.98).toColor(),
      card: const HSLColor.fromAHSL(1, 224.0, 0.71, 0.04).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 210.0, 0.2, 0.98).toColor(),
      popover: const HSLColor.fromAHSL(1, 224.0, 0.71, 0.04).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 210.0, 0.2, 0.98).toColor(),
      primary: const HSLColor.fromAHSL(1, 263.4, 0.7, 0.5).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 210.0, 0.2, 0.98).toColor(),
      secondary: const HSLColor.fromAHSL(1, 215.0, 0.28, 0.17).toColor(),
      secondaryForeground:
          const HSLColor.fromAHSL(1, 210.0, 0.2, 0.98).toColor(),
      muted: const HSLColor.fromAHSL(1, 215.0, 0.28, 0.17).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 217.9, 0.11, 0.65).toColor(),
      accent: const HSLColor.fromAHSL(1, 215.0, 0.28, 0.17).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 210.0, 0.2, 0.98).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.63, 0.31).toColor(),
      destructiveForeground:
          const HSLColor.fromAHSL(1, 210.0, 0.2, 0.98).toColor(),
      border: const HSLColor.fromAHSL(1, 215.0, 0.28, 0.17).toColor(),
      input: const HSLColor.fromAHSL(1, 215.0, 0.28, 0.17).toColor(),
      ring: const HSLColor.fromAHSL(1, 263.4, 0.7, 0.5).toColor(),
      chart1: const HSLColor.fromAHSL(1, 220.0, 0.7, 0.5).toColor(),
      chart2: const HSLColor.fromAHSL(1, 160.0, 0.6, 0.45).toColor(),
      chart3: const HSLColor.fromAHSL(1, 30.0, 0.8, 0.55).toColor(),
      chart4: const HSLColor.fromAHSL(1, 280.0, 0.65, 0.6).toColor(),
      chart5: const HSLColor.fromAHSL(1, 340.0, 0.75, 0.55).toColor(),
    );
  }

  static ContrastedColorScheme violet() {
    return ContrastedColorScheme(
      light: lightViolet(),
      dark: darkViolet(),
    );
  }

  static ColorScheme lightOLED() {
    return ColorScheme(
      brightness: Brightness.light,
      background: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      foreground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.0).toColor(),
      card: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.0).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.0).toColor(),
      primary: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.0).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      secondary: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.7).toColor(),
      secondaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      muted: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.9).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.4).toColor(),
      accent: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.9).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.0).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.84, 0.6).toColor(),
      destructiveForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      border: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.7).toColor(),
      input: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.9).toColor(),
      ring: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.0).toColor(),
      chart1: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.5).toColor(),
      chart2: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.6).toColor(),
      chart3: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.7).toColor(),
      chart4: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.8).toColor(),
      chart5: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.9).toColor(),
    );
  }

  static ColorScheme darkOLED() {
    return ColorScheme(
      brightness: Brightness.dark,
      background: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.0).toColor(),
      foreground: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      card: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.0).toColor(),
      cardForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      popover: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.0).toColor(),
      popoverForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      primary: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      primaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.0).toColor(),
      secondary: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.3).toColor(),
      secondaryForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      muted: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.2).toColor(),
      mutedForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.8).toColor(),
      accent: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.2).toColor(),
      accentForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      destructive: const HSLColor.fromAHSL(1, 0.0, 0.63, 0.31).toColor(),
      destructiveForeground: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      border: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.3).toColor(),
      input: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.2).toColor(),
      ring: const HSLColor.fromAHSL(1, 0.0, 0.0, 1.0).toColor(),
      chart1: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.5).toColor(),
      chart2: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.4).toColor(),
      chart3: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.3).toColor(),
      chart4: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.2).toColor(),
      chart5: const HSLColor.fromAHSL(1, 0.0, 0.0, 0.1).toColor(),
    );
  }

  static ContrastedColorScheme oled() {
    return ContrastedColorScheme(
      light: lightOLED(),
      dark: darkOLED(),
    );
  }
}

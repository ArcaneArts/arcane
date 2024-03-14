import 'package:arcane/api/theme_mod.dart';
import 'package:flutter/material.dart';

class TextThemeMod extends ThemeMod {
  @override
  ThemeData apply(ThemeData themeData) {
    themeData = themeData.copyWith(
        textTheme: themeData.textTheme.apply(
      fontFamily: 'Geist',
      package: 'arcane',
    ));

    return themeData;
  }
}

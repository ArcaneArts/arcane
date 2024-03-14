import 'package:arcane/api/theme_mod.dart';
import 'package:arcane/mods/card.dart';
import 'package:flutter/material.dart';

class GlobalThemeMod extends ThemeMod {
  List<ThemeMod> mods = [];

  void addDefaults() {
    mods.add(CardThemeMod());
  }

  @override
  ThemeData apply(ThemeData themeData) {
    for (var mod in mods) {
      themeData = mod.apply(themeData);
    }

    return themeData.copyWith(
        textTheme: themeData.textTheme.apply(
      fontFamily: 'Geist',
      package: 'arcane',
    ));
  }
}

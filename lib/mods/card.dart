import 'package:arcane/api/theme_mod.dart';
import 'package:flutter/material.dart';

class CardThemeMod extends ThemeMod {
  @override
  ThemeData apply(ThemeData themeData) {
    return themeData.copyWith(
      cardTheme: themeData.cardTheme.copyWith(
        elevation: 0,
        margin: EdgeInsets.all(10),
        color: themeData.colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: themeData.colorScheme.onSurface.withOpacity(0.5),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

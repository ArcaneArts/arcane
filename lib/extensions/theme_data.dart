import 'package:arcane/mods/global.dart';
import 'package:flutter/material.dart';

extension XThemeData on ThemeData {
  static final GlobalThemeMod _mod = GlobalThemeMod()..addDefaults();

  ThemeData arcane() => _mod.apply(this);
}

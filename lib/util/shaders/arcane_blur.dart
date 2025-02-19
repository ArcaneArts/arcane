import 'dart:async';
import 'dart:ui';

import 'package:arcane/util/shaders.dart';

const String _name = "arcane_blur";
Future<FragmentProgram> _loadShader() => ArcaneShader.loadShader(_name);

class ArcaneBlurShader extends ArcaneShader {
  const ArcaneBlurShader(
      {super.programProvider = _loadShader, super.name = _name});
}

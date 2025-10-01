import 'dart:async';
import 'dart:ui' as ui;

import 'package:arcane/arcane.dart';
import 'package:arcane/util/shaders.dart';
import 'package:fast_log/fast_log.dart';

BackdropKey globalBlurBackdropKey = BackdropKey();

Map<int, ui.ImageFilter> _filterCache = {};

class IceSurfaceEffect extends CompositeImageFilterSurfaceEffect {
  const IceSurfaceEffect()
      : super(const [
          BlurSurfaceEffect(radius: 5, tileMode: TileMode.mirror),
          IceShaderSurfaceEffect(spread: 2),
          BlurXYSurfaceEffect(
              radiusX: 3, radiusY: 0.2, tileMode: TileMode.mirror),
        ]);
}

class SparkleSurfaceEffect extends CompositeImageFilterSurfaceEffect {
  const SparkleSurfaceEffect()
      : super(const [
          BlurSurfaceEffect(radius: 1, tileMode: TileMode.mirror),
          IceShaderSurfaceEffect(spread: 2),
        ]);
}

abstract class ImageFilterSurfaceEffect extends SurfaceEffect {
  const ImageFilterSurfaceEffect();

  Future<ui.ImageFilter> get cachedFilter {
    int hash = identityHash;
    if (_filterCache.containsKey(hash)) {
      return Future.value(_filterCache[hash]);
    }

    return filter.then((f) {
      _filterCache[hash] = f;
      return f;
    });
  }

  Future<ui.ImageFilter> get filter;
}

class CompositeImageFilterSurfaceEffect extends ImageFilterSurfaceEffect {
  final List<ImageFilterSurfaceEffect> filters;

  const CompositeImageFilterSurfaceEffect(this.filters);

  @override
  Future<ui.ImageFilter> get filter async {
    if (this.filters.isEmpty) {
      throw Exception('No filters provided for composition.');
    }
    if (this.filters.length == 1) {
      return this.filters.first.filter;
    }

    List<ui.ImageFilter> filters =
        await Future.wait(this.filters.map((i) => i.filter));

    Future<ui.ImageFilter> composeRecursive(int index) async {
      if (index == filters.length - 1) {
        return filters[index];
      }

      ui.ImageFilter outer = await composeRecursive(index + 1);
      return ui.ImageFilter.compose(outer: outer, inner: filters[index]);
    }

    return composeRecursive(0);
  }

  @override
  bool get compatible => filters.every((f) => f.compatible);

  @override
  double get calcRadius =>
      filters.map((f) => f.calcRadius).sum() / filters.length;
}

class IceShaderSurfaceEffect extends ShaderSurfaceEffect {
  final double spread;

  const IceShaderSurfaceEffect({this.spread = 2}) : super("ice");

  @override
  ui.FragmentShader buildShader(ui.FragmentProgram program) =>
      program.fragmentShader()..setFloat(3, spread);

  @override
  double get calcRadius => spread;
}

class ShaderSurfaceEffect extends ImageFilterSurfaceEffect {
  final String program;

  const ShaderSurfaceEffect(this.program);

  ui.FragmentShader buildShader(ui.FragmentProgram program) =>
      program.fragmentShader();

  @override
  Future<ui.ImageFilter> get filter => ArcaneShader.loadShader(program)
      .then((i) => ui.ImageFilter.shader(buildShader(i)));

  @override
  bool get compatible => ui.ImageFilter.isShaderFilterSupported;

  @override
  double get calcRadius => 16;
}

class BlurSurfaceEffect extends BlurXYSurfaceEffect {
  const BlurSurfaceEffect({double radius = 16, super.tileMode})
      : super(radiusX: radius, radiusY: radius);
}

class BlurXYSurfaceEffect extends ImageFilterSurfaceEffect {
  final double radiusX;
  final double radiusY;
  final TileMode tileMode;

  const BlurXYSurfaceEffect(
      {this.radiusX = 16, this.radiusY = 16, this.tileMode = TileMode.mirror});

  @override
  Future<ui.ImageFilter> get filter => Future.value(ui.ImageFilter.blur(
      sigmaX: radiusX, sigmaY: radiusY, tileMode: tileMode));

  @override
  double get calcRadius => (radiusX + radiusY) / 2;

  @override
  bool get compatible => true;
}

class LiquidGlassSurfaceEffect extends SurfaceEffect {
  final LiquidGlassSettings settings;

  const LiquidGlassSurfaceEffect(
      {this.settings = const LiquidGlassSettings(
          blendPx: 5,
          distortExponent: 4,
          distortFalloffPx: 8,
          blurRadiusPx: 8,
          specStrength: 0,
          lightbandWidthPx: 0,
          refractStrength: -0.06,
          lightbandStrength: 0)});

  @override
  bool get compatible => ui.ImageFilter.isShaderFilterSupported;

  @override
  double get calcRadius => settings.blurRadiusPx;
}

class StaticSurfaceEffect extends SurfaceEffect {
  const StaticSurfaceEffect();

  @override
  double get calcRadius => 0;

  @override
  bool get compatible => true;
}

abstract class SurfaceEffect {
  const SurfaceEffect();

  bool get compatible;

  double get calcRadius;

  Widget buildCustom(BuildContext context, Widget child) => child;
}

bool kAllowBackdropGrouping = false;

class ArcaneBlur extends StatelessWidget {
  final SurfaceEffect? mode;
  final SurfaceEffect? backupMode;
  final Widget child;
  final BorderRadius? borderRadius;

  const ArcaneBlur({
    super.key,
    this.borderRadius,
    this.mode,
    this.backupMode,
    required this.child,
  });

  SurfaceEffect getEffect(BuildContext context) {
    ArcaneTheme theme = ArcaneTheme.of(context);
    SurfaceEffect s = mode ?? theme.surfaceEffect;

    if (!s.compatible) {
      s = backupMode ?? theme.backupSurfaceEffect;
    }

    if (!s.compatible) {
      throw Exception(
          "No compatible surface effect found. The backupSurfaceEffect is supposed to be compatible with anything!!!");
    }

    return s;
  }

  @override
  Widget build(BuildContext context) {
    try {
      SurfaceEffect effect = getEffect(context);

      if (effect is StaticSurfaceEffect) {
        return child;
      } else if (effect is ImageFilterSurfaceEffect) {
        BackdropKey? bdKey = kAllowBackdropGrouping
            ? BackdropGroup.of(context)?.backdropKey
            : null;

        return effect.cachedFilter.buildNullable((filter) {
          if (filter == null) {
            return child;
          }

          if (bdKey != null) {
            return BackdropFilter.grouped(
              filter: filter,
              child: child,
            );
          }

          return BackdropFilter(
            filter: filter,
            child: child,
          );
        });
      } else if (effect is LiquidGlassSurfaceEffect) {
        return LiquidGlassGroup(
            settings: effect.settings,
            child: LiquidGlass(
              enabled: true,
              borderRadius: borderRadius?.topLeft.x ?? 0,
              child: child,
            ));
      }

      return effect.buildCustom(context, child);
    } catch (e, es) {
      error("Surface Effect Error!");
      error(e);
      error(es);
      return child;
    }
  }
}

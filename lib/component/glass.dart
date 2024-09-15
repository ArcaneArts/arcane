import 'package:arcane/arcane.dart';
import 'package:pylon/pylon.dart';

enum AntiFlickerDirection {
  top,
  bottom,
  left,
  right,
}

extension XAntiFlickerDirection on AntiFlickerDirection {
  Alignment get alignmentDark {
    switch (this) {
      case AntiFlickerDirection.top:
        return Alignment.topCenter;
      case AntiFlickerDirection.bottom:
        return Alignment.bottomCenter;
      case AntiFlickerDirection.left:
        return Alignment.centerLeft;
      case AntiFlickerDirection.right:
        return Alignment.centerRight;
    }
  }

  AntiFlickerDirection get opposite => switch (this) {
        AntiFlickerDirection.top => AntiFlickerDirection.bottom,
        AntiFlickerDirection.bottom => AntiFlickerDirection.top,
        AntiFlickerDirection.left => AntiFlickerDirection.right,
        AntiFlickerDirection.right => AntiFlickerDirection.left,
      };

  Alignment get alignmentLight => opposite.alignmentDark;
}

class _GlassStop {
  final bool stopping;

  const _GlassStop(this.stopping);
}

class GlassStopper extends StatelessWidget {
  final Widget Function(BuildContext context) builder;
  final bool stopping;

  const GlassStopper({super.key, required this.builder, this.stopping = false});

  static bool isStopping(BuildContext context) =>
      context.pylonOr<_GlassStop>()?.stopping ?? true;

  @override
  Widget build(BuildContext context) =>
      Pylon<_GlassStop>(value: _GlassStop(stopping), builder: builder);
}

class Glass extends StatelessWidget {
  final Color? color;
  final double opacity;
  final Widget child;
  final double? blur;
  final BorderRadius borderRadius;
  final bool disabled;
  final Widget? under;
  final Color? tint;
  final Color? disabledColor;
  final bool ignoreContextSignals;

  const Glass(
      {super.key,
      this.ignoreContextSignals = false,
      this.disabledColor,
      this.under,
      this.tint,
      this.disabled = false,
      this.color,
      this.opacity = 0.5,
      this.blur,
      this.borderRadius = const BorderRadius.all(Radius.circular(0)),
      required this.child});

  @override
  Widget build(BuildContext context) {
    bool disabled = this.disabled ||
        (GlassStopper.isStopping(context) && !ignoreContextSignals);
    Widget b = disabled
        ? Container(
            color: disabledColor ?? Theme.of(context).colorScheme.background,
            child: child,
          )
        : BlurSurface(
            borderRadius: borderRadius,
            blur: blur ?? Theme.of(context).surfaceBlur ?? 16,
            child: child);

    if (under != null) {
      b = Stack(
        fit: StackFit.passthrough,
        children: [
          under!,
          b,
        ],
      );
    }

    b = Container(
      color: tint ?? Theme.of(context).colorScheme.background.withOpacity(0.15),
      child: b,
    );

    return disabled
        ? Container(
            color: disabledColor ?? Theme.of(context).colorScheme.background,
            child: child,
          )
        : ClipRRect(
            borderRadius: borderRadius,
            child: b,
          );
  }
}

class GlassAntiFlicker extends StatelessWidget {
  final AntiFlickerDirection direction;

  const GlassAntiFlicker({super.key, required this.direction});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: direction.alignmentDark,
                end: direction.alignmentLight,
                stops: const [
              0,
              0.1
            ],
                colors: [
              Theme.of(context).colorScheme.background,
              Colors.transparent,
            ])),
      );
}

class BlurSurface extends StatelessWidget {
  final double blur;
  final Widget child;
  final Widget? under;
  final BorderRadius? borderRadius;

  const BlurSurface(
      {super.key,
      required this.blur,
      required this.child,
      this.under,
      this.borderRadius});

  @override
  Widget build(BuildContext context) =>
      Stack(fit: StackFit.passthrough, children: [
        if (context.pylonOr<AntiFlickerDirection>() != null)
          Positioned.fill(
              child: GlassAntiFlicker(
            direction: context.pylon<AntiFlickerDirection>(),
          )),
        if (under != null) under!,
        Positioned.fill(
            child: ArcaneBlur(intensity: blur, child: const SizedBox())),
        Container(
          color: Theme.of(context).colorScheme.background.withOpacity(0.5),
          child: child,
        ),
      ]);
}

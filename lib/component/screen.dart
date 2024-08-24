import 'dart:math';
import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:sliver_tools/sliver_tools.dart';

class Glass extends StatelessWidget {
  final Color? color;
  final double opacity;
  final double roughness;
  final Widget child;
  final double blur;
  final double textureSize;
  final Alignment? antiFlickerStart;
  final Alignment? antiFlickerEnd;

  const Glass(
      {super.key,
      this.color,
      this.textureSize = 32,
      this.antiFlickerStart,
      this.antiFlickerEnd,
      this.opacity = 0.5,
      this.roughness = 2,
      this.blur = 8,
      required this.child});

  Glass.temperature({
    super.key,
    required this.child,
    this.color,
    this.antiFlickerStart,
    this.antiFlickerEnd,
    double temperature = 32,
  })  : textureSize = temperature.clamp(32, 1000).toDouble(),
        opacity = lerpDouble(0.233, 0.4, (temperature / 100).clamp(0, 1))!,
        roughness = lerpDouble(10, 0.5, (temperature / 100).clamp(0, 1))!,
        blur = (temperature / 4).clamp(8, 24);

  @override
  Widget build(BuildContext context) {
    Widget b = SurfaceBlur(
        borderRadius: BorderRadius.zero,
        surfaceBlur: blur,
        child: CustomPaint(
            painter: NoisePainter(
              temp: textureSize,
              minColor: color ??
                  Theme.of(context).colorScheme.background.withOpacity(opacity),
              maxColor: color ??
                  Theme.of(context).colorScheme.background.withOpacity(
                        min(0, opacity * roughness),
                      ),
            ),
            child: child));

    if (antiFlickerStart != null && antiFlickerEnd != null) {
      b = Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.background,
              const Color(0x00000000)
            ], stops: const [
              0.1,
              0.2
            ], begin: antiFlickerStart!, end: antiFlickerEnd!),
          ),
          child: b);
    }

    return b;
  }
}

class NoisePainter extends CustomPainter {
  Color minColor;
  Color maxColor;
  Paint? _paint;
  FragmentShader? sh;
  double temp;
  NoisePainter(
      {required this.minColor, required this.maxColor, this.temp = 32});

  @override
  void paint(Canvas canvas, Size size) {
    _paint ??= Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = false;
    sh ??= ArcaneApp.noiseShader?.fragmentShader();

    if (sh != null) {
      sh!.setFloat(0, size.width);
      sh!.setFloat(1, size.height);
      sh!.setFloat(2, 1); // uTime
      sh!.setFloat(3, minColor.alpha / 255);
      sh!.setFloat(4, minColor.red / 255);
      sh!.setFloat(5, minColor.green / 255);
      sh!.setFloat(6, minColor.blue / 255);
      sh!.setFloat(7, maxColor.alpha / 255);
      sh!.setFloat(8, maxColor.red / 255);
      sh!.setFloat(9, maxColor.green / 255);
      sh!.setFloat(10, maxColor.blue / 255);
      sh!.setFloat(11, temp);
      _paint!.shader = sh!;
      canvas.drawRect(Offset.zero & size, _paint!);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Screen extends StatelessWidget {
  final List<Widget> children;
  final List<Widget> slivers;
  final List<Widget> headers;
  final List<Widget> footers;
  final double? loadingProgress;
  final bool loadingProgressIndeterminate;
  final VoidCallback? onRefresh;
  final bool
      floatingHeader; // when header floats, it takes no space in the layout, and positioned on top of the content
  final bool floatingFooter;
  final Color? headerBackgroundColor;
  final Color? footerBackgroundColor;
  final bool showLoadingSparks;

  const Screen({
    super.key,
    this.slivers = const [],
    this.children = const [],
    this.headers = const [],
    this.footers = const [],
    this.loadingProgress,
    this.loadingProgressIndeterminate = false,
    this.onRefresh,
    this.floatingHeader = false,
    this.floatingFooter = false,
    this.headerBackgroundColor,
    this.footerBackgroundColor,
    this.showLoadingSparks = false,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        child: CustomScrollView(
          slivers: [
            ...headers.map((e) => SliverPinnedHeader(child: e)),
            ...slivers,
            if (children.length == 1)
              SliverFillRemaining(
                child: children.first,
              ),
            if (children.length > 1)
              SliverList(
                delegate: SliverChildListDelegate(children),
              ),
          ],
        ),
      );
}

class Bar extends StatelessWidget {
  final List<Widget> trailing;
  final List<Widget> leading;
  final Widget? child;
  final Widget? title;
  final Widget? header; // small widget placed on top of title
  final Widget? subtitle; // small widget placed below title
  final bool
      trailingExpanded; // expand the trailing instead of the main content
  final Alignment alignment;
  final Color? backgroundColor;
  final double? leadingGap;
  final double? trailingGap;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final bool useSafeArea;
  final double? surfaceBlur;
  final double? surfaceOpacity;

  const Bar(
      {super.key,
      this.trailing = const [],
      this.leading = const [],
      this.title,
      this.header,
      this.subtitle,
      this.child,
      this.trailingExpanded = false,
      this.alignment = Alignment.center,
      this.padding,
      this.backgroundColor,
      this.leadingGap,
      this.trailingGap,
      this.height,
      this.surfaceBlur = 16,
      this.surfaceOpacity = 0.3,
      this.useSafeArea = true});

  // ARGB
  // 1100
  // 1110

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Glass.temperature(
              antiFlickerStart: Alignment.topCenter,
              antiFlickerEnd: Alignment.bottomCenter,
              child: AppBar(
                leading: leading.isEmpty
                    ? [
                        if (Navigator.canPop(context))
                          GhostButton(
                            onPressed: () => Navigator.pop(context),
                            density: ButtonDensity.icon,
                            child: const Icon(BootstrapIcons.chevronLeft),
                          )
                      ]
                    : leading,
                trailing: trailing,
                title: title,
                header: header,
                subtitle: subtitle,
                trailingExpanded: trailingExpanded,
                alignment: alignment,
                padding: padding,
                backgroundColor: backgroundColor,
                leadingGap: leadingGap,
                trailingGap: trailingGap,
                height: height,
                surfaceBlur: null,
                surfaceOpacity: 0.1,
                useSafeArea: useSafeArea,
                child: child,
              ))
        ],
      );
}

import 'package:arcane/arcane.dart';
import 'package:common_svgs/common_svgs.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A component that displays the Arcane Arts logo.
///
/// [ArcaneArtsLogo] provides a simple way to display the Arcane Arts logo
/// as an SVG with customizable size and color. The logo maintains a square
/// aspect ratio, with both width and height set to the [size] parameter.
///
/// See also:
///  * [doc/component/logo.md] for more detailed documentation
class ArcaneArtsLogo extends StatelessWidget {
  /// The width and height of the logo.
  ///
  /// For best results, use sizes that are multiples of 8 (8, 16, 24, 32, etc.).
  /// The default size of 32 is appropriate for most UI contexts like headers
  /// and navigation areas.
  final double size;
  
  /// Optional color override for the logo.
  ///
  /// When provided, this color is applied to the entire logo using a
  /// [ColorFilter] with [BlendMode.srcIn]. If not specified, the logo
  /// will use its default colors.
  final Color? color;

  /// Creates an [ArcaneArtsLogo] widget.
  ///
  /// The [size] parameter defaults to 32, which is suitable for most UI contexts.
  /// The [color] parameter is optional and can be used to override the default colors.
  ///
  /// Example:
  /// ```dart
  /// ArcaneArtsLogo(
  ///   size: 48,
  ///   color: Colors.blue,
  /// )
  /// ```
  const ArcaneArtsLogo({super.key, this.size = 32, this.color});

  @override
  Widget build(BuildContext context) => SvgPicture(
        SvgStringLoader(svgArcaneArts),
        width: size,
        height: size,
        colorFilter:
            color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
      );
}

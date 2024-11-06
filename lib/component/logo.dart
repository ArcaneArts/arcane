import 'package:arcane/arcane.dart';
import 'package:common_svgs/common_svgs.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ArcaneArtsLogo extends StatelessWidget {
  final double size;
  final Color? color;

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

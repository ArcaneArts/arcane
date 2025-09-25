import 'package:arcane/arcane.dart';
import 'package:common_svgs/common_svgs.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A component that displays the Arcane Arts logo in the Arcane Flutter project.
///
/// The [ArcaneArtsLogo] is a lightweight, stateless widget for rendering the branded Arcane Arts logo as a scalable SVG. It integrates seamlessly into Arcane UI structures, such as:
/// - Placing within a [Section] for organized content blocks.
/// - Embedding in [FillScreen] or [SliverScreen] for full or scrollable layouts.
/// - Combining with [ArcaneTheme] for consistent color and styling application.
///
/// Key features:
/// - Maintains a perfect square aspect ratio based on the [size] parameter.
/// - Supports optional color tinting across the entire logo via [ColorFilter.mode] with [BlendMode.srcIn].
/// - Renders efficiently using vector graphics, avoiding pixelation at any scale.
///
/// Performance notes: As a [StatelessWidget], it avoids unnecessary rebuilds, making it ideal for static branding elements in performance-sensitive UIs like navigation bars or headers. The SVG loader ensures minimal memory footprint compared to raster images.
///
/// For detailed usage examples and customization, refer to the component documentation.
class ArcaneArtsLogo extends StatelessWidget {
  /// The width and height of the logo in logical pixels.
  ///
  /// Controls both dimensions to preserve the logo's square aspect ratio. For optimal rendering with Arcane's grid system, prefer sizes that are multiples of 8 (e.g., 16, 24, 32, 48). The default of 32 suits most contexts like [Section] headers or [BottomNavigationBar] icons, balancing visibility and space efficiency.
  final double size;

  /// Optional color override for tinting the entire logo.
  ///
  /// Applies a uniform color filter to the SVG paths using [BlendMode.srcIn], allowing theme-aware customization (e.g., matching [ArcaneTheme.primaryColor]). If omitted, the logo retains its original multi-color design, which integrates well with [Glass] or [GlowCard] backgrounds for visual depth.
  final Color? color;

  /// Creates an [ArcaneArtsLogo] instance with customizable dimensions and coloring.
  ///
  /// Initializes the widget with a default [size] of 32, suitable for standard UI elements. The [color] parameter enables quick theming without asset modifications. Supports const construction for compile-time optimization in lists or trees like [SliverScreen] contents.
  ///
  /// Usage example in an Arcane layout:
  /// ```dart
  /// Section(
  ///   child: Row(
  ///     children: [
  ///       ArcaneArtsLogo(size: 40, color: ArcaneTheme.of(context).primaryColor),
  ///       // Additional content...
  ///     ],
  ///   ),
  /// )
  /// ```
  /// This placement ensures the logo aligns properly within [Gutter]-spaced sections while respecting the theme.
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

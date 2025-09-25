import 'package:arcane/arcane.dart';

/// A styled icon widget that provides a visually enhanced [Icon] with a subtle background
/// container, designed for use within the Arcane UI system.
///
/// This component wraps a standard Flutter [Icon] in a [Container] with padding and a
/// semi-transparent background derived from the app's [ArcaneTheme]. It is ideal for
/// displaying icons in layouts like [Section], [ButtonPanel], or alongside [IconButton]
/// and [Fab] components, offering a consistent, polished appearance that aligns with
/// Arcane's design language. The background uses the foreground color with low opacity
/// for a frosted glass effect, ensuring readability on both light and dark themes.
///
/// Key features:
/// - Customizable icon size and color, falling back to theme defaults.
/// - Rounded border radius for modern aesthetics.
/// - Const constructor for performance in widget trees.
/// - Integrates seamlessly with [ArcaneTheme]'s color scheme for theming consistency.
///
/// Usage example:
/// ```dart
/// FancyIcon(
///   icon: Icons.star,
///   size: 24,
///   color: Colors.amber,
/// )
/// ```
class FancyIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;

  /// Creates a new [FancyIcon] instance.
  ///
  /// The [icon] parameter specifies the [IconData] to display, which is required.
  /// Optionally, provide [size] to override the default icon size or [color] to
  /// set a custom icon color. If [color] is null, it defaults to the foreground
  /// color from the current [ArcaneTheme]. The [key] is passed to the superclass
  /// for widget identification.
  ///
  /// This constructor is const-enabled, allowing efficient reuse in widget builds.
  const FancyIcon({super.key, required this.icon, this.size, this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.foreground.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon,
            size: size,
            color: color ??
                Theme.of(context)
                    .colorScheme
                    .foreground), // This is the White-ish color as you wanted on dark theme.
      );
}

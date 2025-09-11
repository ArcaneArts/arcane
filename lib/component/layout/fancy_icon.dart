import 'package:arcane/arcane.dart';

class FancyIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;

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

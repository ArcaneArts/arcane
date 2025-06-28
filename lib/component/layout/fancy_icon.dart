import 'package:arcane/arcane.dart';

class FancyIcon extends StatelessWidget {
  final IconData icon;
  final double? size;

  const FancyIcon({super.key, required this.icon, this.size});

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon,
            size: size,
            color: Theme.of(context)
                .colorScheme
                .accentForeground), // This is the White-ish color as you wanted on dark theme.
      );
}

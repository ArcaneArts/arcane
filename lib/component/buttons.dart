import 'package:arcane/arcane.dart';

class IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const IconButton({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) => GhostButton(
      onPressed: onPressed, density: ButtonDensity.icon, child: Icon(icon));
}

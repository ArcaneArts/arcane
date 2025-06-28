import 'package:arcane/arcane.dart';

class ButtonPanel extends StatelessWidget {
  /// Use [PanelButton]s
  final List<Widget> buttons;

  const ButtonPanel({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) => Wrap(
        children: [...buttons],
      );
}

class PanelButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const PanelButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      size: MediaQuery.of(context).size.width > 500
          ? ButtonSize.normal
          : ButtonSize.small,
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FancyIcon(icon: icon, size: 32),
          Gap(8),
          Text(label),
        ],
      ),
    );
  }
}

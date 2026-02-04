import 'package:arcane/arcane.dart';

class UnderlineTextButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback? onPressed;

  const UnderlineTextButton({
    super.key,
    required this.label,
    required this.color,
    this.onPressed,
  });

  @override
  State<UnderlineTextButton> createState() => _UnderlineTextButtonState();
}

class _UnderlineTextButtonState extends State<UnderlineTextButton> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => hovering = true),
    onExit: (_) => setState(() => hovering = false),
    child: TextButton(
      onPressed: widget.onPressed,
      child: Text(
        widget.label,
        style: TextStyle(
          color: widget.color,
          decoration: hovering ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    ),
  );
}

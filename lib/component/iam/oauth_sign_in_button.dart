import 'package:arcane/arcane.dart';

class OAuthSignInButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;
  final Widget? icon;

  const OAuthSignInButton(
      {super.key, this.onPressed, this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    Widget? le = icon;
    Widget ch;

    if (label != null) {
      ch = Text(label!);
    } else {
      ch = le ?? const SizedBox();
      le = null;
    }

    return OutlineButton(
      density: ButtonDensity.comfortable,
      onPressed: onPressed,
      leading: le,
      child: ch,
    );
  }
}

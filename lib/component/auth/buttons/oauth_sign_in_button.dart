import 'package:arcane/arcane.dart';

class CredentialSignInButton extends StatelessWidget {
  final String? label;
  final VoidCallback onPressed;
  final Widget? icon;

  const CredentialSignInButton(
      {super.key, required this.onPressed, this.icon, required this.label});

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
      density: ButtonDensity.normal,
      onPressed: onPressed,
      leading: le,
      child: ch,
    );
  }
}

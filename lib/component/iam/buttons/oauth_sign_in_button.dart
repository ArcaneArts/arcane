import 'package:arcane/arcane.dart';

class OAuthSignInButton extends StatelessWidget implements AbstractIAMButton {
  final String? label;
  @override
  final VoidCallback onPressed;
  final Widget? icon;

  const OAuthSignInButton(
      {super.key, required this.onPressed, this.icon, required this.label});

  @override
  OAuthSignInButton withOnPressed(VoidCallback onPressed) => OAuthSignInButton(
        key: key,
        icon: icon,
        label: label,
        onPressed: onPressed,
      );

  @override
  Widget buildContent(BuildContext context) => const Center(
        child: CircularProgressIndicator(
          size: 48,
        ),
      );

  @override
  bool get isAutorun => false;

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

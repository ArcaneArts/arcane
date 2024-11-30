/*
 * Copyright (c) 2024. Crucible Labs Inc.
 *
 * Crucible is a closed source project developed by Crucible Labs Inc.
 * Do not copy, share distribute or otherwise allow this source file
 * to leave hardware approved by Crucible Labs Inc. unless otherwise
 * approved by Crucible Labs Inc.
 */

import 'package:arcane/arcane.dart';

class _Credentials {
  final String email;
  final String password;

  const _Credentials({required this.email, required this.password});

  _Credentials copyWith({String? email, String? password}) => _Credentials(
        email: email ?? this.email,
        password: password ?? this.password,
      );
}

BehaviorSubject<_Credentials> _credentials =
    BehaviorSubject<_Credentials>.seeded(
        const _Credentials(email: "", password: ""));

class EmailPasswordSignIn extends StatelessWidget implements AbstractIAMButton {
  final Widget? icon;
  final String? label;
  @override
  final VoidCallback onPressed;

  const EmailPasswordSignIn(
      {super.key,
      this.icon = const Icon(Icons.mail_ionic, size: 18),
      this.label = "Sign in with Email",
      required this.onPressed});

  @override
  EmailPasswordSignIn withOnPressed(VoidCallback onPressed) =>
      EmailPasswordSignIn(
        key: key,
        icon: icon,
        label: label,
        onPressed: onPressed,
      );

  @override
  bool get isAutorun => false;

  @override
  Widget buildContent(BuildContext context) => const Center(
        child: EmailPasswordLoginBox(),
      );

  @override
  Widget build(BuildContext context) => OAuthSignInButton(
        label: label,
        icon: icon,
        onPressed: onPressed,
      );
}

class EmailPasswordLoginBox extends StatefulWidget {
  const EmailPasswordLoginBox({super.key});

  @override
  State<EmailPasswordLoginBox> createState() => _EmailPasswordLoginBoxState();
}

class _EmailPasswordLoginBoxState extends State<EmailPasswordLoginBox> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late FocusNode _emailFocus;
  late FocusNode _passwordFocus;

  @override
  void initState() {
    _emailController = TextEditingController(text: _credentials.value.email);
    _passwordController =
        TextEditingController(text: _credentials.value.password);
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _credentials.build((c) => Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              border: false,
              leading: Icon(Icons.mail_ionic),
              controller: _emailController,
              onChanged: (v) =>
                  _credentials.add(_credentials.value.copyWith(email: v)),
              onSubmitted: (v) {
                _credentials.add(_credentials.value.copyWith(email: v));
                _passwordFocus.requestFocus();
              },
              autofillHints: const [AutofillHints.email],
              focusNode: _emailFocus,
              placeholder: "email@domain.com",
            ),
            Gap(4),
            Divider(),
            Gap(4),
            TextField(
              border: false,
              leading: Icon(Icons.lock_fill),
              controller: _passwordController,
              onChanged: (v) =>
                  _credentials.add(_credentials.value.copyWith(password: v)),
              onSubmitted: (v) {
                _credentials.add(_credentials.value.copyWith(password: v));
                _passwordFocus.unfocus();
              },
              autofillHints: const [AutofillHints.password],
              focusNode: _passwordFocus,
              obscureText: true,
              placeholder: "Password",
            ),
            Gap(8),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlineButton(
                  enabled: _credentials.value.email.trim().isNotEmpty &&
                      _credentials.value.password.trim().isNotEmpty,
                  child: const Text("Sign In"),
                  onPressed: () {
                    _credentials.add(_credentials.value.copyWith(
                        email: _emailController.text,
                        password: _passwordController.text));
                  }),
            ).padLeft(8),
          ],
        ).iw,
      ));
}

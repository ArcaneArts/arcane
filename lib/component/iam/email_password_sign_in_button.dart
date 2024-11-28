/*
 * Copyright (c) 2024. Crucible Labs Inc.
 *
 * Crucible is a closed source project developed by Crucible Labs Inc.
 * Do not copy, share distribute or otherwise allow this source file
 * to leave hardware approved by Crucible Labs Inc. unless otherwise
 * approved by Crucible Labs Inc.
 */

import 'package:arcane/arcane.dart';

class EmailPasswordSignIn extends StatelessWidget {
  final Widget? icon;
  final String? label;
  final VoidCallback? onPressed;

  const EmailPasswordSignIn(
      {super.key,
      this.icon = const Icon(Icons.mail_ionic, size: 18),
      this.label = "Sign in with Email",
      this.onPressed});

  @override
  Widget build(BuildContext context) => OAuthSignInButton(
        label: label,
        icon: icon,
        onPressed: onPressed,
      );
}

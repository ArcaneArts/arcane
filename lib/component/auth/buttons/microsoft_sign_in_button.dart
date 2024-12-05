/*
 * Copyright (c) 2024. Crucible Labs Inc.
 *
 * Crucible is a closed source project developed by Crucible Labs Inc.
 * Do not copy, share distribute or otherwise allow this source file
 * to leave hardware approved by Crucible Labs Inc. unless otherwise
 * approved by Crucible Labs Inc.
 */

import 'package:arcane/arcane.dart';

class FacebookSignInButton extends StatelessWidget {
  final Widget? icon;
  final String? label;

  const FacebookSignInButton(
      {super.key, this.icon = const FacebookLogo(), this.label = "Facebook"});

  @override
  Widget build(BuildContext context) => CredentialSignInButton(
        label: label,
        icon: icon,
        onPressed: () => context
            .pylon<ArcaneAuthProvider>()
            .signInWithProvider(context, ArcaneSignInProviderType.facebook),
      );
}

class FacebookLogo extends StatelessWidget {
  final double size;

  const FacebookLogo({super.key, this.size = 14});

  @override
  Widget build(BuildContext context) => Icon(Icons.facebook_logo, size: size);
}

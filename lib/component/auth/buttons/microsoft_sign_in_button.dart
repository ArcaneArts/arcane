/*
 * Copyright (c) 2024. Crucible Labs Inc.
 *
 * Crucible is a closed source project developed by Crucible Labs Inc.
 * Do not copy, share distribute or otherwise allow this source file
 * to leave hardware approved by Crucible Labs Inc. unless otherwise
 * approved by Crucible Labs Inc.
 */

import 'package:arcane/arcane.dart';

class MicrosoftSignInButton extends StatelessWidget {
  final Widget? icon;
  final String? label;

  const MicrosoftSignInButton(
      {super.key, this.icon = const MicrosoftLogo(), this.label = "Microsoft"});

  @override
  Widget build(BuildContext context) => CredentialSignInButton(
        label: label,
        icon: icon,
        onPressed: () => context
            .pylon<ArcaneAuthProvider>()
            .signInWithProvider(context, ArcaneSignInProviderType.microsoft),
      );
}

class MicrosoftLogo extends StatelessWidget {
  final double size;

  const MicrosoftLogo({super.key, this.size = 14});

  @override
  Widget build(BuildContext context) =>
      Icon(Icons.logo_microsoft_ionic, size: size);
}

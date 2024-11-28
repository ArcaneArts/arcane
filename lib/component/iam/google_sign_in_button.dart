/*
 * Copyright (c) 2024. Crucible Labs Inc.
 *
 * Crucible is a closed source project developed by Crucible Labs Inc.
 * Do not copy, share distribute or otherwise allow this source file
 * to leave hardware approved by Crucible Labs Inc. unless otherwise
 * approved by Crucible Labs Inc.
 */

import 'package:arcane/arcane.dart';
import 'package:common_svgs/common_svgs.dart';
import 'package:flutter_svg/svg.dart';

class GoogleSignInButton extends StatelessWidget {
  final Widget? icon;
  final String? label;
  final VoidCallback? onPressed;

  const GoogleSignInButton(
      {super.key,
      this.icon = const GoogleLogo(),
      this.label = "Sign in with Google",
      this.onPressed});

  @override
  Widget build(BuildContext context) => OAuthSignInButton(
        label: label,
        icon: icon,
        onPressed: onPressed,
      );
}

class GoogleLogo extends StatelessWidget {
  final double size;

  const GoogleLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) => SvgPicture.string(svgGoogle,
      width: 18,
      height: 18,
      color: Theme.of(context).colorScheme.mutedForeground);
}

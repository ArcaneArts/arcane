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

class AppleSignInButton extends StatelessWidget {
  final Widget? icon;
  final String? label;
  final VoidCallback? onPressed;

  const AppleSignInButton(
      {super.key,
      this.icon = const AppleLogo(),
      this.label = "Sign in with Apple",
      this.onPressed});

  @override
  Widget build(BuildContext context) => OAuthSignInButton(
        label: label,
        icon: icon,
        onPressed: onPressed,
      );
}

class AppleLogo extends StatelessWidget {
  final double size;

  const AppleLogo({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) => SvgPicture.string(svgApple,
      width: 24,
      height: 24,
      color: Theme.of(context).colorScheme.secondaryForeground);
}

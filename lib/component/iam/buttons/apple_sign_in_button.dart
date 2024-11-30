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

class AppleSignInButton extends StatelessWidget implements AbstractIAMButton {
  final Widget? icon;
  final String? label;
  @override
  final VoidCallback onPressed;

  const AppleSignInButton(
      {super.key,
      this.icon = const AppleLogo(),
      this.label = "Sign in with Apple",
      required this.onPressed});

  @override
  Widget build(BuildContext context) => OAuthSignInButton(
        label: label,
        icon: icon,
        onPressed: onPressed,
      );

  @override
  AppleSignInButton withOnPressed(VoidCallback onPressed) => AppleSignInButton(
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
  bool get isAutorun => true;
}

class AppleLogo extends StatelessWidget {
  final double size;

  const AppleLogo({super.key, this.size = 18});

  @override
  Widget build(BuildContext context) => SvgPicture.string(svgApple,
      width: 18,
      height: 18,
      color: Theme.of(context).colorScheme.mutedForeground);
}

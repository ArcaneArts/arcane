import 'package:arcane/arcane.dart';

class CenterBody extends StatelessWidget {
  final IconData icon;
  final String? message;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const CenterBody(
      {super.key,
      required this.icon,
      this.message,
      this.actionText,
      this.onActionPressed});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 56,
            ),
            Gap(16),
            if (message != null) ...[Text(message!)],
            if (actionText != null) ...[
              Gap(8),
              TextButton(
                onPressed: onActionPressed,
                child: Text(actionText!),
              )
            ]
          ],
        ),
      );
}

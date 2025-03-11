import 'package:arcane/arcane.dart';

/// A utility component that displays an icon, an optional message, and an optional
/// action button centered on the screen.
///
/// [CenterBody] is commonly used for empty states, error messages, or simple
/// informational displays where content needs to be prominently centered.
///
/// See also:
///  * [doc/component/center_body.md] for more detailed documentation
class CenterBody extends StatelessWidget {
  /// The icon to display at the center of the screen.
  ///
  /// This icon serves as the visual focus of the display and should represent
  /// the state or information being communicated.
  final IconData icon;
  
  /// Optional text message to display below the icon.
  ///
  /// This message can provide additional context or explanation about the
  /// current state.
  final String? message;
  
  /// Optional text for the action button.
  ///
  /// If provided along with [onActionPressed], a button with this text will be
  /// displayed below the message.
  final String? actionText;
  
  /// Function to call when the action button is pressed.
  ///
  /// This callback is required if [actionText] is provided.
  final VoidCallback? onActionPressed;

  /// Creates a [CenterBody] widget.
  ///
  /// The [icon] parameter is required and specifies the icon to display.
  /// The [message] parameter is optional and provides explanatory text.
  /// If both [actionText] and [onActionPressed] are provided, an action button
  /// will be displayed below the message.
  ///
  /// Example:
  /// ```dart
  /// CenterBody(
  ///   icon: Icons.inbox,
  ///   message: "No messages found",
  ///   actionText: "Refresh",
  ///   onActionPressed: () => refreshMessages(),
  /// )
  /// ```
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

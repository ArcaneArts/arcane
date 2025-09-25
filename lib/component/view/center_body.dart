import 'package:arcane/arcane.dart';

/// A centered body widget that displays an icon with optional message and action button,
/// providing balanced layouts for empty states, errors, or informational displays in Arcane screens.
///
/// [CenterBody] uses [Center] and [Column] to center content vertically and horizontally,
/// integrating seamlessly with [ArcaneTheme] for consistent styling. It is ideal for use within
/// [FillScreen] or [AbstractScreen] to create prominent, focused content areas without complex
/// computations, ensuring high performance through simple widget composition.
///
/// Key features include:
/// - Prominent icon display for visual focus.
/// - Optional explanatory message below the icon.
/// - Conditional action button for user interaction.
/// - Minimal footprint with const constructor for efficient rebuilding.
///
/// Usage example:
/// ```dart
/// CenterBody(
///   icon: Icons.info,
///   message: 'No data available',
///   actionText: 'Retry',
///   onActionPressed: () => refreshData(),
/// )
/// ```
///
/// See also: [Center], [Column], [ArcaneTheme], [FillScreen], [AbstractScreen].
class CenterBody extends StatelessWidget {
  /// The icon to display at the center, serving as the primary visual element.
  ///
  /// This [IconData] represents the state (e.g., empty, error) and is rendered
  /// at 56 logical pixels for prominence. Integrates with [ArcaneTheme] icons.
  final IconData icon;

  /// Optional message text displayed below the icon for context.
  ///
  /// Provides explanatory details about the current state, styled via [ArcaneTheme].
  /// Rendered only if non-null, using default text properties for readability.
  final String? message;

  /// Optional label for the action button shown below the message.
  ///
  /// If provided with [onActionPressed], creates a [TextButton] for user actions
  /// like refresh or navigate, ensuring intuitive interaction in centered layouts.
  final String? actionText;

  /// Callback invoked when the action button is pressed.
  ///
  /// Required if [actionText] is set; enables handling events like data refresh
  /// in [FillScreen] or navigation in [AbstractScreen]. Uses null safety for optional use.
  final VoidCallback? onActionPressed;

  /// Constructs a [CenterBody] with required icon and optional message/action elements.
  ///
  /// - [key]: Standard Flutter widget key for identification.
  /// - [icon]: Required [IconData] for the central visual element.
  /// - [message]: Optional [String] for contextual text below the icon.
  /// - [actionText]: Optional [String] label for the action button.
  /// - [onActionPressed]: Optional callback for button press handling.
  ///
  /// The const constructor ensures efficient widget tree updates. Use named parameters
  /// for clarity in Arcane UI compositions, promoting reusable centered content.
  ///
  /// Example in a screen:
  /// ```dart
  /// FillScreen(
  ///   body: CenterBody(
  ///     icon: Icons.search_off,
  ///     message: 'Search for items',
  ///     actionText: 'Clear',
  ///     onActionPressed: clearSearch,
  ///   ),
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

import 'package:arcane/arcane.dart';

/// A confirmation dialog widget designed for user decision-making in the Arcane
/// Flutter UI system. This component provides a standardized way to present
/// confirmation prompts with a title, optional description (as text or custom
/// widget), and action buttons for confirm and cancel operations. It extends
/// [StatelessWidget] and mixes in [ArcaneDialogLauncher] to enable easy
/// launching from any context.
///
/// Key features:
/// - Customizable title and button texts for flexible messaging.
/// - Support for destructive actions via a red-accented confirm button.
/// - Optional description as plain text or a custom [Widget] for rich content,
///   such as [ConfirmText] for formatted warnings.
/// - Extensible actions list to include additional buttons, like [Command]
///   buttons for secondary options.
/// - Integrates seamlessly with [ArcaneDialog] for consistent theming and
///   behavior.
///
/// This dialog is ideal for scenarios requiring user acknowledgment before
/// performing actions, such as deletions, submissions, or settings changes.
/// It ensures accessibility and follows Material Design principles while
/// adhering to Arcane's magical, glassmorphic aesthetic.
///
/// Usage example:
/// ```dart
/// DialogConfirm(
///   title: 'Are you sure?',
///   description: 'This will permanently delete the item.',
///   destructive: true,
///   onConfirm: () {
///     // Perform deletion logic
///   },
/// ).launch(context);
/// ```
///
/// For more advanced confirmation with commands, combine with [Command] widgets
/// in the actions list.
class DialogConfirm extends StatelessWidget with ArcaneDialogLauncher {
  /// The primary title text displayed prominently at the top of the dialog.
  /// This should clearly state the action being confirmed, e.g., "Delete File?".
  final String title;

  /// An optional descriptive text providing additional context or warnings
  /// about the confirmation action. Rendered as a [Text] widget if provided;
  /// falls back to [descriptionWidget] if null.
  final String? description;

  /// A custom widget for the dialog's content area, used when [description]
  /// is null. Defaults to an empty [SizedBox] to avoid layout issues.
  /// Useful for complex content like [ConfirmText] or formatted explanations.
  final Widget descriptionWidget;

  /// The text label for the confirm button. Defaults to "Confirm" for standard
  /// usage. Customize for context-specific phrasing, e.g., "Delete".
  final String confirmText;

  /// The text label for the cancel button. Defaults to "Cancel" for user-friendly
  /// dismissal.
  final String cancelText;

  /// A required callback invoked when the user confirms the action.
  /// This handles the primary operation, such as saving data or executing
  /// a command. Called after the dialog is dismissed with true.
  final VoidCallback onConfirm;

  /// An optional list of additional [Widget]s to include as actions in the
  /// dialog footer, appended after the standard cancel/confirm buttons.
  /// Useful for adding secondary options, e.g., [Command] buttons for
  /// alternative actions.
  final List<Widget>? actions;

  /// A flag indicating if the confirmation is destructive (e.g., delete operations).
  /// When true, the confirm button uses a red [DestructiveButton] for visual warning.
  /// Defaults to false for non-critical confirmations using [PrimaryButton].
  final bool destructive;

  /// Constructs a [DialogConfirm] widget with the specified properties.
  ///
  /// Required parameters:
  /// - [title]: The dialog's title text.
  /// - [onConfirm]: The callback for the confirm action.
  ///
  /// Optional parameters with defaults:
  /// - [destructive]: false, for standard confirmations.
  /// - [description]: null, falls back to [descriptionWidget].
  /// - [descriptionWidget]: [SizedBox.shrink()], an empty widget.
  /// - [confirmText]: "Confirm", the confirm button label.
  /// - [cancelText]: "Cancel", the cancel button label.
  /// - [actions]: null, no additional actions.
  ///
  /// The constructor initializes all fields directly and supports const
  /// construction for performance in Flutter builds. Use named parameters
  /// for clarity when instantiating.
  const DialogConfirm({
    super.key,
    required this.title,
    this.destructive = false,
    this.description,
    this.descriptionWidget = const SizedBox.shrink(),
    this.confirmText = "Confirm",
    this.cancelText = "Cancel",
    this.actions,
    required this.onConfirm,
  });

  @override

  /// Builds the [DialogConfirm] widget tree, rendering it as an [ArcaneDialog].
  ///
  /// This method constructs the dialog's UI:
  /// - Title: A [Text] widget with [title].
  /// - Content: A flexible [Row] containing either [Text] from [description]
  ///   (if provided) or [descriptionWidget]. Wrapped in [InWidth] for responsive
  ///   sizing.
  /// - Actions: Defaults to cancel ([OutlineButton]) and confirm buttons.
  ///   Confirm uses [DestructiveButton] if [destructive] is true, otherwise
  ///   [PrimaryButton]. Both dismiss the dialog (pop true/false) and invoke
  ///   [onConfirm] on confirm. Additional [actions] are spread if provided.
  ///   The entire actions list is wrapped in [InWidth].
  ///
  /// No side effects beyond building the widget; interactions are handled
  /// via button callbacks. Returns a fully configured [ArcaneDialog] ready
  /// for display.
  ///
  /// The build ensures horizontal centering and maximal content fitting,
  /// maintaining Arcane's aesthetic with glass effects and proper spacing.
  Widget build(BuildContext context) => ArcaneDialog(
        title: Text(title),
        content: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
                child: description != null
                    ? Text(description!)
                    : descriptionWidget)
          ],
        ).iw,
        actions: actions ??
            [
              OutlineButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(cancelText),
              ),
              destructive
                  ? DestructiveButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        onConfirm();
                      },
                      child: Text(confirmText),
                    )
                  : PrimaryButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        onConfirm();
                      },
                      child: Text(confirmText),
                    ),
              if (actions != null) ...actions!,
            ],
      ).iw;
}

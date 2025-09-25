import 'package:arcane/arcane.dart';
import 'package:flutter/services.dart';

/// A customizable text input dialog widget that allows users to enter single-line or multi-line text input.
/// This component is part of the Arcane UI dialog system and extends [StatefulWidget] while mixing in [ArcaneDialogLauncher]
/// for easy integration with the dialog presentation logic. It provides a focused text field within a dialog,
/// suitable for general string entry scenarios such as usernames, notes, or custom text prompts.
/// Key features include support for obscuring text (e.g., for passwords, though [Email] is preferred for emails),
/// customizable keyboard types, line limits, initial values, and additional actions.
///
/// Usage example:
/// ```dart
/// DialogText(
///   title: 'Enter your name',
///   onConfirm: (result) => print('Entered: $result'),
/// );
/// ```
///
/// This dialog fits into the broader [Dialog] ecosystem, similar to [Command] for command inputs or [Confirm] for confirmations,
/// but specialized for free-form text entry. It automatically focuses the text field on presentation and handles
/// confirmation/cancellation via the provided callbacks.

class DialogText extends StatefulWidget with ArcaneDialogLauncher {
  /// The title displayed at the top of the dialog.
  /// Type: String (required).
  /// Usage: Provides a clear header for the text input purpose, e.g., 'Enter Description'.
  final String title;
  /// Optional description text shown below the title.
  /// Type: String? (optional).
  /// Usage: Offers additional context or instructions for the text input, e.g., 'Keep it under 100 characters'.
  final String? description;
  /// A custom widget to display as description instead of plain text.
  /// Type: Widget (optional, defaults to SizedBox.shrink()).
  /// Usage: For rich content like formatted instructions or icons in the description area.
  final Widget descriptionWidget;
  /// The text for the confirm button.
  /// Type: String (optional, defaults to 'Done').
  /// Usage: Customizes the primary action button label, e.g., 'Save'.
  final String confirmText;
  /// The text for the cancel button.
  /// Type: String (optional, defaults to 'Cancel').
  /// Usage: Customizes the secondary action button label, e.g., 'Discard'.
  final String cancelText;
  /// Placeholder widget or text for the text field.
  /// Type: Widget? (optional).
  /// Usage: Provides hint text or icon inside the input field when empty.
  final Widget? placeholder;
  /// Whether to obscure the text input (e.g., for passwords).
  /// Type: bool (optional, defaults to false).
  /// Usage: Set to true for sensitive inputs; note that [Email] handles email-specific validation separately.
  final bool obscureText;
  /// Initial text value pre-filled in the text field.
  /// Type: String? (optional).
  /// Usage: Pre-populates the input for editing scenarios, e.g., current username.
  final String? initialValue;
  /// Callback invoked when the user confirms the input.
  /// Type: void Function(String) (required).
  /// Usage: Receives the entered text; use to process or save the value, e.g., update state or API call.
  final void Function(String result) onConfirm;
  /// Additional custom actions to append after the default confirm/cancel buttons.
  /// Type: List<Widget>? (optional).
  /// Usage: For extra buttons like 'Clear' or integration with other [Dialog] features.
  final List<Widget>? actions;
  /// Maximum number of lines allowed in the text field.
  /// Type: int (optional, defaults to 1).
  /// Usage: Controls multi-line input; set higher for notes or descriptions.
  final int maxLines;
  /// Minimum number of lines for the text field.
  /// Type: int? (optional).
  /// Usage: Ensures a minimum height for multi-line inputs.
  final int? minLines;
  /// Maximum character length for the input.
  /// Type: int? (optional).
  /// Usage: Enforces length limits with counter display if set.
  final int? maxLength;
  /// Type of keyboard to display.
  /// Type: TextInputType? (optional).
  /// Usage: Optimizes input, e.g., TextInputType.emailAddress for emails (complements [Email] dialog).
  final TextInputType? keyboardType;

  /// Constructs a [DialogText] widget.
  ///
  /// Required parameters:
  /// - title: The dialog title.
  /// - onConfirm: Callback for confirmed text.
  ///
  /// Optional parameters include description, keyboardType (defaults to null),
  /// obscureText (false), placeholder (null), initialValue (null), descriptionWidget (SizedBox.shrink()),
  /// confirmText ('Done'), cancelText ('Cancel'), maxLines (1), minLines (null), maxLength (null), actions (null).
  ///
  /// Initializes the dialog with the provided text input configuration, ensuring const construction for performance.
  const DialogText(
      {super.key,
      required this.title,
      this.description,
      this.keyboardType,
      this.obscureText = false,
      this.placeholder,
      this.initialValue,
      this.descriptionWidget = const SizedBox.shrink(),
      this.confirmText = "Done",
      this.cancelText = "Cancel",
      this.maxLines = 1,
      this.minLines,
      this.maxLength,
      required this.onConfirm,
      this.actions});

  /// Creates the state for this [DialogText] widget.
  /// Returns: State<DialogText> - An instance of [_DialogTextState].
  /// Side effects: None; standard Flutter state creation.
  @override
  State<DialogText> createState() => _DialogTextState();
}

  /// The private state class managing the text input dialog's mutable aspects,
  /// such as the text controller and focus node. This handles initialization,
  /// focusing, and building the [ArcaneDialog] with the text field.
  /// It integrates with [DialogText]'s configuration to provide a responsive input experience.
  class _DialogTextState extends State<DialogText> {
  /// Controller for managing the text field's content and selection.
  /// Type: TextEditingController (late-initialized).
  /// Usage: Controls the input text, initialized with initialValue from the widget.
  late TextEditingController controller;
  /// Node for managing focus on the text field.
  /// Type: FocusNode (late-initialized).
  /// Usage: Requests focus automatically after the frame to ensure immediate input readiness.
  late FocusNode focusNode;

  /// Initializes the state by setting up the text controller with initial value
  /// and focus node, then requests focus post-frame to avoid layout conflicts.
  /// Side effects: Creates controller and focus node; schedules focus request.
  @override
  void initState() {
    controller = TextEditingController(
      text: widget.initialValue,
    );
    focusNode = FocusNode();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => focusNode.requestFocus());
    super.initState();
  }

  /// Builds the dialog UI using [ArcaneDialog], including title, optional description,
  /// text field with configurations, and action buttons (cancel, confirm, custom actions).
  /// The text field handles submission on enter and integrates with onConfirm callback.
  /// Returns: Widget - The fully configured dialog wrapped in IntrinsicWidth (via .iw).
  /// Parameters: context - BuildContext for widget tree integration.
  @override
  Widget build(BuildContext context) => ArcaneDialog(
        title: Text(widget.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.description != null ||
                widget.descriptionWidget is! SizedBox)
              widget.description != null
                  ? Text(widget.description!)
                  : widget.descriptionWidget,
            const Gap(16),
            TextField(
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              maxLength: widget.maxLength,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              focusNode: focusNode,
              controller: controller,
              placeholder: widget.placeholder,
              onSubmitted: (value) {
                Navigator.of(context).pop(true);
                widget.onConfirm(value);
              },
              obscureText: widget.obscureText,
              initialValue: widget.initialValue,
            ),
          ],
        ),
        actions: [
          OutlineButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(widget.cancelText),
          ),
          PrimaryButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              widget.onConfirm(controller.text);
            },
            child: Text(widget.confirmText),
          ),
          if (widget.actions != null) ...widget.actions!,
        ],
      ).iw;
}

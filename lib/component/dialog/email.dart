import 'package:arcane/arcane.dart';
import 'package:flutter/services.dart';

/// A customizable dialog widget for collecting user email input within the Arcane UI component system.
///
/// This component extends [StatefulWidget] and implements [ArcaneDialogLauncher] to provide a modal
/// interface specifically designed for email entry. It features an optimized [TextField] with email
/// keyboard type, automatic focus management, and flexible configuration for titles, descriptions,
/// input constraints, and custom actions. The dialog integrates with the broader [ArcaneDialog] family,
/// ensuring consistent styling and behavior across user input scenarios.
///
/// Key features include:
/// - Email-specific input validation and keyboard optimization via [TextInputType.emailAddress].
/// - Support for initial values, placeholders, and length/line limits to control user input.
/// - Submission handling through a required callback, with optional custom actions.
/// - Automatic focus on the input field upon dialog presentation for improved UX.
///
/// This dialog is ideal for scenarios requiring user email collection, such as account creation,
/// profile updates, or newsletter subscriptions. It fits into the Arcane component hierarchy as a
/// specialized input dialog, often used alongside other form elements like [DialogText] or [DialogConfirm].
///
/// Usage example:
/// ```dart
/// DialogEmail(
///   title: 'Enter Your Email',
///   description: 'Please provide a valid email address to continue.',
///   initialValue: 'user@example.com',
///   onConfirm: (email) {
///     // Handle email submission, e.g., validate and save.
///     print('Email submitted: $email');
///   },
/// ).launch(context);
/// ```
class DialogEmail extends StatefulWidget with ArcaneDialogLauncher {
  /// The title text displayed at the top of the dialog.
  ///
  /// This [String] is required and serves as the primary heading, informing the user of the email input purpose.
  /// It is rendered using a [Text] widget within the [ArcaneDialog].
  final String title;

  /// Optional descriptive text below the title.
  ///
  /// This nullable [String] provides additional instructions or context for the email input.
  /// If provided, it is displayed as a [Text] widget; otherwise, no description is shown.
  final String? description;

  /// Custom widget for the description area.
  ///
  /// This [Widget] allows for rich or complex descriptions beyond simple text, such as formatted
  /// instructions or icons. Defaults to a [SizedBox.shrink()] for no content. It is displayed
  /// only if not an empty [SizedBox].
  final Widget descriptionWidget;

  /// Text label for the confirmation button.
  ///
  /// This [String] customizes the primary action button's label, defaulting to "Submit".
  /// It is used in a [PrimaryButton] to trigger email submission via [onConfirm].
  final String confirmText;

  /// Text label for the cancel button.
  ///
  /// This [String] customizes the secondary action button's label, defaulting to "Cancel".
  /// It is used in an [OutlineButton] to dismiss the dialog without submission.
  final String cancelText;

  /// Placeholder widget for the email input field.
  ///
  /// This optional [Widget] serves as a hint in the [TextField], guiding the user on expected input.
  /// It replaces the standard hint text for more customizable UI elements.
  final Widget? placeholder;

  /// Initial email value pre-filled in the text field.
  ///
  /// This nullable [String] sets the starting content of the [TextEditingController], useful for
  /// editing existing emails or providing defaults.
  final String? initialValue;

  /// Callback invoked when the email is confirmed.
  ///
  /// This required function receives the entered [String] email and handles submission logic,
  /// such as validation, API calls, or state updates. Called on button press or field submission.
  final void Function(String email) onConfirm;

  /// Additional action buttons to append after standard confirm/cancel.
  ///
  /// This optional [List] of [Widget]s allows custom buttons, such as "Save Draft" or secondary options.
  /// They are spread into the [ArcaneDialog]'s actions list.
  final List<Widget>? actions;

  /// Maximum number of lines for the email text field.
  ///
  /// This optional [int] limits the [TextField]'s vertical expansion, defaulting to single-line behavior.
  final int? maxLines;

  /// Minimum number of lines for the email text field.
  ///
  /// This optional [int] sets the initial height of the [TextField], useful for multi-line emails if needed.
  final int? minLines;

  /// Maximum character length for the email input.
  ///
  /// This optional [int] enforces a character limit on the [TextField], with visual counter if enforced.
  final int? maxLength;

  /// Constructs a [DialogEmail] widget with the specified configuration.
  ///
  /// All parameters correspond to the class fields and control the dialog's appearance and behavior.
  /// Required parameters include [title] and [onConfirm] for basic functionality.
  /// Optional parameters allow customization of text, input constraints, and actions.
  /// The widget is const-constructible for performance in Flutter builds.
  const DialogEmail({
    super.key,
    required this.title,
    this.description,
    this.descriptionWidget = const SizedBox.shrink(),
    this.confirmText = "Submit",
    this.cancelText = "Cancel",
    this.placeholder,
    this.initialValue,
    required this.onConfirm,
    this.actions,
    this.maxLines,
    this.minLines,
    this.maxLength,
  });

  @override
  State<DialogEmail> createState() => _DialogEmailState();
}

/// Private state class for managing the [DialogEmail] widget's internal logic.
///
/// This class handles the lifecycle of the email input, including controller initialization,
/// focus management, and building the UI. It extends [State<DialogEmail>] to maintain
/// mutable state for the text input while keeping the parent widget immutable.
class _DialogEmailState extends State<DialogEmail> {
  /// [TextEditingController] for managing the email input field's text state.
  ///
  /// Initialized in [initState] with the widget's [initialValue]. Controls text input,
  /// selection, and submission. Disposed in [dispose] to prevent memory leaks.
  late TextEditingController controller;

  /// [FocusNode] for the email text field to handle focus events.
  ///
  /// Created in [initState] and used to automatically request focus on dialog open.
  /// Ensures the input field is immediately active for user entry. Disposed in [dispose].
  late FocusNode focusNode;

  /// Initializes the state upon widget creation.
  ///
  /// Sets up the [controller] with the initial email value and creates the [focusNode].
  /// Requests focus on the text field after the frame is built to ensure the keyboard
  /// appears promptly. Calls super.initState() to complete the lifecycle hook.
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

  /// Disposes resources when the widget is removed from the tree.
  ///
  /// Properly disposes the [controller] and [focusNode] to free memory and prevent
  /// dangling references. No return value; side effect is resource cleanup.
  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  /// Builds the widget's UI representation.
  ///
  /// Constructs a scrollable [ArcaneDialog] with the configured title, optional description
  /// or [descriptionWidget], and a specialized [TextField] for email input. The field
  /// uses [TextInputType.emailAddress] for optimal keyboard, includes a mail icon,
  /// and handles submission via [onSubmitted] or button presses. Actions include
  /// cancel and confirm [Button]s, plus any custom [actions]. Returns a [Widget]
  /// wrapped in [SingleChildScrollView] for overflow handling. No side effects beyond
  /// UI rendering; parameters include [BuildContext] for theming and navigation.
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: ArcaneDialog(
          title: Text(widget.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.description != null ||
                  widget.descriptionWidget is! SizedBox)
                widget.description != null
                    ? Text(widget.description!)
                    : widget.descriptionWidget,
              const Gap(16),
              TextField(
                keyboardType: TextInputType.emailAddress,
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
                leading: const Icon(Icons.mail_ionic),
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
        ).iw,
      );
}

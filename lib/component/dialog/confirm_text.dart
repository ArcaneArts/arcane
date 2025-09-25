import 'package:arcane/arcane.dart';

/// A confirmation dialog widget that requires the user to type a specific verification text
/// to confirm an action, providing an additional layer of user validation to prevent accidental
/// operations, especially destructive ones. This component integrates seamlessly into the
/// Arcane UI system as a specialized form of [ArcaneDialog], often used alongside [Command]
/// dialogs for text-based confirmations in forms or actions requiring explicit acknowledgment.
///
/// Key features include:
/// - Customizable title, description (text or widget), and button labels.
/// - Animated feedback for invalid input: shake effect and temporary destructive tint.
/// - Optional case-insensitive matching for verification text.
/// - Support for custom keyboard types and additional action buttons.
/// - Destructive mode for styling the confirm button with warning colors.
///
/// Usage example:
/// ```dart
/// DialogConfirmText(
///   title: 'Delete Item',
///   verificationText: 'DELETE',
///   onConfirm: () => deleteItem(),
///   destructive: true,
/// );
/// ```
/// This displays a dialog prompting the user to type "DELETE" to proceed, with error animation
/// if mismatched. Launch via [showDialog] or the [ArcaneDialogLauncher] mixin methods.
class DialogConfirmText extends StatefulWidget with ArcaneDialogLauncher {
  final String title;
  final String? description;
  final Widget descriptionWidget;
  final String confirmText;
  final String cancelText;
  final String verificationText;
  final void Function() onConfirm;
  final List<Widget>? actions;
  final TextInputType? keyboardType;
  final bool ignoreCase;
  final bool destructive;

  /// The primary constructor for initializing the confirmation dialog.
  ///
  /// Configures the dialog's appearance and behavior, including the text the user must enter
  /// for confirmation. All parameters allow customization of the UI and validation logic.
  /// The dialog is built as a stateful widget to handle input focus, animations, and validation
  /// dynamically. Defaults provide sensible values for common use cases, but required fields
  /// ensure essential functionality.
  ///
  /// References: Uses [TextField] for input, [OutlineButton] for cancel, and [PrimaryButton]
  /// or [DestructiveButton] for confirm based on the destructive flag.
  const DialogConfirmText({
    super.key,
    this.destructive = false,
    required this.title,
    this.description,
    this.descriptionWidget = const SizedBox.shrink(),
    this.confirmText = "Confirm",
    this.cancelText = "Cancel",
    required this.verificationText,
    required this.onConfirm,
    this.ignoreCase = false,
    this.actions,
    this.keyboardType,
  });

  /// Creates and returns the state object for this stateful widget, enabling
  /// dynamic management of text input, focus, and error animations.
  @override
  State<DialogConfirmText> createState() => _DialogConfirmTextState();
}

/// Private state class managing the internal logic of [DialogConfirmText].
/// Handles text input validation, focus management, and animated error feedback
/// (shake and color tint) when the user enters incorrect verification text.
/// This state integrates with Flutter's animation system using [AnimationController]
/// and [TickerProviderStateMixin] for smooth UI responses. It builds the dialog
/// content using [ArcaneDialog], incorporating the text field and action buttons.
class _DialogConfirmTextState extends State<DialogConfirmText>
    with TickerProviderStateMixin {
  /// [TextEditingController] for the verification text input field.
  /// Manages the user's typed text and enables clearing on error recovery.
  late TextEditingController controller;

  /// [FocusNode] for the text input field.
  /// Automatically requests focus on dialog open and after error corrections
  /// to improve user experience by keeping the keyboard active.
  late FocusNode focusNode;

  /// [AnimationController] driving the horizontal shake animation.
  /// Used to provide visual feedback when verification text does not match,
  /// with a 250ms duration for quick, noticeable error indication.
  late AnimationController _shakeController;

  /// [AnimationController] for the temporary background color animation.
  /// Animates a subtle destructive tint (250ms) during error states to
  /// highlight the input field without overwhelming the UI.
  late AnimationController _colorController;

  /// [Animation<double>] defining the shake sequence.
  /// Uses [TweenSequence] for a back-and-forth motion (0 to ±10 pixels)
  /// with easing for a natural shake effect, applied via [Transform.translate].
  late Animation<double> _shakeAnimation;

  /// [Animation<Color?>] for the error background tint.
  /// Interpolates between the theme's background and a semi-transparent
  /// destructive color, null-safe to handle theme changes.
  Animation<Color?>? _colorAnimation;

  /// Boolean flag tracking the current error state.
  /// Influences text color (destructive on error) and triggers animations;
  /// reset after error feedback completes.
  bool _isError = false;

  /// Initializes the state by creating controllers, nodes, and animations.
  /// Sets up the shake and color [AnimationController]s with 250ms durations.
  /// Requests focus on the input field after the first frame to ensure
  /// immediate keyboard visibility. No side effects beyond setup.
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focusNode = FocusNode();

    // Ooohh Shakey Shakey!
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));

    // make it SCARLET! lol
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  /// Updates the color animation when theme dependencies change.
  /// Creates a [ColorTween] from the current theme's background to a
  /// destructive-tinted version, animated with easing. Called by Flutter
  /// when inherited widgets like [Theme] update; no direct side effects.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _colorAnimation = ColorTween(
      begin: Theme.of(context).colorScheme.background,
      end: Theme.of(context).colorScheme.destructive.withOpacity(0.1),
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));
  }

  /// Disposes all resources to prevent memory leaks.
  /// Releases animation controllers, text controller, and focus node.
  /// Ensures clean shutdown when the dialog is dismissed.
  @override
  void dispose() {
    _shakeController.dispose();
    _colorController.dispose();
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  /// Handles invalid input by triggering error animations and UI feedback.
  /// Sets error state, forwards shake and color animations, then reverses
  /// color, clears input, resets state, and refocuses the field.
  /// No parameters; side effects include visual shake/tint and input reset.
  void _handleError() {
    setState(() => _isError = true);
    _shakeController.forward(from: 0);
    _colorController.forward().then((_) {
      _colorController.reverse();
      controller.clear();
      setState(() => _isError = false);
      focusNode.requestFocus();
    });
  }

  /// Getter determining if the current input matches the required verification text.
  /// Trims whitespace and optionally ignores case for matching.
  /// Returns true if exact or case-insensitive match; used in [_handleSubmit].
  /// No side effects; pure computation based on controller text and widget properties.
  bool get isValid =>
      controller.text.trim() == widget.verificationText.trim() ||
      widget.ignoreCase &&
          controller.text.trim().toLowerCase() ==
              widget.verificationText.trim().toLowerCase();

  /// Processes text submission from the input field.
  /// Validates input using [isValid]; if valid, dismisses dialog with true
  /// and invokes [widget.onConfirm]. Otherwise, calls [_handleError].
  /// Parameter [value] is the submitted text (unused directly, relies on controller).
  /// Side effects: navigation pop and callback execution on success.
  void _handleSubmit(String value) {
    if (!isValid) {
      _handleError();
      return;
    }
    Navigator.of(context).pop(true);
    widget.onConfirm();
  }

  /// Builds the dialog UI using [ArcaneDialog].
  /// Constructs title, content (description + animated text field with placeholder
  /// as verification text), and actions (cancel, confirm/destructive button, custom actions).
  /// Applies shake transform and color decoration on error; handles onSubmitted.
  /// Returns the fully configured dialog widget wrapped in .iw (likely a utility extension).
  /// No parameters beyond context; rebuilds on state/animation changes.
  @override
  Widget build(BuildContext context) => ArcaneDialog(
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
            AnimatedBuilder(
              animation: Listenable.merge([_shakeAnimation, _colorController]),
              builder: (context, child) => Transform.translate(
                offset: Offset(_shakeAnimation.value, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: _colorAnimation?.value,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    keyboardType: widget.keyboardType,
                    maxLines: 1,
                    focusNode: focusNode,
                    controller: controller,
                    placeholder: Text(widget.verificationText),
                    onSubmitted: _handleSubmit,
                    style: TextStyle(
                      color: _isError
                          ? Theme.of(context).colorScheme.destructive
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          OutlineButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(widget.cancelText),
          ),
          widget.destructive
              ? DestructiveButton(
                  onPressed: () {
                    _handleSubmit(controller.text);
                  },
                  child: Text(widget.confirmText),
                )
              : PrimaryButton(
                  onPressed: () {
                    _handleSubmit(controller.text);
                  },
                  child: Text(widget.confirmText),
                ),
          if (widget.actions != null) ...widget.actions!,
        ],
      ).iw;
}

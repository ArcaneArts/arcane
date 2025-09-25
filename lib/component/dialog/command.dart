import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:flutter/services.dart';

/// A customizable command dialog widget that enables users to input text commands with optional autocomplete suggestions from a predefined set of options.
///
/// This component is part of the Arcane UI system and serves as a specialized [Dialog] for interactive command entry, such as user commands in tools, search inputs, or selection dialogs. It provides a focused text input experience with real-time filtering of options, automatic focus management, and seamless confirmation handling.
///
/// Key features:
/// - Supports text input with placeholders, initial values, and obscuring for sensitive data (e.g., passwords).
/// - Displays a dynamic dropdown of matching options as the user types, with case-insensitive filtering.
/// - Customizable via leading/trailing widgets, keyboard types, and character limits.
/// - Integrates with [ArcaneDialogLauncher] for easy presentation and confirmation.
/// - On submission, validates against options and invokes the confirmation callback with the selected or entered value.
///
/// Usage example:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => DialogCommand(
///     placeholder: const Text('Enter a command'),
///     options: {'help', 'save', 'exit', 'undo'},
///     onConfirm: (result) {
///       // Handle the confirmed command
///       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Executed: $result')));
///     },
///   ),
/// );
/// ```
class DialogCommand extends StatefulWidget with ArcaneDialogLauncher {
  /// The placeholder widget to display in the text field when no text is entered.
  ///
  /// Type: Widget?
  ///
  /// Usage: Provides a hint for the expected input, such as a [Text] widget with instructional text. Defaults to null, in which case no placeholder is shown.
  final Widget? placeholder;

  /// Whether the input text should be obscured, useful for passwords or sensitive commands.
  ///
  /// Type: bool
  ///
  /// Usage: Set to true to mask input characters (e.g., for secret commands). Defaults to false for visible text.
  final bool obscureText;

  /// The initial text value to pre-populate in the text field.
  ///
  /// Type: String?
  ///
  /// Usage: Provides a starting point for the input, such as a default command or previous value. Defaults to null for an empty field.
  final String? initialValue;

  /// The callback function invoked when the user confirms the input (via submission or option selection).
  ///
  /// Type: void Function(String result)
  ///
  /// Usage: Receives the confirmed text or selected option as a string. Required for handling the dialog result, such as executing the command.
  final void Function(String result) onConfirm;

  /// The maximum number of characters allowed in the input field.
  ///
  /// Type: int?
  ///
  /// Usage: Enforces input limits, displaying a character counter if set. Defaults to null for unlimited length.
  final int? maxLength;

  /// The set of predefined string options for autocomplete suggestions.
  ///
  /// Type: Set<String>
  ///
  /// Usage: As the user types, matching options (case-insensitive) are filtered and displayed in a dropdown. Defaults to an empty set, disabling autocomplete.
  final Set<String> options;

  /// The type of keyboard to display for input.
  ///
  /// Type: TextInputType?
  ///
  /// Usage: Optimizes the keyboard layout (e.g., TextInputType.text for general input, TextInputType.number for numeric commands). Defaults to null for standard text keyboard.
  final TextInputType? keyboardType;

  /// The widget to display at the start (leading) of the text field, such as an icon.
  ///
  /// Type: Widget?
  ///
  /// Usage: Enhances the input field with visual cues, like a search icon. Defaults to null.
  final Widget? leading;

  /// The widget to display at the end (trailing) of the text field, such as a clear button.
  ///
  /// Type: Widget?
  ///
  /// Usage: Adds interactive elements to the input, like a submit icon. Defaults to null.
  final Widget? trailing;

  /// Constructs a new DialogCommand widget with the specified configuration.
  ///
  /// The [onConfirm] parameter is required and defines how the confirmed input is handled.
  /// All other parameters are optional and allow customization of the dialog's appearance and behavior.
  /// The widget is const-constructible for performance optimization in Flutter builds.
  const DialogCommand(
      {super.key,
      this.options = const {},
      this.keyboardType,
      this.obscureText = false,
      this.placeholder,
      this.initialValue,
      this.maxLength,
      this.leading,
      this.trailing,
      required this.onConfirm});

  /// Creates and returns the [State] object for this widget, which manages the internal text controller and focus logic.
  @override
  State<DialogCommand> createState() => _DialogCommandState();
}

/// The private state class for [DialogCommand], responsible for managing the text input controller, focus node, and building the dynamic UI with autocomplete.
class _DialogCommandState extends State<DialogCommand> {
  /// The text editing controller used to manage the input field's text value and listen for changes.
  ///
  /// Type: TextEditingController
  ///
  /// Usage: Initialized with the widget's initial value; updates trigger UI rebuilds for option filtering.
  late TextEditingController controller;

  /// The focus node for the text field, enabling automatic focus on dialog open.
  ///
  /// Type: FocusNode
  ///
  /// Usage: Requests focus post-frame to immediately activate the input for user convenience.
  late FocusNode focusNode;

  /// Initializes the state by setting up the text controller with the initial value and requesting focus on the input field after the frame is built.
  /// This ensures the dialog is immediately interactive upon presentation.
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

  /// A computed getter that returns the list of valid autocomplete options matching the current input text.
  ///
  /// Filters the widget's options set case-insensitively and returns an empty list if the input is empty.
  ///
  /// Type: List<String>
  ///
  /// Usage: Drives the dynamic dropdown display; used in build to show suggestions and in submission to validate/select defaults.
  List<String> get vOptions => controller.text.trim().isEmpty
      ? []
      : widget.options
          .where((e) => e.toLowerCase().contains(controller.text.toLowerCase()))
          .toList();

  /// Builds the widget's UI, consisting of a padded text field with optional leading/trailing widgets, and a scrollable dropdown of matching options if available.
  ///
  /// The layout is constrained for optimal dialog sizing, with dynamic height based on option count.
  /// Handles input changes to rebuild options and submission to confirm and close the dialog.
  @override
  Widget build(BuildContext context) {
    List<String> validOptions = vOptions;

    double d3 = MediaQuery.of(context).size.height * 0.33;
    double h = 32;

    return PaddingTop(
      padding: min(
          d3, (h * validOptions.length) + (validOptions.isNotEmpty ? 3 : 0)),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: d3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              leading: widget.leading,
              trailing: widget.trailing,
              style: Theme.of(context)
                  .typography
                  .h3
                  .copyWith(fontWeight: FontWeight.w100),
              border: Border(),
              keyboardType: widget.keyboardType,
              maxLength: widget.maxLength,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              focusNode: focusNode,
              controller: controller,
              placeholder: widget.placeholder,
              // sameSizeHintStyle: true, TODO: fix
              onChanged: (value) => setState(() {}),
              onSubmitted: (value) {
                Navigator.of(context).pop(true);

                if (validOptions.isNotEmpty && !validOptions.contains(value)) {
                  widget.onConfirm(validOptions.first);
                } else {
                  widget.onConfirm(value);
                }
              },
              obscureText: widget.obscureText,
              initialValue: widget.initialValue,
            ),
            if (validOptions.isNotEmpty)
              PaddingVertical(
                  padding: 1,
                  child: Container(
                    height: 1,
                    color: Theme.of(context).colorScheme.muted,
                  )),
            if (validOptions.isNotEmpty)
              ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: d3,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...validOptions
                            .map((e) => SizedBox(
                                  height: h,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: GhostButton(
                                        trailing: e == validOptions.first
                                            ? Icon(
                                                Icons
                                                    .return_down_back_outline_ionic,
                                                size: 16,
                                              )
                                            : null,
                                        alignment: Alignment.centerLeft,
                                        child: Text(e),
                                        onPressed: () {
                                          controller.text = e;
                                          widget.onConfirm(e);
                                        },
                                      ))
                                    ],
                                  ),
                                ))
                            .toList(),
                      ],
                    ),
                  )),
          ],
        ),
      ).iw,
    );
  }
}

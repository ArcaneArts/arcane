import 'package:arcane/arcane.dart';
import 'package:arcane/generated/arcane_shadcn/src/components/overlay/dialog.dart';

import '../../generated/arcane_shadcn/src/util.dart';

/// A mixin that enables any [Widget] to be displayed as a modal dialog in the Arcane UI system.
///
/// This mixin provides the `open` method, which leverages Flutter's [showDialog] to present the
/// mixed-in widget as a centered, dismissible overlay. It automatically configures the dialog
/// barrier using colors from the current [ArcaneTheme], disables safe area to allow full-screen
/// overlay, and supports generic return types for capturing user interactions (e.g., selections
/// from [Date] or confirmations from [Confirm]).
///
/// Key features:
/// - Theme-integrated barrier styling with [ArcaneTheme.barrierColors.dialog].
/// - Dismissible by default (tap outside or back gesture).
/// - No safe area padding, ensuring edge-to-edge presentation.
/// - Seamless integration with Arcane's animation system via `.blurIn`.
///
/// This mixin is foundational for Arcane's dialog ecosystem, allowing specialized components
/// like [Command], [ConfirmText], [DateMulti], [DateRange], and [Date] to be launched uniformly.
///
/// Usage example:
/// ```dart
/// class CustomDialog extends StatelessWidget with ArcaneDialogLauncher {
///   @override
///   Widget build(BuildContext context) => ArcaneDialog(
///     title: const Text('Custom Dialog'),
///     content: const Text('Hello, Arcane!'),
///     actions: [
///       TextButton(
///         onPressed: () => Navigator.of(context).pop('OK'),
///         child: const Text('OK'),
///       ),
///     ],
///   );
/// }
///
/// // Launch the dialog
/// final result = CustomDialog().open<String>(context);
/// if (result != null) {
///   // Handle result
/// }
/// ```
mixin ArcaneDialogLauncher on Widget {
  Future<T?> open<T>(BuildContext context) {
    return showDialog<T>(
        context: context,
        barrierDismissible: true,
        useSafeArea: false,
        barrierColor: ArcaneTheme.of(context).barrierColors.dialog,
        builder: (context) => this);
  }
}

/// A stateless base dialog widget in the Arcane UI component system, designed for modal user interactions.
///
/// [ArcaneDialog] serves as the primary entry point for creating customizable dialogs, wrapping the
/// stateful [ArcaneAlertDialog] to handle layout, theming, and animations. It fits into Arcane's
/// component hierarchy as a versatile overlay for confirmations, inputs, and notifications, ensuring
/// consistent glassmorphism styling with optional blur and opacity effects. This class is extended
/// by specialized dialogs such as [Command] for command execution, [Confirm] and [ConfirmText] for
/// user confirmations, [Date], [DateRange], and [DateMulti] for date selections, promoting a unified
/// dialog experience across the app.
///
/// Key features:
/// - Flexible header with leading/trailing widgets (e.g., icons for context).
/// - Scalable padding based on [ArcaneTheme.scaling].
/// - Built-in `.blurIn` animation for smooth entrance.
/// - Generic support via [ArcaneDialogLauncher] for returning values like selections or booleans.
///
/// Usage: Instantiate with content and actions, then launch using `open(context)` from the mixin.
/// For example, see [Confirm] for a pre-built confirmation dialog built on this base.
class ArcaneDialog extends StatelessWidget {
  /// The optional leading widget, typically an icon, displayed on the left side of the dialog header.
  ///
  /// Type: [Widget]?
  ///
  /// Usage: Use for contextual icons, such as a warning symbol in error dialogs or a calendar icon
  /// in [Date]-related dialogs. It is styled with large size and muted foreground color by default.
  final Widget? leading;

  /// The optional trailing widget, often a close button or action icon, on the right of the header.
  ///
  /// Type: [Widget]?
  ///
  /// Usage: Commonly an [IconButton] for dismissing the dialog. Styled similarly to [leading] with
  /// large muted icons. In specialized dialogs like [Command], this might hold additional controls.
  final Widget? trailing;

  /// The optional title widget displayed prominently at the top of the dialog.
  ///
  /// Type: [Widget]?
  ///
  /// Usage: Typically a [Text] widget with bold, large font. Essential for dialogs like [Confirm]
  /// to convey the purpose (e.g., "Delete Item?"). Supports any widget for rich titles.
  final Widget? title;

  /// The main content body of the dialog, such as text, forms, or lists.
  ///
  /// Type: [Widget]?
  ///
  /// Usage: Core area for information or inputs. In [Date] dialogs, this holds date pickers; in
  /// [Command], it displays command previews. Styled with small, muted text if simple [Text].
  final Widget? content;

  /// The list of action buttons or widgets at the bottom of the dialog.
  ///
  /// Type: [List]<[Widget]>?
  ///
  /// Usage: Place interactive elements like [TextButton] for OK/Cancel. Actions are right-aligned
  /// and spaced. For [Confirm], this includes Yes/No buttons; empty lists hide the actions row.
  final List<Widget>? actions;

  /// The blur radius applied to the dialog's surface for a frosted glass effect.
  ///
  /// Type: [double]?
  ///
  /// Usage: Values between 0-20 create depth. Defaults to theme values if null. Enhances visual
  /// hierarchy in layered UIs, common in Arcane's modal overlays.
  final double? surfaceBlur;

  /// The opacity level of the dialog's surface, for transparency effects.
  ///
  /// Type: [double]?
  ///
  /// Usage: Range 0.0 (transparent) to 1.0 (opaque). Complements [surfaceBlur] for modern aesthetics.
  /// Null uses theme defaults, ideal for consistent theming across [Date] and [Confirm] variants.
  final double? surfaceOpacity;

  /// The padding applied inside the dialog around its content.
  ///
  /// Type: [double]
  ///
  /// Usage: Defaults to 24, scaled by [ArcaneTheme.scaling]. Controls spacing for title, content,
  /// and actions. Adjust for compact dialogs or to fit more content in smaller screens.
  final double padding;

  /// Constructs an [ArcaneDialog] instance with customizable header, body, and styling options.
  ///
  /// This constructor initializes the dialog's components and applies defaults for padding (24).
  /// All parameters are optional except as noted, allowing flexible usage from simple alerts to
  /// complex forms. The widget is ready for launch via [ArcaneDialogLauncher.open], which handles
  /// the modal presentation.
  ///
  /// Parameters:
  /// - [key]: Standard Flutter widget key.
  /// - [padding]: Internal padding, default 24, scaled by theme.
  /// - [leading]: Left header widget, e.g., icon for dialog type.
  /// - [title]: Top title widget, bold and large by default.
  /// - [content]: Body content, small and muted if text.
  /// - [actions]: Bottom action list, right-aligned.
  /// - [trailing]: Right header widget, e.g., close button.
  /// - [surfaceBlur]: Custom blur radius for surface (null uses theme).
  /// - [surfaceOpacity]: Custom opacity for surface (null uses theme).
  const ArcaneDialog({
    super.key,
    this.padding = 24,
    this.leading,
    this.title,
    this.content,
    this.actions,
    this.trailing,
    this.surfaceBlur,
    this.surfaceOpacity,
  });

  /// Builds the [ArcaneDialog] by delegating to [ArcaneAlertDialog] with scaled padding and blur-in animation.
  ///
  /// This method constructs the visual structure, applying [EdgeInsets.all] with theme-scaled [padding].
  /// It wraps the inner dialog in a blur-in effect for smooth entry. No side effects; purely declarative.
  ///
  /// Returns: A [Widget] ready for dialog presentation.
  @override
  Widget build(BuildContext context) => ArcaneAlertDialog(
          leading: leading,
          title: title,
          content: content,
          actions: actions,
          padding: EdgeInsets.all(padding * Theme.of(context).scaling),
          trailing: trailing,
          surfaceBlur: surfaceBlur,
          surfaceOpacity: surfaceOpacity)
      .blurIn;
}

/// A stateful alert dialog widget that handles the internal layout and animations for Arcane dialogs.
///
/// [ArcaneAlertDialog] is the core stateful component behind [ArcaneDialog], managing dynamic layout
/// for headers (leading, title, content, trailing) and actions. It integrates with Arcane's [ModalContainer]
/// for bordered, rounded surfaces and supports keyboard-aware padding via [AnimatedPadding]. This class
/// ensures responsive, theme-consistent modals, serving as the rendering engine for all Arcane dialog variants
/// like [Command], [Confirm], [Date], and more, within the broader UI overlay system.
///
/// Key features:
/// - Flexible row-based header with conditional flexible sizing for content.
/// - Actions row with invisible spacer for alignment and scroll handling.
/// - Theme-scaled gaps and border radius ([borderRadiusXxl]).
/// - Centered presentation with bottom inset handling for keyboards.
/// - Blur-in animation inherited from parent.
class ArcaneAlertDialog extends StatefulWidget {
  /// The optional leading widget for the dialog header, positioned left.
  ///
  /// Type: [Widget]?
  ///
  /// Usage: Icons or small widgets for visual cues, e.g., info icons in [Confirm] dialogs. Automatically
  /// styled as large muted icons in the build process.
  final Widget? leading;

  /// The optional trailing widget for the header, positioned right.
  ///
  /// Type: [Widget]?
  ///
  /// Usage: Close buttons or secondary actions. Styled as large muted icons, common in dismissible
  /// dialogs like [DateRange].
  final Widget? trailing;

  /// The optional title for the dialog, displayed bold and large.
  ///
  /// Type: [Widget]?
  ///
  /// Usage: Descriptive header text or widgets. Central to dialogs like [Command] for titles.
  final Widget? title;

  /// The optional content body, displayed small and muted if text.
  ///
  /// Type: [Widget]?
  ///
  /// Usage: Main information or inputs, e.g., date pickers in [DateMulti].
  final Widget? content;

  /// The list of bottom action widgets.
  ///
  /// Type: [List]<[Widget]>?
  ///
  /// Usage: Buttons for interactions. Right-aligned; non-empty triggers the actions row.
  final List<Widget>? actions;

  /// Custom blur for the dialog surface.
  ///
  /// Type: [double]?
  ///
  /// Usage: Enhances depth; null defers to theme.
  final double? surfaceBlur;

  /// Custom opacity for the surface.
  ///
  /// Type: [double]?
  ///
  /// Usage: Controls transparency; null uses theme defaults.
  final double? surfaceOpacity;

  /// The padding geometry for the dialog's internal content.
  ///
  /// Type: [EdgeInsetsGeometry]?
  ///
  /// Usage: Custom spacing; if null, uses symmetric padding from theme scaling.
  final EdgeInsetsGeometry? padding;

  /// Constructs an [ArcaneAlertDialog] with header, content, and styling parameters.
  ///
  /// Initializes the stateful dialog with optional components. All parameters are flexible,
  /// allowing omission for minimal dialogs. The [padding] can be customized; otherwise, defaults
  /// are applied in the state build. This constructor prepares the widget for embedding in modals.
  ///
  /// Parameters:
  /// - [key]: Flutter key.
  /// - [leading]: Left header widget.
  /// - [title]: Title widget.
  /// - [content]: Body widget.
  /// - [actions]: Action list.
  /// - [trailing]: Right header widget.
  /// - [surfaceBlur]: Blur radius.
  /// - [surfaceOpacity]: Opacity level.
  /// - [padding]: Internal padding geometry.
  const ArcaneAlertDialog({
    super.key,
    this.leading,
    this.title,
    this.content,
    this.actions,
    this.trailing,
    this.surfaceBlur,
    this.surfaceOpacity,
    this.padding,
  });

  /// Creates the state object for this stateful widget.
  ///
  /// Returns an instance of [_ArcaneAlertDialogState] to manage build and layout.
  @override
  _ArcaneAlertDialogState createState() => _ArcaneAlertDialogState();
}

/// Private state class for [ArcaneAlertDialog], handling the dynamic UI construction and animations.
///
/// This internal state manages the dialog's responsive layout, theme scaling, and keyboard interactions.
/// It builds the header row, content column, and actions stack, ensuring proper alignment and spacing.
/// Essential for the stateful behavior of Arcane dialogs, supporting variants like [ConfirmText] and [Time].
class _ArcaneAlertDialogState extends State<ArcaneAlertDialog> {
  /// Builds the dialog's visual structure, applying theme scaling, layout, and animations.
  ///
  /// This method constructs the header row with conditional leading/title/content/trailing elements,
  /// wraps in [ModalContainer] for theming, and handles actions with a stacked invisible spacer for
  /// alignment. It centers the content, animates padding for keyboard insets (450ms easeOutCirc),
  /// and applies blur-in transition. No side effects beyond layout; returns the complete dialog widget.
  ///
  /// Parameters: Uses [widget] properties and [context] for theming.
  ///
  /// Returns: A centered, scrollable [Widget] for modal display.
  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var scaling = themeData.scaling;
    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.leading != null)
          widget.leading!.iconXLarge().iconMutedForeground(),
        if (widget.title != null || widget.content != null)
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.title != null) widget.title!.large().semiBold(),
                if (widget.content != null) widget.content!.small().muted(),
              ],
            ).gap(8 * scaling),
          ),
        if (widget.trailing != null)
          widget.trailing!.iconXLarge().iconMutedForeground(),
      ],
    ).gap(16 * scaling);
    Widget d = ModalContainer(
      borderColor: Theme.of(context).colorScheme.border,
      borderRadius: themeData.borderRadiusXxl,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: content,
          ),
          if (widget.actions != null && widget.actions!.isNotEmpty)
            Stack(
              fit: StackFit.passthrough,
              alignment: Alignment.centerRight,
              children: [
                SizedBox(
                  height: 0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    hitTestBehavior: HitTestBehavior.deferToChild,
                    child: Opacity(
                      opacity: 0,
                      child: content,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ...join(widget.actions!, SizedBox(width: 8 * scaling))
                  ],
                )
              ],
            )
        ],
      ).gap(16 * scaling),
    ).blurIn;
    return Center(
      child: SingleChildScrollView(
          child: AnimatedPadding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        duration: 450.milliseconds,
        curve: Curves.easeOutCirc,
        child: d,
      )),
    );
  }
}

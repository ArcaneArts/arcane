import 'package:arcane/arcane.dart';

/// A flexible layout widget that arranges a list of [PanelButton] widgets in a horizontal wrap,
/// ideal for creating responsive button panels in the Arcane UI system. This component is commonly
/// used in forms, toolbars, or action sections where multiple buttons need to flow across available
/// space, adapting to screen size. It integrates seamlessly with [ArcaneTheme] for consistent styling
/// and pairs well with [Section] or [CardSection] for structured layouts.
class ButtonPanel extends StatelessWidget {
  /// Use [PanelButton]s
  final List<Widget> buttons;

  /// Creates a [ButtonPanel] with the required list of buttons.
  ///
  /// The [buttons] parameter accepts a list of [Widget]s, typically [PanelButton] instances,
  /// which are arranged in a [Wrap] layout. This constructor initializes the panel for immediate
  /// use in responsive UIs, ensuring buttons wrap naturally on smaller screens.
  const ButtonPanel({super.key, required this.buttons});

  @override
  Widget build(BuildContext context) => Wrap(
        children: [...buttons],
      );
}

/// A styled button widget designed for use within [ButtonPanel], featuring an icon, label, and
/// callback action. This component provides a compact, icon-leading button layout with responsive
/// sizing, making it suitable for control panels, navigation aids, or action menus in the Arcane
/// UI ecosystem. It leverages [FancyIcon] for enhanced visual appeal and [TextButton] for interaction,
/// ensuring theme consistency via [ArcaneTheme].
class PanelButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  /// Constructs a [PanelButton] with the specified icon, label, and press handler.
  ///
  /// - [icon] defines the leading icon displayed via [FancyIcon], providing visual identification.
  /// - [label] sets the textual description below the icon for accessibility and clarity.
  /// - [onPressed] is the callback executed on tap, enabling custom actions like navigation or
  ///   form submissions. The button automatically adjusts size based on screen width for mobile
  ///   and desktop responsiveness.
  const PanelButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      size: MediaQuery.of(context).size.width > 500
          ? ButtonSize.normal
          : ButtonSize.small,
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FancyIcon(icon: icon, size: 32),
          Gap(8),
          Text(label),
        ],
      ),
    );
  }
}

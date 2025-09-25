import 'package:arcane/arcane.dart';

/// A versatile section widget designed for use within [Collection] components in the Arcane Flutter UI system. It provides a structured container for organizing content, such as cards or lists, into logical sections with customizable headers. This widget integrates seamlessly with scrollable views, supporting both regular widgets and slivers, making it ideal for building dynamic, responsive layouts in applications like data-driven collections or dashboards.
///
/// Key features:
/// - Flexible header configuration with title, subtitle, leading/trailing widgets, and back button support.
/// - Expandable behavior for collapsible sections to manage screen space efficiently.
/// - Conditional rendering: Uses [GlassSection] for custom headers (e.g., glassmorphism effects) or [BarSection] for standard bar-based headers with navigation elements.
/// - Sliver compatibility via [SliverSignal] mixin, allowing conversion of non-sliver children to slivers for use in [CustomScrollView] or similar structures.
///
/// This widget fits into the broader UI component hierarchy by encapsulating content within [Collection] instances, often alongside components like [CardCarousel] for horizontal scrolling or [CardSection] for card-based subsections. It promotes modular design, enabling developers to compose complex UIs from reusable, documented building blocks.
///
/// Usage example:
/// ```dart
/// Section(
///   titleText: 'Featured Items',
///   subtitleText: 'Browse our latest collection',
///   child: CardCarousel(
///     children: [
///       // Add cards here
///     ],
///   ),
///   expandable: true,
/// )
/// ```
class Section extends StatelessWidget with SliverSignal {
  /// The primary content widget displayed within the section. This can be any [Widget], including slivers or regular widgets like [Column], [ListView], or other components such as [CardCarousel]. It is required and forms the core of the section's body.
  final Widget child;

  /// An optional title widget for the section header, allowing custom UI elements like [Text] or [RichText] to be placed prominently above the content.
  final Widget? title;

  /// An optional subtitle widget that provides secondary descriptive text or elements below the title in the header.
  final Widget? subtitle;

  /// An optional header widget for advanced customization of the top section area, which can include multiple elements or complex layouts.
  final Widget? header;

  /// An optional string-based title for the section, rendered as plain text in the header bar. Use this for simple textual titles when a custom [title] widget is not needed.
  final String? titleText;

  /// An optional string-based subtitle for additional context or description in the header.
  final String? subtitleText;

  /// An optional string-based header text for custom header labeling when using [BarSection].
  final String? headerText;

  /// A list of widgets to display on the leading (left) side of the header bar, such as icons, buttons, or navigation elements. Defaults to an empty list.
  final List<Widget> leading;

  /// A list of widgets to display on the trailing (right) side of the header bar, typically for actions like buttons or menus. Defaults to an empty list.
  final List<Widget> trailing;

  /// Controls the visibility and behavior of the back button in the header bar. Possible values include [BarBackButtonMode.never] (default, no back button), [BarBackButtonMode.auto] (shows if applicable), or [BarBackButtonMode.always] (forces display).
  final BarBackButtonMode backButton;

  /// An optional custom header widget that overrides the standard bar-based header. When provided, the section renders using [GlassSection] for a more stylized, glass-like appearance.
  final Widget? customHeader;

  /// Determines if the section is expandable, allowing users to collapse and expand the content via interaction. Defaults to false.
  final bool expandable;

  /// Specifies the initial expanded state of the section when [expandable] is true. Defaults to true (expanded).
  final bool initiallyExpanded;

  /// Constructs a new [Section] instance.
  ///
  /// The [child] parameter is required and defines the main content area. All other parameters are optional and customize the header and behavior.
  ///
  /// If [customHeader] is provided, the widget initializes a [GlassSection] with the custom header and converts the [child] to a sliver if necessary. Otherwise, it initializes a [BarSection] using the provided title, subtitle, leading, trailing, and back button configurations.
  ///
  /// Defaults:
  /// - [initiallyExpanded]: true (section starts expanded if expandable).
  /// - [expandable]: false (non-collapsible by default).
  /// - [backButton]: [BarBackButtonMode.never] (no back button shown).
  /// - [leading] and [trailing]: Empty lists [].
  ///
  /// The key parameter is inherited from [StatelessWidget] for widget identification in the tree.
  const Section({
    super.key,
    this.customHeader,
    this.initiallyExpanded = true,
    this.expandable = false,
    required this.child,
    this.backButton = BarBackButtonMode.never,
    this.title,
    this.subtitle,
    this.header,
    this.titleText,
    this.subtitleText,
    this.headerText,
    this.leading = const [],
    this.trailing = const [],
  });

  @override

  /// Builds and returns the [Section] widget.
  ///
  /// This method conditionally renders either a [GlassSection] or [BarSection] based on the presence of [customHeader]. If [customHeader] is non-null, it uses [GlassSection] with the custom header and the [child] (converted to sliver if needed). Otherwise, it uses [BarSection] configured with the title, subtitle, leading, trailing, back button, and expandability settings.
  ///
  /// The [child] is checked for sliver compatibility using [isSliver]; if not a sliver, it is wrapped via [toSliver] with `fillRemaining: false` to preserve original sizing in scroll views.
  ///
  /// No side effects; purely declarative rendering based on provided properties. Returns a sliver-compatible widget for integration into scrollable parents like those in [Collection].
  Widget build(BuildContext context) => customHeader != null
      ? GlassSection(
          sliver: child.isSliver(context)
              ? child
              : child.toSliver(context, fillRemaining: false),
          header: customHeader!)
      : BarSection(
          expandable: expandable,
          initiallyExpanded: initiallyExpanded,
          titleText: titleText,
          subtitleText: subtitleText,
          headerText: headerText,
          title: title,
          subtitle: subtitle,
          header: header,
          leading: leading,
          trailing: trailing,
          backButton: backButton,
          sliver: child.isSliver(context)
              ? child
              : child.toSliver(context, fillRemaining: false));
}

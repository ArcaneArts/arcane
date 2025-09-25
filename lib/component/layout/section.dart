import 'package:arcane/arcane.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

/// A [SliverStickyHeader] wrapper that applies a [Glass] effect to the header,
/// providing a translucent, frosted glass appearance for section headers in the
/// Arcane UI system. This component is ideal for creating visually appealing,
/// sticky headers in scrollable lists or slivers that integrate seamlessly with
/// [ArcaneTheme] and respond to context signals like translucency.
class GlassSection extends StatelessWidget {
  final Widget sliver;
  final Widget header;

  /// Creates a [GlassSection] with the required [sliver] content and [header].
  ///
  /// The [sliver] represents the scrollable body content, while the [header]
  /// is the sticky element that gains a glass effect when pinned. This
  /// constructor initializes the widget for use in sliver-based layouts,
  /// ensuring the header adapts to pinned states and translucency from the
  /// [ArcaneTheme].
  const GlassSection({super.key, required this.sliver, required this.header});

  /// Builds the [SliverStickyHeader] with a [Glass]-wrapped header that
  /// dynamically adjusts based on pin state and context translucency.
  ///
  /// When the header is pinned, it applies a glass effect; otherwise, it remains
  /// transparent in translucent contexts. This method handles the sticky behavior
  /// and visual integration with the Arcane UI, returning a sliver widget suitable
  /// for [CustomScrollView] or similar sliver containers.
  @override
  Widget build(BuildContext context) => SliverStickyHeader.builder(
        builder: (context, state) => Glass(
          ignoreContextSignals: true,
          disabled: !state.isPinned,
          disabledColor: context.isTranslucent ? Colors.transparent : null,
          child: header,
        ),
        sliver: sliver,
      );
}

/// An expandable [SliverStickyHeader] section that uses a [Bar] for the header
/// and supports dynamic expansion/collapse via [MutablePylon] state management.
/// This component is designed for collapsible sections in scrollable UIs,
/// integrating with [ArcaneTheme] for sidebar responsiveness and providing
/// smooth animations for content visibility in the Arcane UI system.
class ExpansionBarSection extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? header;
  final String? titleText;
  final String? subtitleText;
  final String? headerText;
  final List<Widget> leading;
  final List<Widget> trailing;
  final Widget sliver;
  final BarBackButtonMode backButton;
  final bool initiallyExpanded;

  /// Initializes an [ExpansionBarSection] with optional title, subtitle, and header elements,
  /// along with text fallbacks and leading/trailing widgets.
  ///
  /// The [sliver] is the required content body. [backButton] controls navigation behavior,
  /// defaulting to never showing. [initiallyExpanded] sets the starting state (default true).
  /// Leading and trailing lists allow custom icons or actions, with trailing dynamically
  /// including an expand/collapse chevron based on sidebar expansion from [ArcaneTheme].
  ExpansionBarSection(
      {super.key,
      this.backButton = BarBackButtonMode.never,
      this.title,
      required this.sliver,
      this.subtitle,
      this.header,
      this.titleText,
      this.subtitleText,
      this.headerText,
      this.leading = const [],
      this.trailing = const [],
      this.initiallyExpanded = true});

  /// Builds the expandable [SliverStickyHeader] using [MutablePylon] for state
  /// and [SliverAnimatedPaintExtent] for smooth expansion animations.
  ///
  /// The header is a tappable [GhostButton] wrapping a [Bar] that toggles expansion
  /// state, updating the chevron icon and visibility of the [sliver] content.
  /// Integrates with [ArcaneTheme] for sidebar-aware layout and uses [SliverVisibility]
  /// to conditionally show/hide the sliver based on the expansion state.
  @override
  Widget build(BuildContext context) => MutablePylon<ExpansionBarState>(
        local: true,
        value: ExpansionBarState(initiallyExpanded),
        builder: (context) {
          Widget icon = context.streamPylon<ExpansionBarState>().buildNullable(
              (state) => (state?.expanded ?? true)
                  ? const Icon(Icons.chevron_up_ionic)
                  : const Icon(Icons.chevron_down_ionic));

          return SliverStickyHeader.builder(
            builder: (context, state) => GhostButton(
                density: ButtonDensity.compact,
                onPressed: () => context.modPylon<ExpansionBarState>(
                    (i) => ExpansionBarState(!i.expanded)),
                child: Bar(
                  ignoreContextSignals: true,
                  useGlass: state.isPinned,
                  backButton: backButton,
                  title: context.isSidebarExpandedOrAbsent ? title : icon,
                  header: header,
                  subtitle: subtitle,
                  titleText: titleText,
                  subtitleText: subtitleText,
                  headerText: headerText,
                  leading: leading,
                  trailing: [
                    ...trailing,
                    if (context.isSidebarExpandedOrAbsent) icon
                  ],
                )),
            sliver: SliverAnimatedPaintExtent(
                duration: Duration(milliseconds: 333),
                curve: Curves.easeOutCirc,
                child: context
                    .streamPylon<ExpansionBarState>()
                    .buildNullable((state) => SliverVisibility(
                          visible: (state?.expanded ?? true),
                          sliver: sliver,
                        ))),
          );
        },
      );
}

/// Immutable state holder for tracking the expansion status of an
/// [ExpansionBarSection] in the Arcane UI system.
///
/// Used with [MutablePylon] to manage collapsible section behavior,
/// allowing reactive updates to visibility and icon states in response
/// to user interactions.
class ExpansionBarState {
  final bool expanded;

  /// Creates an [ExpansionBarState] with the specified [expanded] flag.
  ///
  /// This constructor is const for efficient widget rebuilding in stateful
  /// contexts like [MutablePylon], where expansion toggles trigger UI updates.
  const ExpansionBarState(this.expanded);
}

/// A flexible [SliverStickyHeader] section that can be either static or expandable,
/// using [Bar] for the header and optionally delegating to [ExpansionBarSection]
/// for collapsible behavior. This component provides a unified way to create
/// sticky sections in scrollable UIs, integrating with [ArcaneTheme] for glass
/// effects, back buttons, and sidebar responsiveness in the Arcane UI system.
class BarSection extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? header;
  final String? titleText;
  final String? subtitleText;
  final String? headerText;
  final List<Widget> leading;
  final List<Widget> trailing;
  final Widget sliver;
  final BarBackButtonMode backButton;
  final bool expandable;
  final bool initiallyExpanded;

  /// Creates a non-expandable [BarSection] with optional title, subtitle, and header elements.
  ///
  /// The [sliver] is the required content body. [backButton] controls navigation (default never).
  /// [expandable] defaults to false for static sections. Leading and trailing allow custom widgets.
  const BarSection(
      {super.key,
      this.backButton = BarBackButtonMode.never,
      this.title,
      required this.sliver,
      this.subtitle,
      this.header,
      this.titleText,
      this.subtitleText,
      this.headerText,
      this.leading = const [],
      this.expandable = false,
      this.initiallyExpanded = true,
      this.trailing = const []});

  /// Creates an expandable [BarSection] that delegates to [ExpansionBarSection].
  ///
  /// This named constructor sets [expandable] to true and initializes with the
  /// provided parameters, enabling collapsible behavior with [initiallyExpanded]
  /// state (default true) for dynamic content visibility in interactive UIs.
  const BarSection.expandable(
      {super.key,
      this.backButton = BarBackButtonMode.never,
      this.title,
      required this.sliver,
      this.subtitle,
      this.header,
      this.titleText,
      this.subtitleText,
      this.headerText,
      this.leading = const [],
      this.initiallyExpanded = true,
      this.trailing = const []})
      : expandable = true;

  /// Builds either a static [SliverStickyHeader] or delegates to [ExpansionBarSection]
  /// based on the [expandable] flag.
  ///
  /// For static sections, it uses a [Bar] header with glass effects on pin state.
  /// For expandable ones, it leverages [ExpansionBarSection] for state management
  /// and animations, ensuring seamless integration with [ArcaneTheme] and sliver
  /// layouts like [CustomScrollView].
  @override
  Widget build(BuildContext context) => expandable
      ? ExpansionBarSection(
          title: title,
          subtitle: subtitle,
          header: header,
          titleText: titleText,
          subtitleText: subtitleText,
          headerText: headerText,
          leading: leading,
          trailing: trailing,
          sliver: sliver,
          backButton: backButton,
          initiallyExpanded: initiallyExpanded,
        )
      : SliverStickyHeader.builder(
          builder: (context, state) => Bar(
            ignoreContextSignals: true,
            useGlass: state.isPinned,
            backButton: backButton,
            title: title,
            header: header,
            subtitle: subtitle,
            titleText: titleText,
            subtitleText: subtitleText,
            headerText: headerText,
            leading: leading,
            trailing: trailing,
          ),
          sliver: sliver,
        );
}

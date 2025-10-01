import 'package:arcane/arcane.dart';

/// An abstract foundation for Arcane screens that provides a consistent structure integrating with [ArcaneApp], [NavigationScreen], and [Sidebar].
/// This class serves as the base for all screen widgets in the Arcane UI library, supporting both sliver and non-sliver content layouts.
/// Key features include customizable headers via [Bar] or [AppBar], sidebars for navigation, floating action buttons ([FloatingActionButton]), and loading indicators.
/// It ensures efficient rebuilds through const constructors and optional slivers for performance in scrollable views.
/// Usage: Extend for concrete screens like [ChatScreen] or [FillScreen], providing body content via [CenterBody] or [Section], and theme integration via [ArcaneTheme].
/// Integrates with [SafeArea] for edge handling and supports [SliverAppBar] in sliver mode for advanced scrolling behaviors.
class Screen extends AbstractStatelessScreen {
  final Widget child;
  final PylonBuilder? sidebar;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final ScrollController? sidebarController;
  final String? title;
  final String? subtitle;
  final List<Widget>? actions;
  final BarBackButtonMode backButtonMode;

  const Screen({
    super.overrideBackgroundColor,
    super.key,
    super.background,
    super.fab,
    super.footer,
    super.header,
    super.gutter,
    super.loadingProgress,
    super.loadingProgressIndeterminate,
    super.showLoadingSparks,
    super.foreground,
    this.sidebar,
    this.scrollController,
    this.sidebarController,
    this.physics,
    this.title,
    this.subtitle,
    this.actions,
    this.backButtonMode = BarBackButtonMode.always,
    this.child = const Collection(),
  });

  /// Builds the screen widget, automatically selecting [SliverScreen] for sliver content or [FillScreen] for regular widgets.
  /// Conditionally constructs a [Bar] header if title, subtitle, or actions are provided, integrating with [AppBar] semantics.
  /// Applies [ArcaneTheme] for styling, supports [BottomNavigationBar] via navigation context, and enables efficient scrolling with custom physics and controllers.
  /// For sliver content, leverages [SliverAppBar] compatibility; for non-sliver, uses [SafeArea] wrapping implicitly through [FillScreen].
  /// This method promotes extensibility by delegating body rendering while handling layout orchestration for optimal performance in large UIs.
  @override
  Widget build(BuildContext context) => child.isSliver(context)
      ? SliverScreen(
          sliver: child,
          overrideBackgroundColor: overrideBackgroundColor,
          fab: fab,
          footer: footer,
          header: header ??
              ((title != null || subtitle != null || actions != null)
                  ? Bar(
                      backButton: backButtonMode,
                      titleText: title,
                      subtitleText: subtitle,
                      trailing: actions ?? [],
                    )
                  : null),
          gutter: gutter,
          loadingProgress: loadingProgress,
          loadingProgressIndeterminate: loadingProgressIndeterminate,
          showLoadingSparks: showLoadingSparks,
          foreground: foreground,
          background: background,
          sidebar: sidebar,
          scrollController: scrollController,
          sidebarController: sidebarController,
          physics: physics,
        )
      : FillScreen(
          fab: fab,
          overrideBackgroundColor: overrideBackgroundColor,
          // fab: fab,
          footer: footer,
          header: header ??
              ((title != null || subtitle != null || actions != null)
                  ? Bar(
                      backButton: backButtonMode,
                      titleText: title,
                      subtitleText: subtitle,
                      trailing: actions ?? [],
                    )
                  : null),
          gutter: gutter,
          loadingProgress: loadingProgress,
          loadingProgressIndeterminate: loadingProgressIndeterminate,
          showLoadingSparks: showLoadingSparks,
          foreground: foreground,
          background: background,
          sidebar: sidebar,
          child: child,
        );
}

/// Abstract base class for stateful screens in Arcane, providing shared properties for UI consistency and extensibility.
/// Serves as the foundation for interactive screens that require state management, integrating with [ArcaneTheme] for theming and [Sidebar] for navigation.
/// Key features: Optional floating action button ([FloatingActionButton]), header/footer slots for [AppBar] or custom widgets, background/foreground overlays, and loading progress indicators.
/// Ensures performance through optional gutter spacing and indeterminate loading states, suitable for dynamic content like forms or lists.
/// Usage: Extend in concrete implementations like animated [ChatScreen], providing state logic while inheriting layout scaffolding.
/// Integrates with [NavigationScreen] for routing and [BottomNavigationBar] for tabbed navigation, supporting sliver extensions via subclasses.
abstract class AbstractStatefulScreen extends StatefulWidget {
  final Widget? fab;
  final bool? gutter;
  final Widget? header;
  final Widget? footer;
  final Widget? foreground;
  final Widget? background;
  final double? loadingProgress;
  final bool loadingProgressIndeterminate;
  final bool showLoadingSparks;
  final Color? overrideBackgroundColor;

  const AbstractStatefulScreen({
    super.key,
    this.overrideBackgroundColor,
    this.fab,
    this.foreground,
    this.background,
    this.gutter,
    this.header,
    this.footer,
    this.loadingProgress,
    this.loadingProgressIndeterminate = false,
    this.showLoadingSparks = false,
  });
}

/// Abstract base class for stateless screens in Arcane, offering a lightweight foundation for static or computed UIs.
/// Provides essential properties for screen composition, such as header ([Bar] or [AppBar]), footer, and sidebar integration with [Sidebar].
/// Key features: Customizable loading progress with sparks animation, background/foreground layers, and override for background color via [ArcaneTheme].
/// Promotes efficient rebuilds with const constructors and minimal widget tree depth, ideal for performance-sensitive views.
/// Usage: Extend for read-only screens like [FillScreen], injecting body content and actions; supports [CenterBody] or [Section] for structured layouts.
/// Integrates with [SafeArea] implicitly and [SliverAppBar] through sliver-aware subclasses, enabling seamless navigation in [ArcaneApp].
abstract class AbstractStatelessScreen extends StatelessWidget {
  final Widget? fab;
  final bool? gutter;
  final Widget? header;
  final Widget? footer;
  final Widget? foreground;
  final Widget? background;
  final double? loadingProgress;
  final bool loadingProgressIndeterminate;
  final bool showLoadingSparks;
  final Color? overrideBackgroundColor;

  const AbstractStatelessScreen({
    super.key,
    this.overrideBackgroundColor,
    this.fab,
    this.foreground,
    this.background,
    this.gutter,
    this.header,
    this.footer,
    this.loadingProgress,
    this.loadingProgressIndeterminate = false,
    this.showLoadingSparks = false,
  });
}

/// Utility widget for injecting footers into Arcane screens, enabling dynamic footer content via [PylonBuilder].
/// Allows screens like [NavigationScreen] to provide contextual footers (e.g., [BottomNavigationBar]) that can be accessed and rendered.
/// Key features: Local pylon scoping for efficient dependency injection without global state, supporting performance in nested UIs.
/// Usage: Wrap screen content with this to provide footers; retrieve via static methods in concrete screens for integration with [ArcaneTheme] and actions.
/// Integrates with [FillScreen] or [SliverScreen] for layout, ensuring footers appear below body content like [Section] or lists.
class InjectScreenFooter extends StatelessWidget {
  final PylonBuilder footer;
  final PylonBuilder builder;

  /// Retrieves the [InjectScreenFooter] instance from the current build context using pylon dependency injection.
  /// Returns null if no footer injector is present, allowing graceful fallback in screen hierarchies.
  /// Usage: Call in screen build methods to access injected footers for rendering in [FillScreen] or [SliverScreen].
  static InjectScreenFooter? getFooter(BuildContext context) =>
      context.pylonOr<InjectScreenFooter>();

  /// Builds and returns the footer widget from the injected [InjectScreenFooter], or null if unavailable.
  /// Facilitates dynamic footer rendering, integrating with [ArcaneTheme] for styled components like buttons or navigation.
  /// Usage: Invoke in screen layouts to conditionally display footers, enhancing extensibility for custom UIs.
  static Widget? getFooterWidget(BuildContext context) =>
      getFooter(context)?.footer(context);

  const InjectScreenFooter(
      {super.key, required this.footer, required this.builder});

  /// Constructs the pylon-injected widget tree, providing the footer builder to descendants.
  /// Ensures local scoping for performance, avoiding unnecessary rebuilds in parent screens like [ChatScreen].
  /// Integrates with [Pylon] for dependency resolution, supporting [Sidebar] or action footers.
  @override
  Widget build(BuildContext context) => Pylon<InjectScreenFooter?>(
        local: true,
        value: this,
        builder: builder,
      );
}

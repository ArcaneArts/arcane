import 'package:arcane/arcane.dart';

/// A full-view screen widget that extends [AbstractScreen] to provide content-filling layouts optimized for Arcane UI applications.
///
/// FillScreen creates a flexible, expansive screen ideal for content-heavy interfaces, integrating seamlessly with [ArcaneApp] for theming via [ArcaneTheme] and navigation elements like [Sidebar]. It supports a required [child] widget that occupies the main body area, optionally enhanced by [CenterBody] for centered content or direct flexible [Widget] children. Key features include:
/// - Efficient full-screen expansion using [Expanded] and [Flexible] for minimal layout overhead.
/// - Integration with [SafeArea] for edge handling and [Scaffold] for structural integrity.
/// - Optional sidebar via [PylonBuilder] for contextual navigation, propagating themes from [ColorScheme].
/// - Support for headers, footers, FABs, and backgrounds while maintaining performance through const construction and inline optimizations.
///
/// Usage: Wrap content in FillScreen within [ArcaneApp] routes for simple, performant screens that fill available space without unnecessary nesting.
class FillScreen extends AbstractStatelessScreen {
  final Widget child;
  final PylonBuilder? sidebar;

  const FillScreen({
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
    required this.child,
  });

  /// Constructs a FillScreen with a required [child] widget that fills the main content area.
  ///
  /// - The [child] is a required [Widget] (e.g., [CenterBody] or custom flexible content) that expands to fill the screen body.
  /// - Optional [sidebar] provides a [PylonBuilder] for injecting sidebar content, integrating with [Sidebar] for navigation.
  /// - Inherits parameters from [AbstractScreen] for background ([background]), foreground ([foreground]), header ([header]), footer ([footer]), FAB ([fab]), gutter ([gutter]), and loading indicators ([loadingProgress], [loadingProgressIndeterminate], [showLoadingSparks]).
  /// - [overrideBackgroundColor] allows custom [ColorScheme] overrides for theme propagation.
  ///
  /// Emphasizes simplicity for content-heavy screens with efficient filling via [Expanded] and low-overhead const initialization.
  @override
  Widget build(BuildContext context) {
    /// Builds the screen layout using a full-screen [Scaffold] wrapped in [Expanded] for flexible content filling.
    ///
    /// Constructs a [Row] layout optionally including a sidebar via [PylonBuilder], followed by an [Expanded] [Scaffold] that:
    /// - Applies [overrideBackgroundColor] and handles navigation types ([NavigationType.drawer]) for primary content.
    /// - Stacks background ([background]) with content using [Stack] and [PylonRemove] for injector isolation ([InjectScreenFooter], [ArcaneSidebarInjector]).
    /// - Uses [Column] with [SafeArea] and [GlassStopper] for header/footer placement, ensuring theme propagation from [ArcaneTheme].
    /// - Centers the [child] in a [BackdropGroup] within [Gutter], supporting [fab] via [FabSocket] and [foreground] overlays.
    /// - Optimizes performance with [StackFit.expand] and [StackFit.passthrough] for minimal rebuilds in content-heavy scenarios.
    ///
    /// Integrates [Container]-like expansion for full layouts, referencing [Expanded], [Flexible], [SafeArea], and [ColorScheme] for efficient, theme-aware rendering.
    Widget? footer = this.footer ?? InjectScreenFooter.getFooterWidget(context);
    PylonBuilder? isidebar = context.pylonOr<ArcaneSidebarInjector>()?.builder;
    PylonBuilder? sidebar = this.sidebar ?? isidebar;
    Widget s = Row(
      children: [
        if (sidebar != null) sidebar(context),
        Expanded(
            child: Scaffold(
                overrideBackgroundColor: overrideBackgroundColor,
                primary:
                    context.pylonOr<NavigationType>() != NavigationType.drawer,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (background != null)
                      PylonRemove<InjectScreenFooter>(
                          builder: (context) =>
                              PylonRemove<ArcaneSidebarInjector>(
                                  builder: (context) => background!)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (header != null)
                          SafeBar(
                              top: true,
                              builder: (context) => GlassStopper(
                                  builder: (context) => PylonRemove<
                                          InjectScreenFooter>(
                                      builder: (context) =>
                                          PylonRemove<ArcaneSidebarInjector>(
                                              builder: (context) => header!)),
                                  stopping: false)),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Stack(
                                fit: StackFit.passthrough,
                                children: [
                                  Positioned.fill(
                                      child: PylonRemove<InjectScreenFooter>(
                                          builder: (context) => PylonRemove<
                                                  ArcaneSidebarInjector>(
                                              builder: (context) => Gutter(
                                                  enabled: gutter ??
                                                      ArcaneTheme.of(context)
                                                          .gutter
                                                          .enabled,
                                                  child: footer != null
                                                      ? BackdropGroup(
                                                          child: child)
                                                      : BackdropGroup(
                                                          child: child))))),
                                  if (fab != null)
                                    FabSocket(
                                        child: PylonRemove<InjectScreenFooter>(
                                            builder: (context) => PylonRemove<
                                                    ArcaneSidebarInjector>(
                                                builder: (context) => fab!))),
                                  if (foreground != null)
                                    PylonRemove<InjectScreenFooter>(
                                        builder: (context) =>
                                            PylonRemove<ArcaneSidebarInjector>(
                                                builder: (context) =>
                                                    foreground!)),
                                ],
                              ),
                            ),
                            if (footer != null)
                              SafeBar(
                                  bottom: true,
                                  builder: (context) => GlassStopper(
                                      builder: (context) =>
                                          PylonRemove<InjectScreenFooter>(
                                              builder: (context) => PylonRemove<
                                                      ArcaneSidebarInjector>(
                                                  builder: (context) =>
                                                      footer)),
                                      stopping: false)),
                          ],
                        ))
                      ],
                    )
                  ],
                )))
      ],
    );
    
    return s;
  }
}

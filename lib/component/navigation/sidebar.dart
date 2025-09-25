import 'package:arcane/arcane.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

/// Defines the possible states of the [ArcaneSidebar] in Arcane UI,
/// enabling responsive navigation layouts that integrate with [BottomNavigationBar]
/// for seamless app-wide navigation flows.
///
/// - [expanded]: The sidebar is fully visible, displaying labels and content for detailed navigation.
/// - [collapsed]: The sidebar is minimized to icons only, optimizing screen space in compact views.
enum ArcaneSidebarState {
  expanded,
  collapsed,
}

List<Widget> _defWList(BuildContext context) => [];
Widget _defSliver(BuildContext context) => SliverToBoxAdapter();

extension XArcaneSidebarStatePylon on BuildContext {
  bool get isSidebarExpanded =>
      pylonOr<ArcaneSidebarState>() == ArcaneSidebarState.expanded;
  bool get isSidebarExpandedOrAbsent =>
      (pylonOr<ArcaneSidebarState>() ?? ArcaneSidebarState.expanded) ==
      ArcaneSidebarState.expanded;
}

/// A utility class for reserving arbitrary vertical space in [ArcaneSidebar] headers,
/// ensuring consistent layout and preventing shifts when conditional content like
/// [ArcaneSidebarHeader] is rendered or hidden, promoting smooth animations
/// and performance in [CustomScrollView] integrations.
class ArbitraryHeaderSpace {
  final double height;

  const ArbitraryHeaderSpace(this.height);
}

/// A collapsible sidebar navigation component for Arcane UI applications,
/// providing a space-efficient side menu that integrates seamlessly with [BottomNavigationBar]
/// for comprehensive app navigation. Supports theming via [ArcaneTheme], content sections
/// using [Section], and smooth animations for expansion/collapse. Designed for performance
/// with minimal rebuilds using Pylon state management and [AnimatedSize].
///
/// Key features:
/// - Dual mode: Standard widget or sliver for use in [CustomScrollView] within [NavigationScreen].
/// - Customizable width, animation curves, and durations for fluid user interactions.
/// - Optional header and footer builders for dynamic content, e.g., [ArcaneSidebarHeader] and [ArcaneSidebarFooter].
/// - Divider support for visual separation from main content areas like [Glass] panels.
/// - Integrates with [ArcaneApp] for full-screen navigation and [IconButton] for actions.
///
/// Usage: Employ in [ArcaneApp] side panels or [NavigationScreen] for hierarchical navigation,
/// pairing with [ArcaneSidebarButton] for selectable items to maintain theme consistency
/// and avoid layout jumps.
class ArcaneSidebar extends StatefulWidget {
  final List<Widget> Function(BuildContext context) children;
  final PylonBuilder sliver;
  final bool _isSliver;
  final double width;
  final double collapsedWidth;
  final PylonBuilder? footer;
  final PylonBuilder? header;
  final Curve expansionAnimationCurve;
  final Duration expansionAnimationDuration;
  final bool sidebarDivider;

  /// Creates a standard non-sliver [ArcaneSidebar] widget for direct use in layouts.
  ///
  /// The {children} parameter is a builder function returning a [List]<[Widget]> of sidebar content,
  /// typically [ArcaneSidebarButton] instances or [Section] dividers for organized navigation items,
  /// initialized responsively based on [ArcaneTheme] and current [BuildContext].
  ///
  /// {header} is an optional [PylonBuilder] for custom top content, such as [ArcaneSidebarHeader],
  /// allowing integration with user profiles or search via [IconButton].
  ///
  /// {footer} is an optional [PylonBuilder] for bottom content, like [ArcaneSidebarFooter] with toggles.
  ///
  /// {width} sets the expanded width (default: 250), while {collapsedWidth} sets the minimized width (default: 52),
  /// both respecting [ArcaneTheme] spacing for consistent sizing.
  ///
  /// {expansionAnimationCurve} (default: [Curves.easeOutCirc]) and {expansionAnimationDuration}
  /// (default: 333ms) control the smooth transition, ensuring performant animations without jank.
  ///
  /// {sidebarDivider} (default: true) adds a subtle vertical line using [Theme.of(context).colorScheme.muted]
  /// for separation from adjacent [Glass] or main content.
  const ArcaneSidebar({
    super.key,
    this.header,
    this.width = 250,
    this.expansionAnimationCurve = Curves.easeOutCirc,
    this.expansionAnimationDuration = const Duration(milliseconds: 333),
    this.footer,
    this.collapsedWidth = 52,
    this.sidebarDivider = true,
    required this.children,
  })  : _isSliver = false,
        sliver = _defSliver;

  const ArcaneSidebar.sliver(
      {super.key,
      this.header,
      this.sidebarDivider = true,
      this.width = 250,
      this.expansionAnimationCurve = Curves.easeOutCirc,
      this.expansionAnimationDuration = const Duration(milliseconds: 333),
      this.footer,
      this.collapsedWidth = 50,
      required this.sliver})
      : _isSliver = true,
        children = _defWList;

  @override
  State<ArcaneSidebar> createState() => _ArcaneSidebarState();
}

/// Internal state class for [ArcaneSidebar], managing dynamic sizing of header and footer
/// to prevent layout shifts during state changes, and orchestrating the build process
/// with Pylon for reactive updates. Ensures efficient rendering by measuring sizes
/// post-frame and limiting setState invocations, integrating [AnimatedSize] and
/// [CustomScrollView] for smooth, theme-aware navigation in [ArcaneApp].
class _ArcaneSidebarState extends State<ArcaneSidebar> {
  GlobalKey footerKey = GlobalKey();
  GlobalKey headerKey = GlobalKey();
  double footerSize = 0;
  double headerSize = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateFooterSize();
      updateHeaderSize();
      setState(() {});
    });
  }

  /// Dynamically updates the footer height by measuring the [GlobalKey]'s render box,
  /// returning true if the size changed to trigger targeted rebuilds only when necessary,
  /// optimizing performance in dynamic [ArcaneSidebar] layouts with variable footer content
  /// like [ArcaneSidebarFooter].
  bool updateFooterSize() {
    try {
      double v = footerKey.currentContext?.size?.height ?? 0;
      if (v != footerSize) {
        footerSize = v;
        return true;
      }
    } catch (ignored) {}
    return false;
  }

  /// Dynamically updates the header height by measuring the [GlobalKey]'s render box,
  /// returning true if the size changed to trigger targeted rebuilds only when necessary,
  /// supporting responsive [ArcaneSidebarHeader] rendering without unnecessary full rebuilds
  /// in [CustomScrollView] contexts.
  bool updateHeaderSize() {
    try {
      double v = headerKey.currentContext?.size?.height ?? 0;
      if (v != headerSize) {
        headerSize = v;
        return true;
      }
    } catch (ignored) {}
    return false;
  }

  /// Constructs the core content sliver or list for [ArcaneSidebar], delegating to
  /// the appropriate builder based on sliver mode, ensuring compatibility with
  /// [SliverStickyHeader] and [CustomScrollView] for performant scrolling
  /// integrated with [NavigationScreen].
  Widget buildSliverContent(BuildContext context) => widget._isSliver
      ? widget.sliver(context)
      : SListView(
          children: widget.children(context),
        );

  /// Renders the complete [ArcaneSidebar] with animation and state management,
  /// using [Pylon] to listen for [ArcaneSidebarState] changes and [AnimatedSize]
  /// for width transitions. Positions header/footer via [SliverStickyHeader] and
  /// absolute layout to avoid scroll interference, includes optional divider for
  /// theming separation, and supports custom [SidebarScrollController] for external
  /// scroll control. Integrates [Glass] effects implicitly through [ArcaneTheme]
  /// for modern, performant navigation in [ArcaneApp] with [BottomNavigationBar].
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (updateFooterSize() || updateHeaderSize()) {
        setState(() {});
      }
    });

    return AnimatedSize(
      alignment: Alignment.centerLeft,
      duration: widget.expansionAnimationDuration,
      curve: widget.expansionAnimationCurve,
      child: context
          .streamPylon<ArcaneSidebarState>()
          .build((sbs) => Pylon<ArcaneSidebarState>(
                value: sbs,
                builder: (context) => Stack(
                  children: [
                    SizedBox(
                      width: context.isSidebarExpanded
                          ? widget.width
                          : widget.collapsedWidth,
                      child: CustomScrollView(
                          controller: context
                              .pylonOr<SidebarScrollController>()
                              ?.controller,
                          slivers: [
                            SliverStickyHeader.builder(
                                builder: (context, _) => widget.header != null
                                    ? KeyedSubtree(
                                        key: headerKey,
                                        child: KeyedSubtree(
                                          child: widget.header!(context),
                                          key: ValueKey(sbs),
                                        ))
                                    : SizedBox(height: 0),
                                sliver: MultiSliver(
                                  children: [
                                    buildSliverContent(context),
                                    SliverToBoxAdapter(
                                      child: SizedBox(height: footerSize),
                                    ),
                                  ],
                                ))
                          ]),
                    ),
                    if (widget.footer != null)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: KeyedSubtree(
                            key: footerKey, child: widget.footer!(context)),
                      ),
                    if (widget.sidebarDivider)
                      Positioned(
                          top: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            color: Theme.of(context).colorScheme.muted,
                            width: 1,
                          )),
                  ],
                ),
              )),
    );
  }
}

/// A responsive header component for [ArcaneSidebar], adapting content visibility
/// based on expansion state via Pylon. Built on [Bar] for structured title, actions,
/// and back navigation, with optional [Glass] blur for elevated appearance.
///
/// Key features:
/// - Collapses to minimal view in narrow states, using {collapsedBuilder} for custom icons.
/// - Supports leading/trailing widgets like [IconButton] for actions or menus.
/// - Integrates [ArcaneTheme] for colors, spacing, and typography in titles/subtitles.
/// - Back button modes ([BarBackButtonMode]) for navigation history in [NavigationScreen].
///
/// Usage: Provide as {header} to [ArcaneSidebar] for top-level branding or search integration,
/// ensuring no layout shifts with [ArbitraryHeaderSpace] if conditional.
class ArcaneSidebarHeader extends StatelessWidget {
  final List<Widget> trailing;
  final List<Widget> leading;
  final Widget? child;
  final Widget? title;
  final Widget? barHeader;
  final Widget? barFooter;
  final String? titleText;
  final String? headerText;
  final String? subtitleText;
  final Widget? header; // small widget placed on top of title
  final Widget? subtitle; // small widget placed below title
  final bool
      trailingExpanded; // expand the trailing instead of the main content
  final Alignment alignment;
  final Color? backgroundColor;
  final double? leadingGap;
  final double? trailingGap;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final bool useGlass;
  final BarBackButtonMode backButton;
  final bool ignoreContextSignals;
  final BarActions? actions;
  final PylonBuilder? collapsedBuilder;

  const ArcaneSidebarHeader(
      {super.key,
      this.ignoreContextSignals = true,
      this.trailing = const [],
      this.leading = const [],
      this.titleText,
      this.backButton = BarBackButtonMode.never,
      this.headerText,
      this.subtitleText,
      this.title,
      this.actions,
      this.collapsedBuilder,
      this.header,
      this.subtitle,
      this.child,
      this.trailingExpanded = false,
      this.alignment = Alignment.center,
      this.padding,
      this.backgroundColor,
      this.leadingGap,
      this.trailingGap,
      this.height,
      this.barHeader,
      this.barFooter,
      this.useGlass = true});

  @override
  Widget build(BuildContext context) {
    bool e = context.isSidebarExpanded;

    if (collapsedBuilder != null && !e) {
      return collapsedBuilder!(context);
    }

    return Bar(
      title:
          !e ? null : (title ?? (titleText != null ? Text(titleText!) : null)),
      subtitle: !e
          ? null
          : (subtitle ?? (subtitleText != null ? Text(subtitleText!) : null)),
      header: !e ? null : header,
      actions: !e ? null : actions,
      backButton: backButton,
      barHeader: !e ? null : barHeader,
      barFooter: !e ? null : barFooter,
      trailing: !e ? const [] : trailing,
      leading: leading,
      trailingExpanded: trailingExpanded,
      alignment: alignment,
      backgroundColor: backgroundColor,
      leadingGap: leadingGap,
      trailingGap: trailingGap,
      padding: padding,
      height: height,
      useGlass: useGlass,
      ignoreContextSignals: ignoreContextSignals,
      titleText: !e ? null : titleText,
      headerText: !e ? null : headerText,
      subtitleText: !e ? null : subtitleText,
      child: !e ? null : child,
    );
  }
}

/// A bottom footer component for [ArcaneSidebar], providing a fixed-position panel
/// with divider separation and trailing actions like expansion toggle.
/// Uses [SurfaceCard] for subtle elevation and integrates [ArcaneTheme] colors.
///
/// {content} is the main left-aligned widget, visible only when expanded, e.g., user info or quick links.
///
/// {trailing} is the right-aligned widget (default: [ArcaneSidebarExpansionToggle]), for controls
/// like [IconButton] or menus, ensuring accessibility in navigation flows with [BottomNavigationBar].
///
/// Usage: Pass as {footer} to [ArcaneSidebar] for persistent bottom navigation or settings,
/// maintaining performance by avoiding scroll inclusion.
class ArcaneSidebarFooter extends StatelessWidget {
  final Widget content;
  final Widget trailing;

  // Cant be const because pylon
  // ignore: prefer_const_constructors_in_immutables
  ArcaneSidebarFooter(
      {super.key,
      this.trailing = const ArcaneSidebarExpansionToggle(),
      this.content = const SizedBox.shrink()});

  @override
  Widget build(BuildContext context) => SurfaceCard(
      padding: const EdgeInsets.all(0),
      borderRadius: BorderRadius.zero,
      borderColor: Colors.transparent,
      borderWidth: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (context.isSidebarExpanded) content.padLeft(8),
              Spacer(),
              trailing
            ],
          ).pad(8)
        ],
      ));
}

/// Default trailing toggle for [ArcaneSidebarFooter], rendering chevron icons
/// that respond to [ArcaneSidebarState] via Pylon for expansion/collapse.
/// Handles drawer dismissal with [Arcane.closeDrawer] when active, integrating
/// seamlessly with [ArcaneApp]'s navigation drawer system and [IconButton] styling
/// from [ArcaneTheme] for consistent touch targets.
class ArcaneSidebarExpansionToggle extends StatelessWidget {
  const ArcaneSidebarExpansionToggle({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        icon: context.streamPylon<ArcaneSidebarState>().build((g) =>
            g == ArcaneSidebarState.expanded
                ? Icon(Icons.chevron_back_ionic)
                : Icon(Icons.chevron_forward_ionic)),
        onPressed: (context.pylonOr<ArcaneDrawerSignal>()?.open ?? false)
            ? () => Arcane.closeDrawer(context)
            : () => context.modPylon<ArcaneSidebarState>((i) =>
                i == ArcaneSidebarState.expanded
                    ? ArcaneSidebarState.collapsed
                    : ArcaneSidebarState.expanded),
      );
}

/// A wrapper for providing custom [ScrollController] to [ArcaneSidebar],
/// enabling external management of scroll position and behavior in
/// [CustomScrollView] setups, such as syncing with [NavigationScreen] or
/// [BottomNavigationBar] transitions for smooth user experience.
class SidebarScrollController {
  final ScrollController? controller;

  SidebarScrollController({this.controller});
}

/// An interactive button widget for navigation items in [ArcaneSidebar],
/// adapting from icon-only in collapsed state to full label display when expanded.
/// Uses [GhostButton] for subtle pressed states and highlights selection with
/// muted background from [ArcaneTheme]. Supports animations via [AnimatedContainer]
/// and [AnimatedPadding] for fluid transitions without performance overhead.
///
/// {icon} is the primary visual element, sourced from Arcane [icons] for consistency.
///
/// {label} provides the main text, hidden when collapsed, using normal typography.
///
/// {subLabel} adds secondary info like counts, in muted small text.
///
/// {onTap} is the selection callback, typically navigating via [ArcaneApp] routes.
///
/// {selected} (default: false) applies visual feedback for active items, integrating
/// with [Section] highlighting in larger navigation hierarchies.
class ArcaneSidebarButton extends StatelessWidget {
  final Widget icon;
  final String? label;
  final String? subLabel;
  final VoidCallback? onTap;
  final bool selected;

  const ArcaneSidebarButton(
      {super.key,
      required this.icon,
      this.label,
      this.subLabel,
      this.onTap,
      this.selected = false});

  @override
  Widget build(BuildContext context) => AnimatedPadding(
      padding:
          EdgeInsets.symmetric(horizontal: context.isSidebarExpanded ? 16 : 0),
      duration: const Duration(milliseconds: 333),
      curve: Curves.easeOutCirc,
      child: AnimatedContainer(
          decoration: BoxDecoration(
            color: selected ? Theme.of(context).colorScheme.muted : null,
            borderRadius: Theme.of(context).borderRadiusMd,
          ),
          duration: const Duration(milliseconds: 333),
          curve: Curves.easeOutCirc,
          child: context.isSidebarExpanded
              ? GhostButton(
                  density: ButtonDensity.compact,
                  onPressed: onTap,
                  child: Row(
                    children: [
                      icon.pad(8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (label != null) Text(label!).normal(),
                          if (subLabel != null) Text(subLabel!).muted().small(),
                        ],
                      )
                    ],
                  ).padLeft(8),
                )
              : IconButton(icon: icon, onPressed: onTap)));
}

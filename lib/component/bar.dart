import 'dart:ui';

import 'package:arcane/arcane.dart';
import 'package:arcane/util/unicorn.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

/// Controls the behavior of the back button in a [Bar] widget.
///
/// See more details in the [documentation](../../../doc/components/bar.md#barbackbuttonmode).
enum BarBackButtonMode {
  /// Never show the back button
  never,

  /// Always show the back button if navigation can pop
  always,

  /// Show the back button only when the bar is pinned
  whenPinned
}

/// A customizable app bar component that provides a flexible interface for creating headers.
///
/// The Bar widget supports leading and trailing widgets, title, subtitle, custom header and
/// footer components, and includes built-in features like back button handling and glass effects.
///
/// For complete documentation, examples, and usage guidelines, see the
/// [Bar Component Documentation](../../../doc/components/bar.md).
class Bar extends StatelessWidget {
  /// Widgets displayed at the end (right) of the bar.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final List<Widget> trailing;

  /// Widgets displayed at the start (left) of the bar.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final List<Widget> leading;

  /// The main content of the bar.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final Widget? child;

  /// Custom widget to use as the title.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final Widget? title;

  /// Content displayed above the bar.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final Widget? barHeader;

  /// Content displayed below the bar.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final Widget? barFooter;

  /// Text to display as the title.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final String? titleText;

  /// Text to display above the title.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final String? headerText;

  /// Text to display below the title.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final String? subtitleText;

  /// Small widget placed on top of title.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final Widget? header;

  /// Small widget placed below title.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final Widget? subtitle;

  /// Whether to expand the trailing section instead of the main content.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final bool trailingExpanded;

  /// Alignment of the title content.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final Alignment alignment;

  /// Background color of the bar.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final Color? backgroundColor;

  /// Space between leading widgets.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final double? leadingGap;

  /// Space between trailing widgets.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final double? trailingGap;

  /// Padding around bar content.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final EdgeInsetsGeometry? padding;

  /// Height of the bar.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final double? height;

  /// Whether to apply a glass effect to the bar.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) and [Glass Effect](../../../doc/components/bar.md#features) in the documentation.
  final bool useGlass;

  /// Controls when to show the back button.
  ///
  /// See [BarBackButtonMode](../../../doc/components/bar.md#barbackbuttonmode) in the documentation.
  final BarBackButtonMode backButton;

  /// Whether to ignore context signals from parent widgets.
  ///
  /// See [Parameters](../../../doc/components/bar.md#parameters) in the documentation.
  final bool ignoreContextSignals;

  /// Collection of action buttons to display in the trailing area.
  ///
  /// See [BarActions](../../../doc/components/bar.md#baractions) in the documentation.
  final BarActions? actions;

  /// Creates a customizable app bar.
  ///
  /// For complete usage examples, see:
  /// - [Basic Bar with Title](../../../doc/components/bar.md#basic-bar-with-title)
  /// - [Bar with Back Button and Actions](../../../doc/components/bar.md#bar-with-back-button-and-actions)
  /// - [Custom Bar with Leading and Trailing Widgets](../../../doc/components/bar.md#custom-bar-with-leading-and-trailing-widgets)
  /// - [Bar with Header and Footer](../../../doc/components/bar.md#bar-with-header-and-footer)
  const Bar(
      {super.key,
      this.ignoreContextSignals = false,
      this.trailing = const [],
      this.leading = const [],
      this.titleText,
      this.backButton = BarBackButtonMode.always,
      this.headerText,
      this.subtitleText,
      this.title,
      this.actions,
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

  /// Creates a copy of this Bar with the given fields replaced by new values.
  ///
  /// This method is useful for making small modifications to an existing Bar.
  /// See [Notes](../../../doc/components/bar.md#notes) in the documentation.
  Bar copyWith({
    Key? key,
    List<Widget>? trailing,
    List<Widget>? leading,
    Widget? barHeader,
    Widget? barFooter,
    Widget? child,
    Widget? title,
    String? titleText,
    String? headerText,
    String? subtitleText,
    Widget? header,
    Widget? subtitle,
    bool? trailingExpanded,
    Alignment? alignment,
    Color? backgroundColor,
    double? leadingGap,
    double? trailingGap,
    EdgeInsetsGeometry? padding,
    double? height,
    bool? useGlass,
    BarBackButtonMode? backButton,
    bool? ignoreContextSignals,
  }) =>
      Bar(
        barHeader: barHeader ?? this.barHeader,
        key: key ?? this.key,
        trailing: trailing ?? this.trailing,
        leading: leading ?? this.leading,
        title: title ?? this.title,
        titleText: titleText ?? this.titleText,
        headerText: headerText ?? this.headerText,
        subtitleText: subtitleText ?? this.subtitleText,
        header: header ?? this.header,
        subtitle: subtitle ?? this.subtitle,
        trailingExpanded: trailingExpanded ?? this.trailingExpanded,
        alignment: alignment ?? this.alignment,
        padding: padding ?? this.padding,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        leadingGap: leadingGap ?? this.leadingGap,
        trailingGap: trailingGap ?? this.trailingGap,
        height: height ?? this.height,
        useGlass: useGlass ?? this.useGlass,
        backButton: backButton ?? this.backButton,
        ignoreContextSignals: ignoreContextSignals ?? this.ignoreContextSignals,
        barFooter: barFooter ?? this.barFooter,
        child: child ?? this.child,
      );

  @override
  Widget build(BuildContext context) {
    Widget? barHeader = this.barHeader ??
        context.pylonOr<InjectBarHeader>()?.header.call(context);
    return Stack(
      children: [
        Glass(
            ignoreContextSignals: ignoreContextSignals,
            disabled: !useGlass,
            disabledColor: (context.isTranslucent
                ? Colors.transparent
                : Theme.of(context).colorScheme.background),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (barHeader != null) barHeader!,
                SafeBar.withSafety(
                    context,
                    NoIntrinsicAppBar(
                      leading: InjectBarLeading.mutate(context, [
                        if ((backButton == BarBackButtonMode.always ||
                                (backButton == BarBackButtonMode.whenPinned &&
                                    !GlassStopper.isStopping(context))) &&
                            Navigator.canPop(context) &&
                            !BlockBackButton.isBlocking(context))
                          GhostButton(
                              density: ButtonDensity.icon,
                              child: context.inSheet
                                  ? const Icon(PhosphorIcons.x_bold)
                                  : const Icon(PhosphorIcons.caret_left_bold),
                              onPressed: () => Arcane.pop(context)),
                        ...leading
                      ]),
                      surfaceOpacity: 0,
                      trailing: InjectBarTrailing.mutate(context,
                          [...trailing, if (actions != null) actions!]),
                      title: (titleText?.text ?? title)?.ast(2),
                      header: (headerText?.text ?? header)?.ast(1),
                      subtitle: (subtitleText?.text ?? subtitle)?.ast(1),
                      trailingExpanded: trailingExpanded,
                      alignment: alignment,
                      padding: padding,
                      backgroundColor: backgroundColor,
                      leadingGap: leadingGap,
                      trailingGap: trailingGap,
                      height: height,
                      surfaceBlur: 0,
                      child: child,
                    )),
                if (barFooter != null) barFooter!,
              ],
            ))
      ],
    );
  }
}

extension XAST on Widget {
  Widget ast(int ml) => this is Text
      ? AutoSizeText(
          (this as Text).data ?? "",
          style: (this as Text).style,
          minFontSize: 9,
          overflow: TextOverflow.ellipsis,
          maxFontSize: (this as Text).style?.fontSize ?? 16,
          maxLines: ml,
          wrapWords: false,
        )
      : this;
}

/// Helps manage safe areas (notches, cutouts) around the bar.
///
/// For complete documentation and examples, see [SafeBar](../../../doc/components/bar.md#safebar).
class SafeBar extends StatelessWidget {
  /// Whether to apply safe area at the top.
  final bool top;

  /// Whether to apply safe area at the bottom.
  final bool bottom;

  /// Whether to apply safe area on the left.
  final bool left;

  /// Whether to apply safe area on the right.
  final bool right;

  /// The builder function for the content.
  final PylonBuilder builder;

  /// Applies SafeArea to the widget based on the SafeBar settings in the context.
  ///
  /// This method is used internally by Bar to handle safe areas.
  static Widget withSafety(BuildContext context, Widget widget) {
    SafeBar? s = context.pylonOr<SafeBar>();

    if (s != null) {
      return SafeArea(
        top: s.top,
        bottom: s.bottom,
        left: s.left,
        right: s.right,
        child: widget,
      );
    }
    return widget;
  }

  /// Creates a SafeBar widget to manage safe areas around the Bar.
  ///
  /// See [SafeBar](../../../doc/components/bar.md#safebar) in the documentation.
  const SafeBar(
      {super.key,
      this.top = false,
      this.bottom = false,
      this.left = false,
      this.right = false,
      required this.builder});

  @override
  Widget build(BuildContext context) => Pylon<SafeBar>(
        local: true,
        value: this,
        builder: builder,
      );
}

/// Allows you to temporarily disable the back button.
///
/// For complete documentation and examples, see [BlockBackButton](../../../doc/components/bar.md#blockbackbutton).
class BlockBackButton extends StatelessWidget {
  /// Whether to block the back button.
  final bool block;

  /// The builder function for the content.
  final PylonBuilder builder;

  /// Checks if a BlockBackButton is blocking in the current context.
  static bool isBlocking(BuildContext context) =>
      context.pylonOr<BlockBackButton>()?.block ?? false;

  /// Creates a BlockBackButton widget to control back button behavior.
  ///
  /// See [BlockBackButton](../../../doc/components/bar.md#blockbackbutton) in the documentation.
  const BlockBackButton({super.key, this.block = true, required this.builder});

  @override
  Widget build(BuildContext context) => Pylon<BlockBackButton>(
        local: true,
        value: this,
        builder: builder,
      );
}

const double _iconButtonWidth = 24;

/// Provides a flexible way to add multiple action buttons to a Bar.
///
/// BarActions automatically collapses overflow actions into a dropdown menu when
/// there are more actions than the specified maximum.
///
/// For complete documentation and examples, see [BarActions](../../../doc/components/bar.md#baractions).
class BarActions extends StatelessWidget {
  /// The list of action buttons to display.
  final List<BarAction> actions;

  /// Maximum number of icons to show before collapsing excess into a dropdown menu.
  final int maxIcons;

  /// Creates a collection of action buttons for a Bar.
  ///
  /// See [BarActions](../../../doc/components/bar.md#baractions) in the documentation.
  const BarActions({super.key, this.actions = const [], this.maxIcons = 2});

  @override
  Widget build(BuildContext context) {
    List<MenuButton> menu = [];
    List<Widget> spread = [];
    List<Widget> mandatory = actions
        .where((i) => !i.collapsable)
        .map((i) => Tooltip(
            tooltip: (context) => Text(i.label),
            child: IconButton(
              icon: Icon(i.icon),
              onPressed: i.onPressed,
            )))
        .toList();
    bool hasMenu = false;
    List<BarAction> col = actions.where((i) => i.collapsable).toList();

    while (
        (col.length + mandatory.length + (hasMenu ? 1 : 0)) * _iconButtonWidth >
                (maxIcons * _iconButtonWidth) &&
            col.isNotEmpty) {
      hasMenu = true;
      BarAction c = col.removeAt(0);
      menu.add(MenuButton(
        leading: Icon(c.icon),
        onPressed: () => c.onPressed(),
        child: Text(
          c.label,
        ),
      ));
    }

    spread.addAll(mandatory);
    spread.addAll(col.map((i) => Tooltip(
        tooltip: (context) => Text(i.label),
        child: IconButton(
          icon: Icon(i.icon),
          onPressed: i.onPressed,
        ))));

    if (hasMenu) {
      spread.add(IconButtonMenu(icon: Icons.dots_three, items: menu));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: spread,
    );
  }
}

/// Represents a single action button in the bar.
///
/// For complete documentation, see [BarAction](../../../doc/components/bar.md#baraction).
class BarAction {
  /// Icon to display for the action.
  final IconData icon;

  /// Text label for the action (shown in tooltip or menu).
  final String label;

  /// Function to call when the action is triggered.
  final VoidCallback onPressed;

  /// Whether this action can be moved to the overflow menu.
  final bool collapsable;

  /// Creates a single action button for use in a BarActions widget.
  ///
  /// See [BarAction](../../../doc/components/bar.md#baraction) in the documentation.
  const BarAction(
      {required this.icon,
      required this.label,
      required this.onPressed,
      this.collapsable = true});
}

/// Injects widgets into either the leading or trailing areas of a Bar.
///
/// This is part of the Bar's injection system. See [Injection](../../../doc/components/bar.md#injection).
class InjectBarEnds extends StatelessWidget {
  /// Whether to inject into the trailing (true) or leading (false) area.
  final bool trailing;

  /// The builder function for the content.
  final PylonBuilder builder;

  /// Whether to add injected widgets at the start (true) or end (false) of the area.
  final bool start;

  /// Function that returns widgets to inject.
  final List<Widget> Function(BuildContext)? children;

  /// Creates an InjectBarEnds widget to inject widgets into a Bar.
  ///
  /// See [Injection](../../../doc/components/bar.md#injection) in the documentation.
  const InjectBarEnds(
      {super.key,
      this.trailing = true,
      this.start = false,
      this.children,
      required this.builder});

  @override
  Widget build(BuildContext context) => trailing
      ? InjectBarTrailing(builder: builder, start: start, children: children)
      : InjectBarLeading(builder: builder, start: start, children: children);
}

/// Injects widgets into the trailing area of a Bar.
///
/// This is part of the Bar's injection system. See [Injection](../../../doc/components/bar.md#injection).
class InjectBarTrailing extends StatelessWidget {
  /// Function that returns widgets to inject into the trailing area.
  final List<Widget> Function(BuildContext)? children;

  /// Whether to add injected widgets at the start (true) or end (false) of the trailing area.
  final bool start;

  /// The builder function for the content.
  final PylonBuilder builder;

  /// Finds the InjectBarTrailing in the current context, if any.
  static InjectBarTrailing? of(BuildContext context) =>
      context.pylonOr<InjectBarTrailing>();

  /// Modifies the trailing widgets list based on any injections in the context.
  static List<Widget> mutate(BuildContext context, List<Widget> children) {
    InjectBarTrailing? i = of(context);
    return i != null
        ? (i.start
            ? [...children, ...(i.children?.call(context) ?? [])]
            : [...(i.children?.call(context) ?? []), ...children])
        : children;
  }

  /// Creates an InjectBarTrailing widget to inject widgets into a Bar's trailing area.
  ///
  /// See [Injection](../../../doc/components/bar.md#injection) in the documentation.
  const InjectBarTrailing(
      {super.key, this.children, this.start = false, required this.builder});

  @override
  Widget build(BuildContext context) =>
      Pylon<InjectBarTrailing?>(value: this, builder: builder, local: true);
}

/// Injects widgets into the leading area of a Bar.
///
/// This is part of the Bar's injection system. See [Injection](../../../doc/components/bar.md#injection).
class InjectBarLeading extends StatelessWidget {
  /// Function that returns widgets to inject into the leading area.
  final List<Widget> Function(BuildContext)? children;

  /// Whether to add injected widgets at the start (true) or end (false) of the leading area.
  final bool start;

  /// The builder function for the content.
  final PylonBuilder builder;

  /// Finds the InjectBarLeading in the current context, if any.
  static InjectBarLeading? of(BuildContext context) =>
      context.pylonOr<InjectBarLeading>();

  /// Modifies the leading widgets list based on any injections in the context.
  static List<Widget> mutate(BuildContext context, List<Widget> children) {
    InjectBarLeading? i = of(context);
    return i != null
        ? (i.start
            ? [...children, ...(i.children?.call(context) ?? [])]
            : [...(i.children?.call(context) ?? []), ...children])
        : children;
  }

  /// Creates an InjectBarLeading widget to inject widgets into a Bar's leading area.
  ///
  /// See [Injection](../../../doc/components/bar.md#injection) in the documentation.
  const InjectBarLeading(
      {super.key, this.children, this.start = true, required this.builder});

  @override
  Widget build(BuildContext context) =>
      Pylon<InjectBarLeading?>(value: this, builder: builder, local: true);
}

/// Injects a header widget into a Bar.
///
/// This is part of the Bar's injection system. See [Injection](../../../doc/components/bar.md#injection).
class InjectBarHeader {
  /// The builder function for the header content.
  final PylonBuilder header;

  /// Creates an InjectBarHeader to inject a header into a Bar.
  ///
  /// See [Injection](../../../doc/components/bar.md#injection) in the documentation.
  const InjectBarHeader({required this.header});
}

class NoIntrinsicAppBar extends StatefulWidget {
  final List<Widget> trailing;
  final List<Widget> leading;
  final Widget? child;
  final Widget? title;
  final Widget? header; // small widget placed on top of title
  final Widget? subtitle; // small widget placed below title
  final bool
      trailingExpanded; // expand the trailing instead of the main content
  final AlignmentGeometry alignment;
  final Color? backgroundColor;
  final double? leadingGap;
  final double? trailingGap;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final bool useSafeArea;
  final double? surfaceBlur;
  final double? surfaceOpacity;

  const NoIntrinsicAppBar({
    super.key,
    this.trailing = const [],
    this.leading = const [],
    this.title,
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
    this.surfaceBlur,
    this.surfaceOpacity,
    this.useSafeArea = true,
  }) : assert(
          child == null || title == null,
          'Cannot provide both child and title',
        );

  @override
  State<NoIntrinsicAppBar> createState() => _AppBarState();
}

class _AppBarState extends State<NoIntrinsicAppBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final barData = Data.maybeOf<ScaffoldBarData>(context);
    final surfaceBlur = widget.surfaceBlur ?? theme.surfaceBlur;
    final surfaceOpacity = widget.surfaceOpacity ?? theme.surfaceOpacity;

    return FocusTraversalGroup(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: surfaceBlur ?? 0,
            sigmaY: surfaceBlur ?? 0,
          ),
          child: Container(
            color: widget.backgroundColor ??
                theme.colorScheme.background.scaleAlpha(surfaceOpacity ?? 1),
            alignment: widget.alignment,
            padding: widget.padding ??
                (const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ) *
                    scaling),
            child: SafeArea(
              top: widget.useSafeArea &&
                  barData?.isHeader == true &&
                  barData?.childIndex == 0,
              right: widget.useSafeArea,
              left: widget.useSafeArea,
              bottom: widget.useSafeArea &&
                  barData?.isHeader == false &&
                  barData?.childIndex == (barData?.childrenCount ?? 0) - 1,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.leading.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: widget.leading,
                    ).gap(widget.leadingGap ?? (4 * scaling)),
                  Flexible(
                    fit:
                        widget.trailingExpanded ? FlexFit.loose : FlexFit.tight,
                    child: widget.child ??
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.header != null)
                              KeyedSubtree(
                                key: const ValueKey('header'),
                                child: widget.header!.muted().small(),
                              ),
                            if (widget.title != null)
                              KeyedSubtree(
                                key: const ValueKey('title'),
                                child: widget.title!.large().medium(),
                              ),
                            if (widget.subtitle != null)
                              KeyedSubtree(
                                key: const ValueKey('subtitle'),
                                child: widget.subtitle!.muted().small(),
                              ),
                          ],
                        ),
                  ),
                  if (widget.trailing.isNotEmpty)
                    if (!widget.trailingExpanded)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: widget.trailing,
                      ).gap(widget.trailingGap ?? (4 * scaling))
                    else
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: widget.trailing,
                        ).gap(widget.trailingGap ?? (4 * scaling)),
                      ),
                ],
              ).gap(18 * scaling),
            ),
          ),
        ),
      ),
    );
  }
}

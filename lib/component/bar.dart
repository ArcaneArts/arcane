import 'package:arcane/arcane.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

enum BarBackButtonMode { never, always, whenPinned }

class Bar extends StatelessWidget {
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
        child: child ?? this.child,
        barFooter: barFooter ?? this.barFooter,
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
            blur: Theme.of(context).surfaceBlur ?? 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (barHeader != null) barHeader!,
                SafeBar.withSafety(
                    context,
                    AppBar(
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
                      title: titleText?.text ?? title,
                      header: headerText?.text ?? header,
                      subtitle: subtitleText?.text ?? subtitle,
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
  Widget get ast => this is Text
      ? AutoSizeText(
          (this as Text).data ?? "",
          style: (this as Text).style,
          minFontSize: 9,
          maxFontSize: (this as Text).style?.fontSize ?? 16,
        )
      : this;
}

class SafeBar extends StatelessWidget {
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;
  final PylonBuilder builder;

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

class BlockBackButton extends StatelessWidget {
  final bool block;
  final PylonBuilder builder;

  static bool isBlocking(BuildContext context) =>
      context.pylonOr<BlockBackButton>()?.block ?? false;

  const BlockBackButton({super.key, this.block = true, required this.builder});

  @override
  Widget build(BuildContext context) => Pylon<BlockBackButton>(
        local: true,
        value: this,
        builder: builder,
      );
}

const double _iconButtonWidth = 24;

class BarActions extends StatelessWidget {
  final List<BarAction> actions;
  final int maxIcons;

  const BarActions({super.key, this.actions = const [], this.maxIcons = 2});

  @override
  Widget build(BuildContext context) {
    List<MenuButton> menu = [];
    List<Widget> spread = [];
    List<Widget> mandatory = actions
        .where((i) => !i.collapsable)
        .map((i) => Tooltip(
            tooltip: Text(i.label),
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
        tooltip: Text(i.label),
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

class BarAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool collapsable;

  const BarAction(
      {required this.icon,
      required this.label,
      required this.onPressed,
      this.collapsable = true});
}

class InjectBarEnds extends StatelessWidget {
  final bool trailing;
  final PylonBuilder builder;
  final bool start;
  final List<Widget> Function(BuildContext)? children;

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

class InjectBarTrailing extends StatelessWidget {
  final List<Widget> Function(BuildContext)? children;
  final bool start;
  final PylonBuilder builder;

  static InjectBarTrailing? of(BuildContext context) =>
      context.pylonOr<InjectBarTrailing>();

  static List<Widget> mutate(BuildContext context, List<Widget> children) {
    InjectBarTrailing? i = of(context);
    return i != null
        ? (i.start
            ? [...children, ...(i.children?.call(context) ?? [])]
            : [...(i.children?.call(context) ?? []), ...children])
        : children;
  }

  const InjectBarTrailing(
      {super.key, this.children, this.start = false, required this.builder});

  @override
  Widget build(BuildContext context) =>
      Pylon<InjectBarTrailing?>(value: this, builder: builder, local: true);
}

class InjectBarLeading extends StatelessWidget {
  final List<Widget> Function(BuildContext)? children;
  final bool start;
  final PylonBuilder builder;

  static InjectBarLeading? of(BuildContext context) =>
      context.pylonOr<InjectBarLeading>();

  static List<Widget> mutate(BuildContext context, List<Widget> children) {
    InjectBarLeading? i = of(context);
    return i != null
        ? (i.start
            ? [...children, ...(i.children?.call(context) ?? [])]
            : [...(i.children?.call(context) ?? []), ...children])
        : children;
  }

  const InjectBarLeading(
      {super.key, this.children, this.start = true, required this.builder});

  @override
  Widget build(BuildContext context) =>
      Pylon<InjectBarLeading?>(value: this, builder: builder, local: true);
}

class InjectBarHeader {
  final PylonBuilder header;

  const InjectBarHeader({required this.header});
}

import 'package:arcane/arcane.dart';
import 'package:flutter/gestures.dart';

class FixedTabs extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  final List<TabChild> children;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? selectedColor;

  const FixedTabs({
    super.key,
    required this.index,
    required this.onChanged,
    required this.children,
    this.backgroundColor,
    this.selectedColor,
    this.padding,
  });

  void onChange(BuildContext context, int v) {
    onChanged(v);
  }

  Widget _childBuilder(
    BuildContext context,
    TabContainerData data,
    Widget child,
  ) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final compTheme = ComponentTheme.maybeOf<TabsTheme>(context);
    final tabPadding = styleValue(
      defaultValue:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4) * scaling,
      themeValue: compTheme?.tabPadding,
      widgetValue: padding,
    );
    final i = data.index;
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerUp: (p) {
        if (p.buttons & kPrimaryButton == 0) {
          onChange(context, i);
        }
      },
      child: MouseRegion(
        hitTestBehavior: HitTestBehavior.translucent,
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 50,
          ), // slightly faster than kDefaultDuration
          alignment: Alignment.center,
          padding: tabPadding,
          decoration: BoxDecoration(
            color: i == index ? theme.colorScheme.background : null,
            borderRadius: BorderRadius.circular(theme.radiusMd),
          ),
          child: (i == index ? child.foreground() : child.muted())
              .small()
              .medium(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final compTheme = ComponentTheme.maybeOf<TabsTheme>(context);
    final containerPadding = styleValue(
      defaultValue: const EdgeInsets.all(4) * scaling,
      themeValue: compTheme?.containerPadding,
    );
    final backgroundColor = styleValue(
      defaultValue: theme.colorScheme.muted,
      themeValue: compTheme?.backgroundColor,
    );
    final borderRadius = styleValue(
      defaultValue: BorderRadius.circular(theme.radiusLg),
      themeValue: compTheme?.borderRadius,
    );
    return TabContainer(
      selected: index,
      onSelect: (v) => onChange(context, v),
      builder: (context, children) {
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius is BorderRadius
                ? borderRadius
                : borderRadius.resolve(Directionality.of(context)),
          ),
          padding: containerPadding,
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ).muted(),
          ),
        );
      },
      childBuilder: _childBuilder,
      children: children,
    );
  }
}

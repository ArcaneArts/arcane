import 'package:arcane/generated/arcane_shadcn/shadcn_flutter.dart';
import 'package:arcane/generated/arcane_shadcn/src/events.dart';

class Tabs extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  final List<TabChild> children;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? selectedColor;

  const Tabs({
    super.key,
    required this.index,
    required this.onChanged,
    required this.children,
    this.backgroundColor,
    this.selectedColor,
    this.padding,
  });

  void onChange(BuildContext context, int v) {
    $shadEvent?.onTabChanged(context);
    onChanged(v);
  }

  Widget _childBuilder(
      BuildContext context, TabContainerData data, Widget child) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final i = data.index;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onChange(context, i);
      },
      child: MouseRegion(
        hitTestBehavior: HitTestBehavior.translucent,
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(
              milliseconds: 50), // slightly faster than kDefaultDuration
          alignment: Alignment.center,
          padding: padding ??
              const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ) *
                  scaling,
          decoration: BoxDecoration(
            color: i == index
                ? selectedColor ?? theme.colorScheme.background
                : null,
            borderRadius: BorderRadius.circular(
              theme.radiusMd,
            ),
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
    return TabContainer(
      selected: index,
      onSelect: (v) => onChange(context, v),
      builder: (context, children) {
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.colorScheme.muted,
            borderRadius: BorderRadius.circular(theme.radiusLg),
          ),
          padding: const EdgeInsets.all(4) * scaling,
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

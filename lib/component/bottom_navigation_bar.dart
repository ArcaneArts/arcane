import 'package:arcane/arcane.dart';
import 'package:pylon/pylon.dart';
import 'package:toxic/extensions/iterable.dart';

class IconTab extends StatelessWidget {
  final IconData icon;
  final IconData? selectedIcon;
  final String? label;
  final VoidCallback? onPressed;

  const IconTab(
      {super.key,
      required this.icon,
      this.selectedIcon,
      this.label,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    bool selected =
        context.pylonOr<_IsSelectedBottomIndex>()?.selected ?? false;

    return TextButton(
      onPressed: onPressed,
      enabled: true,
      density: ButtonDensity((padding) => padding.copyWith(
            bottom: padding.bottom * 0.5,
            top: padding.top * 0.5,
            left: padding.left * 0.5,
            right: padding.right * 0.5,
          )),
      child: Icon(selected ? (selectedIcon ?? icon) : icon,
          color: selected ? Theme.of(context).colorScheme.primary : null),
    );
  }
}

class _IsSelectedBottomIndex {
  final bool selected;

  const _IsSelectedBottomIndex(this.selected);
}

class ButtonBar extends StatelessWidget {
  final int selectedIndex;
  final List<IconTab> buttons;

  const ButtonBar({super.key, this.selectedIndex = 0, required this.buttons});

  @override
  Widget build(BuildContext context) => Bar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buttons
              .mapIndexed((button, index) => Pylon<_IsSelectedBottomIndex>(
                    value: _IsSelectedBottomIndex(index == selectedIndex),
                    builder: (context) => button,
                    key: ValueKey("$index.${button.icon}"),
                  ))
              .toList(),
        ),
      );
}

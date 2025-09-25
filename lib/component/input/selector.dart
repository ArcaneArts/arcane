import 'package:arcane/arcane.dart';

class Selector<T> extends StatelessWidget {
  final bool canUnselect;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final List<T> values;
  final String Function(T) labelBuilder;

  const Selector(
      {super.key,
      this.canUnselect = false,
      this.value,
      this.onChanged,
      required this.values,
      required this.labelBuilder});

  @override
  Widget build(BuildContext context) => Select<T>(
      itemBuilder: (context, item) => Text(labelBuilder(item)),
      value: value,
      onChanged: onChanged,
      popupWidthConstraint: PopoverConstraint.anchorFixedSize,
      canUnselect: canUnselect,
      popup: (context) => SurfaceCard(
              child: Column(
            children: [
              ...values.map((e) =>
                  SelectItemButton(value: e, child: Text(labelBuilder(e))))
            ],
          )));
}

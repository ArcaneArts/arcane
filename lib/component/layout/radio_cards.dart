import 'package:arcane/arcane.dart';

class RadioCards<T> extends StatelessWidget {
  final Widget Function(T) builder;
  final void Function(T) onChanged;
  final List<T> items;
  final T? value;

  const RadioCards(
      {super.key,
      required this.builder,
      required this.onChanged,
      required this.items,
      this.value});

  @override
  Widget build(BuildContext context) => RadioGroup<T>(
        value: value,
        onChanged: (v) => onChanged(v),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: items
              .map((item) => PaddingHorizontal(
                  padding: 4,
                  child: RadioCard(
                    value: item,
                    child: builder(item),
                  )))
              .toList(),
        ),
      );
}

import 'package:arcane/arcane.dart';

class ArcaneFormBool<T> extends ArcaneFormFieldStateless
    with ArcaneFormMixin<T> {
  final int? maxValue;
  final int? minValue;
  final String? placeholder;
  final bool? Function(T t) reader;
  final T Function(T t, bool? s) writer;
  final bool tristate;
  final Widget Function(BuildContext context)? builder;

  const ArcaneFormBool(
      {super.key,
      this.builder,
      this.tristate = false,
      required this.reader,
      required this.writer,
      this.maxValue,
      this.minValue,
      this.placeholder,
      required super.label,
      super.subLabel});

  @override
  Widget build(BuildContext context) => ArcaneFormFieldContainer(
        label: label,
        subLabel: subLabel,
        child: builder?.call(context) ??
            Row(
              children: [
                Checkbox(
                    state: reader(getData(context)) == true
                        ? CheckboxState.checked
                        : reader(getData(context)) == false
                            ? CheckboxState.unchecked
                            : tristate
                                ? CheckboxState.indeterminate
                                : CheckboxState.unchecked,
                    onChanged: (v) {
                      setData(
                          context,
                          writer(
                              getData(context),
                              v == CheckboxState.checked
                                  ? true
                                  : v == CheckboxState.unchecked
                                      ? false
                                      : tristate
                                          ? null
                                          : false));
                    }),
                Flexible(child: Text(label!))
              ],
            ),
      );
}

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
        subLabel: subLabel,
        child: builder?.call(context) ??
            Clickable(
                mouseCursor:
                    const WidgetStatePropertyAll(SystemMouseCursors.click),
                onPressed: () {
                  bool? v = reader(getData(context));
                  if (tristate) {
                    setData(
                        context,
                        writer(
                            getData(context),
                            v == true
                                ? null
                                : v == false
                                    ? true
                                    : false));
                  } else {
                    setData(context,
                        writer(getData(context), v == true ? false : true));
                  }
                },
                child: Row(
                  children: [
                    getStream(context).build((b) => Checkbox(
                        padding: 0,
                        state: reader(b) == true
                            ? CheckboxState.checked
                            : reader(b) == false
                                ? CheckboxState.unchecked
                                : tristate
                                    ? CheckboxState.indeterminate
                                    : CheckboxState.unchecked,
                        onChanged: (v) {
                          setData(
                              context,
                              writer(
                                  b,
                                  v == CheckboxState.checked
                                      ? true
                                      : v == CheckboxState.unchecked
                                          ? false
                                          : tristate
                                              ? null
                                              : false));
                        })),
                    Flexible(
                        child: Text(label!)
                            .padLeft(8 * Theme.of(context).scaling)),
                  ],
                )),
      );
}

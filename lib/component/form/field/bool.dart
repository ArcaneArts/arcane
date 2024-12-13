import 'package:arcane/arcane.dart';

class ArcaneFormBool<T> extends ArcaneFormFieldStateless
    with ArcaneFormMixin<T> {
  final String? placeholder;
  final bool? Function(T t) reader;
  final T Function(T t, bool? s) writer;
  final bool tristate;
  final bool rightHanded;
  final Widget Function(BuildContext context)? builder;

  const ArcaneFormBool(
      {super.key,
      this.builder,
      this.rightHanded = false,
      this.tristate = false,
      required this.reader,
      required this.writer,
      this.placeholder,
      required super.label,
      super.subLabel});

  @override
  Widget build(BuildContext context) {
    Widget box = getStream(context).build((b) => IgnorePointer(
          ignoring: true,
          child: Checkbox(
              padding: 0,
              state: reader(b) == true
                  ? CheckboxState.checked
                  : reader(b) == false
                      ? CheckboxState.unchecked
                      : tristate
                          ? CheckboxState.indeterminate
                          : CheckboxState.unchecked,
              onChanged: (v) {}),
        ));

    return ArcaneFormFieldContainer(
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
              child: rightHanded
                  ? Row(
                      children: [
                        Expanded(child: Text(label!)),
                        box,
                      ],
                    )
                  : Row(
                      children: [
                        box,
                        Flexible(
                            child: Text(label!)
                                .padLeft(8 * Theme.of(context).scaling)),
                      ],
                    )),
    );
  }
}

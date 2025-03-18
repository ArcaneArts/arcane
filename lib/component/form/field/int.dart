import 'package:arcane/arcane.dart';

class ArcaneFormInteger<T> extends ArcaneFormField {
  final int? maxValue;
  final int? minValue;
  final Widget? placeholder;
  final bool showButtons;
  final int Function(T t) reader;
  final T Function(T t, int s) writer;
  final Widget Function(BuildContext context, ArcaneFormIntegerState<T> state)?
      builder;

  const ArcaneFormInteger(
      {super.key,
      this.builder,
      this.showButtons = true,
      required this.reader,
      required this.writer,
      this.maxValue,
      this.minValue,
      this.placeholder,
      super.label,
      super.subLabel});

  @override
  State<ArcaneFormInteger<T>> createState() => ArcaneFormIntegerState<T>();
}

class ArcaneFormIntegerState<T> extends State<ArcaneFormInteger<T>>
    with ArcaneFormMixin<T> {
  late TextEditingController controller;
  int value = 0;

  @override
  void initState() {
    controller =
        TextEditingController(text: widget.reader(getData(context)).toString());
    super.initState();
  }

  void onEditingComplete() =>
      setData(context, widget.writer(getData(context), value));

  @override
  Widget build(BuildContext context) => ArcaneFormFieldContainer(
        label: widget.label,
        subLabel: widget.subLabel,
        child: widget.builder?.call(context, this) ??
            (NumberInput(
              allowDecimals: false,
              showButtons: widget.showButtons,
              max: widget.maxValue?.toDouble(),
              min: widget.minValue?.toDouble(),
              decimalPlaces: 0,
              pointerSignals: false,
              initialValue: widget.reader(getData(context)).toDouble(),
              onChanged: (g) => value = g.round(),
              placeholder: widget.placeholder,
              onEditingComplete: onEditingComplete,
              controller: controller,
            )),
      );
}

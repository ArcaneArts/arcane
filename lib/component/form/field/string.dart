import 'package:arcane/arcane.dart';

class ArcaneFormString<T> extends ArcaneFormField {
  final String? placeholder;
  final String Function(T t) reader;
  final T Function(T t, String s) writer;
  final bool textArea;
  final Widget Function(BuildContext context, ArcaneFormStringState<T> state)?
      builder;

  const ArcaneFormString(
      {super.key,
      this.builder,
      required this.reader,
      required this.writer,
      this.placeholder,
      this.textArea = false,
      super.label,
      super.subLabel});

  @override
  State<ArcaneFormString<T>> createState() => ArcaneFormStringState<T>();
}

class ArcaneFormStringState<T> extends State<ArcaneFormString<T>>
    with ArcaneFormMixin<T> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  void onEditingComplete() =>
      setData(context, widget.writer(getData(context), controller.text));

  @override
  Widget build(BuildContext context) => ArcaneFormFieldContainer(
        label: widget.label,
        subLabel: widget.subLabel,
        child: widget.builder?.call(context, this) ??
            (widget.textArea
                ? TextArea(
                    placeholder: widget.placeholder,
                    onEditingComplete: onEditingComplete,
                    controller: controller,
                  )
                : TextField(
                    placeholder: widget.placeholder,
                    onEditingComplete: onEditingComplete,
                    controller: controller,
                  )),
      );
}

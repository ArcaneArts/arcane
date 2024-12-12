import 'package:arcane/arcane.dart';

class ArcaneForm<T> extends StatefulWidget {
  final List<Widget> children;
  final void Function(T t)? onSubmitted;
  final T initialData;

  const ArcaneForm(
      {super.key,
      required this.children,
      this.onSubmitted,
      required this.initialData});

  @override
  State<ArcaneForm<T>> createState() => ArcaneFormState<T>();
}

class ArcaneFormState<T> extends State<ArcaneForm<T>> {
  late T data;

  @override
  void initState() {
    data = widget.initialData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Pylon<ArcaneFormState<T>>(
        value: this,
        builder: (context) => Column(
          children: widget.children.joinSeparator(Gap(8)),
        ),
      );
}

abstract class ArcaneFormField extends StatefulWidget {
  final String? label;
  final String? subLabel;

  const ArcaneFormField({super.key, this.label, this.subLabel});
}

abstract class ArcaneFormFieldStateless extends StatelessWidget {
  final String? label;
  final String? subLabel;

  const ArcaneFormFieldStateless({super.key, this.label, this.subLabel});
}

mixin ArcaneFormMixin<T> {
  ArcaneFormState<T> getForm(BuildContext context) =>
      context.pylon<ArcaneFormState<T>>();

  T getData(BuildContext context) => getForm(context).data;

  void setData(BuildContext context, T data) => getForm(context).setState(() {
        getForm(context).data = data;
        print("Set data to $data");
      });
}

class ArcaneFormFieldContainer extends StatelessWidget {
  final Widget child;
  final String? label;
  final String? subLabel;

  const ArcaneFormFieldContainer(
      {super.key, required this.child, this.label, this.subLabel});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null && label!.trim().isNotEmpty) Text(label!).small(),
          child,
          if (subLabel != null && subLabel!.trim().isNotEmpty)
            Text(subLabel!).xSmall().muted(),
        ].joinSeparator(Gap(8)),
      );
}

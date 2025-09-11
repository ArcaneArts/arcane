import 'package:arcane/arcane.dart';

class ArcaneColorField extends StatefulWidget {
  final PromptMode mode;
  final Widget? dialogTitle;
  final AlignmentGeometry? popoverAlignment;
  final AlignmentGeometry? popoverAnchorAlignment;
  final EdgeInsetsGeometry? popoverPadding;
  final bool? showAlpha;
  final bool? allowPickFromScreen;
  final Duration writeThrottle;

  const ArcaneColorField(
      {super.key,
      this.writeThrottle = const Duration(seconds: 1),
      this.allowPickFromScreen,
      this.mode = PromptMode.popover,
      this.dialogTitle,
      this.popoverAlignment,
      this.popoverAnchorAlignment,
      this.popoverPadding,
      this.showAlpha});

  @override
  State<ArcaneColorField> createState() => _ArcaneColorFieldState();
}

class _ArcaneColorFieldState extends State<ArcaneColorField> {
  late ColorDerivative currentColor;

  @override
  void initState() {
    ArcaneField<Color> field = context.pylon<ArcaneField<Color>>();
    currentColor = ColorDerivative.fromColor(
        field.provider.subject.valueOrNull ?? field.provider.defaultValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ArcaneField<Color> field = context.pylon<ArcaneField<Color>>();
    return ArcaneFieldWrapper<Color>(
        builder: (context) => ColorInput(
            showLabel: true,
            showAlpha: widget.showAlpha,
            dialogTitle: widget.dialogTitle,
            popoverAlignment: widget.popoverAlignment,
            popoverAnchorAlignment: widget.popoverAnchorAlignment,
            popoverPadding: widget.popoverPadding,
            allowPickFromScreen: widget.allowPickFromScreen,
            mode: widget.mode,
            onChanged: (v) {
              setState(() {
                currentColor = v;
              });

              throttle("colorPicker${widget.key?.hashCode ?? -1}.$identityHash",
                  () {
                field.provider.setValue(field.meta.effectiveKey, v.toColor());
              }, leaky: true, cooldown: widget.writeThrottle);
            },
            color: currentColor));
  }
}

import 'package:arcane/arcane.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

enum EditButtonType { ghost, pencil }

class MutableText extends StatefulWidget {
  final String value;
  final ValueChanged<String>? onChanged;
  final TextStyle? style;
  final int? maxLines;
  final int? minLines;
  final Locale? locale;
  final Color? selectionColor;
  final TextOverflow? overflow;
  final String? semanticsLabel;
  final bool? softWrap;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextHeightBehavior? textHeightBehavior;
  final TextScaler? textScaler;
  final TextWidthBasis? textWidthBasis;
  final String? placeholder;
  final bool border;
  final EditButtonType buttonType;
  final bool autoCorrect;
  final List<TextInputFormatter>? inputFormatters;

  const MutableText(this.value,
      {super.key,
      this.onChanged,
      this.autoCorrect = true,
      this.minLines,
      this.style,
      this.maxLines,
      this.locale,
      this.selectionColor,
      this.overflow,
      this.semanticsLabel,
      this.inputFormatters,
      this.softWrap,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.textHeightBehavior,
      this.textScaler,
      this.textWidthBasis,
      this.placeholder,
      this.buttonType = EditButtonType.pencil,
      this.border = false});

  @override
  State<MutableText> createState() => _MutableTextState();
}

class _MutableTextState extends State<MutableText> {
  bool _editing = false;
  TextEditingController? _controller;

  Widget buildText(BuildContext context) => Text(
        widget.value,
        style: widget.style,
        maxLines: widget.maxLines,
        locale: widget.locale,
        selectionColor: widget.selectionColor,
        overflow: widget.overflow,
        semanticsLabel: widget.semanticsLabel,
        softWrap: widget.softWrap,
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        textHeightBehavior: widget.textHeightBehavior,
        textScaler: widget.textScaler,
        textWidthBasis: widget.textWidthBasis,
      );

  @override
  Widget build(BuildContext context) => _editing
      ? Shortcuts(
          shortcuts: {
              LogicalKeySet(LogicalKeyboardKey.escape): _EscapeIntent(),
            },
          child: Actions(
              actions: {
                _EscapeIntent: CallbackAction<_EscapeIntent>(
                    onInvoke: (e) => setState(() {
                          _editing = false;
                        })),
              },
              child: TextField(
                inputFormatters: widget.inputFormatters,
                autocorrect: widget.autoCorrect,
                textInputAction: TextInputAction.done,
                autofocus: true,
                style: widget.style,
                textAlign: widget.textAlign ?? TextAlign.start,
                controller: _controller,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                placeholder: widget.placeholder,
                border: widget.border,
                onSubmitted: (v) {
                  setState(() {
                    _editing = false;
                  });

                  widget.onChanged?.call(v);
                },
                onEditingComplete: () {
                  setState(() {
                    _editing = false;
                  });
                },
              ).iw))
      : widget.onChanged == null
          ? buildText(context)
          : switch (widget.buttonType) {
              EditButtonType.ghost => GhostButton(
                  child: buildText(context),
                  onPressed: () => setState(() {
                        _controller = TextEditingController(text: widget.value);
                        _editing = true;
                      })),
              EditButtonType.pencil => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildText(context),
                    IconButton(
                        icon: Icon(
                          Icons.pencil_fill,
                          size: 14,
                        ),
                        onPressed: () => setState(() {
                              _controller =
                                  TextEditingController(text: widget.value);
                              _editing = true;
                            }))
                  ],
                )
            };
}

extension XText on Text {
  Widget mutable(ValueChanged<String> onChanged,
          {String? placeholder,
          int? minLines,
          bool border = false,
          bool autoCorrect = true,
          EditButtonType buttonType = EditButtonType.pencil}) =>
      MutableText(data ?? "",
          placeholder: placeholder,
          minLines: minLines,
          maxLines: maxLines,
          autoCorrect: autoCorrect,
          buttonType: buttonType,
          textAlign: textAlign,
          style: style,
          textWidthBasis: textWidthBasis,
          textScaler: textScaler,
          textHeightBehavior: textHeightBehavior,
          textDirection: textDirection,
          strutStyle: strutStyle,
          softWrap: softWrap,
          key: key,
          semanticsLabel: semanticsLabel,
          overflow: overflow,
          selectionColor: selectionColor,
          locale: locale,
          border: border,
          onChanged: onChanged);
}

class _EscapeIntent extends Intent {}

import 'package:arcane/arcane.dart';

class ArcaneTimeField extends StatelessWidget {
  final PromptMode mode;
  final ValueChanged<TimeOfDay?>? onChanged;
  final AlignmentGeometry? popoverAlignment;
  final AlignmentGeometry? popoverAnchorAlignment;
  final EdgeInsetsGeometry? popoverPadding;
  final bool? use24HourFormat;
  final bool showSeconds;
  final Widget? dialogTitle;

  const ArcaneTimeField(
      {super.key,
      this.mode = PromptMode.popover,
      this.onChanged,
      this.popoverAlignment,
      this.popoverAnchorAlignment,
      this.popoverPadding,
      this.use24HourFormat,
      this.showSeconds = false,
      this.dialogTitle});

  @override
  Widget build(BuildContext context) {
    ArcaneField<DateTime> field = context.pylon<ArcaneField<DateTime>>();
    return ArcaneFieldWrapper<DateTime>(
        builder: (context) => TimePicker(
            popoverAlignment: popoverAlignment,
            popoverAnchorAlignment: popoverAnchorAlignment,
            popoverPadding: popoverPadding,
            use24HourFormat: use24HourFormat,
            showSeconds: showSeconds,
            dialogTitle: dialogTitle,
            mode: mode,
            onChanged: (v) => field.provider.setValue(field.meta.effectiveKey,
                v?.toDateTime() ?? field.provider.defaultValue),
            value: TimeOfDay.fromDateTime(field.provider.subject.valueOrNull ??
                field.provider.defaultValue)));
  }
}

class ArcaneStringField extends StatefulWidget {
  final int? minLines;
  final int? maxLines;

  const ArcaneStringField({super.key, this.minLines, this.maxLines});

  @override
  State<ArcaneStringField> createState() => _ArcaneStringFieldState();
}

class _ArcaneStringFieldState extends State<ArcaneStringField> {
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller =
        TextEditingController(text: field.provider.subject.valueOrNull ?? "");
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        save();
      }
    });
  }

  void save() {
    field.provider.setValue(field.meta.effectiveKey, controller.text);
  }

  ArcaneField<String> get field => context.pylon<ArcaneField<String>>();

  @override
  Widget build(BuildContext context) => ArcaneFieldWrapper<String>(
      builder: (context) => TextField(
            controller: controller,
            focusNode: focusNode,
            minLines: widget.minLines,
            maxLines: widget.maxLines ?? 1,
            onEditingComplete: save,
            placeholder: field.meta.placeholder is String
                ? Text(field.meta.placeholder)
                : null,
          ));
}

enum ArcaneEnumFieldType { dropdown, cards }

Widget _defaultItemBuilder<T extends Enum>(BuildContext context, T item) =>
    Text(item.toString());

class ArcaneEnumField<T extends Enum> extends StatelessWidget {
  final ArcaneEnumFieldType? mode;
  final List<T> options;
  final Widget Function(BuildContext, T)? itemBuilder;
  final Widget Function(BuildContext, T, T)? cardBuilder;

  const ArcaneEnumField(
      {super.key,
      this.mode,
      required this.options,
      this.itemBuilder,
      this.cardBuilder});

  @override
  Widget build(BuildContext context) {
    ArcaneField<T> field = context.pylon<ArcaneField<T>>();
    return ArcaneFieldWrapper<T>(
        builder: (context) => switch (mode ??
                (options.length > 3
                    ? ArcaneEnumFieldType.dropdown
                    : ArcaneEnumFieldType.cards)) {
              ArcaneEnumFieldType.dropdown => Card(
                  padding: EdgeInsetsGeometry.zero,
                  borderColor: Colors.transparent,
                  borderWidth: 0,
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.card.withOpacity(0.5),
                  child: Select<T>(
                    itemBuilder: (context, item) {
                      return Stack(
                        children: [
                          ...options
                              .where((e) => e.name.length > item.name.length)
                              .map((e) => Opacity(
                                  opacity: 0,
                                  child: itemBuilder?.call(context, e) ??
                                      Text(e.name))),
                          itemBuilder?.call(context, item) ?? Text(item.name)
                        ],
                      );
                    },
                    popupWidthConstraint: PopoverConstraint.anchorMaxSize,
                    onChanged: (value) => field.provider.setValue(
                        field.meta.effectiveKey,
                        value ?? field.provider.defaultValue),
                    value: field.provider.subject.valueOrNull ??
                        field.provider.defaultValue,
                    popup: SelectPopup(
                      items: SelectItemList(
                        children: [
                          ...options.map((i) => SelectItemButton(
                                value: i,
                                child: itemBuilder?.call(context, i) ??
                                    Text(i.name),
                              )),
                        ],
                      ),
                    ).call,
                  ),
                ),
              ArcaneEnumFieldType.cards => CardCarousel(
                  featherColor: Theme.of(context).colorScheme.card,
                  children: [
                    ...options
                        .map((e) =>
                            cardBuilder?.call(
                                context,
                                e,
                                field.provider.subject.valueOrNull ??
                                    field.provider.defaultValue) ??
                            Card(
                              filled: true,
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .card
                                  .withOpacity(0.5),
                              borderWidth:
                                  field.provider.subject.valueOrNull == e
                                      ? 2
                                      : null,
                              borderColor:
                                  field.provider.subject.valueOrNull == e
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5)
                                      : null,
                              onPressed: () => field.provider
                                  .setValue(field.meta.effectiveKey, e),
                              child:
                                  itemBuilder?.call(context, e) ?? Text(e.name),
                            ))
                        .whereType<Widget>()
                        .joinSeparator(Gap(8))
                  ],
                )
            });
  }
}

class ArcaneDateField extends StatelessWidget {
  final PromptMode mode;
  final CalendarViewType? initialViewType;
  final Widget? dialogTitle;
  final CalendarView? initialView;
  final AlignmentGeometry? popoverAlignment;
  final AlignmentGeometry? popoverAnchorAlignment;
  final EdgeInsetsGeometry? popoverPadding;
  final DateStateBuilder? stateBuilder;

  const ArcaneDateField(
      {super.key,
      this.mode = PromptMode.popover,
      this.initialViewType,
      this.dialogTitle,
      this.initialView,
      this.popoverAlignment,
      this.popoverAnchorAlignment,
      this.popoverPadding,
      this.stateBuilder});

  @override
  Widget build(BuildContext context) {
    ArcaneField<DateTime> field = context.pylon<ArcaneField<DateTime>>();
    return ArcaneFieldWrapper<DateTime>(
        builder: (context) => DatePicker(
            initialViewType: initialViewType,
            dialogTitle: dialogTitle,
            initialView: initialView,
            popoverAlignment: popoverAlignment,
            popoverAnchorAlignment: popoverAnchorAlignment,
            popoverPadding: popoverPadding,
            stateBuilder: stateBuilder,
            mode: mode,
            onChanged: (v) => field.provider.setValue(
                field.meta.effectiveKey, v ?? field.provider.defaultValue),
            value: field.provider.subject.valueOrNull ??
                field.provider.defaultValue));
  }
}

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

class ArcaneBoolField extends StatelessWidget {
  const ArcaneBoolField({super.key});

  @override
  Widget build(BuildContext context) {
    ArcaneField<bool> field = context.pylon<ArcaneField<bool>>();
    return ArcaneFieldWrapper<bool>(
        overrideTileScaffold: true,
        builder: (context) {
          bool v = context.pylon<bool>();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: Checkbox(
                          gap: 0,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (field.meta.icon != null)
                                Icon(field.meta.icon!).padRight(4),
                              if (field.meta.name != null) ...[
                                Flexible(child: Text(field.meta.name!).xSmall),
                                Gap(8)
                              ],
                              Icon(Icons.check, size: 12, color: Colors.green)
                                  .animate(key: ValueKey(v))
                                  .fadeIn(
                                      duration: 1.seconds,
                                      curve: Curves.easeOutCirc,
                                      begin: 0)
                                  .fadeOut(
                                      delay: 1.seconds,
                                      begin: 1,
                                      duration: 3.seconds,
                                      curve: Curves.easeOutCirc)
                            ],
                          ).padOnly(top: 8, left: 8, bottom: 8),
                          state: v
                              ? CheckboxState.checked
                              : CheckboxState.unchecked,
                          onChanged: (v) {
                            field.provider.setValue(field.meta.effectiveKey,
                                v == CheckboxState.checked);
                          }))
                ],
              ),
              if (field.meta.description != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Text(field.meta.description!).xSmall.muted)
                  ],
                ).padBottom(8)
            ],
          );
        });
  }
}

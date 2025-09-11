import 'package:arcane/arcane.dart';

class ArcaneInput {
  const ArcaneInput._();

  static ArcaneField color({
    String? name,
    String? description,
    IconData? icon,
    Color? defaultValue,
    required Future<Color> Function() getter,
    required Future Function(Color) setter,
    PromptMode mode = PromptMode.popover,
    Widget? dialogTitle,
    AlignmentGeometry? popoverAlignment,
    AlignmentGeometry? popoverAnchorAlignment,
    EdgeInsetsGeometry? popoverPadding,
    bool? showAlpha,
    bool? allowPickFromScreen,
    Duration writeThrottle = const Duration(seconds: 1),
  }) =>
      ArcaneField<Color>(
          meta: ArcaneFieldMetadata(
            name: name,
            description: description,
            icon: icon,
          ),
          provider: ArcaneFieldDirectProvider(
              defaultValue: defaultValue ?? Colors.black,
              getter: (_) => getter(),
              setter: (_, v) => setter(v)),
          builder: (context) => ArcaneColorField(
                popoverAlignment: popoverAlignment,
                popoverAnchorAlignment: popoverAnchorAlignment,
                popoverPadding: popoverPadding,
                showAlpha: showAlpha,
                allowPickFromScreen: allowPickFromScreen,
                writeThrottle: writeThrottle,
                dialogTitle: dialogTitle,
                mode: mode,
              ));

  static ArcaneField date({
    String? name,
    String? description,
    IconData? icon,
    DateTime? defaultValue,
    required Future<DateTime> Function() getter,
    required Future Function(DateTime) setter,
    PromptMode mode = PromptMode.popover,
    CalendarViewType? initialViewType,
    Widget? dialogTitle,
    CalendarView? initialView,
    AlignmentGeometry? popoverAlignment,
    AlignmentGeometry? popoverAnchorAlignment,
    EdgeInsetsGeometry? popoverPadding,
    DateStateBuilder? stateBuilder,
  }) =>
      ArcaneField<DateTime>(
          meta: ArcaneFieldMetadata(
            name: name,
            description: description,
            icon: icon,
          ),
          provider: ArcaneFieldDirectProvider(
              defaultValue: defaultValue ?? DateTime.now(),
              getter: (_) => getter(),
              setter: (_, v) => setter(v)),
          builder: (context) => ArcaneDateField(
                mode: mode,
                initialViewType: initialViewType,
                dialogTitle: dialogTitle,
                initialView: initialView,
                popoverAlignment: popoverAlignment,
                popoverAnchorAlignment: popoverAnchorAlignment,
                popoverPadding: popoverPadding,
                stateBuilder: stateBuilder,
              ));

  static ArcaneField time({
    String? name,
    String? description,
    IconData? icon,
    DateTime? defaultValue,
    required Future<DateTime> Function() getter,
    required Future Function(DateTime) setter,
    PromptMode mode = PromptMode.popover,
    ValueChanged<TimeOfDay?>? onChanged,
    AlignmentGeometry? popoverAlignment,
    AlignmentGeometry? popoverAnchorAlignment,
    EdgeInsetsGeometry? popoverPadding,
    bool? use24HourFormat,
    bool showSeconds = false,
    Widget? dialogTitle,
  }) =>
      ArcaneField<DateTime>(
          meta: ArcaneFieldMetadata(
            name: name,
            description: description,
            icon: icon,
          ),
          provider: ArcaneFieldDirectProvider(
              defaultValue: defaultValue ?? DateTime.now(),
              getter: (_) => getter(),
              setter: (_, v) => setter(v)),
          builder: (context) => ArcaneTimeField(
                mode: mode,
                onChanged: onChanged,
                popoverAlignment: popoverAlignment,
                popoverAnchorAlignment: popoverAnchorAlignment,
                popoverPadding: popoverPadding,
                use24HourFormat: use24HourFormat,
                showSeconds: showSeconds,
                dialogTitle: dialogTitle,
              ));

  static ArcaneField checkbox(
          {String? name,
          String? description,
          IconData? icon,
          bool defaultValue = false,
          required Future<bool> Function() getter,
          required Future Function(bool) setter}) =>
      ArcaneField<bool>(
          meta: ArcaneFieldMetadata(
            name: name,
            description: description,
            icon: icon,
          ),
          provider: ArcaneFieldDirectProvider(
              defaultValue: defaultValue,
              getter: (_) => getter(),
              setter: (_, v) => setter(v)),
          builder: (context) => ArcaneBoolField());

  static ArcaneField select<T extends Enum>(
          {String? name,
          String? description,
          IconData? icon,
          ArcaneEnumFieldType? mode,
          Widget Function(BuildContext, T)? itemBuilder,
          Widget Function(BuildContext, T, T)? cardBuilder,
          required T defaultValue,
          required List<T> options,
          required Future<T> Function() getter,
          required Future Function(T) setter}) =>
      ArcaneField<T>(
          meta: ArcaneFieldMetadata(
            name: name,
            description: description,
            icon: icon,
          ),
          provider: ArcaneFieldDirectProvider(
              defaultValue: defaultValue,
              getter: (_) => getter(),
              setter: (_, v) => setter(v)),
          builder: (context) => ArcaneEnumField<T>(
                options: options,
                mode: mode,
                itemBuilder: itemBuilder,
                cardBuilder: cardBuilder,
              ));

  static ArcaneField selectDropdown<T extends Enum>(
          {String? name,
          String? description,
          IconData? icon,
          Widget Function(BuildContext, T)? itemBuilder,
          Widget Function(BuildContext, T, T)? cardBuilder,
          required T defaultValue,
          required List<T> options,
          required Future<T> Function() getter,
          required Future Function(T) setter}) =>
      select<T>(
          mode: ArcaneEnumFieldType.dropdown,
          getter: getter,
          setter: setter,
          name: name,
          options: options,
          defaultValue: defaultValue,
          icon: icon,
          itemBuilder: itemBuilder,
          cardBuilder: cardBuilder,
          description: description);

  static ArcaneField selectCards<T extends Enum>(
          {String? name,
          String? description,
          IconData? icon,
          Widget Function(BuildContext, T)? itemBuilder,
          Widget Function(BuildContext, T, T)? cardBuilder,
          required T defaultValue,
          required List<T> options,
          required Future<T> Function() getter,
          required Future Function(T) setter}) =>
      select<T>(
          mode: ArcaneEnumFieldType.cards,
          getter: getter,
          setter: setter,
          name: name,
          options: options,
          defaultValue: defaultValue,
          icon: icon,
          itemBuilder: itemBuilder,
          cardBuilder: cardBuilder,
          description: description);

  static ArcaneField<String> text(
          {String? name,
          String? description,
          IconData? icon,
          String? placeholder,
          int? minLines,
          int? maxLines,
          String defaultValue = "",
          required Future<String> Function() getter,
          required Future Function(String) setter}) =>
      ArcaneField<String>(
          meta: ArcaneFieldMetadata(
            name: name,
            description: description,
            icon: icon,
            placeholder: placeholder,
          ),
          provider: ArcaneFieldDirectProvider(
              defaultValue: defaultValue,
              getter: (_) => getter(),
              setter: (_, v) => setter(v)),
          builder: (context) => ArcaneStringField(
                minLines: minLines,
                maxLines: maxLines,
              ));

  static ArcaneField<String> textArea(
          {String? name,
          String? description,
          IconData? icon,
          String? placeholder,
          int? minLines = 3,
          int? maxLines = 6,
          String defaultValue = "",
          required Future<String> Function() getter,
          required Future Function(String) setter}) =>
      ArcaneInput.text(
          getter: getter,
          setter: setter,
          name: name,
          description: description,
          icon: icon,
          placeholder: placeholder,
          minLines: minLines,
          maxLines: maxLines,
          defaultValue: defaultValue);
}

class ArcaneField<T> extends StatelessWidget {
  final ArcaneFieldMetadata meta;
  final ArcaneFieldProvider<T> provider;
  final PylonBuilder builder;

  Type get dataRuntimeType => T;

  const ArcaneField({
    super.key,
    required this.meta,
    required this.provider,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) => Pylon<ArcaneField<T>>(
        value: this,
        builder: builder,
      );
}

class ArcaneFieldMetadata {
  final String? key;
  final String? name;
  final String? description;
  final IconData? icon;
  final dynamic placeholder;

  const ArcaneFieldMetadata({
    this.name,
    this.key,
    this.icon,
    this.description,
    this.placeholder,
  });

  String get effectiveKey =>
      key ??
      name?.toLowerCase().replaceAll(' ', '_').replaceAll("/", ".") ??
      "no_key";
}

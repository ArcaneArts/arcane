import 'package:arcane/arcane.dart';

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

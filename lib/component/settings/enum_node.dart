import 'package:arcane/arcane.dart';
import 'package:arcane/component/settings/core.dart';

enum KUIEnumNodeMode { dropdown, cards }

class KUIEnumNode<T extends Enum> extends StatelessWidget {
  final KUIEnumNodeMode? mode;
  final List<T> options;

  const KUIEnumNode({super.key, this.mode, required this.options});

  @override
  Widget build(BuildContext context) {
    KField<T> field = context.pylon<KField<T>>();
    return KFieldWrapper<T>(
        builder: (context) => switch (mode ??
                (options.length > 3
                    ? KUIEnumNodeMode.dropdown
                    : KUIEnumNodeMode.cards)) {
              KUIEnumNodeMode.dropdown => Select<T>(
                  itemBuilder: (context, item) {
                    return Stack(
                      children: [
                        ...options
                            .where((e) => e.name.length > item.name.length)
                            .map((e) =>
                                Opacity(opacity: 0, child: Text(e.name))),
                        Text(item.name)
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
                              child: Text(i.name),
                            )),
                      ],
                    ),
                  ).call,
                ),
              KUIEnumNodeMode.cards => CardCarousel(
                  featherColor: Theme.of(context).colorScheme.card,
                  children: [
                    ...options
                        .map((e) => Card(
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
                              child: Text(e.name),
                            ))
                        .whereType<Widget>()
                        .joinSeparator(Gap(8))
                  ],
                )
            });
  }
}

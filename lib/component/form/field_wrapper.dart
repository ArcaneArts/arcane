import 'package:arcane/arcane.dart';

class ArcaneFieldWrapper<T> extends StatelessWidget {
  final PylonBuilder builder;
  final bool overrideTileScaffold;

  const ArcaneFieldWrapper(
      {super.key, required this.builder, this.overrideTileScaffold = false});

  @override
  Widget build(BuildContext context) {
    ArcaneField<T> field = context.pylon<ArcaneField<T>>();
    return field.provider
        .getValue(field.meta.effectiveKey)
        .buildNullable((v) => (field.provider.subject
            .buildNullable((v) => overrideTileScaffold
                ? Pylon<T>(
                    value: v ?? field.provider.defaultValue,
                    builder: builder,
                  )
                : ListTile(
                    leading:
                        field.meta.icon != null ? Icon(field.meta.icon!) : null,
                    subtitleText: field.meta.description,
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (field.meta.name != null) ...[
                              Flexible(child: Text(field.meta.name!).xSmall),
                              Gap(8),
                            ],
                            Icon(Icons.check, size: 12, color: Colors.green)
                                .padTop(4)
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
                        ),
                        Gap(8),
                        v == null
                            ? Text("Loading...")
                            : Builder(builder: builder),
                        Gap(4)
                      ],
                    ),
                  ))
            .shimmer(loading: v == null)));
  }
}

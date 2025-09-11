import 'package:arcane/arcane.dart';

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

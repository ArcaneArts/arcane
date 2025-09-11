import 'package:arcane/arcane.dart';
import 'package:arcane/component/settings/core.dart';

class KUIBoolNode extends StatelessWidget {
  const KUIBoolNode({super.key});

  @override
  Widget build(BuildContext context) {
    KField<bool> field = context.pylon<KField<bool>>();
    return KFieldWrapper<bool>(
        overrideTileScaffold: true,
        builder: (context) {
          bool v = context.pylon<bool>();
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                  child: CheckboxTile(
                checkPosition: TileWidgetPosition.leading,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                leadingPadding: EdgeInsets.zero,
                tristate: false,
                value: v,
                onChanged: (v) => field.provider.setValue(
                    field.meta.effectiveKey, v ?? field.provider.defaultValue),
                leading:
                    field.meta.icon != null ? Icon(field.meta.icon!) : null,
                subtitleText: field.meta.description,
                title: Text(field.meta.name).xSmall,
              )),
              Gap(8),
              Icon(Icons.check, size: 12, color: Colors.green)
                  .animate(key: ValueKey(v))
                  .fadeIn(
                      duration: 1.seconds, curve: Curves.easeOutCirc, begin: 0)
                  .fadeOut(
                      delay: 1.seconds,
                      begin: 1,
                      duration: 3.seconds,
                      curve: Curves.easeOutCirc)
            ],
          );
        });
  }
}

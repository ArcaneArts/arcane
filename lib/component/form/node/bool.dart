import 'package:arcane/arcane.dart';

/// Compact boolean toggle field for Arcane forms, rendered as a [Checkbox] with metadata-driven labeling and animation.
///
/// This class extends [StatelessWidget] and provides a space-efficient toggle for boolean values, overriding the default
/// tile scaffold for inline placement within larger forms via [ArcaneFieldWrapper<bool>]. It features animated green
/// check confirmation on toggle to true for visual feedback and optional description display below the checkbox.
/// Integrates directly with [ArcaneField<bool>] for state management, suitable for flags, preferences,
/// or yes/no inputs like "Enable notifications". The minimal column layout ensures it fits seamlessly alongside
/// other fields like [ArcaneStringField] without disrupting form flow.
///
/// The widget uses the provider value to set [CheckboxState], applies icon/name from metadata, and updates on change,
/// with fade animations for the check icon to enhance interactivity in the Arcane UI.
///
/// Usage example:
/// ```dart
/// ArcaneBoolField(), // Relies on ArcaneField meta for name, icon, description
/// ```
class ArcaneBoolField extends StatelessWidget {
  /// Constructs the minimal boolean field widget without arguments.
  ///
  /// This static packed constructor maintains the widgets' default behavior, activating from the [ArcaneField<bool>]
  /// provider's value with no additional configuration. It seamlessly fits as an on/off choice in compact form layouts,
  /// handling checkbox state and theming via [ArcaneFieldWrapper] integration.
  const ArcaneBoolField({super.key});

  /// Builds the boolean field UI as a minimal [Column] with [Checkbox] and optional description, wrapped in [ArcaneFieldWrapper<bool>].
  ///
  /// This method retrieves the [ArcaneField<bool>] and current value, constructs a [Row] for the checkbox with gap:0,
  /// incorporating metadata icon and name as [Text.xSmall], followed by an animated [Icon(Icons.check, green)] that
  /// fades in on true (1s easeOutCirc) and out after delay (3s). Sets [CheckboxState] based on value, with [onChanged]
  /// updating provider to bool equivalent. If description in meta, adds muted [Text.xSmall] below. Overrides tile scaffold
  /// for inline rendering; returns [Widget] for compact toggle; side effects: provider update on tap; animated for UX.
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

import 'package:arcane/arcane.dart';

/// A data class for each shortcut/menu item.
class ShortcutItem {
  final String label;
  final SingleActivator activator;
  final VoidCallback? callback;
  final bool enabled;

  const ShortcutItem({
    required this.label,
    required this.activator,
    required this.callback,
    this.enabled = true,
  });
}

BehaviorSubject<List<AdaptiveMenuGroup>> $globalMenuItems =
    BehaviorSubject.seeded([]);

class AdaptiveMenuGroup {
  final String label;
  final List<ShortcutItem> shortcuts;

  AdaptiveMenuGroup({required this.label, required this.shortcuts});
}

class AdaptiveMenu extends StatefulWidget {
  final String label;
  final Widget child;
  const AdaptiveMenu({super.key, required this.label, required this.child});

  @override
  State<AdaptiveMenu> createState() => _AdaptiveMenuState();
}

class AdaptiveMenuOverride extends StatefulWidget {
  final List<AdaptiveMenuGroup> groups;
  final Widget child;

  const AdaptiveMenuOverride({
    super.key,
    required this.groups,
    required this.child,
  });

  @override
  State<AdaptiveMenuOverride> createState() => _AdaptiveMenuOverrideState();
}

class _AdaptiveMenuOverrideState extends State<AdaptiveMenuOverride> {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void initState() {
    List<AdaptiveMenuGroup> groups = widget.groups
        .where((i) => i.shortcuts.isNotEmpty)
        .toList();
    $globalMenuItems.add([
      ...$globalMenuItems.value.where(
        (i) => !groups.any((g) => g.label == i.label),
      ),
      ...groups,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    List<AdaptiveMenuGroup> groups = widget.groups
        .where((i) => i.shortcuts.isNotEmpty)
        .toList();

    $globalMenuItems.add(
      $globalMenuItems.value
          .where((i) => !groups.any((g) => g.label == i.label))
          .toList(),
    );
    super.dispose();
  }
}

class _AdaptiveMenuState extends State<AdaptiveMenu> {
  @override
  Widget build(BuildContext context) => Platform.isMacOS
      ? $globalMenuItems.stream.build(
          (items) => PlatformMenuBar(
            menus: [
              PlatformMenu(
                label: widget.label,
                menus: [
                  const PlatformProvidedMenuItem(
                    type: PlatformProvidedMenuItemType.quit,
                  ),
                ],
              ),
              ...items.map(
                (i) => PlatformMenu(
                  label: i.label,
                  menus: [
                    ...i.shortcuts.map(
                      (j) => PlatformMenuItem(
                        label: j.label,
                        shortcut: _macActivator(j.activator),
                        onSelected: j.enabled ? j.callback : null,
                      ),
                    ),
                  ],
                ),
              ),
              PlatformMenu(
                label: 'Help',
                menus: const [
                  PlatformProvidedMenuItem(
                    type: PlatformProvidedMenuItemType.about,
                  ),
                ],
              ),
            ],
            child: widget.child,
          ),
        )
      : CallbackShortcuts(
          bindings: {
            for (AdaptiveMenuGroup group in $globalMenuItems.value)
              for (ShortcutItem item in group.shortcuts.where((i) => i.enabled))
                item.activator: item.callback!,
          },
          child: Focus(autofocus: true, child: widget.child),
        );
}

SingleActivator _macActivator(SingleActivator original) {
  return SingleActivator(
    original.trigger,
    shift: original.shift,
    alt: original.alt,
    // Replace Control with Command on macOS (standard mapping)
    control: false,
    meta: original.meta || original.control,
  );
}

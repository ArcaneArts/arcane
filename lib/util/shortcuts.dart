import 'package:arcane/arcane.dart';

class _ArcaneShortcutIntent extends Intent {
  final LogicalKeySet keySet;

  const _ArcaneShortcutIntent(this.keySet);
}

class ArcaneShortcuts extends StatelessWidget {
  final Widget child;
  final Map<LogicalKeySet, VoidCallback> shortcuts;

  const ArcaneShortcuts(
      {super.key, this.shortcuts = const {}, required this.child});

  @override
  Widget build(BuildContext context) => Shortcuts(
          shortcuts: {
            for (var keySet in shortcuts.keys)
              keySet: _ArcaneShortcutIntent(keySet)
          },
          child: Actions(actions: {
            _ArcaneShortcutIntent: CallbackAction<_ArcaneShortcutIntent>(
                onInvoke: (intent) => shortcuts[intent.keySet]!())
          }, child: child));
}

import 'dart:math';

import 'package:arcane/arcane.dart';

class VFSEntityContainer extends StatelessWidget {
  final Widget child;

  const VFSEntityContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    VEntity ent = context.vfsEntity;
    return context.vfsController.selection
        .map((i) => i.contains(ent))
        .build((selected) => Container(
              decoration: BoxDecoration(
                borderRadius: Theme.of(context).borderRadiusMd,
                color: selected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : null,
              ),
              child: ContextMenu(
                  enabled: ent.hasContextMenu(context),
                  items: ent.buildContextMenu(context),
                  child: child),
            ));
  }
}

class VFSEntityListTile extends StatelessWidget {
  const VFSEntityListTile({super.key});

  @override
  Widget build(BuildContext context) {
    VEntity ent = context.vfsEntity;
    return VFSEntityContainer(
        child: ListTile(
      leading: ent.buildIcon(context, 24),
      title: ent.buildTitle(context),
      subtitle: ent.buildSubtitle(context),
      trailing: ent.buildTrailing(context),
      onPressed: () => context.vfsController.tap(context, ent,
          comparator: context.vfsView.comparator,
          reversed: context.vfsView.reversedComparator),
    ));
  }
}

class VFSEntityGridTile extends StatelessWidget {
  const VFSEntityGridTile({super.key});

  @override
  Widget build(BuildContext context) {
    VEntity ent = context.vfsEntity;
    return VFSEntityContainer(
        child: GhostButton(
      trailing: ent.buildTrailing(context),
      onPressed: () => context.vfsController.tap(context, ent,
          comparator: context.vfsView.comparator,
          reversed: context.vfsView.reversedComparator),
      child: Column(
        children: [
          if (ent.iconBuilder != null)
            Expanded(
                child: ent.buildIcon(
                    context,
                    (MediaQuery.of(context).size.width /
                            max(1, MediaQuery.of(context).size.width ~/ 125)) *
                        0.5)!),
          Basic(
            title: OverflowMarquee(
                child: ent.buildTitle(context).xSmall().medium()),
            subtitle: ent.buildSubtitle(context)?.xSmall().muted(), //
          )
        ],
      ),
    ));
  }
}

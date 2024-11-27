import 'dart:math';

import 'package:arcane/arcane.dart';

BehaviorSubject<Offset> _dragSlink = BehaviorSubject.seeded(Offset.zero);

class VFSEntityContainer extends StatelessWidget {
  final Widget child;

  const VFSEntityContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    VEntity ent = context.vfsEntity;
    Widget container = context.vfsController.selection
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
            ))
        .animate(
          key: ValueKey(ent.path),
        )
        .fadeIn(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutExpo,
        )
        .blurXY(
          begin: 16,
          end: 0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCirc,
        );

    Widget dg = LongPressDraggable<VEntity>(
        onDragStarted: () {
          if (!context.vfsController.selection.value.contains(ent)) {
            context.vfsController.selection
                .add([...context.vfsController.selection.value, ent]);
          }
        },
        key: ValueKey("drag_${ent.path}"),
        data: ent,
        feedback: Pylon<VFSController>(
          value: context.vfsController,
          builder: (context) => VFSTileDraggablePreview(child: child),
        ),
        child: container);

    return ent is VFolder
        ? DragTarget<VEntity>(
            onAcceptWithDetails: (data) =>
                context.vfsController.moveInto(ent, data.data),
            builder: (context, candidateData, rejectedData) => dg,
          )
        : dg;
  }
}

class VFSTileDraggablePreview extends StatelessWidget {
  final Widget child;

  const VFSTileDraggablePreview({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    List<VEntity> entity = context.vfsController.selection.value;
    int g = 0;
    return Stack(
      children: [
        ...entity.take(5).withPylons((i) => Transform.translate(
              offset: Offset(g * 8, (g++) * 8),
              child: SurfaceCard(
                surfaceBlur: (Theme.of(context).surfaceBlur ?? 36) * 1 / g,
                surfaceOpacity:
                    (Theme.of(context).surfaceOpacity ?? 0.5) * (1 / g),
                child: IgnorePointer(
                  ignoring: true,
                  child: child.iw.ih,
                ),
              ),
            ))
      ],
    );

    return const Placeholder();
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

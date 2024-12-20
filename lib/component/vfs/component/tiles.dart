import 'dart:math';

import 'package:arcane/arcane.dart';

BehaviorSubject<Offset> _dragSlink = BehaviorSubject.seeded(Offset.zero);

class VFSEntityContainer extends StatefulWidget {
  final Widget child;

  const VFSEntityContainer({super.key, required this.child});

  @override
  State<VFSEntityContainer> createState() => _VFSEntityContainerState();
}

class _VFSEntityContainerState extends State<VFSEntityContainer>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    VEntity ent = context.vfsEntity;
    Widget container = context.vfs.selection
        .map((i) => i.contains(ent))
        .build((selected) {
          List<MenuItem> menu = context.vfs
              .getEntityMenuItems(context, context.vfs.selectionWithFocus(ent))
              .toList();
          return Container(
            decoration: BoxDecoration(
              borderRadius: Theme.of(context).borderRadiusMd,
              color: selected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : null,
            ),
            child: ContextMenu(
                enabled: menu.isNotEmpty, items: menu, child: widget.child),
          );
        })
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
          if (!context.vfs.selection.value.contains(ent)) {
            context.vfs.selection.add([...context.vfs.selection.value, ent]);
          }
        },
        key: ValueKey("drag_${ent.path}"),
        data: ent,
        feedback: Pylon<VFS>(
          value: context.vfs,
          builder: (context) => VFSTileDraggablePreview(child: widget.child),
        ),
        child: container);

    return ent is VFolder
        ? DragTarget<VEntity>(
            onAcceptWithDetails: (data) => context.vfs.moveInto(ent, data.data),
            builder: (context, candidateData, rejectedData) => dg,
          )
        : dg;
  }

  @override
  bool get wantKeepAlive => true;
}

class VFSTileDraggablePreview extends StatelessWidget {
  final Widget child;

  const VFSTileDraggablePreview({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    List<VEntity> entity = context.vfs.selection.value;
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
      onPressed: () => context.vfs.tap(context, ent),
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
      onPressed: () => context.vfs.tap(context, ent),
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

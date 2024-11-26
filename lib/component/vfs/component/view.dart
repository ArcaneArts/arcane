import 'dart:math';

import 'package:arcane/arcane.dart';

enum VFSViewMode {
  list,
  grid,
}

class VFSEntityContainer extends StatelessWidget {
  final Widget child;

  const VFSEntityContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    VEntity ent = context.vfsEntity;
    return ContextMenu(
        enabled: ent.hasContextMenu(context),
        items: ent.buildContextMenu(context),
        child: child);
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
      onPressed: () => ent is VFolder
          ? context.vfsController.openFolder(ent)
          : ent is VFile
              ? ent.onOpen != null
                  ? ent.onOpen!(context)
                  : null
              : null,
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
      onPressed: () => ent is VFolder
          ? context.vfsController.openFolder(ent)
          : ent is VFile
              ? ent.onOpen != null
                  ? ent.onOpen!(context)
                  : null
              : null,
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

extension XContextVFSEntity on BuildContext {
  VEntity get vfsEntity => pylon<VEntity>();
  VFSController get vfsController => pylon<VFSController>();
}

class VFSView extends StatefulWidget {
  final String workingDirectory;
  final VFS vfs;
  final List<VFSLayout> layouts;
  final List<VFSComparator> comparators;

  const VFSView(
      {super.key,
      this.comparators = const [VFSComparatorName()],
      required this.vfs,
      this.layouts = const [VFSLayoutList(), VFSLayoutGrid()],
      this.workingDirectory = "/"});

  @override
  State<VFSView> createState() => _VFSViewState();
}

class _VFSViewState extends State<VFSView> {
  late VFSComparator comparator;
  late bool reversedComparator;
  late VFSController vfs;
  late VFSLayout layout;
  BehaviorSubject<int> updater = BehaviorSubject.seeded(0);

  @override
  void initState() {
    vfs = VFSController(
        vfs: widget.vfs, workingDirectory: widget.workingDirectory);
    comparator = widget.comparators.first;
    reversedComparator = true;
    layout = widget.layouts.first;
    super.initState();
  }

  void _update() => updater.add(updater.value + 1);

  @override
  Widget build(BuildContext context) =>
      updater.build((_) => Pylon<VFSController>(
            value: vfs,
            builder: (context) => vfs.workingVFolder.build(
              (wd) => SliverScreen(
                gutter: false,
                header: Bar(
                  titleText: "VFS Explorer",
                  subtitleText: wd.path,
                  leading: [
                    if (vfs.canGoUp)
                      IconButton(
                        icon: const Icon(Icons.chevron_up_outline_ionic),
                        onPressed: vfs.canGoUp ? vfs.goUp : null,
                      ),
                  ],
                  trailing: [
                    IconButtonMenu(icon: Icons.filter_ionic, items: [
                      MenuButton(
                        leading: const Icon(Icons.eye),
                        subMenu: [
                          ...widget.layouts.map((l) => MenuButton(
                                autoClose: false,
                                onPressed: (_) {
                                  layout = l;
                                  _update();
                                },
                                trailing: updater.build((_) => layout == l
                                    ? const Icon(Icons.check)
                                    : const SizedBox.shrink()),
                                leading: Icon(l.icon),
                                child: Text(l.name),
                              ))
                        ],
                        child: Text("View"),
                      ),
                      MenuButton(
                        leading: const Icon(Icons.eye),
                        subMenu: [
                          ...widget.comparators.map((c) => MenuButton(
                                autoClose: false,
                                onPressed: (_) {
                                  if (comparator == c) {
                                    reversedComparator = !reversedComparator;
                                  } else {
                                    comparator = c;
                                    reversedComparator = true;
                                  }
                                  _update();
                                },
                                trailing: updater.build((_) => comparator == c
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.check),
                                          const Gap(4),
                                          reversedComparator
                                              ? const Icon(Icons.arrow_down)
                                              : const Icon(Icons.arrow_up),
                                        ],
                                      )
                                    : const SizedBox.shrink()),
                                leading: Icon(c.icon),
                                child: Text(c.name),
                              )),
                        ],
                        child: Text("Sort"),
                      )
                    ])
                  ],
                ),
                sliver: vfs.vfs.getChildren(wd).toList().build(
                    (l) => layout.build(
                        context,
                        vfs,
                        l,
                        reversedComparator
                            ? comparator.compareReversed
                            : comparator.compare),
                    loading: const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )),
              ),
              loading: const FillScreen(
                  header: Text("Loading VFS"),
                  child: Center(
                    child: CircularProgressIndicator(),
                  )),
            ),
          ));
}

class VFSComparatorEntityType extends VFSComparator {
  const VFSComparatorEntityType()
      : super(name: "Entity Type", icon: Icons.folder_open);

  @override
  int compare(VEntity a, VEntity b) => a is VFolder && b is VFile ? -1 : 1;
}

class VFSComparatorName extends VFSComparator {
  const VFSComparatorName() : super(name: "Name", icon: Icons.text_aa);

  @override
  int compare(VEntity a, VEntity b) => a.name.compareTo(b.name);
}

abstract class VFSComparator {
  final String name;
  final IconData icon;

  const VFSComparator({required this.name, required this.icon});

  int compare(VEntity a, VEntity b);

  int compareReversed(VEntity a, VEntity b) => -compare(a, b);
}

class VFSLayoutList extends VFSLayout {
  const VFSLayoutList({super.name = "List", super.icon = Icons.list});

  @override
  Widget build(BuildContext context, VFSController vfs, List<VEntity> entities,
          int Function(VEntity, VEntity)? comparator) =>
      SListView(
        children: [
          ...entities
              .sorted(comparator)
              .sorted(VFSComparatorEntityType().compare)
              .withPylons((context) => VFSEntityListTile())
        ],
      );
}

class VFSLayoutGrid extends VFSLayout {
  const VFSLayoutGrid({super.name = "Grid", super.icon = Icons.grid_four});

  @override
  Widget build(BuildContext context, VFSController vfs, List<VEntity> entities,
      int Function(VEntity, VEntity)? comparator) {
    double w = MediaQuery.of(context).size.width;
    return SGridView(
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      crossAxisCount: max(1, w ~/ 125),
      children: [
        ...entities
            .sorted(comparator)
            .sorted(VFSComparatorEntityType().compare)
            .withPylons((context) => VFSEntityGridTile())
      ],
    );
  }
}

abstract class VFSLayout {
  final String name;
  final IconData icon;

  const VFSLayout({required this.name, required this.icon});

  Widget build(BuildContext context, VFSController vfs, List<VEntity> entities,
      int Function(VEntity, VEntity)? comparator);
}

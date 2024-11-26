import 'package:arcane/arcane.dart';

extension XContextVFSEntity on BuildContext {
  VEntity get vfsEntity => pylon<VEntity>();
  VFSController get vfsController => pylon<VFSController>();
  VFSViewState get vfsView => pylon<VFSViewState>();
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
  State<VFSView> createState() => VFSViewState();
}

class VFSViewState extends State<VFSView> {
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
  Widget build(BuildContext context) => Pylon<VFSViewState>(
      value: this,
      builder: (context) => updater.build((_) => Pylon<VFSController>(
            value: vfs,
            builder: (context) => vfs.workingVFolder.build(
              (wd) => ContextMenu(
                  enabled: false,
                  items: [],
                  child: GestureDetector(
                    onTap: () {
                      vfs.selection.add([]);
                    },
                    child: SliverScreen(
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
                                          reversedComparator =
                                              !reversedComparator;
                                        } else {
                                          comparator = c;
                                          reversedComparator = true;
                                        }
                                        _update();
                                      },
                                      trailing:
                                          updater.build((_) => comparator == c
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(Icons.check),
                                                    const Gap(4),
                                                    reversedComparator
                                                        ? const Icon(
                                                            Icons.arrow_down)
                                                        : const Icon(
                                                            Icons.arrow_up),
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
                      sliver: vfs.vfs
                          .getChildren(wd,
                              comparator: comparator,
                              reverse: reversedComparator)
                          .toList()
                          .build((l) => layout.build(context, vfs, l),
                              loading: const SliverFillRemaining(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )),
                    ),
                  )),
              loading: const FillScreen(
                  header: Text("Loading VFS"),
                  child: Center(
                    child: CircularProgressIndicator(),
                  )),
            ),
          )));
}
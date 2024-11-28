import 'package:arcane/arcane.dart';
import 'package:desktop_drop/desktop_drop.dart';

extension XContextVFSEntity on BuildContext {
  VEntity get vfsEntity => pylon<VEntity>();
  VFS get vfs => pylon<VFS>();
  VFSViewState get vfsView => pylon<VFSViewState>();
}

class VFSView extends StatefulWidget {
  final VFS vfs;
  const VFSView({super.key, required this.vfs});

  @override
  State<VFSView> createState() => VFSViewState();
}

class VFSViewState extends State<VFSView> {
  late BehaviorSubject<bool> _dropZone = BehaviorSubject.seeded(false);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Pylon<VFSViewState>(
      value: this,
      builder: (context) => widget.vfs.listen.build((_) => Pylon<VFS>(
            value: widget.vfs,
            builder: (context) => widget.vfs.workingVFolder.build(
              (wd) => ContextMenu(
                  enabled: false,
                  items: _buildMenu(context),
                  child: GestureDetector(
                    onTap: () {
                      widget.vfs.selection.add([]);
                    },
                    child: DropTarget(
                        onDragDone: (detail) {
                          _dropZone.add(false);
                          widget.vfs.insertDrop(context, detail.files);
                        },
                        onDragEntered: (detail) => _dropZone.add(true),
                        onDragExited: (detail) => _dropZone.add(false),
                        child: SliverScreen(
                          gutter: false,
                          header: Bar(
                            titleText: "VFS Explorer",
                            subtitleText: wd.path,
                            leading: [
                              if (widget.vfs.canGoUp)
                                DragTarget<VEntity>(
                                    onAcceptWithDetails: (data) =>
                                        context.vfs.moveUpOut(data.data),
                                    builder: (context, candidateData,
                                            rejectedData) =>
                                        IconButton(
                                          icon: const Icon(
                                              Icons.chevron_up_outline_ionic),
                                          onPressed: widget.vfs.canGoUp
                                              ? widget.vfs.goUp
                                              : null,
                                        )),
                            ],
                            trailing: [
                              IconButtonMenu(
                                  icon: Icons.filter_ionic,
                                  items: _buildMenu(context))
                            ],
                          ),
                          sliver: widget.vfs.getChildren(wd).toList().build(
                              (l) => widget.vfs.currentLayout
                                  .build(context, widget.vfs, l),
                              loading: const SliverFillRemaining(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )),
                        )),
                  )),
              loading: const FillScreen(
                  header: Text("Loading VFS"),
                  child: Center(
                    child: CircularProgressIndicator(),
                  )),
            ),
          )));

  List<MenuItem> _buildMenu(BuildContext context) => [
        MenuButton(
            leading: Icon(Icons.folder_plus),
            onPressed: (_) => widget.vfs.mkdirDialog(context),
            child: Text("New Folder")),
        MenuButton(
          leading: const Icon(Icons.eye),
          subMenu: widget.vfs.buildLayoutMenuItems(context).toList(),
          child: Text("View"),
        ),
        MenuButton(
          leading: const Icon(Icons.arrows_down_up),
          subMenu: widget.vfs.buildComparatorMenuItems(context).toList(),
          child: Text("Sort"),
        )
      ];
}

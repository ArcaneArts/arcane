import 'package:arcane/arcane.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/services.dart';

extension XContextVFSEntity on BuildContext {
  VEntity get vfsEntity => pylon<VEntity>();
  VFS get vfs => pylon<VFS>();
  VFSViewState get vfsView => pylon<VFSViewState>();
}

class VFSNewFolderIntent extends Intent {
  const VFSNewFolderIntent();
}

class VFSSelectAllIntent extends Intent {
  const VFSSelectAllIntent();
}

class VFSDeselectIntent extends Intent {
  const VFSDeselectIntent();
}

class VFSNewGoUpIntent extends Intent {
  const VFSNewGoUpIntent();
}

class VFSDirectionalIntent extends Intent {
  final Offset drift;

  const VFSDirectionalIntent(this.drift);
}

class VFSDirectionalExpandIntent extends Intent {
  final Offset drift;

  const VFSDirectionalExpandIntent(this.drift);
}

class VFSRenameIntent extends Intent {
  const VFSRenameIntent();
}

class VFSDeleteIntent extends Intent {
  const VFSDeleteIntent();
}

class VFSOpenIntent extends Intent {
  const VFSOpenIntent();
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
  Widget build(BuildContext context) => Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
              const VFSNewFolderIntent(),
          LogicalKeySet(LogicalKeyboardKey.escape): const VFSDeselectIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyA):
              const VFSSelectAllIntent(),
          LogicalKeySet(LogicalKeyboardKey.backspace): const VFSNewGoUpIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.arrowUp):
              const VFSNewGoUpIntent(),
          LogicalKeySet(LogicalKeyboardKey.delete): const VFSDeleteIntent(),
          LogicalKeySet(LogicalKeyboardKey.f2): const VFSRenameIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyR):
              const VFSRenameIntent(),
          LogicalKeySet(LogicalKeyboardKey.enter): const VFSOpenIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowUp):
              const VFSDirectionalIntent(Offset(0, -1)),
          LogicalKeySet(LogicalKeyboardKey.arrowDown):
              const VFSDirectionalIntent(Offset(0, 1)),
          LogicalKeySet(LogicalKeyboardKey.arrowLeft):
              const VFSDirectionalIntent(Offset(-1, 0)),
          LogicalKeySet(LogicalKeyboardKey.arrowRight):
              const VFSDirectionalIntent(Offset(1, 0)),
          LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowUp):
              const VFSDirectionalExpandIntent(Offset(0, -1)),
          LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowDown):
              const VFSDirectionalExpandIntent(Offset(0, 1)),
          LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowLeft):
              const VFSDirectionalExpandIntent(Offset(-1, 0)),
          LogicalKeySet(
                  LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowRight):
              const VFSDirectionalExpandIntent(Offset(1, 0)),
        },
        child: Actions(
            actions: {
              VFSSelectAllIntent: CallbackAction<VFSSelectAllIntent>(
                  onInvoke: (intent) => widget.vfs.selectAll()),
              VFSDeselectIntent: CallbackAction<VFSDeselectIntent>(
                  onInvoke: (intent) => widget.vfs.selection.add([])),
              VFSNewGoUpIntent:
                  CallbackAction<VFSNewGoUpIntent>(onInvoke: (intent) {
                if (widget.vfs.canGoUp) {
                  widget.vfs.goUp();
                }
              }),
              VFSDirectionalIntent:
                  CallbackAction<VFSDirectionalIntent>(onInvoke: (intent) {
                widget.vfs.moveSelection(intent.drift);
              }),
              VFSDirectionalExpandIntent:
                  CallbackAction<VFSDirectionalExpandIntent>(
                      onInvoke: (intent) {
                widget.vfs.expandSelection(intent.drift);
              }),
              VFSOpenIntent: CallbackAction<VFSOpenIntent>(onInvoke: (intent) {
                if (widget.vfs.selection.value.isNotEmpty &&
                    widget.vfs.selection.value.length == 1) {
                  widget.vfs.tapOpen(context, widget.vfs.selection.value.first);
                }
              }),
              VFSRenameIntent:
                  CallbackAction<VFSRenameIntent>(onInvoke: (intent) {
                if (widget.vfs.selection.value.isNotEmpty &&
                    widget.vfs.selection.value.length == 1) {
                  widget.vfs
                      .renameDialog(context, widget.vfs.selection.value.first);
                }
              }),
              VFSNewFolderIntent: CallbackAction<VFSNewFolderIntent>(
                  onInvoke: (intent) => widget.vfs.mkdirDialog(context)),
              VFSDeleteIntent: CallbackAction<VFSDeleteIntent>(
                  onInvoke: (intent) => widget.vfs
                      .deleteDialog(context, widget.vfs.selection.value))
            },
            child: Focus(
              autofocus: true,
              child: Pylon<VFSViewState>(
                  value: this,
                  builder: (context) => widget.vfs.listen.build((_) =>
                      Pylon<VFS>(
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
                                        widget.vfs
                                            .insertDrop(context, detail.files);
                                      },
                                      onDragEntered: (detail) =>
                                          _dropZone.add(true),
                                      onDragExited: (detail) =>
                                          _dropZone.add(false),
                                      child: SliverScreen(
                                        gutter: false,
                                        header: Bar(
                                          titleText: "VFS Explorer",
                                          subtitleText: wd.path,
                                          leading: [
                                            if (widget.vfs.canGoUp)
                                              DragTarget<VEntity>(
                                                  onAcceptWithDetails: (data) =>
                                                      context.vfs
                                                          .moveUpOut(data.data),
                                                  builder: (context,
                                                          candidateData,
                                                          rejectedData) =>
                                                      IconButton(
                                                        icon: const Icon(Icons
                                                            .chevron_up_outline_ionic),
                                                        onPressed: widget
                                                                .vfs.canGoUp
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
                                        sliver: widget.vfs
                                            .getChildren(wd)
                                            .toList()
                                            .build(
                                                (l) => widget.vfs.currentLayout
                                                    .build(
                                                        context, widget.vfs, l),
                                                loading:
                                                    const SliverFillRemaining(
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                )),
                                      )))),
                          loading: const FillScreen(
                              header: Text("Loading VFS"),
                              child: Center(
                                child: CircularProgressIndicator(),
                              )),
                        ),
                      ))),
            )),
      );

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

extension XVEntityTreeNode on VEntity {
  Future<TreeNode<VEntity>> treeNode(BuildContext context,
      {bool addChildren = false}) async {
    return TreeItem<VEntity>(
        data: this,
        children: this is VFolder && addChildren
            ? await Future.wait(await context.vfs
                .getChildren(this as VFolder)
                .asyncMap((e) =>
                    e.map((e) => e.treeNode(context, addChildren: addChildren)))
                .toList())
            : []);
  }
}

class VFSTreeView extends StatelessWidget {
  const VFSTreeView({super.key});

  Future<List<TreeNode<VEntity>>> buildTree(BuildContext context) async {
    List<TreeNode<VEntity>> nodes = [];
    VFS vfs = context.vfs;
    VFolder root = vfs.root;
    VFolder wd = (await vfs.getEntity(vfs.workingDirectory)) as VFolder;

    nodes.add(TreeRoot<VEntity>(children: [
      ...(await root.treeNode(context, addChildren: true)).children,
    ]));

    print("Nodes: ${nodes.length}");
    return nodes;
  }

  @override
  Widget build(BuildContext context) => context.vfs.listen.build(
      (_) => buildTree(context).build((i) => TreeView<VEntity>(
          allowMultiSelect: true,
          branchLine: BranchLine.path,
          key: ValueKey("vfs_tree"),
          shrinkWrap: true,
          nodes: i,
          builder: (context, node) {
            return TreeItemView(child: Text("Node"));
          })),
      loading: const Center(child: CircularProgressIndicator()));
}

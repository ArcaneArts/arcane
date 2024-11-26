import 'package:arcane/arcane.dart';

Widget _defaultEntityBuilder(
        BuildContext context, VFSController vfs, List<VEntity> entities) =>
    SListView(
      children: [
        if (vfs.canGoUp)
          ListTile(
            title: const Text('..'),
            leading: const Icon(Icons.arrow_up),
            onPressed: vfs.goUp,
          ),
        for (VEntity entity in entities)
          ListTile(
            title: Text(entity.name),
            leading: entity is VFolder
                ? const Icon(Icons.folder)
                : const Icon(Icons.file),
            onPressed: () {
              if (entity is VFolder) {
                vfs.openFolder(entity);
              }
            },
          ),
      ],
    );

class VFSView extends StatefulWidget {
  final String workingDirectory;
  final VFS vfs;
  final Widget Function(BuildContext, VFSController, List<VEntity> entities)
      entitySliverBuilder;

  const VFSView(
      {super.key,
      required this.vfs,
      required this.workingDirectory,
      this.entitySliverBuilder = _defaultEntityBuilder});

  @override
  State<VFSView> createState() => _VFSViewState();
}

class _VFSViewState extends State<VFSView> {
  late VFSController vfs;

  @override
  void initState() {
    vfs = VFSController(
        vfs: widget.vfs, workingDirectory: widget.workingDirectory);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => vfs.workingVFolder.build(
        (wd) => SliverScreen(
          header: Bar(
            titleText: "VFS Explorer",
            subtitleText: wd.path,
          ),
          sliver: vfs.vfs
              .getChildren(wd)
              .toList()
              .build((l) => widget.entitySliverBuilder(context, vfs, l),
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
      );
}

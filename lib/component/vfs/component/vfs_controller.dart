import 'package:arcane/arcane.dart';

class VFSController {
  final VFS vfs;
  final BehaviorSubject<String> workingDirectory;
  final BehaviorSubject<VFolder> workingVFolder;

  VFSController({required this.vfs, String workingDirectory = "/"})
      : workingDirectory = BehaviorSubject.seeded(workingDirectory),
        workingVFolder =
            BehaviorSubject.seeded(VFolder(path: workingDirectory, vfs: vfs)) {
    this.workingDirectory.listen((wd) {
      workingVFolder.add(VFolder(path: wd, vfs: vfs));
    });
  }

  bool get canGoUp => VPaths.hasParent(workingDirectory.value);

  void openFolder(VFolder entity) {
    workingDirectory.add(entity.path);
  }

  void goUp() {
    workingDirectory.add(VPaths.parentOf(workingDirectory.value));
  }
}

import 'package:arcane/arcane.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:universal_io/io.dart';

class IOVFS extends VFS {
  final Directory rootDirectory;

  IOVFS(this.rootDirectory)
      : assert(!kIsWeb, "RealVFS is not supported on the web");

  String get realRoot => rootDirectory.path;

  String getRealPath(String localPath) =>
      VPaths.join(realRoot, localPath).replaceAll("/", Platform.pathSeparator);

  String getVFSPath(String realPath) => VPaths.localize(realPath, realRoot);

  Directory toDirectory(String path) => Directory(getRealPath(path));

  File toFile(String path) => File(getRealPath(path));

  @override
  Stream<VEntity> onGetChildren(VFolder folder) async* {
    yield* toDirectory(folder.path).list().asyncMap((entity) {
      if (entity is Directory) {
        return VFolder(
            path: VPaths.join(folder.path, VPaths.name(entity.path)),
            vfs: this);
      } else if (entity is File) {
        return VFile(
          path: VPaths.join(folder.path, VPaths.name(entity.path)),
          vfs: this,
        );
      }

      return null;
    }).whereType<VEntity>();
  }

  @override
  Future<VEntity> onGetEntity(String path) async {
    if (await FileSystemEntity.isDirectory(getRealPath(path))) {
      return VFolder(path: path, vfs: this);
    } else if (await FileSystemEntity.isFile(getRealPath(path))) {
      File file = toFile(path);
      return VFile(
        vfs: this,
        path: path,
      );
    } else {
      throw Exception('NO! (symlink?)');
    }
  }
}

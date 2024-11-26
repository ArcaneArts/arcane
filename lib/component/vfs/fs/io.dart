import 'dart:async';

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

  @override
  Future<bool> onExists(String path) => FileSystemEntity.type(getRealPath(path))
      .then((type) => type != FileSystemEntityType.notFound);

  @override
  Future<VFolder> onMakeDirectory(String path) => toDirectory(path)
      .create(recursive: false)
      .then((_) => VFolder(path: path, vfs: this));

  @override
  Future<void> onDeleteEmptyFolder(VFolder folder) =>
      toDirectory(folder.path).delete(recursive: false);

  @override
  Future<void> onDeleteFile(VFile file) => toFile(file.path).delete();

  @override
  Future<void> onMoveFile(VFile entity, String newPath) =>
      toFile(entity.path).rename(getRealPath(newPath));

  @override
  Stream<bool> onWatchDirectory(String path) => toDirectory(path)
      .watch(events: FileSystemEvent.all, recursive: false)
      .map((event) => true)
      .handleError((e) => false);

  @override
  Stream<List<int>> onReadFileStream(String path) =>
      toFile(path).openRead().map((event) => event);

  @override
  Future<void> onWriteFile(String path, Stream<List<int>> byteStream) async {
    IOSink sink = toFile(path).openWrite();
    await sink.addStream(byteStream);
    await sink.flush();
    await sink.close();
  }
}

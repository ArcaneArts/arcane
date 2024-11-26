import 'dart:typed_data';

import 'package:arcane/arcane.dart';
import 'package:fast_log/fast_log.dart';

abstract class VFS {
  final BehaviorSubject<int> _updater = BehaviorSubject.seeded(0);
  final Map<String, VEntity> _cache = {};
  final Map<String, List<String>> _childrenCache = {};

  VFolder get root => VFolder(path: VPaths.root, vfs: this);

  Stream<VEntity> onGetChildren(VFolder folder);

  Future<VFolder> onMakeDirectory(String path);

  Future<bool> onExists(String path);

  Future<bool> exists(String path) => onExists(VPaths.sanitize(path));

  Future<String> findUnallocatedName(String path) async {
    if (await exists(path)) {
      int i = 1;
      while (await exists(VPaths.appendName(path, " (copy $i)"))) {
        i++;
      }
      return VPaths.appendName(path, " (copy $i)");
    }

    return path;
  }

  Stream<int> get listen => _updater.stream;

  Stream<bool> onWatchDirectory(String path);

  Stream<bool> watchDirectory(String path) {
    network("WATCH DIR $path");
    return onWatchDirectory(VPaths.sanitize(path));
  }

  Future<VFolder> mkdir(String path,
      {bool recursive = true, bool $recursing = false}) async {
    path = VPaths.sanitize(path);
    if (!await exists(path)) {
      if (VPaths.hasParent(path)) {
        await mkdir(VPaths.parentOf(path),
            recursive: recursive, $recursing: true);
      }

      VFolder v = await onMakeDirectory(path);
      success("MKDIR $path");

      return v;
    }

    return (await getEntity(path)) as VFolder;
  }

  Future<void> move(VEntity entity, VFolder into,
      {bool $recursing = false}) async {
    if (entity is VFolder) {
      VFolder newFolder = await mkdir(into.childPath(entity.name));
      List<Future> work = [];

      for (VEntity child in await getChildren(entity).toList()) {
        work.add(move(child, newFolder, $recursing: true));
      }

      await Future.wait(work);
      if (!$recursing) {
        invalidate();
        await delete(entity);
      }
    } else if (entity is VFile) {
      await onMoveFile(entity, into.childPath(entity.name));
      warn("MOVE FILE ${entity.path} -> ${into.childPath(entity.name)}");
    }
  }

  Future<void> onDeleteFile(VFile file);

  Future<void> onDeleteEmptyFolder(VFolder folder);

  Future<void> delete(VEntity entity) async {
    if (entity is VFolder) {
      List<Future> work = [];

      for (VEntity child in await getChildren(entity).toList()) {
        work.add(delete(child));
      }

      await Future.wait(work);
      await onDeleteEmptyFolder(entity);
      error("DELETE FOLDER ${entity.path}");
      return;
    } else if (entity is VFile) {
      await onDeleteFile(entity);
      error("DELETE FILE ${entity.path}");
    }
  }

  Future<void> onMoveFile(VFile entity, String newPath);

  void update() {
    invalidate();
    _updater.add(_updater.value + 1);
    info("UPDATE");
  }

  Future<void> onWriteFile(String path, Stream<List<int>> byteStream);

  Future<void> writeFileStream(
      String path, Stream<List<int>> byteStream) async {
    await onWriteFile(VPaths.sanitize(path), byteStream);
    success("WRITE FILE $path");
  }

  Stream<List<int>> onReadFileStream(String path);

  Stream<List<int>> readFileBytes(String path) {
    info("READ FILE $path");
    return onReadFileStream(VPaths.sanitize(path));
  }

  Future<void> writeFileBytes(String path, List<int> bytes) =>
      writeFileStream(path, Stream.fromIterable([bytes]));

  Future<void> writeFileText(String path, String textContent) =>
      writeFileBytes(path, Uint8List.fromList(textContent.codeUnits));

  Stream<VEntity> getChildren(
    VFolder folder, {
    VFSComparator? comparator,
    bool reverse = false,
  }) async* {
    if (!_childrenCache.containsKey(folder.path)) {
      List<String> children = [];
      await for (VEntity entity in onGetChildren(folder)) {
        children.add(entity.path);
        _cache[entity.path] = entity;
      }

      _childrenCache[folder.path] = children;
    }

    List<VEntity> v = await Stream.fromFutures(
        _childrenCache[folder.path]!.map((i) => getEntity(i))).toList();

    if (comparator != null) {
      v = v.sorted(reverse ? comparator.compareReversed : comparator.compare);
    } else if (reverse) {
      v = v.reversed.toList();
    }

    v = v.sorted(VFSComparatorEntityType().compare);

    yield* Stream.fromIterable(v);
  }

  Future<VEntity> onGetEntity(String path);

  Future<VEntity> getEntity(String path) async {
    path = VPaths.sanitize(path);
    if (!_cache.containsKey(path)) {
      _cache[path] = await onGetEntity(path);
    }

    return _cache[path]!;
  }

  void invalidate([String? path]) {
    if (path == null) {
      _cache.clear();
      _childrenCache.clear();
      verbose("INVAL **");
    } else {
      _cache.removeWhere((k, i) => VPaths.contains(path, k));
      _childrenCache.removeWhere((k, i) => VPaths.contains(path, k));
      verbose("INVAL $path");
    }
  }
}

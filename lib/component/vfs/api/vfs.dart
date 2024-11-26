import 'package:arcane/arcane.dart';

abstract class VFS {
  final Map<String, VEntity> _cache = {};
  final Map<String, List<String>> _childrenCache = {};

  VFolder get root => VFolder(path: VPaths.root, vfs: this);

  Stream<VEntity> onGetChildren(VFolder folder);

  Stream<VEntity> getChildren(VFolder folder) async* {
    if (!_childrenCache.containsKey(folder.path)) {
      List<String> children = [];
      await for (VEntity entity in onGetChildren(folder)) {
        children.add(entity.path);
        _cache[entity.path] = entity;
      }

      _childrenCache[folder.path] = children;
    }

    yield* Stream.fromFutures(
        _childrenCache[folder.path]!.map((i) => getEntity(i)));
  }

  Future<VEntity> onGetEntity(String path);

  Future<VEntity> getEntity(String path) async {
    if (!_cache.containsKey(path)) {
      _cache[path] = await onGetEntity(path);
    }

    return _cache[path]!;
  }

  void invalidate([String? path]) {
    if (path == null) {
      _cache.clear();
      _childrenCache.clear();
    } else {
      _cache.removeWhere((k, i) => VPaths.contains(path, k));
      _childrenCache.removeWhere((k, i) => VPaths.contains(path, k));
    }
  }
}

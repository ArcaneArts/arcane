import 'package:arcane/arcane.dart';

abstract class VEntity {
  final VFS vfs;
  final String path;

  VEntity({required String path, required this.vfs})
      : path = VPaths.sanitize(path);

  String get name => path.split('/').last;

  bool get hasParent => VPaths.hasParent(path);

  String get parentPath => VPaths.parentOf(path);

  String childPath(String name) => VPaths.join(path, name);
}

class VFolder extends VEntity {
  VFolder({
    required super.vfs,
    required super.path,
  });
}

class VFile extends VEntity {
  VFile({
    required super.vfs,
    required super.path,
  });
}

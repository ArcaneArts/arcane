import 'package:arcane/arcane.dart';

Widget _buildIconFile(BuildContext context, double? size) =>
    Icon(Icons.file_fill, size: size);
Widget _buildIconFolder(BuildContext context, double? size) =>
    Icon(Icons.folder_fill, size: size);
Widget _buildTitle(BuildContext context) => Text(context.vfsEntity.name);

abstract class VEntity {
  final VFS vfs;
  final String path;
  final Widget Function(BuildContext context, double? size)? iconBuilder;
  final Widget Function(BuildContext context)? titleBuilder;
  final Widget Function(BuildContext context)? subtitleBuilder;
  final Widget Function(BuildContext context)? trailingBuilder;

  VEntity(
      {required String path,
      required this.vfs,
      this.iconBuilder,
      this.titleBuilder = _buildTitle,
      this.subtitleBuilder,
      this.trailingBuilder})
      : path = VPaths.sanitize(path);

  String get name => path.split('/').last;

  bool get hasParent => VPaths.hasParent(path);

  String get parentPath => VPaths.parentOf(path);

  String childPath(String name) => VPaths.join(path, name);

  Widget buildTitle(BuildContext context) =>
      titleBuilder?.call(context) ?? Text(name);

  Widget? buildSubtitle(BuildContext context) => subtitleBuilder?.call(context);

  Widget? buildTrailing(BuildContext context) => trailingBuilder?.call(context);

  Widget? buildIcon(BuildContext context, double? size) =>
      iconBuilder?.call(context, size);
}

class VFolder extends VEntity {
  VFolder({
    required super.vfs,
    required super.path,
    super.iconBuilder = _buildIconFolder,
    super.titleBuilder = _buildTitle,
    super.subtitleBuilder,
    super.trailingBuilder,
  });
}

class VFile extends VEntity {
  final Widget Function(BuildContext context)? onOpen;
  VFile({
    required super.vfs,
    required super.path,
    super.iconBuilder = _buildIconFile,
    super.titleBuilder = _buildTitle,
    super.subtitleBuilder,
    super.trailingBuilder,
    this.onOpen,
  });
}

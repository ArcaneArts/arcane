import 'dart:async';

import 'package:arcane/arcane.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:universal_io/io.dart';

class IOVFS extends VFS {
  final Directory rootDirectory;
  final bool showExtensions;

  IOVFS(this.rootDirectory, {this.showExtensions = true})
      : assert(!kIsWeb, "RealVFS is not supported on the web");

  String get realRoot => rootDirectory.path;

  String getRealPath(String localPath) =>
      VPaths.join(realRoot, localPath).replaceAll("/", Platform.pathSeparator);

  String getVFSPath(String realPath) => VPaths.localize(realPath, realRoot);

  Directory toDirectory(String path) => Directory(getRealPath(path));

  File toFile(String path) => File(getRealPath(path));

  VFile _vfile(String path) => VFile(
      vfs: this,
      path: path,
      iconBuilder: (context, size) => Icon(getFileIcon(path), size: size),
      titleBuilder: (context) => Text(showExtensions
          ? VPaths.name(path)
          : VPaths.hideExtension(VPaths.name(path))));

  VFolder _vfolder(String path) => VFolder(
      vfs: this,
      path: path,
      iconBuilder: (context, size) => Icon(getFolderIcon(path), size: size),
      titleBuilder: (context) => Text(VPaths.name(path)));

  @override
  Stream<VEntity> onGetChildren(VFolder folder) async* {
    yield* toDirectory(folder.path).list().asyncMap((entity) {
      if (entity is Directory) {
        return _vfolder(VPaths.join(folder.path, VPaths.name(entity.path)));
      } else if (entity is File) {
        return _vfile(
          VPaths.join(folder.path, VPaths.name(entity.path)),
        );
      }

      return null;
    }).whereType<VEntity>();
  }

  @override
  Future<VEntity?> onGetEntity(String path) async {
    if (await FileSystemEntity.isDirectory(getRealPath(path))) {
      return _vfolder(path);
    } else if (await FileSystemEntity.isFile(getRealPath(path))) {
      return _vfile(path);
    } else if (await FileSystemEntity.isLink(getRealPath(path))) {
      return null;
    }
  }

  @override
  Future<bool> onExists(String path) => FileSystemEntity.type(getRealPath(path))
      .then((type) => type != FileSystemEntityType.notFound);

  @override
  Future<VFolder> onMakeDirectory(String path) =>
      toDirectory(path).create(recursive: false).then((_) => _vfolder(path));

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

  static IconData getFolderIcon(String path) {
    String name = VPaths.name(path);
    String ext = name.startsWith(".")
        ? "."
        : name.contains(".")
            ? name.split('.').sublist(1).join('.')
            : "";

    if (ext == ".") {
      return Icons.folder_dotted_fill;
    }

    return Icons.folder_fill;
  }

  static IconData getFileIcon(String path) {
    String name = VPaths.name(path);
    String ext = name.startsWith(".")
        ? "."
        : name.contains(".")
            ? name.split('.').sublist(1).join('.')
            : "";

    if (ext.isEmpty) {
      return Icons.file_fill;
    }

    // dart format off
    return switch (ext.toLowerCase()) {
      "." => Icons.file_dotted_fill,
      "mp4" ||
      "mov" ||
      "mkv" ||
      "avi" ||
      "webm" ||
      "flv" ||
      "wmv" ||
      "mpg" ||
      "mpeg" ||
      "m4v" =>
        Icons.file_video_fill,
      "mp3" ||
      "wav" ||
      "flac" ||
      "ogg" ||
      "m4a" ||
      "wma" ||
      "aac" =>
        Icons.file_audio_fill,
      "zip" ||
      "tar.gz" ||
      "rar" ||
      "gz" ||
      "tar" ||
      "7z" =>
        Icons.file_zip_fill,
      "gif" ||
      "bmp" ||
      "webp" ||
      "tiff" ||
      "svg" ||
      "ico" =>
        Icons.file_image_fill,
      "py" || "go" || "cs" || "cpp" || "dart" || "java" => Icons.file_code_fill,
      "txt" ||
      "rtf" ||
      "md" ||
      "nfo" ||
      "json" ||
      "yml" ||
      "yaml" ||
      "toml" =>
        Icons.file_text_fill,
      "jpg" || "jpeg" || "jxl" => Icons.file_jpg_fill,
      "scss" || "css" => Icons.file_css_fill,
      "html" || "htm" => Icons.file_html_fill,
      "docx" || "doc" => Icons.file_doc_fill,
      "ppt" || "pptx" => Icons.file_ppt_fill,
      "xls" || "xlsx" => Icons.file_xls_fill,
      "js" => Icons.file_js_fill,
      "csv" => Icons.file_csv_fill,
      "jsx" => Icons.file_jsx_fill,
      "pdf" => Icons.file_pdf_fill,
      "png" => Icons.file_png_fill,
      "apng" => Icons.file_png_fill,
      "rs" => Icons.file_rs_fill,
      "tsx" => Icons.file_tsx_fill,
      "ts" => Icons.file_ts_fill,
      "vue" => Icons.file_vue_fill,
      "x" => Icons.file_x_fill,
      _ => Icons.file_fill
    };
    // dart format on
  }

  @override
  Iterable<MenuItem> onEntityMenuItems(BuildContext context, List<VEntity> entities)sync* {

  }

  @override
  Iterable<MenuItem> onFileMenuItems(BuildContext context, List<VFile> files)sync* {

  }

  @override
  Iterable<MenuItem> onFolderMenuItems(BuildContext context, List<VFolder> folders) sync* {

  }
}

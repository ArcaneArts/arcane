import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

class VPaths {
  static bool contains(String base, String path) =>
      "/${sanitize(path)}/".startsWith("/${sanitize(base)}/");

  static String hideExtension(String name) =>
      name.startsWith(".") ? name : name.split('.').first;

  static String name(String path) => sanitize(path).split('/').last;

  static String get root => '/';

  static String join(String base, String append) => sanitize([
        ...sanitize(base).split('/'),
        ...sanitize(append).split('/'),
      ].join('/'));

  static bool hasParent(String path) => sanitize(path) != "/";

  static String appendName(String path, String append) {
    path = sanitize(path);
    String name = path.split('/').last;
    List<String> seg = name.split('.');
    seg[0] = seg[0] + append;
    return join(parentOf(path), seg.join('.'));
  }

  static String parentOf(String path) {
    List<String> parts = sanitize(path).split('/');

    if (parts.length > 1) {
      parts.removeLast();
    } else {
      return '/';
    }

    return sanitize(parts.join('/'));
  }

  static String localize(String global, String base) {
    global = sanitize(global);
    base = sanitize(base);
    if (global.startsWith(base)) {
      return sanitize(global.substring(base.length));
    } else {
      throw Exception('Not a child');
    }
  }

  static int getDepth(String path) {
    path = sanitize(path);

    if (path == '/') {
      return 0;
    }

    if (!path.contains("/")) {
      return 1;
    }

    return path.split('/').length;
  }

  static bool isValidFolderName(String name) => !(name.isEmpty ||
      name.contains("/") ||
      name.contains("\\") ||
      name.contains(">") ||
      name.contains("<") ||
      name.contains(":") ||
      name.contains("\"") ||
      name.contains("|") ||
      name.contains("?") ||
      name.contains("*"));

  static bool isValidFileName(String name) => !(name.isEmpty ||
      name.contains("/") ||
      name.contains("\\") ||
      name.contains(">") ||
      name.contains("<") ||
      name.contains(":") ||
      name.contains("\"") ||
      name.contains("|") ||
      name.contains("?") ||
      name.contains("*"));

  static String sanitize(String path) {
    path = path.replaceAll(kIsWeb ? "\\" : Platform.pathSeparator, "/");

    while (path.contains('//')) {
      path = path.replaceAll('//', '/');
    }

    if (path.length > 1) {
      if (path.startsWith('/')) {
        path = path.substring(1);
      }

      if (path.endsWith('/')) {
        path = path.substring(0, path.length - 1);
      }
    } else if (path.isEmpty) {
      path = '/';
    }

    return path;
  }
}

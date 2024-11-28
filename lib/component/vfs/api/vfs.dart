import 'dart:async';
import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:fast_log/fast_log.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

abstract class VFS {
  final List<VFSLayout> layouts;
  final List<VFSComparator> comparators;
  final BehaviorSubject<List<VEntity>> selection = BehaviorSubject.seeded([]);
  String workingDirectory;
  late final BehaviorSubject<VFolder> workingVFolder;
  VEntity? _lastTapped;
  int? _lastTappedTime;
  StreamSubscription<bool>? _watcher;
  StreamSubscription<bool>? _parentWatcher;
  late final StreamSubscription<String> _wdWatcher;
  final BehaviorSubject<int> _updater = BehaviorSubject.seeded(0);
  final Map<String, VEntity> _cache = {};
  final Map<String, List<String>> _childrenCache = {};
  late int _currentLayout;
  late int _currentComparator;
  late bool _reversedComparator;
  late bool _ticking;

  VFS({
    this.workingDirectory = "/",
    this.comparators = const [VFSComparatorName()],
    this.layouts = const [VFSLayoutList(), VFSLayoutGrid()],
  })  : assert(comparators.isNotEmpty, "At least one comparator is required"),
        assert(layouts.isNotEmpty, "At least one layout is required") {
    _init();
  }

  void _init() {
    _currentLayout = 0;
    _currentComparator = 0;
    _reversedComparator = true;
    workingVFolder =
        BehaviorSubject.seeded(VFolder(path: workingDirectory, vfs: this));
    _wdWatcher = _updater.map((i) => workingDirectory).distinct().listen((_) {
      getEntity(workingDirectory).then((i) {
        if (i == null) {
          error("Working directory $workingDirectory does not exist");
        } else {
          workingVFolder.add(i as VFolder);
        }
      });
      String wd = workingDirectory;
      watchTargetDirectory(wd);
    });
    _ticking = true;
    Future.delayed(1.seconds, () async {
      while (_ticking) {
        await tick();
        await Future.delayed(1.seconds);
      }
    });
  }

  Future<void> onTick();

  Future<void> tick() async {
    try {
      if (await checkWorkingDirectory()) {
        await onTick();
      }
    } catch (e, es) {
      error("TICK ERROR $e $es");
    }
  }

  void dispose() {
    _ticking = false;
    selection.close();
    workingVFolder.close();
    _updater.close();
    _watcher?.cancel();
    _wdWatcher.cancel();
  }

  void setLayoutIndex(int layout) {
    assert(_currentLayout >= 0 && _currentLayout < layouts.length,
        "Invalid layout index");
    _currentLayout = layout;
    update();
  }

  void setLayout(VFSLayout layout) => setLayoutIndex(layouts.indexOf(layout));

  void setComparator(VFSComparator comparator, {bool reversed = false}) =>
      setComparatorIndex(comparators.indexOf(comparator), reversed: reversed);

  void setComparatorIndex(int comparator, {bool reversed = false}) {
    assert(_currentComparator >= 0 && _currentComparator < comparators.length,
        "Invalid comparator index");
    _currentComparator = comparator;
    _reversedComparator = reversed;
    update();
  }

  int get layoutIndex => _currentLayout;

  int get comparatorIndex => _currentComparator;

  bool get isComparatorReversed => _reversedComparator;

  VFSLayout get currentLayout => layouts[_currentLayout];

  VFSComparator get currentComparator => comparators[_currentComparator];

  List<VEntity> selectionWithFocus(VEntity focus) {
    if (!selection.value.contains(focus)) {
      return [focus];
    }

    return selection.value;
  }

  void watchTargetDirectory(String wd) {
    _parentWatcher?.cancel();
    _parentWatcher = null;

    if (VPaths.hasParent(wd)) {
      _parentWatcher =
          watchDirectory(VPaths.parentOf(wd)).listen((event) async {
        await checkWorkingDirectory();
        update();
      }, onDone: () {
        verbose("PARENT WATCH ENDED");
        checkWorkingDirectory();
      }, onError: (e, es) {
        error("PARENT WATCH ERROR $e $es");
        checkWorkingDirectory();
      });
    }

    _watcher?.cancel();
    _watcher = null;
    _watcher = watchDirectory(wd).listen((event) async {
      update();
    }, onDone: () {
      verbose("WATCH ENDED");
    }, onError: (e, es) {
      error("WATCH ERROR $e $es");
    });
  }

  Future<bool> checkWorkingDirectory() async {
    bool ex = await exists(workingDirectory);
    if (!ex && VPaths.hasParent(workingDirectory)) {
      warn("Working directory $workingDirectory does not exist, going up.");
      goUp();
      return false;
    } else if (!ex) {
      error(
          "Working directory $workingDirectory does not exist and has no parent!");
      return false;
    }

    return true;
  }

  bool get canGoUp => VPaths.hasParent(workingDirectory);

  void openFolder(VFolder entity) {
    workingDirectory = entity.path;
    selection.add([]);
    update();
  }

  void goUp() {
    workingDirectory = VPaths.parentOf(workingDirectory);
    selection.add([]);
    update();
  }

  void tapOpen(BuildContext context, VEntity ent) => ent is VFolder
      ? openFolder(ent)
      : ent is VFile
          ? ent.onOpen != null
              ? ent.onOpen!(context)
              : null
          : null;

  Iterable<MenuItem> buildLayoutMenuItems(BuildContext context) sync* {
    yield* layouts.map((l) => MenuButton(
          autoClose: true,
          onPressed: (_) {
            setLayout(l);
          },
          trailing: listen.build((_) => currentLayout == l
              ? const Icon(Icons.check)
              : const SizedBox.shrink()),
          leading: Icon(l.icon),
          child: Text(l.name),
        ));
  }

  Iterable<MenuItem> buildComparatorMenuItems(BuildContext context) sync* {
    yield* comparators.map((c) => MenuButton(
          autoClose: false,
          onPressed: (_) {
            if (currentComparator == c) {
              setComparator(currentComparator, reversed: !isComparatorReversed);
            } else {
              setComparator(c, reversed: true);
            }
            update();
          },
          trailing: listen.build((_) => currentComparator == c
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check),
                    const Gap(4),
                    isComparatorReversed
                        ? const Icon(Icons.arrow_down)
                        : const Icon(Icons.arrow_up),
                  ],
                )
              : const SizedBox.shrink()),
          leading: Icon(c.icon),
          child: Text(c.name),
        ));
  }

  void tap(BuildContext context, VEntity ent) async {
    if (_lastTapped == ent &&
        DateTime.now().millisecondsSinceEpoch - _lastTappedTime! < 500) {
      tapOpen(context, ent);
    } else {
      bool inSelection = selection.value.contains(ent);

      if (HardwareKeyboard.instance.isShiftPressed && _lastTapped != null) {
        List<VEntity> view = await getChildren(
          workingVFolder.value,
        ).toList();

        int start = view.indexOf(_lastTapped!);
        int end = view.indexOf(ent);

        if (start < 0 || end < 0) {
          selection.add([ent]);
        } else {
          List<VEntity> newSelection = [];
          int a = min(start, end);
          int b = max(start, end);

          for (int i = a; i <= b; i++) {
            newSelection.add(view[i]);
          }

          selection.add(newSelection);
        }
      } else if (HardwareKeyboard.instance.isControlPressed) {
        if (inSelection) {
          selection.add([...selection.value.where((e) => e != ent)]);
        } else {
          selection.add([...selection.value, ent]);
        }
      } else {
        selection.add([ent]);
      }

      _lastTapped = ent;
      _lastTappedTime = DateTime.now().millisecondsSinceEpoch;
    }
  }

  bool isSelected(VEntity ent) => selection.value.contains(ent);

  Future<void> moveUpOut(VEntity dragged) async {
    List<VEntity> sel = selection.value;

    if (!sel.contains(dragged)) {
      sel.add(dragged);
    }

    for (VEntity i in sel) {
      await move(
          i, ((await getEntity(VPaths.parentOf(workingDirectory))) as VFolder));
    }

    selection.add([]);
    update();
  }

  Future<void> moveInto(VFolder ent, VEntity dragged) async {
    List<VEntity> sel = selection.value;

    if (!sel.contains(dragged)) {
      sel.add(dragged);
    }

    if (sel.contains(ent)) {
      sel.remove(ent);
    }

    for (VEntity i in sel) {
      await move(i, ent);
    }

    selection.add([]);
    update();
  }

  void mkdirDialog(BuildContext context) => DialogText(
        title: "New Folder",
        hint: "Folder Name",
        maxLength: 255,
        onConfirm: (name) {
          name = VPaths.sanitize(name.trim());
          if (name.isEmpty) {
            TextToast("Folder name cannot be empty").open(context);
            return;
          }

          if (name.contains("/") ||
              name.contains("\\") ||
              name.contains(">") ||
              name.contains("<") ||
              name.contains(":") ||
              name.contains("\"") ||
              name.contains("|") ||
              name.contains("?") ||
              name.contains("*")) {
            TextToast("Folder name cannot contain /,\\,>,<,:,\",|,?,*")
                .open(context);
            return;
          }

          mkdir(VPaths.join(workingDirectory, name));
          selection.add([]);
          update();
        },
      ).open(context);

  Future<void> insertDrop(BuildContext context, List<DropItem> files) async {
    List<String> conflicts = [];
    Map<String, String> renames = {};

    for (DropItem i in files) {
      String p = VPaths.join(workingDirectory, i.name);
      if (await exists(p)) {
        conflicts.add(i.name);
      }
    }

    if (conflicts.isNotEmpty) {
      bool abort = false;
      await DialogConfirm(
        title: "Overwrite Files?",
        description:
            "The following files already exist in this directory:\n\n${conflicts.join("\n")}",
        onConfirm: () => conflicts.clear(),
        cancelText: "Skip Duplicates",
        confirmText: "Overwrite",
        actions: [
          OutlineButton(
              onPressed: () {
                abort = true;
                Navigator.pop(context);
              },
              child: Text("Stop")),
          OutlineButton(
              onPressed: () async {
                for (DropItem i in files) {
                  String p = VPaths.join(workingDirectory, i.name);
                  if (await exists(p)) {
                    renames[p] = await findUnallocatedName(p);
                  }
                }

                conflicts.clear();
                Navigator.pop(context);
              },
              child: Text("Keep Both")),
          OutlineButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Skip")),
          DestructiveButton(
              onPressed: () {
                conflicts.clear();
                Navigator.pop(context);
              },
              child: Text("Overwrite"))
        ],
      ).open(context);

      if (abort) {
        return;
      }
    }

    List<Future> work = [];

    for (DropItem i in files) {
      String p = VPaths.join(workingDirectory, i.name);
      p = renames[p] ?? p;

      if (conflicts.contains(i.name)) {
        continue;
      }

      work.add(writeFileStream(p, i.openRead()));
    }

    await Future.wait(work);
    update();
  }

  VFolder get root => VFolder(path: VPaths.root, vfs: this);

  Stream<VEntity> onGetChildren(VFolder folder);

  Future<VFolder> onMakeDirectory(String path);

  Future<bool> onExists(String path);

  Future<bool> exists(String path) => onExists(VPaths.sanitize(path));

  Iterable<MenuItem> defaultFileMenuItems(
      BuildContext context, List<VFile> files) sync* {}

  Iterable<MenuItem> defaultFolderMenuItems(
      BuildContext context, List<VFolder> folders) sync* {}

  Iterable<MenuItem> defaultEntityMenuItems(
      BuildContext context, List<VEntity> entities) sync* {
    if (entities.length == 1) {
      yield MenuButton(
        leading: Icon(Icons.pencil),
        onPressed: (_) => renameDialog(context, entities.first),
        child: Text("Rename"),
      );
    }

    yield MenuButton(
        leading: Icon(Icons.trash),
        onPressed: (_) => deleteDialog(context, entities),
        child: Text("Delete"));
  }

  Future<void> renameDialog(BuildContext context, VEntity entity) => DialogText(
        title: "Rename ${entity.name}",
        initialValue: entity.name,
        onConfirm: (name) async {
          if (!VPaths.isValidFolderName(name)) {
            TextToast("Invalid Folder Name").open(context);
            return;
          }

          try {
            renameEntity(entity, name.trim());
          } catch (e) {
            TextToast("Failed to rename").open(context);
            return;
          }
        },
      ).open(context);

  Iterable<MenuItem> getFileMenuItems(
      BuildContext context, List<VFile> files) sync* {
    yield* onFileMenuItems(context, files);
    yield* defaultFileMenuItems(context, files);
  }

  Iterable<MenuItem> getFolderMenuItems(
      BuildContext context, List<VFolder> folders) sync* {
    yield* onFolderMenuItems(context, folders);
    yield* defaultFolderMenuItems(context, folders);
  }

  Iterable<MenuItem> getEntityMenuItems(
      BuildContext context, List<VEntity> entities) sync* {
    yield* onEntityMenuItems(context, entities);

    if (entities.every((i) => i is VFile)) {
      yield* getFileMenuItems(context, entities.cast<VFile>());
    }

    if (entities.every((i) => i is VFolder)) {
      yield* getFolderMenuItems(context, entities.cast<VFolder>());
    }

    yield* defaultEntityMenuItems(context, entities);
  }

  Iterable<MenuItem> onFileMenuItems(BuildContext context, List<VFile> files);
  Iterable<MenuItem> onFolderMenuItems(
      BuildContext context, List<VFolder> folders);
  Iterable<MenuItem> onEntityMenuItems(
      BuildContext context, List<VEntity> entities);

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

  Future<void> renameEntity(VEntity entity, String newName) async {
    if (entity is VFile) {
      String newPath = VPaths.join(entity.parentPath, newName);
      await onMoveFile(entity, newPath);
      warn("MOVE FILE ${entity.path} -> $newPath");
    } else if (entity is VFolder) {
      String newPath = VPaths.join(entity.parentPath, newName);

      if (await exists(newPath)) {
        throw Exception("Already exists");
      }

      VFolder newFolder = await mkdir(newPath);
      await Future.wait(
          await getChildren(entity).map((i) => move(i, newFolder)).toList());
      await delete(entity);
    }

    update();
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

  Future<void> deleteAll(List<VEntity> entities) async {
    List<VFile> files = entities.whereType<VFile>().toList();
    List<VFolder> folders = entities.whereType<VFolder>().toList();
    await Future.wait(files.map(delete));
    folders.sort(
        (a, b) => VPaths.getDepth(b.path).compareTo(VPaths.getDepth(a.path)));
    invalidate();
    for (VFolder folder in folders) {
      await delete(folder);
    }
    update();
  }

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

  Stream<VEntity> getChildren(VFolder folder) async* {
    if (!_childrenCache.containsKey(folder.path)) {
      List<String> children = [];
      await for (VEntity entity in onGetChildren(folder)) {
        children.add(entity.path);
        _cache[entity.path] = entity;
      }

      _childrenCache[folder.path] = children;
    }

    List<VEntity> v = await Stream.fromFutures(
            _childrenCache[folder.path]!.map((i) => getEntity(i)))
        .whereType<VEntity>()
        .toList();
    v.sort(isComparatorReversed
        ? currentComparator.compareReversed
        : currentComparator.compare);
    v.sort(VFSComparatorEntityType().compare);
    yield* Stream.fromIterable(v);
  }

  Future<VEntity?> onGetEntity(String path);

  Future<VEntity?> getEntity(String path) async {
    path = VPaths.sanitize(path);
    if (!_cache.containsKey(path)) {
      VEntity? entity = await onGetEntity(path);
      if (entity != null) {
        _cache[path] = entity;
      }
    }

    return _cache[path];
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

  Stream<VEntity> getAllChildren(List<VEntity> roots) async* {
    for (VEntity root in roots) {
      if (root is VFolder) {
        yield* getAllChildren(await getChildren(root).toList());
      }
      yield root;
    }
  }

  Future<void> deleteDialog(
      BuildContext context, List<VEntity> entities) async {
    List<VEntity> all = await getAllChildren(entities).toList();
    await DialogConfirm(
        title: all.length == 1
            ? "Delete ${all.first.name}?"
            : "Delete ${all.length} Items",
        destructive: true,
        confirmText: "Delete",
        description: all.length == 1
            ? "Are you sure you want to delete ${all.first.name}?"
            : "Are you sure you want to delete ${all.whereType<VFile>().length} files and ${all.whereType<VFolder>().length} folders?",
        onConfirm: () => deleteAll(all)).open(context);
  }

  Future<void> moveSelection(Offset drift) async {
    if (selection.value.isEmpty) {
      selection.add([await getChildren(workingVFolder.value).first]);
    }

    if (selection.value.length > 1) {
      if (drift.dx > 0 || drift.dy > 0) {
        selection.add([selection.value.last]);
      } else {
        selection.add([selection.value.first]);
      }
    }

    int across = currentLayout.span;
    VEntity selected = selection.value.first;
    List<VEntity> view = await getChildren(workingVFolder.value).toList();
    int index = view.indexOf(selected);
    int newIndex =
        _SpanUtil.move(index, drift.dx.round(), drift.dy.round(), span: across);
    newIndex = max(0, min(view.length - 1, newIndex));
    selection.add([view[newIndex]]);
    _lastTapped = view[newIndex];
  }

  Future<void> expandSelection(Offset drift) async {
    if (selection.value.isEmpty) {
      return;
    }

    int across = currentLayout.span;
    List<VEntity> view = await getChildren(workingVFolder.value).toList();
    int startIndex = view.indexOf(selection.value.last);
    if (selection.value.length > 1 && drift.dx > 0 || drift.dy > 0) {}

    int newIndex = _SpanUtil.move(
        startIndex, drift.dx.round(), drift.dy.round(),
        span: across);
    newIndex = max(0, min(view.length - 1, newIndex));
    List<VEntity> newSelection = selection.value.toList();
    bool added = false;
    for (int i = min(startIndex, newIndex);
        i <= max(startIndex, newIndex);
        i++) {
      if (!newSelection.contains(view[i])) {
        newSelection.add(view[i]);
        added = true;
      }
    }

    if (!added) {
      newSelection.remove(view[startIndex]);
    }

    selection.add(newSelection);
    _lastTapped = view[newIndex];
  }

  Future<void> selectAll() async =>
      selection.add(await getChildren(workingVFolder.value).toList());
}

class _SpanUtil {
  static int move(int index, int x, int y, {int span = 1}) {
    int nx = getX(index, span: span) + x;
    int ny = getY(index, span: span) + y;
    return getIndex(nx, ny, span: span);
  }

  static int getX(int index, {int span = 1}) => index % span;

  static int getY(int index, {int span = 1}) => index ~/ span;

  static int getIndex(int x, int y, {int span = 1}) => y * span + x;
}

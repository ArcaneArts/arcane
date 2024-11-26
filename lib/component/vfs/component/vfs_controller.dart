import 'dart:async';
import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:desktop_drop/src/drop_item.dart';
import 'package:flutter/services.dart';

class VFSController {
  final VFS vfs;
  final BehaviorSubject<List<VEntity>> selection = BehaviorSubject.seeded([]);
  final BehaviorSubject<String> workingDirectory;
  final BehaviorSubject<VFolder> workingVFolder;
  VEntity? _lastTapped;
  int? _lastTappedTime;
  StreamSubscription<bool>? _watcher;

  VFSController({required this.vfs, String workingDirectory = "/"})
      : workingDirectory = BehaviorSubject.seeded(workingDirectory),
        workingVFolder =
            BehaviorSubject.seeded(VFolder(path: workingDirectory, vfs: vfs)) {
    this.workingDirectory.listen((wd) {
      workingVFolder.add(VFolder(path: wd, vfs: vfs));
      _watch(wd);
    });
  }

  bool get canGoUp => VPaths.hasParent(workingDirectory.value);

  void openFolder(VFolder entity) {
    workingDirectory.add(entity.path);
    selection.add([]);
    vfs.update();
  }

  void goUp() {
    workingDirectory.add(VPaths.parentOf(workingDirectory.value));
    selection.add([]);
    vfs.update();
  }

  void tapOpen(BuildContext context, VEntity ent) => ent is VFolder
      ? context.vfsController.openFolder(ent)
      : ent is VFile
          ? ent.onOpen != null
              ? ent.onOpen!(context)
              : null
          : null;

  void tap(BuildContext context, VEntity ent,
      {VFSComparator? comparator, bool reversed = false}) async {
    if (_lastTapped == ent &&
        DateTime.now().millisecondsSinceEpoch - _lastTappedTime! < 500) {
      tapOpen(context, ent);
    } else {
      bool inSelection = selection.value.contains(ent);

      if (HardwareKeyboard.instance.isShiftPressed && _lastTapped != null) {
        List<VEntity> view = await vfs
            .getChildren(
              workingVFolder.value,
              comparator: comparator,
              reverse: reversed,
            )
            .toList();

        int start = view.indexOf(_lastTapped!);
        int end = view.indexOf(ent);

        if (start < 0 || end < 0) {
          selection.add([ent]);
        } else {
          List<VEntity> newSelection = [];

          int a = min(start, end);
          int b = max(start, end);

          print("From $a to $b");

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

  Future<void> moveInto(VFolder ent, VEntity dragged) async {
    List<VEntity> sel = selection.value;

    if (!sel.contains(dragged)) {
      sel.add(dragged);
    }

    if (sel.contains(ent)) {
      sel.remove(ent);
    }

    for (VEntity i in sel) {
      await vfs.move(i, ent);
    }

    selection.add([]);
    vfs.update();
  }

  void mkdir(BuildContext context) => DialogText(
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

          vfs.mkdir(VPaths.join(workingDirectory.value, name));
          selection.add([]);
          vfs.update();
        },
      ).open(context);

  void _watch(String wd) {
    _watcher?.cancel();
    _watcher = null;
    _watcher = vfs.watchDirectory(wd).listen((event) {
      vfs.update();
    });
  }

  Future<void> insertDrop(BuildContext context, List<DropItem> files) async {
    List<String> conflicts = [];
    Map<String, String> renames = {};

    for (DropItem i in files) {
      String p = VPaths.join(workingDirectory.value, i.name);
      if (await vfs.exists(p)) {
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
                  String p = VPaths.join(workingDirectory.value, i.name);
                  if (await vfs.exists(p)) {
                    renames[p] = await vfs.findUnallocatedName(p);
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
      String p = VPaths.join(workingDirectory.value, i.name);
      p = renames[p] ?? p;

      if (conflicts.contains(i.name)) {
        continue;
      }

      work.add(vfs.writeFileStream(p, i.openRead()));
    }

    await Future.wait(work);
    vfs.update();
  }
}

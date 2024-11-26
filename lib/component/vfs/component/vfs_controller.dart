import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:flutter/services.dart';

class VFSController {
  final VFS vfs;
  final BehaviorSubject<List<VEntity>> selection = BehaviorSubject.seeded([]);
  final BehaviorSubject<String> workingDirectory;
  final BehaviorSubject<VFolder> workingVFolder;
  VEntity? _lastTapped;
  int? _lastTappedTime;

  VFSController({required this.vfs, String workingDirectory = "/"})
      : workingDirectory = BehaviorSubject.seeded(workingDirectory),
        workingVFolder =
            BehaviorSubject.seeded(VFolder(path: workingDirectory, vfs: vfs)) {
    this.workingDirectory.listen((wd) {
      workingVFolder.add(VFolder(path: wd, vfs: vfs));
    });
  }

  bool get canGoUp => VPaths.hasParent(workingDirectory.value);

  void openFolder(VFolder entity) {
    workingDirectory.add(entity.path);
    selection.add([]);
  }

  void goUp() {
    workingDirectory.add(VPaths.parentOf(workingDirectory.value));
    selection.add([]);
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
}

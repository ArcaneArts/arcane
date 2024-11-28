import 'dart:math';

import 'package:arcane/arcane.dart';

int _lspan = 1;

class VFSLayoutGrid extends VFSLayout {
  const VFSLayoutGrid({super.name = "Grid", super.icon = Icons.grid_four});

  @override
  Widget build(BuildContext context, VFS vfs, List<VEntity> entities) {
    double w = MediaQuery.of(context).size.width;
    _lspan = max(1, w ~/ 125);

    return SGridView(
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      crossAxisCount: _lspan,
      children: [...entities.withPylons((context) => VFSEntityGridTile())],
    );
  }

  @override
  int get span => _lspan;
}

class VFSLayoutList extends VFSLayout {
  const VFSLayoutList({super.name = "List", super.icon = Icons.list});

  @override
  Widget build(BuildContext context, VFS vfs, List<VEntity> entities) =>
      SListView(
        children: [...entities.withPylons((context) => VFSEntityListTile())],
      );
}

abstract class VFSLayout {
  final String name;
  final IconData icon;

  const VFSLayout({required this.name, required this.icon});

  Widget build(BuildContext context, VFS vfs, List<VEntity> entities);

  int get span => 1;
}

import 'dart:math';

import 'package:arcane/arcane.dart';

class VFSLayoutGrid extends VFSLayout {
  const VFSLayoutGrid({super.name = "Grid", super.icon = Icons.grid_four});

  @override
  Widget build(
      BuildContext context, VFSController vfs, List<VEntity> entities) {
    double w = MediaQuery.of(context).size.width;
    return SGridView(
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      crossAxisCount: max(1, w ~/ 125),
      children: [...entities.withPylons((context) => VFSEntityGridTile())],
    );
  }
}

class VFSLayoutList extends VFSLayout {
  const VFSLayoutList({super.name = "List", super.icon = Icons.list});

  @override
  Widget build(
          BuildContext context, VFSController vfs, List<VEntity> entities) =>
      SListView(
        children: [...entities.withPylons((context) => VFSEntityListTile())],
      );
}

abstract class VFSLayout {
  final String name;
  final IconData icon;

  const VFSLayout({required this.name, required this.icon});

  Widget build(BuildContext context, VFSController vfs, List<VEntity> entities);
}

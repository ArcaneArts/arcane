import 'package:arcane/arcane.dart';

class VFSComparatorEntityType extends VFSComparator {
  const VFSComparatorEntityType()
      : super(name: "Entity Type", icon: Icons.folder_open);

  @override
  int compare(VEntity a, VEntity b) => a is VFolder && b is VFile ? -1 : 1;
}

class VFSComparatorName extends VFSComparator {
  const VFSComparatorName() : super(name: "Name", icon: Icons.text_aa);

  @override
  int compare(VEntity a, VEntity b) => a.name.compareTo(b.name);
}

abstract class VFSComparator {
  final String name;
  final IconData icon;

  const VFSComparator({required this.name, required this.icon});

  int compare(VEntity a, VEntity b);

  int compareReversed(VEntity a, VEntity b) => -compare(a, b);
}

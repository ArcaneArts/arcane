import 'package:arcane/arcane.dart';

extension XString on String {
  DocumentReference<Map<String, dynamic>> get doc =>
      FirebaseFirestore.instance.doc(this);
}

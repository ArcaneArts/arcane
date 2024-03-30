import 'package:arcane/arcane.dart';

late final Arcane instance;

class Arcane {
  final List<Function()> initializers;
  final ArcaneApp application;

  Arcane({
    this.initializers = const [],
    required this.application,
  }) {
    _start();
  }

  Future<void> _start() async {
    for (final initializer in initializers) {
      var m = initializer();

      if (m is Future) {
        await m;
      }
    }
  }
}

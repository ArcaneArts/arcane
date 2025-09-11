import 'package:arcane/arcane.dart';

class ArcaneFieldMapProvider<T> extends ArcaneFieldProvider<T> {
  final Map<String, dynamic> storage;

  ArcaneFieldMapProvider({required super.defaultValue, required this.storage});

  @override
  Future<T> onGetValue(String k) async {
    List<String> parts = k.split('.');
    Map<String, dynamic> current = storage;
    for (int i = 0; i < parts.length; i++) {
      String part = parts[i];

      if (i == parts.length - 1) {
        if (current.containsKey(part)) {
          return current[part] as T;
        } else {
          throw Exception("Key not found: $k");
        }
      } else {
        if (current[part] is Map<String, dynamic>) {
          current = current[part] as Map<String, dynamic>;
        } else {
          throw Exception("Key not found: $k");
        }
      }
    }

    throw Exception("Key not found: $k");
  }

  @override
  Future<void> onSetValue(String k, T value) async {
    List<String> parts = k.split('.');
    Map<String, dynamic> current = storage;
    for (int i = 0; i < parts.length; i++) {
      String part = parts[i];
      if (i == parts.length - 1) {
        current[part] = value;
      } else {
        current[part] ??= <String, dynamic>{};
        current = current[part] as Map<String, dynamic>;
      }
    }
  }
}

class ArcaneFieldDirectProvider<T> extends ArcaneFieldProvider<T> {
  final Future<T> Function(String) getter;
  final Future<void> Function(String, T) setter;

  ArcaneFieldDirectProvider({
    required super.defaultValue,
    required this.getter,
    required this.setter,
  });

  @override
  Future<T> onGetValue(String k) => getter(k);

  @override
  Future<void> onSetValue(String k, T value) => setter(k, value);
}

abstract class ArcaneFieldProvider<T> {
  final T defaultValue;

  ArcaneFieldProvider({required this.defaultValue});

  BehaviorSubject<T> subject = BehaviorSubject<T>();

  Future<T> onGetValue(String k);

  Future<void> onSetValue(String k, T value);

  Future<T> getValue(String k) =>
      onGetValue(k).catchError((_) => defaultValue).thenRun((t) {
        if (!subject.hasValue) {
          subject.add(t);
        }
      });

  Future<void> setValue(String k, T value) =>
      onSetValue(k, value).thenRun((_) => subject.add(value));
}

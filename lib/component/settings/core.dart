import 'package:arcane/arcane.dart';

class KFieldWrapper<T> extends StatelessWidget {
  final PylonBuilder builder;
  final bool overrideTileScaffold;

  const KFieldWrapper(
      {super.key, required this.builder, this.overrideTileScaffold = false});

  @override
  Widget build(BuildContext context) {
    KField<T> field = context.pylon<KField<T>>();
    return field.provider
        .getValue(field.meta.effectiveKey)
        .buildNullable((v) => (field.provider.subject
            .buildNullable((v) => overrideTileScaffold
                ? Pylon<T>(
                    value: v ?? field.provider.defaultValue,
                    builder: builder,
                  )
                : ListTile(
                    leading:
                        field.meta.icon != null ? Icon(field.meta.icon!) : null,
                    subtitleText: field.meta.description,
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(child: Text(field.meta.name).xSmall),
                            Gap(8),
                            Icon(Icons.check, size: 12, color: Colors.green)
                                .padTop(4)
                                .animate(key: ValueKey(v))
                                .fadeIn(
                                    duration: 1.seconds,
                                    curve: Curves.easeOutCirc,
                                    begin: 0)
                                .fadeOut(
                                    delay: 1.seconds,
                                    begin: 1,
                                    duration: 3.seconds,
                                    curve: Curves.easeOutCirc)
                          ],
                        ),
                        Gap(8),
                        v == null
                            ? Text("Loading...")
                            : Builder(builder: builder),
                        Gap(4)
                      ],
                    ),
                  ))
            .shimmer(loading: v == null)));
  }
}

class KMapProvider<T> extends KProvider<T> {
  final Map<String, dynamic> storage;

  KMapProvider({required super.defaultValue, required this.storage});

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

class KDirectProvider<T> extends KProvider<T> {
  final Future<T> Function(String) getter;
  final Future<void> Function(String, T) setter;

  KDirectProvider({
    required super.defaultValue,
    required this.getter,
    required this.setter,
  });

  @override
  Future<T> onGetValue(String k) => getter(k);

  @override
  Future<void> onSetValue(String k, T value) => setter(k, value);
}

abstract class KProvider<T> {
  final T defaultValue;

  KProvider({required this.defaultValue});

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

class KField<T> extends StatelessWidget {
  final KMeta meta;
  final KProvider<T> provider;
  final PylonBuilder builder;

  Type get dataRuntimeType => T;

  const KField({
    super.key,
    required this.meta,
    required this.provider,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) => Pylon<KField<T>>(
        value: this,
        builder: builder,
      );
}

class KMeta {
  final String? key;
  final String name;
  final String? description;
  final IconData? icon;
  final dynamic placeholder;

  const KMeta({
    required this.name,
    this.key,
    this.icon,
    this.description,
    this.placeholder,
  });

  String get effectiveKey =>
      key ?? name.toLowerCase().replaceAll(' ', '_').replaceAll("/", ".");
}

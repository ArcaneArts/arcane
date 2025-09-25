import 'package:arcane/arcane.dart';

/// The abstract base class for form field providers in the Arcane form system, managing reactive state with a [BehaviorSubject<T>].
///
/// This class defines the interface for getting and setting form values, with built-in error handling via [defaultValue] and
/// reactive broadcasting for UI updates. It serves as the foundation for [ArcaneField] and [FieldNode] integrations in [ArcaneForm],
/// enabling dynamic validation, nested structures, and custom storage backends. Subclasses like [ArcaneFieldMapProvider] and
/// [ArcaneFieldDirectProvider] implement the abstract [onGetValue] and [onSetValue] for specific persistence needs.
abstract class ArcaneFieldProvider<T> {
  ArcaneFieldProvider({required this.defaultValue});

  /// The default value used as a fallback when value retrieval fails (e.g., key not found or error in [onGetValue]).
  ///
  /// This field is final and required, ensuring type-safe defaults. It promotes null safety by providing a non-null alternative
  /// in [getValue], preventing runtime errors in form displays tied to [ArcaneField].
  final T defaultValue;

  /// The reactive [BehaviorSubject<T>] that broadcasts current field values to listeners, enabling real-time UI updates.
  ///
  /// Initialized empty and populated on first successful [getValue] call. Emits new values after [setValue] operations.
  /// Integrates with form widgets like [ArcaneField] for automatic rebuilding on changes; use [subject.stream] for observing.
  BehaviorSubject<T> subject = BehaviorSubject<T>();

  /// Abstract method to be implemented by subclasses for asynchronously retrieving the value associated with a key.
  ///
  /// Returns a [Future<T>] representing the fetched value. Called internally by [getValue]; should handle storage-specific logic,
  /// such as nested map traversal in [ArcaneFieldMapProvider] or API calls in [ArcaneFieldDirectProvider]. No side effects expected.
  Future<T> onGetValue(String k);

  /// Abstract method to be implemented by subclasses for asynchronously setting the value for a key.
  ///
  /// Accepts the key and new value, returning a [Future<void>] upon completion. Invoked by [setValue]; responsible for
  /// persistence, such as updating maps or external stores. Ensures changes are reflected in the [subject] for reactivity.
  Future<void> onSetValue(String k, T value);

  /// Asynchronously retrieves the value for the given key, falling back to [defaultValue] on any error from [onGetValue].
  ///
  /// Initializes and emits to the [subject] if no value has been set yet, ensuring reactive streams start with a valid state.
  /// Handles exceptions gracefully with .catchError, promoting robust form behavior in [ArcaneForm] and [FieldNode] contexts.
  /// Returns the resolved [Future<T>] value.
  Future<T> getValue(String k) =>
      onGetValue(k).catchError((_) => defaultValue).thenRun((t) {
        if (!subject.hasValue) {
          subject.add(t);
        }
      });

  /// Asynchronously sets the value for the given key using [onSetValue], then emits the new value to the [subject].
  ///
  /// Ensures UI components listening to the stream (e.g., [ArcaneField]) update immediately after persistence.
  /// Chains the set operation with subject emission via .thenRun, with no additional error handling beyond the underlying setter.
  /// Returns a [Future<void>] for completion tracking.
  Future<void> setValue(String k, T value) =>
      onSetValue(k, value).thenRun((_) => subject.add(value));
}

/// A concrete implementation of [ArcaneFieldProvider] that manages form field state using a nested [Map<String, dynamic>] for storage.
///
/// This provider supports hierarchical data access via dot notation (e.g., 'user.name.first'), making it suitable for complex form structures
/// in [ArcaneForm] where fields may be nested. It integrates seamlessly with [ArcaneField] and [FieldNode] from the form system,
/// providing reactive value updates through a [BehaviorSubject]. Key features include automatic creation of nested maps during value setting,
/// exception handling for missing keys during retrieval, and fallback to a default value on errors. Use this for in-memory form state management
/// without external dependencies, ensuring type-safe access to nested form data.
class ArcaneFieldMapProvider<T> extends ArcaneFieldProvider<T> {
  /// The nested storage map holding form field values, supporting dynamic key access with dot notation for hierarchy.
  ///
  /// This field is final and required, initialized with an empty map or pre-populated data. It uses [Map<String, dynamic>] to allow
  /// flexible typing for nested structures, with null safety handled via ??= during setting to create missing sub-maps.
  final Map<String, dynamic> storage;

  /// Constructs an [ArcaneFieldMapProvider] instance with the specified default value and storage map.
  ///
  /// The [defaultValue] serves as a fallback for missing keys, while [storage] provides the persistent map for get/set operations.
  /// Initializes the inherited [BehaviorSubject] indirectly through the base class. Usage example:
  /// ```dart
  /// final provider = ArcaneFieldMapProvider<String>(
  ///   defaultValue: '',
  ///   storage: {'user': {'name': 'Default Name'}},
  /// );
  /// await provider.setValue('user.name', 'John Doe');
  /// String name = await provider.getValue('user.name'); // Returns 'John Doe'
  /// ```
  ArcaneFieldMapProvider({required super.defaultValue, required this.storage});

  /// Asynchronously retrieves the value associated with the given key from the nested [storage] map.
  ///
  /// Supports dot-separated keys for nested access (e.g., 'parent.child'). Traverses the map hierarchy, casting the final value to T.
  /// Throws an [Exception] if the key path is invalid or not found. Integrates with [getValue] for error handling and subject emission.
  /// No side effects beyond reading from storage.
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

  /// Asynchronously sets the value for the given key in the nested [storage] map, creating intermediate maps if needed.
  ///
  /// Uses dot notation for nested paths. Automatically initializes missing sub-maps with empty [Map<String, dynamic>] using ??= for null safety.
  /// No return value. Called by [setValue] to update the underlying storage and emit changes via the [subject].
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

/// A flexible concrete implementation of [ArcaneFieldProvider] that delegates value retrieval and storage to custom asynchronous functions.
///
/// This provider allows integration with external data sources, databases, or APIs by providing user-defined [getter] and [setter] functions.
/// It supports any storage mechanism while maintaining reactive updates through the [BehaviorSubject]. Ideal for forms in [ArcaneForm]
/// that require custom persistence, such as syncing with remote services or legacy systems. Works with [ArcaneField] and [FieldNode]
/// for dynamic form handling, with error fallback to [defaultValue] on get failures.
class ArcaneFieldDirectProvider<T> extends ArcaneFieldProvider<T> {
  /// The asynchronous function to retrieve a value by key, returning a [Future<T>].
  ///
  /// This field is final and required, allowing custom logic for value fetching (e.g., from a database or API).
  /// Called by [onGetValue]; ensure it handles errors appropriately for integration with [getValue]'s fallback mechanism.
  final Future<T> Function(String) getter;

  /// The asynchronous function to set a value by key, accepting a [Future<void>] return.
  ///
  /// This field is final and required, enabling custom storage logic (e.g., API updates or local persistence).
  /// Invoked by [onSetValue]; no specific error handling is enforced here, but it should be robust for form reliability.
  final Future<void> Function(String, T) setter;

  /// Initializes an [ArcaneFieldDirectProvider] with a default value and custom getter/setter functions.
  ///
  /// The [defaultValue] provides fallback for retrieval errors, while [getter] and [setter] define the storage interface.
  /// Sets up the base [BehaviorSubject] for reactivity. Usage example:
  /// ```dart
  /// Future<String> myGetter(String key) async => await database.get(key) ?? '';
  /// Future<void> mySetter(String key, String value) async => await database.set(key, value);
  /// final provider = ArcaneFieldDirectProvider<String>(
  ///   defaultValue: 'Default',
  ///   getter: myGetter,
  ///   setter: mySetter,
  /// );
  /// await provider.setValue('key', 'New Value');
  /// String val = await provider.getValue('key'); // Fetches via myGetter
  /// ```
  ArcaneFieldDirectProvider({
    required super.defaultValue,
    required this.getter,
    required this.setter,
  });

  /// Delegates to the provided [getter] function to asynchronously retrieve the value for the key.
  ///
  /// Simply forwards the key to the custom getter, returning its [Future<T>] result.
  /// No additional error handling or side effects; relies on [getValue] for fallback to [defaultValue].
  @override
  Future<T> onGetValue(String k) => getter(k);

  /// Delegates to the provided [setter] function to asynchronously store the value for the key.
  ///
  /// Forwards the key and value to the custom setter, awaiting its completion.
  /// No return value beyond the [Future<void>]; triggers [subject] emission via [setValue].
  @override
  Future<void> onSetValue(String k, T value) => setter(k, value);
}

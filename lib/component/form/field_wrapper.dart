import 'package:arcane/arcane.dart';

class ArcaneFieldWrapper<T> extends StatelessWidget {
  /// A versatile wrapper widget for form fields within the Arcane UI component ecosystem.
  ///
  /// This [StatelessWidget] integrates seamlessly with the [Form] system by leveraging [ArcaneField] and [Pylon] for reactive state management. It provides a consistent layout for displaying form field values, metadata (such as icons, names, and descriptions), and interactive content via a customizable builder. Key features include:
  /// - Reactive rendering of field values from the [Pylon] provider, with support for nullable types.
  /// - Visual validation feedback using an animated check icon that fades in on valid values and out after a delay.
  /// - Loading state handling with a "Loading..." placeholder and shimmer animation.
  /// - Flexible scaffolding: defaults to a [ListTile] for standard form field presentation but allows overriding with a custom [Pylon] widget for advanced layouts.
  /// - Tight integration with [ArcaneField.meta] for displaying field-specific UI elements like icons and subtitles.
  ///
  /// This wrapper is typically used within form sections or [Section] components to encapsulate individual fields, ensuring a polished and responsive user experience. It fits into the broader form architecture by consuming [ArcaneFieldProvider] for value retrieval and updates.
  ///
  /// Example usage in a form context:
  /// ```dart
  /// ArcaneFieldWrapper<String>(
  ///   builder: (value) => Text(value ?? 'Enter your name'),
  ///   overrideTileScaffold: false, // Use default ListTile
  /// )
  /// ```
  /// The builder callback responsible for constructing the interactive or display widget based on the current field value.
  ///
  /// This function receives the resolved value of type `T` (or `null` if loading/unset) and must return a [Widget] representing the field's content, such as input fields, selectors, or custom UI elements. It enables dynamic rendering tied to the form's state via [Pylon].
  ///
  /// For example, it could render a [TextField] for editable strings or a [DropdownButton] for selections.
  final PylonBuilder builder;
  /// Flag to determine whether to use a custom [Pylon] scaffold instead of the default [ListTile] layout.
  ///
  /// When `true`, the wrapper renders a [Pylon] widget directly, providing full control over the field's presentation (e.g., for non-tile-based designs). When `false` (default), it uses a [ListTile] with built-in support for field metadata like icons, titles, and subtitles, ensuring consistency with Arcane's form styling.
  ///
  /// This option is useful for integrating with other layout components like [CardSection] or custom grids where tile semantics are not desired.
  final bool overrideTileScaffold;

  /// Constructs an [ArcaneFieldWrapper] instance with the required builder and optional scaffold override.
  ///
  /// The [builder] parameter is mandatory and defines the widget factory for the field's content based on its value. It initializes the reactive rendering pipeline.
  ///
  /// The [overrideTileScaffold] parameter defaults to `false`, enabling the standard [ListTile]-based layout. Set to `true` to bypass this and use a plain [Pylon] for custom scaffolding. This affects how the field value and metadata are presented without altering the underlying [Pylon] state management.
  ///
  /// The `key` parameter follows standard Flutter conventions for widget identification and optimization.
  const ArcaneFieldWrapper(
      {super.key, required this.builder, this.overrideTileScaffold = false});

  /// Builds and returns the widget representation of the field wrapper.
  ///
  /// This method retrieves the ambient [ArcaneField<T>] from the [BuildContext] using [Pylon] dependency injection. It then fetches the current value for the field's effective key from its [ArcaneFieldProvider].
  ///
  /// If a value is available, it constructs either:
  /// - A [ListTile] (default) incorporating the field's [meta] properties (icon, name, description), an animated validation check icon (fading in on valid values), and the [builder]-generated content.
  /// - A custom [Pylon] widget if [overrideTileScaffold] is true, passing the value and builder directly.
  ///
  /// During loading (null value), it displays a "Loading..." text with a shimmer animation for smooth UX. The animation for the check icon uses [fadeIn] and [fadeOut] with specific durations and curves for subtle feedback.
  ///
  /// No side effects occur; this is a pure rendering method relying on reactive [Pylon] updates for rebuilds. Returns a [Widget] that integrates into the form's widget tree.
  @override
  Widget build(BuildContext context) {
    ArcaneField<T> field = context.pylon<ArcaneField<T>>();
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
                            if (field.meta.name != null) ...[
                              Flexible(child: Text(field.meta.name!).xSmall),
                              Gap(8),
                            ],
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

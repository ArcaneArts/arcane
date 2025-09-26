import 'package:arcane/arcane.dart';

/// Enumeration of display modes for the [ArcaneEnumField] widget in the Arcane form system.
///
/// This enum defines how enum options are presented to the user: as a compact dropdown for space-efficient selection
/// with many choices or interactive cards for fewer, more visual selections with 3 or fewer options. It is used
/// internally by [ArcaneEnumField] to automatically choose the optimal mode based on the number of [options], promoting
/// intuitive UX and layout efficiency. When unspecified, the field defaults to [dropdown] for >3 options and [cards]
/// for ≤3, balancing density and interactivity in forms integrated with [ArcaneFieldWrapper].
enum ArcaneEnumFieldType {
  /// Dropdown mode: Utilizes a [Select] popup menu for space-efficient selection, ideal for forms with 4 or more options.
  /// This variant minimizes vertical space in the [ArcaneFieldWrapper] while providing searchable or scrollable access
  /// to choices, suitable for long lists like categories or statuses in the Arcane UI.
  dropdown,

  /// Cards mode: Renders options as tappable [Card] widgets within a [CardCarousel], best suited for 3 or fewer options.
  /// This approach offers visual appeal and touch-friendly interaction, with built-in highlighting for the selected
  /// item, enhancing usability in compact forms alongside other components like [ArcaneBoolField].
  cards
}

enum Something { a, b, c }

void go() {
  Something a = Something.a;
  print(a.name);
}

extension _EnumOrT<T> on T {
  String get ename => this is Enum ? (this as Enum).name : toString();
}

/// Default item builder function for [ArcaneEnumField], converting enum values to simple [Text] widgets.
///
/// This top-level function, of type [Widget Function(BuildContext, T)], is used as a fallback when no custom
/// [itemBuilder] is provided in [ArcaneEnumField]. It displays the enum's string representation (e.g., 'Priority.low')
/// as plain text, ensuring consistent rendering for both dropdown and card modes without additional configuration.
/// It receives the [BuildContext] and the enum item [T], returning a [Text] widget for direct use
/// in [SelectItemButton] or [Card] children. This promotes simplicity in form setup while allowing overrides
/// for icons or rich descriptions via custom builders in the Arcane form system.
Widget _defaultItemBuilder<T>(BuildContext context, T item) =>
    Text(item.toString());

/// A versatile form field for selecting enum values in the Arcane UI system, supporting both dropdown and card-based interfaces.
///
/// This class extends [StatelessWidget] and wraps selection logic within [ArcaneFieldWrapper<T>], where T is an enum type,
/// updating the [ArcaneField<T>] provider upon choice. It automatically selects the display [mode] based on the number
/// of [options] (>3: [ArcaneEnumFieldType.dropdown], ≤3: [ArcaneEnumFieldType.cards]) for optimal user experience,
/// balancing space efficiency and visual interactivity. Custom [itemBuilder] and [cardBuilder] functions allow tailored
/// rendering, such as adding icons, descriptions, or colors to options, making it perfect for categorical inputs like
/// priority levels, statuses, or themes in forms. In card mode, the selected option is highlighted with borders for
/// immediate feedback, integrating smoothly with other Arcane components like [ArcaneStringField] for hybrid forms.
///
/// The widget retrieves the current enum value from the provider, renders the UI accordingly (e.g., [Select] for dropdown
/// or [CardCarousel] for cards), and handles updates with null fallback to default. It supports dynamic sizing in dropdowns
/// via stacked invisible items for accurate popup width, ensuring responsive design.
///
/// Usage example:
/// ```dart
/// enum Priority { low, medium, high }
///
/// ArcaneEnumField<Priority>(
///   options: Priority.values,
///   itemBuilder: (context, priority) => Text(priority.name.toUpperCase()),
///   cardBuilder: (context, priority, selected) => Card(
///     // Custom styling based on selection
///     child: Text(priority.name),
///   ),
///   mode: ArcaneEnumFieldType.dropdown,
/// )
/// ```
class ArcaneEnumField<T> extends StatelessWidget {
  /// Optional mode override for enum display, of type [ArcaneEnumFieldType?]; if null, auto-selects
  /// [ArcaneEnumFieldType.dropdown] for more than 3 [options] or [ArcaneEnumFieldType.cards] for 3 or fewer,
  /// optimizing for screen space and interaction style in the [ArcaneFieldWrapper]. This field allows explicit
  /// control when auto-detection does not match UX needs, such as forcing cards for visual emphasis in simple forms.
  final ArcaneEnumFieldType? mode;

  /// Required list of selectable enum instances, of type [List<T>], covering all relevant choices for the field.
  /// Expects non-empty, unique values for proper functionality; used to populate the dropdown items or card carousel.
  /// The length influences auto-mode selection, integrating with [ArcaneField<T>] for validation of selected values.
  final List<T> options;

  /// Custom builder for rendering individual enum items in both dropdown and cards modes, of type
  /// [Widget Function(BuildContext, T)?]. Receives the [BuildContext] and item; defaults to [_defaultItemBuilder]
  /// which shows the enum name as [Text]. This enables rich UIs like icons or formatted descriptions in Arcane forms.
  final Widget Function(BuildContext, T)? itemBuilder;

  /// Specialized builder for card mode only, of type [Widget Function(BuildContext, T, T)?], receiving context,
  /// the option, and current selected value. It enables visual feedback such as borders, colors, or icons for the
  /// active selection; if null, falls back to [itemBuilder]. This field enhances interactivity in [CardCarousel]
  /// within the [ArcaneFieldWrapper], ideal for touch-based selections.
  final Widget Function(BuildContext, T, T)? cardBuilder;

  /// Constructs an [ArcaneEnumField<T>] instance with the specified configuration for enum selection.
  ///
  /// This const constructor supports generic enum types T and initializes fields for mode, options, and builders.
  /// The [options] list is required and drives the UI generation; [mode] can be null for auto-selection based
  /// on length. Custom [itemBuilder] and [cardBuilder] allow flexible rendering, while the widget integrates
  /// with [ArcaneField<T>] provider for state persistence. Defaults promote ease of use, e.g., auto-mode for
  /// varying option counts, ensuring compatibility with form validation and theming in Arcane.
  const ArcaneEnumField(
      {super.key,
      this.mode,
      required this.options,
      this.itemBuilder,
      this.cardBuilder});

  /// Builds the enum selection UI based on the configured [mode], rendering either a themed [Select] dropdown
  /// or a [CardCarousel] of interactive cards, wrapped in [ArcaneFieldWrapper<T>].
  ///
  /// This method retrieves the current [T] value from the [ArcaneField<T>] provider, determines the mode (auto if null),
  /// and constructs the appropriate widget tree. For dropdown, it uses a [Card] container with [Select<T>] , applying
  /// a stacked [itemBuilder] for dynamic popup sizing via [PopoverConstraint.anchorMaxSize], and populates [SelectPopup]
  /// with [SelectItemButton] children. For cards, it creates a [CardCarousel] with tappable [Card] widgets, using
  /// [cardBuilder] or fallback, highlighting the selected with border and color from theme. On change, updates provider
  /// with new value or default if null. Returns a [Widget] optimized for form integration; no side effects beyond
  /// provider sets; efficient with const elements where possible.
  @override
  Widget build(BuildContext context) {
    ArcaneField<T> field = context.pylon<ArcaneField<T>>();
    return ArcaneFieldWrapper<T>(
        builder: (context) => switch (mode ??
                (options.length > 3
                    ? ArcaneEnumFieldType.dropdown
                    : ArcaneEnumFieldType.cards)) {
              ArcaneEnumFieldType.dropdown => Card(
                  padding: EdgeInsetsGeometry.zero,
                  borderColor: Colors.transparent,
                  borderWidth: 0,
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.card.withOpacity(0.5),
                  child: Select<T>(
                    itemBuilder: (context, item) {
                      return Stack(
                        children: [
                          ...options
                              .where((e) => e.ename.length > item.ename.length)
                              .map((e) => Opacity(
                                  opacity: 0,
                                  child: itemBuilder?.call(context, e) ??
                                      Text(e.ename))),
                          itemBuilder?.call(context, item) ?? Text(item.ename)
                        ],
                      );
                    },
                    popupWidthConstraint: PopoverConstraint.anchorMaxSize,
                    onChanged: (value) => field.provider.setValue(
                        field.meta.effectiveKey,
                        value ?? field.provider.defaultValue),
                    value: field.provider.subject.valueOrNull ??
                        field.provider.defaultValue,
                    popup: SelectPopup(
                      items: SelectItemList(
                        children: [
                          ...options.map((i) => SelectItemButton(
                                value: i,
                                child: itemBuilder?.call(context, i) ??
                                    Text(i.ename),
                              )),
                        ],
                      ),
                    ).call,
                  ),
                ),
              ArcaneEnumFieldType.cards => CardCarousel(
                  featherColor: Theme.of(context).colorScheme.card,
                  children: [
                    ...options
                        .map((e) =>
                            cardBuilder?.call(
                                context,
                                e,
                                field.provider.subject.valueOrNull ??
                                    field.provider.defaultValue) ??
                            Card(
                              filled: true,
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .card
                                  .withOpacity(0.5),
                              borderWidth:
                                  field.provider.subject.valueOrNull == e
                                      ? 2
                                      : null,
                              borderColor:
                                  field.provider.subject.valueOrNull == e
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5)
                                      : null,
                              onPressed: () => field.provider
                                  .setValue(field.meta.effectiveKey, e),
                              child: itemBuilder?.call(context, e) ??
                                  Text(e.ename),
                            ))
                        .whereType<Widget>()
                        .joinSeparator(Gap(8))
                  ],
                )
            });
  }
}

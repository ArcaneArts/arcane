import 'package:arcane/arcane.dart';

/// Represents the search mode for [SearchButton], determining how search queries are handled and submitted.
///
/// **Live mode** provides real-time updates to the search callback as the user types, sending:
/// - An empty string when the search box opens but is empty.
/// - A trimmed non-empty string for active queries.
/// - `null` when the search box closes, indicating no active search.
///
/// This mode is ideal for dynamically filtering lists or content in components like [Selector] or [Collection].
///
/// **Transactional mode** only submits non-empty queries upon pressing enter or the close button, closing the search box immediately.
/// Empty submissions are ignored, ensuring the callback receives only valid search terms without nulls.
///
/// This mode suits scenarios where search triggers a separate action, such as opening a [Dialog] or navigating to a results screen,
/// integrating well with [PopupMenu] for combined search-and-select interfaces or [MutableText] for editable search history.
enum SearchButtonMode {
  /// Live search mode for real-time query updates.
  live,

  /// Transactional search mode for submit-only queries.
  transactional
}

/// A compact, toggleable search button that expands into a [SearchBox] when activated,
/// providing seamless search functionality within Flutter interfaces.
///
/// This widget handles search input in two modes via [SearchButtonMode]: live for immediate filtering
/// (e.g., updating a [Collection] or [Selector] as the user types) or transactional for explicit submission
/// (e.g., launching a [Dialog] or [SearchDelegate]-like screen). It integrates with [ArcaneTheme] for consistent styling
/// and pairs naturally with input components like [IconButton] for icons, [PopupMenu] for advanced filters,
/// or [MutableText] for query persistence. The button starts as a search icon and reveals the full [SearchBox]
/// on press, managing focus and state internally for a smooth user experience.
class SearchButton extends StatefulWidget {
  final SearchButtonMode mode;
  final ValueChanged<String?>? onSearch;

  /// Constructs a [SearchButton] with customizable search behavior.
  ///
  /// The [mode] determines query handling: live mode calls [onSearch] on every change (including empty or null states),
  /// while transactional mode only invokes it for non-empty submissions and closes the box.
  /// The [onSearch] callback receives the trimmed query string or null (live mode only), enabling integration
  /// with data sources like filtered [Collection]s or navigation triggers.
  ///
  /// **Usage example:**
  /// ```dart
  /// SearchButton(
  ///   mode: SearchButtonMode.live,
  ///   onSearch: (query) {
  ///     if (query == null) {
  ///       // Clear filters in a [Selector] or [Collection]
  ///     } else {
  ///       // Apply live search to update UI
  ///     }
  ///   },
  /// )
  /// ```
  /// Embed in an [AppBar] or toolbar for discoverability, often alongside [Fab] or [IconButton] for related actions.
  const SearchButton(
      {super.key, this.onSearch, this.mode = SearchButtonMode.transactional});

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  bool searching = false;

  /// Renders the search interface based on the current state.
  ///
  /// When not searching, displays an [IconButton] with a search icon that toggles the state to open and
  /// optionally notifies [onSearch] with an empty string in live mode.
  ///
  /// When searching, shows a [SearchBox] with autofocus, leading search icon, and trailing close [IconButton].
  /// The [SearchBox]'s [onChanged] updates live queries, while [onSubmitted] handles enter key presses:
  /// - In live mode, trims and sends the query without closing.
  /// - In transactional mode, sends non-empty trimmed queries and closes the box.
  ///
  /// Closing via the trailing button resets state and sends null in live mode to clear searches.
  /// This method ensures smooth transitions and integrates with [FocusNode] for keyboard navigation.
  @override
  Widget build(BuildContext context) => (!searching
      ? IconButton(
          icon: const Icon(Icons.search_outline_ionic),
          onPressed: () => setState(() {
                searching = true;

                if (widget.mode == SearchButtonMode.live) {
                  widget.onSearch?.call("");
                }
              }))
      : SearchBox(
          autofocus: true,
          onChanged: widget.mode == SearchButtonMode.live
              ? (v) => widget.onSearch?.call(v.trim())
              : null,
          leading: const Icon(Icons.search_outline_ionic),
          onSubmitted: (v) {
            switch (widget.mode) {
              case SearchButtonMode.live:
                widget.onSearch?.call(v.trim());
                break;
              case SearchButtonMode.transactional:
                String? r = v.trim().isEmpty ? null : v.trim();

                if (r != null) {
                  widget.onSearch?.call(r);
                }

                setState(() {
                  searching = false;
                });

                break;
            }
          },
          trailing: IconButton(
              density: ButtonDensity.compact,
              icon: const Icon(Icons.close_outline_ionic),
              onPressed: () => setState(() {
                    searching = false;

                    if (widget.mode == SearchButtonMode.live) {
                      widget.onSearch?.call(null);
                    }
                  })),
        ));
}

/// A versatile, styled text input field optimized for search operations,
/// featuring customizable placeholders, icons, and event callbacks.
///
/// This widget wraps Flutter's [TextField] with arcane-specific enhancements like [ArcaneTheme] integration,
/// minimum width constraints, and seamless support for leading/trailing widgets (e.g., search [IconButton] or clear buttons).
/// It handles single-line input with autofocus options, making it ideal for search bars in [SearchButton], [AppBar]s,
/// or standalone use in forms alongside [ArcaneField] or [FieldWrapper]. Callbacks enable real-time filtering
/// (e.g., updating a [Collection] via [onChanged]) or submission actions (e.g., opening a [Dialog] via [onSubmitted]).
/// Null safety is managed through optional parameters and coalescing defaults.
class SearchBox extends StatefulWidget {
  final double? minWidth;
  final Widget placeholder;
  final Widget? leading;
  final Widget? trailing;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? initialText;
  final TextEditingController? controller;

  /// Initializes a [SearchBox] with flexible configuration for search inputs.
  ///
  /// Key features include:
  /// - [placeholder]: A widget (typically [Text]) shown when empty, customizable for context like "Search items...".
  /// - [leading] and [trailing]: Optional icons or buttons, e.g., search [IconButton] or clear [IconButton].
  /// - [onChanged]: Invoked on every keystroke for live updates, trimming whitespace implicitly in callers like [SearchButton].
  /// - [onSubmitted]: Triggered on enter key, passing the full input string for processing (e.g., query submission).
  /// - [onEditingComplete]: Called when editing ends (e.g., focus loss), useful for validation.
  /// - [focusNode]: External [FocusNode] for manual control, integrating with [ArcaneFieldProvider] or keyboard shortcuts.
  /// - [autofocus]: Enables immediate focus on render, common in [SearchButton] expansions.
  /// - [initialText]: Pre-fills the field, preserved via controller.
  /// - [controller]: Custom [TextEditingController] for advanced management, like linking to [MutableText].
  /// - [minWidth]: Constrains the box's minimum size for layout consistency.
  ///
  /// **Usage example:**
  /// ```dart
  /// SearchBox(
  ///   autofocus: true,
  ///   leading: Icon(Icons.search),
  ///   onChanged: (query) => filterCollection(query),
  ///   placeholder: Text("Search in [Collection]"),
  /// )
  /// ```
  /// Often nested in [SearchButton] for toggleable UIs or used directly in [Sheet] for modal searches.
  const SearchBox(
      {super.key,
      this.minWidth,
      this.onChanged,
      this.onEditingComplete,
      this.onSubmitted,
      this.initialText,
      this.focusNode,
      this.controller,
      this.autofocus = false,
      this.placeholder = const Text("Search"),
      this.leading,
      this.trailing});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late TextEditingController _controller;

  /// Initializes the internal text controller, using the provided [controller] or creating a new one
  /// pre-filled with [initialText] if supplied.
  ///
  /// This ensures the [SearchBox] starts with the correct content and integrates smoothly
  /// with external state management, such as syncing with [ArcaneField] values.
  /// No side effects beyond controller setup; subsequent changes trigger [onChanged].
  @override
  void initState() {
    _controller = widget.controller ??
        TextEditingController(
          text: widget.initialText,
        );
    super.initState();
  }

  /// Constructs the search input UI by wrapping a [TextField] with width constraints and arcane styling.
  ///
  /// The [TextField] is configured for single-line input ([maxLines: 1]), with callbacks wired to widget properties.
  /// Applies [constrained] for [minWidth] enforcement and `.iw` for intrinsic width optimization.
  /// Leading/trailing widgets (e.g., [IconButton]s) appear as adornments, enhancing usability
  /// in contexts like [SearchButton] or [PopupMenu] integrations.
  ///
  /// Renders responsively, respecting [autofocus], [focusNode], and [placeholder] for empty states.
  /// No direct side effects; delegates input handling to Flutter's focus system.
  @override
  Widget build(BuildContext context) => TextField(
        controller: _controller,
        maxLines: 1,
        onEditingComplete: widget.onEditingComplete,
        onSubmitted: widget.onSubmitted,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onChanged: widget.onChanged,
        placeholder: widget.placeholder,
        leading: widget.leading,
        trailing: widget.trailing,
      ).constrained(minWidth: widget.minWidth).iw;
}

import 'package:arcane/arcane.dart';

/// Represents the search mode. Live is for changing a list live
/// and transactional is for submitting a search to perhaps open a screen or launch something.
enum SearchButtonMode {
  /// When the search is submitted, the search box will simply unfocus, when the user closes the search
  /// box, null will be sent to onSearch. This ensures the onSearch matches the live query where null
  /// means there is no searching.
  ///
  /// * An empty string means the search box is open but empty / trimmed
  /// * A non-empty string means the search box is open and has a query
  /// * null means the search box is closed
  live,

  /// When the search is submitted, the search box will be closed.
  /// onSearch will never send nulls, only search changes.
  ///
  /// * Empty strings are ignored and wont send an event
  transactional
}

class SearchButton extends StatefulWidget {
  final SearchButtonMode mode;
  final ValueChanged<String?>? onSearch;

  const SearchButton(
      {super.key, this.onSearch, this.mode = SearchButtonMode.transactional});

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  bool searching = false;

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

  @override
  void initState() {
    _controller = widget.controller ??
        TextEditingController(
          text: widget.initialText,
        );
    super.initState();
  }

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

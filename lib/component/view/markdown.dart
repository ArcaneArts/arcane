import 'package:arcane/arcane.dart';
import 'package:flutter/material.dart' show SelectionArea;
import 'package:gpt_markdown/custom_widgets/markdown_config.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:url_launcher/url_launcher.dart';

/// Wrapper widget that enables text selection for its child content within the Arcane UI ecosystem.
///
/// This component integrates seamlessly with other Arcane widgets such as [Section] for structured content blocks
/// or [FillScreen] for full-screen markdown displays. It uses Flutter's [SelectionArea] to allow users to select
/// and copy text, enhancing accessibility and usability in read-only or informational screens like [SliverScreen].
///
/// Key features:
/// - Simple, lightweight wrapper with no performance overhead.
/// - Preserves the child's layout and styling while enabling selection.
/// - Ideal for documentation, articles, or any text-heavy content in Arcane apps.
///
/// Usage example:
/// ```dart
/// TextSelect(
///   child: Text('Selectable content in Arcane UI.'),
/// )
/// ```
class TextSelect extends StatelessWidget {
  final Widget child;

  const TextSelect({super.key, required this.child});

  @override
  Widget build(BuildContext context) => SelectionArea(child: child);
}

/// Core Markdown rendering widget for displaying formatted text in Arcane Flutter applications.
///
/// This stateless widget renders Markdown content using the [GptMarkdown] package, customized with Arcane-specific
/// components for enhanced UI integration. It supports a wide range of Markdown elements including code blocks,
/// tables, images, links, lists, and LaTeX math, all styled according to [ArcaneTheme]. Designed for efficient
/// rendering in performance-sensitive contexts like [FillScreen] or [SliverScreen], it avoids unnecessary rebuilds
/// by leveraging const constructors and stateless design. Use within [Section] for modular content sections or
/// [BasicCard] for contained, scrollable markdown views.
///
/// Key features:
/// - Comprehensive support for Markdown syntax with Arcane-styled components (e.g., [StaticTable] for tables, [HoverCard] for links).
/// - Custom link handling with hover previews and external URL launching.
/// - Inline and block-level components for rich text rendering.
/// - Performance optimized: Single-pass rendering with no state management overhead; suitable for large documents.
/// - Integrates with [Gesture] for interactive elements and [ArcaneTheme] for consistent theming.
///
/// Usage example:
/// ```dart
/// Markdown('## Heading\nThis is *italic* text with a [link](https://example.com).')
/// ```
class Markdown extends StatelessWidget {
  final String data;

  /// Creates a new Markdown widget with the provided content.
  ///
  /// The [data] parameter holds the raw Markdown string to render. This constructor initializes
  /// the widget with default Arcane components for optimal styling and interaction. No additional
  /// configuration is needed for basic usage, but custom builders can be extended if required.
  const Markdown(this.data, {super.key});

  @override
  Widget build(BuildContext context) => GptMarkdown(
        data,
        components: [
          CodeBlockMd(),
          NewLines(),
          BlockQuote(),
          ImageMd(),
          ATagMd(),
          ArcaneTableMd(),
          HTag(),
          UnOrderedList(),
          OrderedList(),
          RadioButtonMd(),
          CheckBoxMd(),
          HrLine(),
          StrikeMd(),
          BoldMd(),
          ItalicMd(),
          LatexMath(),
          LatexMathMultiLine(),
          HighlightedText(),
          SourceTag(),
          IndentMd(),
        ],
        codeBuilder: codeBuilder,
        linkBuilder: buildLink,
        inlineComponents: [
          ImageMd(),
          ATagMd(),
          TableMd(),
          StrikeMd(),
          BoldMd(),
          ItalicMd(),
          LatexMath(),
          LatexMathMultiLine(),
          HighlightedText(),
          SourceTag(),
        ],
        onLinkTap: (url, title) => openLink(context, url, title),
      );

  /// Builds a custom inline link widget with hover preview for better user experience.
  ///
  /// This method creates a [HoverCard]-wrapped [Text] span for Markdown links, blending the link color
  /// with the foreground for subtle emphasis. On hover, it displays a [SurfaceCard] with the link text and URL,
  /// using [Basic] layout for structured preview. Inputs include the link text span, URL, and base style;
  /// outputs a selectable, underlined text widget. Enhances accessibility in [Section] or [SliverScreen] contexts
  /// by providing visual feedback without full navigation.
  Widget buildLink(
    BuildContext context,
    InlineSpan text,
    String url,
    TextStyle style,
  ) =>
      HoverCard(
          child: Text(
            text.toPlainText(),
            style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .mix(Theme.of(context).colorScheme.foreground, 50),
                decoration: TextDecoration.underline),
          ),
          hoverBuilder: (context) => SurfaceCard(
                  child: Basic(
                leadingAlignment: Alignment.center,
                leading: Icon(Icons.globe),
                title: Text(text.toPlainText()),
                subtitle: Text(url),
              )));

  /// Handles external link opening with error feedback via [TextToast].
  ///
  /// This async method checks if the URL can be launched using [canLaunchUrl], then launches it with [launchUrl].
  /// If unsuccessful, it displays a toast notification with the error URL. Designed for seamless integration
  /// in interactive markdown like chat responses in [ChatScreen] or documentation in [FillScreen]. No state
  /// changes occur, ensuring efficient, non-blocking operation.
  Future<void> openLink(BuildContext context, String url, String title) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      TextToast("Could not open link: $url").open(context);
    }
  }

  /// Renders code blocks with syntax highlighting using [CodeSnippet].
  ///
  /// This builder function takes the code language, content, and closure state, returning a [CodeSnippet]
  /// widget configured for the specified mode. It supports various languages for accurate highlighting,
  /// integrating with [ArcaneTheme] for consistent code styling. Used in block-level code rendering within
  /// [GptMarkdown], ideal for technical docs in [Section] or tutorials in [SliverScreen]. Simple and performant,
  /// with no additional computations.
  Widget codeBuilder(
          BuildContext context, String name, String code, bool closed) =>
      CodeSnippet(code: code, mode: name);
}

/// Custom Markdown block component for rendering tables in Arcane UI with horizontal scrolling and bordered styling.
///
/// Extends [BlockMd] to parse and display Markdown tables using [StaticTable], wrapped in a scrollable [Scrollbar]
/// for wide content. Integrates with [ArcaneTheme] for border radius and colors, making it suitable for data
/// presentation in [BasicCard], [Section], or [FillScreen]. Handles variable column counts efficiently,
/// skipping separator rows and empty cells. Performance note: Uses [ScrollController] for smooth horizontal
/// scrolling without full widget rebuilds; ideal for dynamic content in [SliverScreen] without layout thrashing.
///
/// Key features:
/// - Parses pipe-delimited Markdown tables into rows of [TD] cells.
/// - Applies [TableBorder] with theme-based styling for professional appearance.
/// - Filters out header separator lines (e.g., '---') and empty rows.
/// - Supports [MdWidget] for nested Markdown in cells, enabling rich inline content.
///
/// Usage example:
/// ```dart
/// // Markdown: | Header | Value |\n| --- | --- |\n| Row1 | Data |
/// // Renders as scrollable [StaticTable] if columns exceed viewport.
///
/// You can use this in your Arcane UI projects to display properly formatted markdown tables. For instance:
/// ```dart
/// ArcaneTableMd() can be used within [Section], [BasicCard], [FillScreen], or [SliverScreen]```
class ArcaneTableMd extends BlockMd {
  void test() {
    TableMd();
  }

  /// Regular expression pattern for detecting Markdown table syntax in block text.
  @override
  String get expString =>
      (r"(((\|[^\n\|]+\|)((([^\n\|]+\|)+)?)\ *)(\n\ *(((\|[^\n\|]+\|)(([^\n\|]+\|)+)?))\ *)+)$");

  /// Builds the table widget from parsed Markdown text.
  ///
  /// This method splits the input [text] into rows, trims and maps cells by index, determining max columns
  /// for consistent layout. It constructs [TR] rows with [TD] cells containing [MdWidget] for recursive rendering,
  /// skipping separator (dashes) or empty rows. Wraps in [SingleChildScrollView] and [Scrollbar] for horizontal
  /// overflow handling. Inputs: context, raw text, and [GptMarkdownConfig] for styling; outputs a fully styled,
  /// scrollable table. Logic ensures no empty tables are rendered, with theme-integrated borders for [ArcaneTheme]
  /// consistency. Efficient for large tables, as parsing is O(n) and no unnecessary allocations occur.
  @override
  Widget build(
    BuildContext context,
    String text,
    final GptMarkdownConfig config,
  ) {
    final List<Map<int, String>> value = text
        .split('\n')
        .map<Map<int, String>>(
          (e) => e
              .trim()
              .split('|')
              .where((element) => element.isNotEmpty)
              .toList()
              .asMap(),
        )
        .toList();

    int maxCol = 0;
    for (final each in value) {
      if (maxCol < each.keys.length) {
        maxCol = each.keys.length;
      }
    }
    if (maxCol == 0) {
      return Text("", style: config.style);
    }
    final controller = ScrollController();
    return Scrollbar(
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        child: StaticTable(
            border: TableBorder(
                borderRadius: Theme.of(context).borderRadiusMd,
                bottom: BorderSide(
                    width: 1, color: Theme.of(context).colorScheme.border),
                left: BorderSide(
                    width: 1, color: Theme.of(context).colorScheme.border),
                right: BorderSide(
                    width: 1, color: Theme.of(context).colorScheme.border),
                top: BorderSide(
                    width: 1, color: Theme.of(context).colorScheme.border)),
            rows: [
              ...value
                  .asMap()
                  .entries
                  .map((i) => TR(
                          column: List.generate(maxCol, (index) {
                        var e = i.value;
                        String data = e[index] ?? "";
                        if (RegExp(r"^:?--+:?$").hasMatch(data.trim()) ||
                            data.trim().isEmpty) {
                          return null;
                        }

                        return TD(MdWidget(
                          context,
                          (e[index] ?? "").trim(),
                          false,
                          config: config,
                        ));
                      }).whereType<TD>().toList()))
                  .where((tr) => tr.column.isNotEmpty)
            ]),
      ),
    );
  }
}

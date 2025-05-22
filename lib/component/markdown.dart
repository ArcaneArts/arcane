import 'package:arcane/arcane.dart';
import 'package:flutter/material.dart' show SelectionArea;
import 'package:gpt_markdown/custom_widgets/markdown_config.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:url_launcher/url_launcher.dart';

class TextSelect extends StatelessWidget {
  final Widget child;

  const TextSelect({super.key, required this.child});

  @override
  Widget build(BuildContext context) => SelectionArea(child: child);
}

class Markdown extends StatelessWidget {
  final String data;

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
        onLinkTab: (url, title) => openLink(context, url, title),
      );

  Widget buildLink(
    BuildContext context,
    String text,
    String url,
    TextStyle style,
  ) =>
      HoverCard(
          child: Text(
            text,
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
                title: Text(text),
                subtitle: Text(url),
              )));

  Future<void> openLink(BuildContext context, String url, String title) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      TextToast("Could not open link: $url").open(context);
    }
  }

  Widget codeBuilder(
          BuildContext context, String name, String code, bool closed) =>
      CodeSnippet(code: code, mode: name);
}

/// Table component
class ArcaneTableMd extends BlockMd {
  void test() {
    TableMd();
  }

  @override
  String get expString =>
      (r"(((\|[^\n\|]+\|)((([^\n\|]+\|)+)?)\ *)(\n\ *(((\|[^\n\|]+\|)(([^\n\|]+\|)+)?))\ *)+)$");
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

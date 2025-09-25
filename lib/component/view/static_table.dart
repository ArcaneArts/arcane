import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:flutter/widgets.dart' as w show Table, TableRow;

enum TRStyle {
  normal,
  header,
  footer,
}

class TR {
  final BoxDecoration? decoration;
  final Color? color;
  final List<TD> column;
  final TRStyle style;

  const TR(
      {required this.column,
      this.color,
      this.decoration,
      this.style = TRStyle.normal});

  const TR.header({required this.column, this.color, this.decoration})
      : style = TRStyle.header;

  const TR.footer({required this.column, this.color, this.decoration})
      : style = TRStyle.footer;

  const TR.normal({required this.column, this.color, this.decoration})
      : style = TRStyle.normal;

  TR copyWith({
    BoxDecoration? decoration,
    Color? color,
    List<TD>? column,
    TRStyle? style,
  }) =>
      TR(
        column: column ?? this.column,
        color: color ?? this.color,
        decoration: decoration ?? this.decoration,
        style: style ?? this.style,
      );
}

class TD extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsets padding;
  final TRStyle style;

  const TD(this.child,
      {super.key,
      this.padding = const EdgeInsets.all(8.0),
      this.color,
      this.style = TRStyle.normal});

  @override
  Widget build(BuildContext context) => Container(
        color: color,
        child: Padding(
            padding: padding,
            child: switch (style) {
              TRStyle.header => child.muted().padOnly(top: 4, bottom: 4),
              TRStyle.footer => child.muted().padOnly(top: 4, bottom: 4),
              _ => child,
            }),
      );

  TD copyWith({
    Widget? child,
    Color? color,
    EdgeInsets? padding,
    TRStyle? style,
  }) =>
      TD(
        child ?? this.child,
        color: color ?? this.color,
        padding: padding ?? this.padding,
        style: style ?? this.style,
      );
}

class StaticTable extends StatelessWidget {
  final TableBorder? border;
  final List<TR> rows;
  final bool alternatingRowColor;
  final Map<int, TableColumnWidth>? columnWidths;
  final TableColumnWidth defaultColumnWidth;
  final TableCellVerticalAlignment defaultVerticalAlignment;

  const StaticTable(
      {super.key,
      required this.rows,
      this.alternatingRowColor = false,
      this.border,
      this.columnWidths,
      this.defaultVerticalAlignment = TableCellVerticalAlignment.baseline,
      this.defaultColumnWidth = const ComfyColumnWidth()});

  static BorderSide getDefaultBorderSide(BuildContext context) => BorderSide(
        color: Theme.of(context).colorScheme.border,
        width: 1,
      );

  static TableBorder getDefaultBorder(
          BuildContext context, bool isAlternatingRowColors) =>
      isAlternatingRowColors
          ? const TableBorder()
          : TableBorder(
              bottom: getDefaultBorderSide(context),
              horizontalInside: getDefaultBorderSide(context),
            );

  @override
  Widget build(BuildContext context) => w.Table(
        border: border ?? getDefaultBorder(context, alternatingRowColor),
        defaultColumnWidth: defaultColumnWidth,
        columnWidths: columnWidths,
        defaultVerticalAlignment: defaultVerticalAlignment,
        textBaseline: TextBaseline.alphabetic,
        children: [
          for (int i = 0; i < rows.length; i++)
            w.TableRow(
              decoration: rows[i].decoration ??
                  BoxDecoration(
                    color: rows[i].color ??
                        (rows[i].style == TRStyle.normal &&
                                alternatingRowColor &&
                                i.isOdd
                            ? Theme.of(context)
                                .colorScheme
                                .muted
                                .withOpacity(0.3)
                            : null),
                  ),
              children: rows[i].style != TRStyle.normal
                  ? rows[i]
                      .column
                      .map((e) => e.copyWith(style: rows[i].style))
                      .toList()
                  : rows[i].column,
            ),
        ],
      );
}

class ComfyColumnWidth extends TableColumnWidth {
  const ComfyColumnWidth({double? flex, double padding = 8})
      : _flex = flex,
        _padding = padding;

  @override
  double minIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) {
    double result = 0.0;
    for (final RenderBox cell in cells) {
      result = max(result, cell.getMinIntrinsicWidth(double.infinity));
    }
    return result + _padding;
  }

  @override
  double maxIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) {
    double result = 0.0;
    for (final RenderBox cell in cells) {
      result = max(result, cell.getMaxIntrinsicWidth(double.infinity));
    }
    return result + _padding;
  }

  final double? _flex;
  final double _padding;

  @override
  double? flex(Iterable<RenderBox> cells) => _flex;
}

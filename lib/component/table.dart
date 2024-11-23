import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:flutter/widgets.dart' as w show Table, TableRow;

class TR {
  final List<TD> column;

  const TR({required this.column});
}

class TD extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const TD(this.child, {super.key, this.padding = const EdgeInsets.all(8.0)});

  @override
  Widget build(BuildContext context) => Padding(padding: padding, child: child);
}

class Table extends StatelessWidget {
  final TableBorder? border;
  final List<TR> rows;
  final Map<int, TableColumnWidth>? columnWidths;
  final TableColumnWidth defaultColumnWidth;
  final TableCellVerticalAlignment defaultVerticalAlignment;

  const Table(
      {super.key,
      required this.rows,
      this.border,
      this.columnWidths,
      this.defaultVerticalAlignment = TableCellVerticalAlignment.baseline,
      this.defaultColumnWidth = const ComfyColumnWidth()});

  static BorderSide getDefaultBorderSide(BuildContext context) => BorderSide(
        color: Theme.of(context).colorScheme.border,
        width: 2,
      );

  static TableBorder getDefaultBorder(BuildContext context) => TableBorder(
        bottom: getDefaultBorderSide(context),
        horizontalInside: getDefaultBorderSide(context),
      );

  @override
  Widget build(BuildContext context) => w.Table(
        border: border ?? getDefaultBorder(context),
        defaultColumnWidth: defaultColumnWidth,
        columnWidths: columnWidths,
        defaultVerticalAlignment: defaultVerticalAlignment,
        textBaseline: TextBaseline.alphabetic,
        children: [
          for (final TR row in rows)
            w.TableRow(
              children: row.column,
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

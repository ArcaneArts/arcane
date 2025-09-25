import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:flutter/widgets.dart' as w show Table, TableRow;

/// Enum defining styles for table rows in [StaticTable].
///
/// - [normal]: Standard row style for data entries.
/// - [header]: Header row with muted text and reduced padding for titles.
/// - [footer]: Footer row similar to header for summaries or totals.
enum TRStyle {
  normal,
  header,
  footer,
}

/// A table row representation for use in [StaticTable], allowing custom styling and cell content.
///
/// This class encapsulates a row of [TD] cells with optional decoration, color, and style.
/// It supports efficient rendering in Arcane UI components like [Section] or [FillScreen],
/// where tables can be embedded without unnecessary rebuilds due to its stateless nature.
/// Use [TR.header] for column titles and [TR.footer] for summaries to maintain visual hierarchy.
class TR {
  final BoxDecoration? decoration;
  final Color? color;
  final List<TD> column;
  final TRStyle style;

  /// Creates a normal table row with required cells.
  ///
  /// The [column] must contain [TD] widgets for each cell.
  /// Optional [color] and [decoration] allow custom background and borders.
  /// Defaults to [TRStyle.normal] for standard data rows.
  const TR(
      {required this.column,
      this.color,
      this.decoration,
      this.style = TRStyle.normal});

  /// Factory for header rows, typically used for column titles.
  ///
  /// Applies [TRStyle.header] automatically, with [column] for header cells.
  /// Integrates well with [ArcaneTheme] for consistent muted styling.
  const TR.header({required this.column, this.color, this.decoration})
      : style = TRStyle.header;

  /// Factory for footer rows, often for totals or summaries.
  ///
  /// Uses [TRStyle.footer] for visual distinction, with [column] cells.
  /// Efficient for static content in [SliverScreen] without state overhead.
  const TR.footer({required this.column, this.color, this.decoration})
      : style = TRStyle.footer;

  /// Factory explicitly for normal rows.
  ///
  /// Identical to the default constructor but emphasizes standard usage.
  const TR.normal({required this.column, this.color, this.decoration})
      : style = TRStyle.normal;

  /// Creates a modified copy of this row.
  ///
  /// Useful for dynamic updates in parent widgets while preserving immutability.
  /// Only non-null parameters override existing values.
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

  /// Creates a table cell with required [child] content.
  ///
  /// [padding] defaults to 8.0 on all sides for comfortable spacing.
  /// [color] sets background; [style] determines text muting and padding adjustments.
  /// Use in [TR.column] lists for row construction.
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

  /// Creates a modified copy of this cell.
  ///
  /// Allows targeted updates, e.g., changing [style] for dynamic theming
  /// while maintaining performance in large tables.
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

/// A stateless widget for rendering static tables in Arcane Flutter applications.
///
/// Builds a Flutter [w.Table] from [rows] of [TR] objects, supporting borders, alternating colors,
/// and custom column widths. Ideal for displaying fixed data in UI components like [Section],
/// [FillScreen], or [SliverScreen] without state management overhead, ensuring efficient
/// rendering even for large datasets. Integrates seamlessly with [ArcaneTheme] for colors
/// and [Gesture] for interactive rows if wrapped.
class StaticTable extends StatelessWidget {
  final TableBorder? border;
  final List<TR> rows;
  final bool alternatingRowColor;
  final Map<int, TableColumnWidth>? columnWidths;
  final TableColumnWidth defaultColumnWidth;
  final TableCellVerticalAlignment defaultVerticalAlignment;

  /// Creates a static table with required [rows].
  ///
  /// [alternatingRowColor] enables subtle shading for odd rows using [ArcaneTheme.muted].
  /// [border] customizes edges; defaults to horizontal lines if not alternating colors.
  /// [columnWidths] overrides per-column sizing; [defaultColumnWidth] uses [ComfyColumnWidth].
  /// [defaultVerticalAlignment] baselines cells for text alignment.
  const StaticTable(
      {super.key,
      required this.rows,
      this.alternatingRowColor = false,
      this.border,
      this.columnWidths,
      this.defaultVerticalAlignment = TableCellVerticalAlignment.baseline,
      this.defaultColumnWidth = const ComfyColumnWidth()});

  /// Returns the default border side using [ArcaneTheme.colorScheme.border].
  ///
  /// Width is 1.0 for subtle separation in tables.
  static BorderSide getDefaultBorderSide(BuildContext context) => BorderSide(
        color: Theme.of(context).colorScheme.border,
        width: 1,
      );

  /// Computes the default [TableBorder] based on [isAlternatingRowColors].
  ///
  /// If alternating, no border (relies on row colors); otherwise, horizontal lines
  /// for clear row separation. Uses [getDefaultBorderSide] for consistency.
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

/// A custom [TableColumnWidth] for comfortable table sizing in [StaticTable].
///
/// Computes intrinsic widths with added padding for better readability.
/// Supports optional flex for proportional sizing. Efficient for static layouts,
/// avoiding over-constrained columns in Arcane UI tables within [BasicCard] or [Glass].
class ComfyColumnWidth extends TableColumnWidth {
  const ComfyColumnWidth({double? flex, double padding = 8})
      : _flex = flex,
        _padding = padding;

  /// Calculates the minimum intrinsic width by taking the max of cell mins plus padding.
  ///
  /// Ensures columns are wide enough for content without truncation.
  @override
  double minIntrinsicWidth(Iterable<RenderBox> cells, double containerWidth) {
    double result = 0.0;
    for (final RenderBox cell in cells) {
      result = max(result, cell.getMinIntrinsicWidth(double.infinity));
    }
    return result + _padding;
  }

  /// Calculates the maximum intrinsic width similarly, for flexible layouts.
  ///
  /// Allows columns to expand based on content while respecting padding.
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

  /// Returns the flex value if set, for proportional column distribution.
  @override
  double? flex(Iterable<RenderBox> cells) => _flex;
}

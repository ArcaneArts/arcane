# DataTable

The `DataTable` component provides an enhanced version of Flutter's standard DataTable widget with additional features like fixed headers, fixed columns, column sizing, and improved performance for large datasets.

## Overview

Arcane's DataTable extends Flutter's DataTable with several advanced features:
- Fixed headers that remain visible when scrolling vertically
- Fixed left columns that remain visible when scrolling horizontally
- Customizable column widths with S, M, L sizing options
- Fixed width columns
- Row-level tap events
- Specific row heights
- Enhanced styling options

## DataTable

### Constructor

```dart
DataTable({
  Key? key,
  required List<DataColumn> columns,
  int? sortColumnIndex,
  bool sortAscending = true,
  ValueSetter<bool?>? onSelectAll,
  Decoration? decoration,
  WidgetStateProperty<Color?>? dataRowColor,
  double? dataRowHeight,
  TextStyle? dataTextStyle,
  WidgetStateProperty<Color?>? headingRowColor,
  Color? fixedColumnsColor,
  Color? fixedCornerColor,
  double? headingRowHeight,
  TextStyle? headingTextStyle,
  CheckboxThemeData? headingCheckboxTheme,
  CheckboxThemeData? datarowCheckboxTheme,
  double? horizontalMargin,
  double? checkboxHorizontalMargin,
  Alignment checkboxAlignment = Alignment.center,
  double? bottomMargin,
  double? columnSpacing,
  bool showHeadingCheckBox = true,
  bool showCheckboxColumn = true,
  bool showBottomBorder = false,
  double? dividerThickness,
  Clip? clipBehavior,
  double? minWidth,
  ScrollController? scrollController,
  ScrollController? horizontalScrollController,
  bool? isVerticalScrollBarVisible = false,
  bool? isHorizontalScrollBarVisible = true,
  Widget? empty,
  TableBorder? border,
  double smRatio = 0.67,
  int fixedTopRows = 1,
  int fixedLeftColumns = 0,
  double lmRatio = 1.2,
  Duration sortArrowAnimationDuration = const Duration(milliseconds: 150),
  IconData sortArrowIcon = Icons.arrow_upward,
  Widget? Function(bool ascending, bool sorted)? sortArrowBuilder,
  BoxDecoration? headingRowDecoration,
  required List<DataRow> rows
})
```

## DataColumn

Arcane's `DataColumn` extends Flutter's version with size options and fixed width capabilities.

### Constructor

```dart
const DataColumn({
  required Widget label,
  String? tooltip,
  bool numeric = false,
  Function(int, bool)? onSort,
  ColumnSize size = ColumnSize.M,
  double? fixedWidth
});
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `label` | `Widget` | The column heading |
| `tooltip` | `String?` | Text shown when the user hovers over the column heading |
| `numeric` | `bool` | Whether the column values are numbers |
| `onSort` | `Function(int, bool)?` | Called when this column is tapped for sorting |
| `size` | `ColumnSize` | Relative size of the column (S, M, or L) |
| `fixedWidth` | `double?` | Optional fixed width in pixels for the column |

## DataRow

Arcane's `DataRow` extends Flutter's version with additional functionality.

### Constructor

```dart
const DataRow({
  LocalKey? key,
  bool selected = false,
  ValueChanged<bool?>? onSelectChanged,
  WidgetStateProperty<Color?>? color,
  Decoration? decoration,
  required List<DataCell> cells,
  double? specificRowHeight,
  GestureTapCallback? onTap,
  GestureTapCallback? onDoubleTap,
  GestureLongPressCallback? onLongPress,
  GestureTapCallback? onSecondaryTap,
  GestureTapDownCallback? onSecondaryTapDown
});
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `key` | `LocalKey?` | A unique identifier for this row |
| `selected` | `bool` | Whether this row is selected |
| `onSelectChanged` | `ValueChanged<bool?>?` | Called when the user selects or unselects this row |
| `color` | `WidgetStateProperty<Color?>?` | The background color for this row |
| `decoration` | `Decoration?` | Decoration to be applied to the row |
| `cells` | `List<DataCell>` | The cells that make up this row |
| `specificRowHeight` | `double?` | Specific height for this row (overrides dataRowHeight) |
| `onTap` | `GestureTapCallback?` | Called when the user taps this row |
| `onDoubleTap` | `GestureTapCallback?` | Called when the user double-taps this row |
| `onLongPress` | `GestureLongPressCallback?` | Called when the user long-presses this row |
| `onSecondaryTap` | `GestureTapCallback?` | Called when the user right-clicks this row |
| `onSecondaryTapDown` | `GestureTapDownCallback?` | Called when the user right-clicks this row (on down event) |

## Usage Examples

### Basic Data Table

```dart
DataTable(
  columns: [
    DataColumn(label: Text('Name'), size: ColumnSize.L),
    DataColumn(label: Text('Age'), size: ColumnSize.S, numeric: true),
    DataColumn(label: Text('Role'), size: ColumnSize.M),
  ],
  rows: [
    DataRow(cells: [
      DataCell(Text('John')),
      DataCell(Text('25')),
      DataCell(Text('Developer')),
    ]),
    DataRow(cells: [
      DataCell(Text('Jane')),
      DataCell(Text('23')),
      DataCell(Text('Designer')),
    ]),
    DataRow(cells: [
      DataCell(Text('Bob')),
      DataCell(Text('27')),
      DataCell(Text('Manager')),
    ]),
  ],
)
```

### Advanced Data Table

```dart
DataTable(
  fixedTopRows: 1,
  fixedLeftColumns: 1,
  columns: [
    DataColumn(
      label: Text('ID'),
      size: ColumnSize.S,
      numeric: true,
      onSort: (columnIndex, ascending) {
        // Sort logic here
      },
    ),
    DataColumn(label: Text('Name'), size: ColumnSize.L),
    DataColumn(label: Text('Department'), size: ColumnSize.M),
    DataColumn(label: Text('Salary'), numeric: true, size: ColumnSize.M),
  ],
  rows: employees.map((employee) => DataRow(
    cells: [
      DataCell(Text('${employee.id}')),
      DataCell(Text(employee.name)),
      DataCell(Text(employee.department)),
      DataCell(Text('\$${employee.salary}')),
    ],
    onTap: () => showEmployeeDetails(employee),
    specificRowHeight: 56.0,
  )).toList(),
  sortColumnIndex: _sortColumnIndex,
  sortAscending: _sortAscending,
  dataRowColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
      return Colors.blue.withOpacity(0.1);
    }
    return null;
  }),
  empty: Center(
    child: Text('No employees found'),
  ),
  minWidth: 600,
)
```

## ColumnSize Enum

The `ColumnSize` enum specifies the relative width of columns:

- `ColumnSize.S`: Small column (approximately 0.67x the width of a medium column)
- `ColumnSize.M`: Medium column (the default size)
- `ColumnSize.L`: Large column (approximately 1.2x the width of a medium column)

## Features

### Fixed Headers and Columns

- `fixedTopRows`: Number of rows to fix at the top while scrolling (default: 1)
- `fixedLeftColumns`: Number of columns to fix at the left while scrolling (default: 0)

### Custom Column Sizing

- Use `ColumnSize` to specify relative column widths
- Use `fixedWidth` on DataColumn for precise width control
- Control relative sizing with `smRatio` and `lmRatio`

### Scrolling

- `scrollController`: Controls vertical scrolling
- `horizontalScrollController`: Controls horizontal scrolling
- `isVerticalScrollBarVisible`: Controls visibility of the vertical scrollbar
- `isHorizontalScrollBarVisible`: Controls visibility of the horizontal scrollbar

### Styling

- `headingRowColor` and `dataRowColor`: Control row background colors
- `fixedColumnsColor` and `fixedCornerColor`: Style fixed sections differently
- `headingRowDecoration`: Apply custom decoration to the heading row
- `headingCheckboxTheme` and `datarowCheckboxTheme`: Style checkboxes
- `border`: Customize table borders

## Notes

- For large tables with many rows, consider implementing pagination
- The `minWidth` property is useful for ensuring tables don't shrink too much on small screens
- For empty states, provide a meaningful widget via the `empty` property
- Row-level gestures (onTap, onDoubleTap, etc.) can be used to implement detailed row interactions

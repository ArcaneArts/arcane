import 'package:arcane/arcane.dart';
import 'package:flutter/material.dart' show DataCell;

bool v = false;
String? vv;
void main() {
  runApp(const ExampleArcaneApp());
}

class ExampleArcaneApp extends StatelessWidget {
  const ExampleArcaneApp({super.key});

  @override
  Widget build(BuildContext context) => ArcaneApp(
        home: ExampleNavigationScreen(),
        theme: ArcaneTheme(
            scheme: ContrastedColorScheme.fromScheme(ColorSchemes.zinc)),
      );
}

class ExampleNavigationScreen extends StatelessWidget {
  const ExampleNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) => FillScreen(
    gutter: false,
        header: Bar(
          titleText: "Data Table Test",
        ),
        child: DataTable(
          columns: [
            DataColumn(label: Text("Name"), size: ColumnSize.L),
            DataColumn(label: Text("Age"), size: ColumnSize.S),
            DataColumn(label: Text("Address"), size: ColumnSize.L),
            DataColumn(label: Text("Phone"), size: ColumnSize.M),
            DataColumn(label: Text("Email"), size: ColumnSize.M),
          ],
          rows: List<DataRow>.generate(
              100,
              (index) => DataRow(cells: [
                    DataCell(Text("Name $index")),
                    DataCell(Text("$index")),
                    DataCell(Text("Address $index")),
                    DataCell(Text("Phone $index")),
                    DataCell(Text("Email $index")),
                  ])),
        ),
      );
}

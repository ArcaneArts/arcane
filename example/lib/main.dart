import 'package:arcane/arcane.dart';

bool v = false;
String? vv;
void main() {
  runApp(const ExampleArcaneApp());
}

class ExampleArcaneApp extends StatelessWidget {
  const ExampleArcaneApp({super.key});

  @override
  Widget build(BuildContext context) => ArcaneApp(
        home: FillScreen(
            child: Builder(
                builder: (context) => Table(
                      rows: const [
                        TR(
                          column: [
                            TD(
                              Text("Cell 1"),
                            ),
                            TD(Text("Cell A")),
                          ],
                        ),
                        TR(
                          column: [
                            TD(Text("Cell 2")),
                            TD(Text("Cell B")),
                          ],
                        ),
                      ],
                    ))),
        theme: ArcaneTheme(
            scheme: ContrastedColorScheme.fromScheme(ColorSchemes.zinc)),
      );
}

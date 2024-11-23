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
                      alternatingRowColor: false,
                      rows: [
                        TR.header(
                          column: [
                            TD(Text("Cell 1")),
                            TD(Text("Cell A")),
                          ],
                        ),
                        TR(
                          column: [
                            TD(Text("Cell 1"),
                                color: Colors.red.withOpacity(0.1)),
                            TD(Text("Cell A")),
                          ],
                        ),
                        TR(
                          column: [
                            TD(Text("Cell 2"),
                                color: Colors.red.withOpacity(0.1)),
                            TD(Text("Cell B"),
                                color: Colors.blue.withOpacity(0.1)),
                          ],
                        ),
                        TR(
                          column: [
                            TD(Text("Cell 2")),
                            TD(Text("Cell B"),
                                color: Colors.blue.withOpacity(0.1)),
                          ],
                        ),
                        TR(
                          color: Colors.green.withOpacity(0.1),
                          column: [
                            TD(Text("Cell 2")),
                            TD(Text("Cell B")),
                          ],
                        ),
                        TR(
                          column: [
                            TD(Text("Cell 2")),
                            TD(Text("Cell B")),
                          ],
                        ),
                        TR.footer(
                          column: [
                            TD(Text("Cell 1")),
                            TD(Text("Cell A")),
                          ],
                        ),
                      ],
                    ))),
        theme: ArcaneTheme(
            scheme: ContrastedColorScheme.fromScheme(ColorSchemes.zinc)),
      );
}

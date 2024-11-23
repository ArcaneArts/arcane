import 'package:arcane/arcane.dart';
import 'package:arcane/component/dialog/command.dart';

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
            child: Center(
          child: Builder(
              builder: (context) => PrimaryButton(
                  child: Text("Date Range Picker"),
                  onPressed: () => DialogCommand(
                        leading: Icon(Icons.airplane),
                        trailing: Icon(Icons.airplane),
                        onConfirm: (range) {
                          print(range);
                        },
                      ).open(context))),
        )),
        theme: ArcaneTheme(
            scheme: ContrastedColorScheme.fromScheme(ColorSchemes.zinc)),
      );
}

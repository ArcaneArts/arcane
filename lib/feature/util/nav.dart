import 'package:arcane/arcane.dart';
import 'package:flyout/flyout.dart';

class Nav {
  static Future<dynamic> to(BuildContext context, WidgetBuilder screen) async =>
      Navigator.push(context, MaterialPageRoute(builder: screen));

  static Future<dynamic> fly(
          BuildContext context, WidgetBuilder screen) async =>
      flyout(context, () => screen(context));

  static Future<dynamic> pop(BuildContext context, [dynamic result]) async =>
      Navigator.pop(context, result);

  static void home(BuildContext context) =>
      Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);

  static void stack(BuildContext context, List<WidgetBuilder> stack) {
    home(context);

    for (WidgetBuilder i in stack) {
      to(context, i);
    }
  }
}

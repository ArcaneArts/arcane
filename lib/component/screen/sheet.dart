import 'package:arcane/arcane.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class InsideSheetSignal {
  const InsideSheetSignal();
}

extension XBuildContextSheetSignal on BuildContext {
  bool get inSheet => pylonOr<InsideSheetSignal>() != null;
}

mixin ArcaneSheetLauncher on Widget {
  bool get isDismissible;

  Future<T?> open<T>(BuildContext context) {
    PylonBuilder builder = Pylon.mirror(context, (context) => this);
    return showCupertinoModalBottomSheet(
      duration: const Duration(milliseconds: 500),
      isDismissible: isDismissible,
      bounce: true,
      enableDrag: isDismissible,
      animationCurve: Curves.easeOutExpo,
      context: context,
      builder: builder,
    );
  }
}

class Sheet extends StatelessWidget with ArcaneSheetLauncher {
  final bool dismissible;
  final Widget Function(BuildContext context) builder;

  const Sheet({super.key, required this.builder, this.dismissible = true});

  @override
  Widget build(BuildContext context) => Pylon<InsideSheetSignal>(
        value: const InsideSheetSignal(),
        builder: builder,
      );

  @override
  bool get isDismissible => dismissible;
}

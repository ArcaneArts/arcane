import 'package:arcane/arcane.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:padded/padded.dart';
import 'package:pylon/pylon.dart';
import 'package:smooth_sheets/smooth_sheets.dart' as ss;

class InsideSheetSignal {
  const InsideSheetSignal();
}

extension XBuildContextSheetSignal on BuildContext {
  bool get inSheet => pylonOr<InsideSheetSignal>() != null;
}

mixin ArcaneSheetLauncher on Widget {
  bool get isDismissible;

  void open(BuildContext context) {
    PylonBuilder builder = Pylon.mirror(context, (context) => this);
    showCupertinoModalBottomSheet(
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

mixin ArcaneKBSheetLauncher on Widget {
  Future<T?> open<T extends Object?>(BuildContext context) => Navigator.push(
      context,
      ss.ModalSheetRoute(builder: Pylon.mirror(context, (context) => this)));
}

class KeyboardSheet extends StatelessWidget with ArcaneKBSheetLauncher {
  final Widget Function(BuildContext context) builder;

  const KeyboardSheet({super.key, required this.builder});

  @override
  Widget build(BuildContext context) => ss.SheetKeyboardDismissible(
      dismissBehavior: const ss.SheetKeyboardDismissBehavior.onDragDown(
        isContentScrollAware: true,
      ),
      child: ss.ScrollableSheet(
          child: ss.SheetContentScaffold(
              backgroundColor: Colors.transparent,
              body: SurfaceCard(
                  clipBehavior: Clip.antiAlias,
                  child: SafeArea(
                      bottom: false,
                      child: PaddingAll(
                          padding: 8,
                          child: Builder(
                            builder: builder,
                          )))))));
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

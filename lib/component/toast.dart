import 'package:arcane/arcane.dart';
import 'package:pylon/pylon.dart';

mixin ArcaneToastLauncher on Widget {
  bool get dismissible;
  Duration get showDuration;
  Duration get entryDuration;
  ToastLocation get location;

  void open(BuildContext context) {
    PylonBuilder builder = Pylon.mirror(context, (context) => this);
    showToast(
        context: context,
        location: location,
        showDuration: showDuration,
        dismissible: dismissible,
        entryDuration: entryDuration,
        curve: Curves.easeOutExpo,
        builder: (context, overlay) => Builder(builder: builder));
  }
}

class TextToast extends StatelessWidget with ArcaneToastLauncher {
  @override
  final Duration showDuration;
  @override
  final bool dismissible;
  @override
  final Duration entryDuration;
  @override
  final ToastLocation location;
  final String message;
  const TextToast(
    this.message, {
    super.key,
    this.showDuration = const Duration(seconds: 3),
    this.dismissible = true,
    this.location = ToastLocation.bottomLeft,
    this.entryDuration = const Duration(milliseconds: 100),
  });

  @override
  Widget build(BuildContext context) =>
      Toast(builder: (context) => Text(message));
}

class Toast extends StatelessWidget with ArcaneToastLauncher {
  @override
  final Duration showDuration;
  @override
  final bool dismissible;
  @override
  final Duration entryDuration;
  @override
  final ToastLocation location;
  final Widget Function(BuildContext context) builder;

  const Toast({
    super.key,
    this.location = ToastLocation.bottomLeft,
    this.showDuration = const Duration(seconds: 3),
    this.dismissible = true,
    this.entryDuration = const Duration(milliseconds: 100),
    required this.builder,
  });

  @override
  Widget build(BuildContext context) => Glass(
        ignoreContextSignals: true,
        disabled: false,
        blur: Theme.of(context).surfaceBlur ?? 16,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Builder(builder: builder),
        ),
      );
}

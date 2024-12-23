import 'package:arcane/arcane.dart';
import 'package:arcane/generated/arcane_shadcn/src/components/overlay/toast.dart';

class ToastTheme {
  final ToastLocation location;
  final Duration entryDuration;
  final Duration showDuration;

  const ToastTheme({
    this.location = ToastLocation.bottomLeft,
    this.entryDuration = const Duration(milliseconds: 500),
    this.showDuration = const Duration(seconds: 3),
  });

  ToastTheme copyWith({
    ToastLocation? location,
    Duration? entryDuration,
    Duration? showDuration,
  }) {
    return ToastTheme(
      location: location ?? this.location,
      entryDuration: entryDuration ?? this.entryDuration,
      showDuration: showDuration ?? this.showDuration,
    );
  }
}

mixin ArcaneToastLauncher on Widget {
  bool get dismissible;
  Duration? get showDuration;
  Duration? get entryDuration;
  ToastLocation? get location;

  void open(BuildContext context) {
    ToastTheme t = ArcaneTheme.of(context).toast;
    PylonBuilder builder = Pylon.mirror(context, (context) => this);
    showToast(
        context: context,
        location: location ?? t.location,
        showDuration: showDuration ?? t.showDuration,
        dismissible: dismissible,
        entryDuration: entryDuration ?? t.entryDuration,
        curve: Curves.easeOutExpo,
        builder: (context, overlay) => Builder(builder: builder));
  }
}

class TextToast extends StatelessWidget with ArcaneToastLauncher {
  @override
  final Duration? showDuration;
  @override
  final bool dismissible;
  @override
  final Duration? entryDuration;
  @override
  final ToastLocation? location;
  final String message;
  const TextToast(
    this.message, {
    super.key,
    this.showDuration,
    this.dismissible = true,
    this.location,
    this.entryDuration,
  });

  @override
  Widget build(BuildContext context) =>
      Toast(builder: (context) => Text(message));
}

class Toast extends StatelessWidget with ArcaneToastLauncher {
  @override
  final Duration? showDuration;
  @override
  final bool dismissible;
  @override
  final Duration? entryDuration;
  @override
  final ToastLocation? location;
  final Widget Function(BuildContext context) builder;

  const Toast({
    super.key,
    this.location,
    this.showDuration,
    this.dismissible = true,
    this.entryDuration,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) => SurfaceCard(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Builder(builder: builder),
        ),
      );
}

import 'package:arcane/arcane.dart';
import 'package:arcane/generated/arcane_shadcn/src/components/overlay/toast.dart';

/// Toast notification dialog for the Arcane UI library.
///
/// Displays temporary, non-intrusive notifications that integrate seamlessly with ArcaneTheme for default
/// positioning, durations, and styling. Uses the toast mixin for easy launching via open() method.
///
/// Key features:
/// - Auto-dismiss after configurable showDuration (defaults from theme).
/// - Customizable location (e.g., bottomLeft) and entry animations.
/// - Dismissible by user gesture.
/// - Renders content via builder in a SurfaceCard with padding.
///
/// Usage:
/// ```dart
/// Toast(
///   builder: (context) => const Text('Success!'),
/// ).open(context);
/// ```
class ArcaneToastTheme {
  final ToastLocation location;
  final Duration entryDuration;
  final Duration showDuration;

  const ArcaneToastTheme({
    this.location = ToastLocation.bottomLeft,
    this.entryDuration = const Duration(milliseconds: 500),
    this.showDuration = const Duration(seconds: 3),
  });

  ArcaneToastTheme copyWith({
    ToastLocation? location,
    Duration? entryDuration,
    Duration? showDuration,
  }) {
    return ArcaneToastTheme(
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
    ArcaneToastTheme t = ArcaneTheme.of(context).toast;
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

  /// Constructs a Toast notification.
  ///
  /// The [builder] defines the widget content to display. Optional parameters override theme defaults
  /// for location, durations, and dismissibility, enabling flexible toast handling in Arcane apps.

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

import 'package:arcane/arcane.dart';

mixin ArcaneDialogLauncher on Widget {
  void open(BuildContext context) {
    PylonBuilder builder = Pylon.mirror(context, (context) => this);
    showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Theme.of(context)
            .colorScheme
            .background
            .withOpacity(Theme.of(context).surfaceOpacity ?? 0.5),
        builder: builder);
  }
}

class ArcaneDialog extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final double? surfaceBlur;
  final double? surfaceOpacity;
  final Color? barrierColor;
  final double padding;

  const ArcaneDialog({
    super.key,
    this.padding = 24,
    this.leading,
    this.title,
    this.content,
    this.actions,
    this.trailing,
    this.surfaceBlur,
    this.surfaceOpacity,
    this.barrierColor,
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
        leading: leading,
        title: title,
        content: content,
        actions: actions,
        padding: EdgeInsets.all(padding * Theme.of(context).scaling),
        trailing: trailing,
        surfaceBlur: surfaceBlur,
        surfaceOpacity: surfaceOpacity,
        barrierColor: barrierColor ??
            Theme.of(context).colorScheme.background.withOpacity(0.65),
      ).blurIn;
}

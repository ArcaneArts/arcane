import 'package:arcane/arcane.dart';
import 'package:arcane/generated/arcane_shadcn/src/components/overlay/dialog.dart';

mixin ArcaneDialogLauncher on Widget {
  Future<T?> open<T>(BuildContext context) {
    return showDialog<T>(
        context: context,
        barrierDismissible: true,
        useSafeArea: false,
        barrierColor: Colors.black.withOpacity(0.3),
        builder: (context) => this);
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
  });

  @override
  Widget build(BuildContext context) => ArcaneAlertDialog(
          leading: leading,
          title: title,
          content: content,
          actions: actions,
          padding: EdgeInsets.all(padding * Theme.of(context).scaling),
          trailing: trailing,
          surfaceBlur: surfaceBlur,
          surfaceOpacity: surfaceOpacity)
      .blurIn;
}

class ArcaneAlertDialog extends StatefulWidget {
  final Widget? leading;
  final Widget? trailing;
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final double? surfaceBlur;
  final double? surfaceOpacity;
  final EdgeInsetsGeometry? padding;

  const ArcaneAlertDialog({
    super.key,
    this.leading,
    this.title,
    this.content,
    this.actions,
    this.trailing,
    this.surfaceBlur,
    this.surfaceOpacity,
    this.padding,
  });

  @override
  _ArcaneAlertDialogState createState() => _ArcaneAlertDialogState();
}

class _ArcaneAlertDialogState extends State<ArcaneAlertDialog> {
  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var scaling = themeData.scaling;
    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.leading != null)
          widget.leading!.iconXLarge().iconMutedForeground(),
        if (widget.title != null || widget.content != null)
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.title != null) widget.title!.large().semiBold(),
                if (widget.content != null) widget.content!.small().muted(),
              ],
            ).gap(8 * scaling),
          ),
        if (widget.trailing != null)
          widget.trailing!.iconXLarge().iconMutedForeground(),
      ],
    ).gap(16 * scaling);
    Widget d = ModalContainer(
      borderColor: Theme.of(context).colorScheme.border,
      borderRadius: themeData.borderRadiusXxl,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: content,
          ),
          if (widget.actions != null && widget.actions!.isNotEmpty)
            Stack(
              fit: StackFit.passthrough,
              alignment: Alignment.centerRight,
              children: [
                SizedBox(
                  height: 0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    hitTestBehavior: HitTestBehavior.deferToChild,
                    child: Opacity(
                      opacity: 0,
                      child: content,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ...join(widget.actions!, SizedBox(width: 8 * scaling))
                  ],
                )
              ],
            )
        ],
      ).gap(16 * scaling),
    ).blurIn;
    return d;
  }
}

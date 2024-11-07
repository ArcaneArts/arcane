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
  Widget build(BuildContext context) => ArcaneAlertDialog(
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

class ArcaneAlertDialog extends StatefulWidget {
  final Widget? leading;
  final Widget? trailing;
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final double? surfaceBlur;
  final double? surfaceOpacity;
  final Color? barrierColor;
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
    this.barrierColor,
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
    return ModalContainer(
      borderRadius: themeData.borderRadiusXxl,
      barrierColor: widget.barrierColor ?? Colors.black.withOpacity(0.8),
      surfaceClip: ModalContainer.shouldClipSurface(
          widget.surfaceOpacity ?? themeData.surfaceOpacity),
      child: OutlinedContainer(
        backgroundColor: themeData.colorScheme.popover,
        borderRadius: themeData.borderRadiusXxl,
        borderWidth: 1 * scaling,
        borderColor: themeData.colorScheme.muted,
        padding: widget.padding ?? EdgeInsets.all(24 * scaling),
        surfaceBlur: widget.surfaceBlur ?? themeData.surfaceBlur,
        surfaceOpacity: widget.surfaceOpacity ?? themeData.surfaceOpacity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Row(
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
                          if (widget.title != null)
                            widget.title!.large().semiBold(),
                          if (widget.content != null)
                            widget.content!.small().muted(),
                        ],
                      ).gap(8 * scaling),
                    ),
                  if (widget.trailing != null)
                    widget.trailing!.iconXLarge().iconMutedForeground(),
                ],
              ).gap(16 * scaling),
            ),
            if (widget.actions != null && widget.actions!.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                // children: widget.actions!,
                children: join(widget.actions!, SizedBox(width: 8 * scaling))
                    .toList(),
              ),
          ],
        ).gap(16 * scaling),
      ),
    );
  }
}

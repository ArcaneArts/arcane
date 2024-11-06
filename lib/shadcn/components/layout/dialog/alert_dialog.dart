import 'package:arcane/arcane.dart';

class AlertDialog extends StatefulWidget {
  final Widget? leading;
  final Widget? trailing;
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final double? surfaceBlur;
  final double? surfaceOpacity;
  final Color? barrierColor;
  final double padding;

  const AlertDialog({
    super.key,
    this.leading,
    this.title,
    this.content,
    this.actions,
    this.trailing,
    this.surfaceBlur,
    this.surfaceOpacity,
    this.barrierColor,
    this.padding = 24,
  });

  @override
  _AlertDialogState createState() => _AlertDialogState();
}

class _AlertDialogState extends State<AlertDialog> {
  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);
    var scaling = themeData.scaling;
    return IntrinsicWidth(
      child: ModalContainer(
        borderRadius: themeData.borderRadiusXxl,
        barrierColor: widget.barrierColor ?? Colors.black.withOpacity(0.8),
        child: OutlinedContainer(
          backgroundColor: themeData.colorScheme.popover,
          borderRadius: themeData.radiusXxl,
          borderWidth: 1 * scaling,
          borderColor: themeData.colorScheme.border,
          padding: EdgeInsets.all(widget.padding * scaling),
          surfaceBlur: widget.surfaceBlur ?? themeData.surfaceBlur,
          surfaceOpacity:
              (widget.surfaceOpacity ?? themeData.surfaceOpacity)! * 1.1,
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.leading != null)
                        widget.leading!.iconXLarge().iconMutedForeground(),
                      if (widget.title != null || widget.content != null)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
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
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      // children: widget.actions!,
                      children:
                          join(widget.actions!, SizedBox(width: 8 * scaling))
                              .toList(),
                    ),
                  ),
              ],
            ).gap(16 * scaling),
          ),
        ),
      ),
    );
  }
}

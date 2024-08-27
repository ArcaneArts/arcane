import 'package:arcane/arcane.dart';

enum ArcaneCheckboxState implements Comparable<ArcaneCheckboxState> {
  checked,
  unchecked,
  indeterminate;

  @override
  int compareTo(ArcaneCheckboxState other) {
    return index.compareTo(other.index);
  }
}

class ArcaneCheckbox extends StatefulWidget {
  final ArcaneCheckboxState state;
  final ValueChanged<ArcaneCheckboxState>? onChanged;
  final Widget? leading;
  final Widget? trailing;
  final bool tristate;

  const ArcaneCheckbox({
    Key? key,
    required this.state,
    required this.onChanged,
    this.leading,
    this.trailing,
    this.tristate = false,
  }) : super(key: key);

  @override
  _ArcaneCheckboxState createState() => _ArcaneCheckboxState();
}

class _ArcaneCheckboxState extends State<ArcaneCheckbox>
    with FormValueSupplier {
  final bool _focusing = false;
  bool _shouldAnimate = false;

  void _changeTo(ArcaneCheckboxState state) {
    if (widget.onChanged != null) {
      widget.onChanged!(state);
    }
  }

  void _tap() {
    if (widget.tristate) {
      switch (widget.state) {
        case ArcaneCheckboxState.checked:
          _changeTo(ArcaneCheckboxState.unchecked);
          break;
        case ArcaneCheckboxState.unchecked:
          _changeTo(ArcaneCheckboxState.indeterminate);
          break;
        case ArcaneCheckboxState.indeterminate:
          _changeTo(ArcaneCheckboxState.checked);
          break;
      }
    } else {
      _changeTo(
        widget.state == ArcaneCheckboxState.checked
            ? ArcaneCheckboxState.unchecked
            : ArcaneCheckboxState.checked,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reportNewFormValue(widget.state, (value) {
      if (widget.onChanged != null) {
        widget.onChanged!(value);
      }
    });
  }

  @override
  void didUpdateWidget(covariant ArcaneCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state) {
      reportNewFormValue(widget.state, (value) {
        _changeTo(value);
      });
      _shouldAnimate = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Clickable(
      enabled: widget.onChanged != null,
      mouseCursor: const WidgetStatePropertyAll(SystemMouseCursors.click),
      onPressed: widget.onChanged != null ? _tap : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.leading != null) ...[
            widget.leading!.small().medium(),
            Gap(theme.scaling * 8)
          ],
          AnimatedContainer(
            duration: kDefaultDuration,
            width: theme.scaling * 16,
            height: theme.scaling * 16,
            decoration: BoxDecoration(
              color: widget.state == ArcaneCheckboxState.checked
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withOpacity(0),
              borderRadius: BorderRadius.circular(theme.radiusSm),
              border: Border.all(
                color: _focusing
                    ? theme.colorScheme.ring
                    : widget.state == ArcaneCheckboxState.checked
                        ? theme.colorScheme.primary
                        : theme.colorScheme.mutedForeground,
                width: (_focusing ? 2 : 1) * theme.scaling,
              ),
            ),
            child: widget.state == ArcaneCheckboxState.checked
                ? Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      child: SizedBox(
                        width: theme.scaling * 9,
                        height: theme.scaling * 6.5,
                        child: AnimatedValueBuilder(
                          value: 1.0,
                          initialValue: _shouldAnimate ? 0.0 : null,
                          duration: Duration(milliseconds: 300),
                          curve: IntervalDuration(
                            start: Duration(milliseconds: 175),
                            duration: Duration(milliseconds: 300),
                          ),
                          builder: (context, value, child) {
                            return CustomPaint(
                              painter: AnimatedArcaneCheckPainter(
                                progress: value,
                                color: theme.colorScheme.primaryForeground,
                                strokeWidth: theme.scaling * 1,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: widget.state == ArcaneCheckboxState.indeterminate
                          ? theme.scaling * 8
                          : 0,
                      height: widget.state == ArcaneCheckboxState.indeterminate
                          ? theme.scaling * 8
                          : 0,
                      padding: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(theme.radiusXs),
                      ),
                    ),
                  ),
          ),
          if (widget.trailing != null) ...[
            Gap(theme.scaling * 8),
            widget.trailing!.small().medium(),
          ],
        ],
      ),
    );
  }
}

class AnimatedArcaneCheckPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  AnimatedArcaneCheckPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    Offset firstStrokeStart = Offset(0, size.height * 0.5);
    Offset firstStrokeEnd = Offset(size.width * 0.35, size.height);
    Offset secondStrokeStart = firstStrokeEnd;
    Offset secondStrokeEnd = Offset(size.width, 0);
    double firstStrokeLength =
        (firstStrokeEnd - firstStrokeStart).distanceSquared;
    double secondStrokeLength =
        (secondStrokeEnd - secondStrokeStart).distanceSquared;
    double totalLength = firstStrokeLength + secondStrokeLength;

    double normalizedFirstStrokeLength = firstStrokeLength / totalLength;
    double normalizedSecondStrokeLength = secondStrokeLength / totalLength;

    double firstStrokeProgress =
        progress.clamp(0.0, normalizedFirstStrokeLength) /
            normalizedFirstStrokeLength;
    double secondStrokeProgress = (progress - normalizedFirstStrokeLength)
            .clamp(0.0, normalizedSecondStrokeLength) /
        normalizedSecondStrokeLength;
    if (firstStrokeProgress <= 0) {
      return;
    }
    Offset currentPoint =
        Offset.lerp(firstStrokeStart, firstStrokeEnd, firstStrokeProgress)!;
    path.moveTo(firstStrokeStart.dx, firstStrokeStart.dy);
    path.lineTo(currentPoint.dx, currentPoint.dy);
    if (secondStrokeProgress <= 0) {
      canvas.drawPath(path, paint);
      return;
    }
    Offset secondPoint = Offset.lerp(
      secondStrokeStart,
      secondStrokeEnd,
      secondStrokeProgress,
    )!;
    path.lineTo(secondPoint.dx, secondPoint.dy);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant AnimatedArcaneCheckPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

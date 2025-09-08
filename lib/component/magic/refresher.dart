import 'package:arcane/arcane.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

class MagicRefresher extends StatefulWidget {
  final Widget child;
  final IndicatorController? controller;
  final Future<void> Function()? onLoadTop;
  final Future<void> Function()? onLoadBottom;

  const MagicRefresher({
    super.key,
    required this.child,
    this.controller,
    this.onLoadTop,
    this.onLoadBottom,
  });

  @override
  State<MagicRefresher> createState() => _MagicRefresherState();
}

class _MagicRefresherState extends State<MagicRefresher> {
  late IndicatorController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = widget.controller ?? IndicatorController();
  }

  @override
  Widget build(BuildContext context) =>
      widget.onLoadTop == null && widget.onLoadBottom == null
          ? widget.child
          : CustomRefreshIndicator(
              controller: _ctrl,
              autoRebuild: false,
              offsetToArmed: 100,
              trigger: widget.onLoadTop != null && widget.onLoadBottom != null
                  ? IndicatorTrigger.bothEdges
                  : widget.onLoadTop != null
                      ? IndicatorTrigger.leadingEdge
                      : widget.onLoadBottom != null
                          ? IndicatorTrigger.trailingEdge
                          : IndicatorTrigger.bothEdges,
              leadingScrollIndicatorVisible: false,
              trailingScrollIndicatorVisible: false,
              onRefresh: () async {
                if (_ctrl.side == IndicatorSide.top) {
                  await widget.onLoadTop?.call();
                } else if (_ctrl.side == IndicatorSide.bottom) {
                  await widget.onLoadBottom?.call();
                }
              },
              onStateChanged: (change) {
                // Optional: Use for custom animations if needed (e.g., for more complex indicators).
                // For CircularProgressIndicator, not required as it handles its own progress animation.
                // Example from package docs:
                // if (change.didChange(to: IndicatorState.loading)) {
                //   _myAnimation.repeat(reverse: true);
                // } else if (change.didChange(from: IndicatorState.loading)) {
                //   _myAnimation.stop();
                // } else if (change.didChange(to: IndicatorState.idle)) {
                //   _myAnimation.value = 0.0;
                // }
              },
              builder: (
                BuildContext context,
                Widget child,
                IndicatorController controller,
              ) {
                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    const double armedExtent = 100.0;
                    double extent = controller.value * armedExtent;
                    double childTranslation = 0.0;
                    double indicatorTranslation = 0.0;
                    Alignment alignment = Alignment.center;
                    bool showIndicator = controller.side != IndicatorSide.none;

                    if (controller.side == IndicatorSide.top) {
                      alignment = Alignment.topCenter;
                      childTranslation = extent;
                      indicatorTranslation = -armedExtent + extent;
                    } else if (controller.side == IndicatorSide.bottom) {
                      alignment = Alignment.bottomCenter;
                      childTranslation = -extent;
                      indicatorTranslation = armedExtent - extent;
                    }

                    return Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Transform.translate(
                          offset: Offset(0, childTranslation),
                          child: child,
                        ),
                        if (showIndicator)
                          Align(
                            alignment: alignment,
                            child: Transform.translate(
                              offset: Offset(0, indicatorTranslation),
                              child: SizedBox(
                                height: armedExtent,
                                width: double.infinity,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: controller.isLoading
                                        ? null
                                        : controller.value.clamp(0.0, 1.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
              child: widget.child,
            );
}

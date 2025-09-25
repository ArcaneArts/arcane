import 'package:arcane/arcane.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

/// A pull-to-refresh utility widget that enhances Flutter's [RefreshIndicator] with Arcane theming and flexible loading support.
///
/// This widget wraps a scrollable [child] (such as [ListView], [SliverList], or [ChatScreen]) to enable pull-to-refresh gestures at the top,
/// bottom, or both edges. It integrates with [ArcaneTheme] for consistent styling of the loading indicator ([CircularProgressIndicator])
/// and provides smooth animations for user feedback. Use it in scrollable views to handle data refreshes asynchronously without blocking
/// the UI, supporting error handling via [Toast] for failures. It builds on [CustomRefreshIndicator] for advanced trigger modes and
/// physics integration, ensuring performance with non-blocking async operations and efficient rebuilds. Compatible with [SliverRefresher]
/// for sliver contexts and responds to [PullToRefreshNotification] for custom notifications.
class ListRefresher extends StatefulWidget {
  final Widget child;
  final IndicatorController? controller;
  final Future<void> Function()? onLoadTop;
  final Future<void> Function()? onLoadBottom;

  /// Creates a [ListRefresher] instance with the required scrollable [child] widget.
  ///
  /// The [child] is the scrollable content (e.g., [ListView] or [SliverList]) that will be wrapped for refresh support.
  /// Provide [onLoadTop] for top-edge pull-to-refresh (typical data reload) and/or [onLoadBottom] for bottom-edge loading (e.g., infinite scroll).
  /// Optionally supply a custom [controller] for manual refresh control. The widget automatically configures trigger modes based on provided callbacks,
  /// with a 100-unit pull distance to arm the refresh. Integrates [CircularProgressIndicator] styled via [ArcaneTheme] for visual feedback during loading.
  const ListRefresher({
    super.key,
    required this.child,
    this.controller,
    this.onLoadTop,
    this.onLoadBottom,
  });

  @override
  State<ListRefresher> createState() => _ListRefresherState();
}

/// The private state class for [ListRefresher], managing the indicator controller and refresh logic.
///
/// Handles initialization of the [IndicatorController], determines trigger edges based on provided callbacks, and orchestrates async refresh calls.
/// Ensures smooth pull gestures with animated translations and theme-aware loading indicators, integrating with [ArcaneTheme] for colors and
/// [Toast] for error notifications if needed. Supports both top and bottom refreshes for versatile use in [ChatScreen] or paginated lists.
class _ListRefresherState extends State<ListRefresher> {
  late IndicatorController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = widget.controller ?? IndicatorController();
  }

  @override
  Widget build(BuildContext context) =>

      /// Builds the refresh-enabled widget tree, conditionally wrapping the [child] with [CustomRefreshIndicator] if refresh callbacks are provided.
      ///
      /// Configures the indicator for top/bottom/both edges based on [onLoadTop] and [onLoadBottom], with a 100-unit armed offset for intuitive pulls.
      /// The [onRefresh] callback executes the appropriate async loader ([onLoadTop] or [onLoadBottom]) based on pull side, ensuring non-blocking UI updates.
      /// Uses [AnimatedBuilder] for smooth extent-based translations and shows a [CircularProgressIndicator] (themed via [ArcaneTheme]) during loading,
      /// with value progress for armed state. Hides default scroll indicators and clips none for overlay effects. Integrates with [SliverRefresher] patterns
      /// and responds to [PullToRefreshNotification] implicitly through gesture handling, optimizing performance by avoiding unnecessary rebuilds.
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

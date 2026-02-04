import 'package:flutter/material.dart';

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
    this.parallaxIntensity = 0.25,
    this.fadeIntensity = 0,
    this.axis = Axis.horizontal,
  }) : super(repaint: scrollable.position);

  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;
  final double parallaxIntensity;
  final double fadeIntensity;
  final Axis axis;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(width: constraints.maxWidth);
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = axis == Axis.horizontal
        ? listItemBox.localToGlobal(
            listItemBox.size.topCenter(Offset.zero),
            ancestor: scrollableBox,
          )
        : listItemBox.localToGlobal(
            listItemBox.size.centerLeft(Offset.zero),
            ancestor: scrollableBox,
          );
    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction =
        (0.5 -
        ((axis == Axis.horizontal ? listItemOffset.dx : listItemOffset.dy) /
            viewportDimension));
    double visibility = 1.0 - scrollFraction.abs();
    double invisibility = 1.0 - visibility;
    context.paintChild(
      0,
      transform: Transform.translate(
        offset: Offset(
          axis == Axis.horizontal
              ? scrollFraction * (scrollableBox.size.width * parallaxIntensity)
              : 0.0,
          axis == Axis.vertical
              ? scrollFraction * (scrollableBox.size.width * parallaxIntensity)
              : 0.0,
        ),
      ).transform,
      opacity: (visibility * fadeIntensity) + (1.0 - fadeIntensity),
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}

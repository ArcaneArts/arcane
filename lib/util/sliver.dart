import 'package:arcane/arcane.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter_hooks/flutter_hooks.dart';

export 'package:sliver_tools/src/rendering/multi_sliver.dart';

class SnappingScrollNotificationHandler {
  final double expandedBarHeight;
  final double collapsedBarHeight;
  final double bottomBarHeight;
  final bool shouldAddHapticFeedback;

  SnappingScrollNotificationHandler({
    required this.expandedBarHeight,
    required this.collapsedBarHeight,
    this.bottomBarHeight = 0.0,
    this.shouldAddHapticFeedback = false,
  })  : assert(
          expandedBarHeight > 0.0,
          'Expanded Bar Height cannot be negative',
        ),
        assert(
          collapsedBarHeight > 0.0,
          'Collapsed bar height cannot have a negative value',
        ),
        assert(
          collapsedBarHeight < expandedBarHeight,
          'Expanded bar height value must have a higher value than the collapsed bar height value',
        );

  factory SnappingScrollNotificationHandler.withHapticFeedback({
    required double expandedBarHeight,
    required double collapsedBarHeight,
    double bottomBarHeight = 0.0,
  }) =>
      SnappingScrollNotificationHandler(
        expandedBarHeight: expandedBarHeight,
        collapsedBarHeight: collapsedBarHeight,
        shouldAddHapticFeedback: true,
        bottomBarHeight: bottomBarHeight,
      );

  /// Scrolling Notification listener
  ///
  /// triggers haptic feedback and snaps the appbar to either collapse or expand
  /// depending on which state is closest to the current scrolling offset
  bool handleScrollNotification({
    required ScrollNotification notification,
    required ScrollController scrollController,
    required ValueNotifier<bool> isCollapsedValueNotifier,
    CollapsingStateCallback? onCollapseStateChanged,
  }) {
    /// The position at which we either collapse or expand
    ///
    /// the threshold which if we exceed then we should expand
    /// otherwise we should collapse the appbar
    final double expandThresholdPosition =
        (expandedBarHeight - collapsedBarHeight) / 1.75;

    /// The current position of the scrolling
    final double currentScrollingPosition = scrollController.offset;

    /// sets the collapsed and expanded views as the user scrolls
    //region Update isCollapsed value as user scrolls
    _updateIsAppBarCollapsed(
      isCollapsed: isCollapsedValueNotifier,
      scrollController: scrollController,
      expandThresholdPosition: expandThresholdPosition,
      onCollapseStateChanged: onCollapseStateChanged,
    );
    //endregion

    //region
    if (notification is ScrollEndNotification) {
      _snapAppBar(
        currentScrollingPosition: currentScrollingPosition,
        expandThresholdPosition: expandThresholdPosition,
        scrollController: scrollController,
      );
    }
    //endregion

    return false;
  }

  /// Snaps the app bar to either fully expanded or fully collapsed position.
  void _snapAppBar({
    required double currentScrollingPosition,
    required double expandThresholdPosition,
    required ScrollController scrollController,
  }) {
    if (_shouldSnapAppBarFullyExpanded(
      currentScrollingPosition,
      expandThresholdPosition,
    )) {
      _scrollToOffset(scrollController: scrollController, scrollToOffset: 0.0);
    } else if (_shouldSnapAppBarFullyCollapsed(
      currentScrollingPosition,
      expandThresholdPosition,
    )) {
      _scrollToOffset(
        scrollController: scrollController,
        scrollToOffset:
            expandedBarHeight - collapsedBarHeight - bottomBarHeight,
      );
    }
  }

  /// Returns `true` if the app bar should snap to fully collapsed position.
  bool _shouldSnapAppBarFullyCollapsed(
    double currentScrollingPosition,
    double expandThresholdPosition,
  ) {
    return currentScrollingPosition > expandThresholdPosition &&
        currentScrollingPosition < expandedBarHeight - collapsedBarHeight;
  }

  /// Returns `true` if the app bar should snap to fully expanded position.
  bool _shouldSnapAppBarFullyExpanded(
    double currentScrollingPosition,
    double expandThresholdPosition,
  ) {
    return currentScrollingPosition < expandThresholdPosition;
  }

  /// Updates the isCollapsed value as the user scrolls up and down
  ///
  /// if the current offset is greater than the expandThresholdPosition
  /// then we set isCollapsed to true
  ///
  void _updateIsAppBarCollapsed({
    required ValueNotifier<bool> isCollapsed,
    required ScrollController scrollController,
    required double expandThresholdPosition,
    CollapsingStateCallback? onCollapseStateChanged,
  }) {
    isCollapsed.value = scrollController.hasClients &&
        scrollController.offset > expandThresholdPosition;
    onCollapseStateChanged?.call(
      isCollapsed.value,
      scrollController.offset,
      scrollController.position.maxScrollExtent,
    );
  }

  /// Scrolls to the calculated [scrollToOffset] from the previous step
  ///
  /// snaps the appbar to either collapse or expand depending on which
  /// state is closest to the current scrolling offset
  void _scrollToOffset({
    required ScrollController scrollController,
    required double scrollToOffset,
  }) {
    Future.microtask(
      () => scrollController.animateTo(
        scrollToOffset,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
      ),
    );
  }
}

/// Widget which is shown when the [SliverSnap] is expanded.
///
/// Helps in adding a leading widget only in the expanded state.
class ExpandedContent extends StatelessWidget {
  /// The child widget of the [ExpandedContent].
  ///
  final Widget? child;

  /// The leading widget of the [ExpandedContent].
  ///
  /// It is usually a [BackButton] or a [CloseButton].
  ///
  /// Use this only when you need a leading widget only in the expanded state.
  ///
  /// Take care when adding the [leading] widget both here and
  /// in the [SliverSnap] widget, as they might overlap.
  final Widget? leading;

  const ExpandedContent({
    super.key,
    this.child,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (child != null) child!,
        if (leading != null)
          SafeArea(
            child: leading!,
          ),
      ],
    );
  }
}

class SnappingAppBarBody extends StatelessWidget {
  const SnappingAppBarBody({
    super.key,
    required this.scrollController,
    required this.expandedContent,
    required this.collapsedBar,
    required this.collapsedBarHeight,
    required this.sliver,
    this.scrollBehavior,
    this.leading,
    this.floating = false,
    this.pinned = false,
    this.snap = false,
    this.stretch = false,
    this.backdropWidget,
    this.expandedContentHeight,
    this.collapsedBackgroundColor,
    this.expandedBackgroundColor,
    this.actions,
    this.bottom,
    this.isCollapsed = false,
    this.automaticallyImplyLeading = false,
    this.elevation = 0,
    this.forceElevated = false,
  });

  final ScrollController scrollController;

  final Widget expandedContent;
  final List<Widget>? actions;
  final Widget collapsedBar;
  final Widget sliver;
  final double? expandedContentHeight;
  final double collapsedBarHeight;
  final PreferredSizeWidget? bottom;
  final Widget? leading;
  final bool pinned;
  final bool floating;
  final bool snap;
  final bool stretch;
  final bool isCollapsed;
  final Widget? backdropWidget;
  final Color? collapsedBackgroundColor;
  final Color? expandedBackgroundColor;
  final ScrollBehavior? scrollBehavior;
  final bool automaticallyImplyLeading;
  final bool forceElevated;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (backdropWidget != null) backdropWidget!,
        CustomScrollView(
          controller: scrollController,
          scrollBehavior: scrollBehavior,
          slivers: [
            SliverAppBar(
              actions: actions,
              snap: snap,
              floating: floating,
              stretch: stretch,
              bottom: bottom,
              expandedHeight: expandedContentHeight,
              collapsedHeight: collapsedBarHeight,
              centerTitle: false,
              pinned: pinned,
              elevation: 0,
              forceElevated: forceElevated,
              surfaceTintColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              title: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isCollapsed ? 1 : 0,
                child: collapsedBar,
              ),
              leadingWidth: 0,
              automaticallyImplyLeading: false,
              leading: const SizedBox.shrink(),
              titleSpacing: 0,
              backgroundColor: isCollapsed
                  ? collapsedBackgroundColor
                  : expandedBackgroundColor,
              flexibleSpace: m.FlexibleSpaceBar(
                background: expandedContent,
              ),
            ),
            sliver,
          ],
        ),
      ],
    );
  }
}

typedef CollapsingStateCallback = void Function(
  bool isCollapsed,
  double scrollingOffset,
  double maxExtent,
);

class SliverSnap extends HookWidget {
  final ScrollController? scrollController;

  /// The content that is shown when the appBar is expanded
  ///
  /// (e.g. a movie poster and it's ratings)
  final Widget expandedContent;

  /// The collapsed appbar or content that is shown when state is collapsed
  ///
  /// (e.g. the title of the movie)
  final Widget collapsedContent;

  /// The content that is shown below the appbar
  final Widget sliver;

  /// The height of the [ExpandedContent]
  final double? expandedContentHeight;

  /// The height of the [collapsedContent]
  final double collapsedBarHeight;

  /// Whether the app bar should become visible as soon as the user scrolls
  /// towards the app bar.
  ///
  /// Otherwise, the user will need to scroll near the top of the scroll view to
  /// reveal the app bar.
  ///
  /// If [snap] is true then a scroll that exposes the app bar will trigger an
  /// animation that slides the entire app bar into view. Similarly if a scroll
  /// dismisses the app bar, the animation will slide it completely out of view.
  ///
  /// ## Animated Examples
  ///
  /// The following animations show how the app bar changes its scrolling
  /// behavior based on the value of this property.
  ///
  /// * App bar with [floating] set to false:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar.mp4}
  /// * App bar with [floating] set to true:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar_floating.mp4}
  ///
  /// See also:
  ///
  ///  * [SliverAppBar] for more animated examples of how this property changes the
  ///    behavior of the app bar in combination with [pinned] and [snap].
  final bool floating;

  /// Whether the appbar will be fixed at the top of the scroll view
  ///
  /// meaning it will always be visible to the user
  /// as they scroll through the content.
  ///
  /// Although the appbar can still change in size as the user scrolls,
  /// it will not be scrolled out of view like other elements in the scroll view.
  ///
  /// ## Animated Examples
  ///
  /// The following animations show how the app bar changes its scrolling
  /// behavior based on the value of this property.
  ///
  /// * App bar with [floating] set to false:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar.mp4}
  /// * App bar with [floating] set to true:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar_floating.mp4}
  ///
  /// See also:
  ///
  ///  * [SliverAppBar] for more animated examples of how this property changes the
  final bool pinned;

  /// Controls the behavior of a floating app bar when the user scrolls.
  ///
  /// When [snap] is false, the app bar will move smoothly with the content as the
  /// user scrolls, and will be dismissed smoothly when the user scrolls down.
  ///
  /// When [snap] is true, the app bar will have a more rigid behavior. It will
  /// snap into view when the user scrolls up and snap out of view when the user
  /// scrolls down. Additionally, when the user interacts with any part of the
  /// fully into view so that the user can see and interact with all of its
  /// contents.
  ///
  /// ## Animated Examples
  ///
  /// The following animations show how the app bar changes its scrolling
  /// behavior based on the value of this property.
  ///
  /// * App bar with [snap] set to false:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar_floating.mp4}
  /// * App bar with [snap] set to true:
  ///   {@animation 476 400 https://flutter.github.io/assets-for-api-docs/assets/material/app_bar_floating_snap.mp4}
  ///
  /// This property only applies to floating app bars.
  ///
  /// See also:
  ///
  ///  * [SliverAppBar], for more examples of how this property affects app bar
  ///    behavior in combination with [SliverAppBar.snap] and [SliverAppBar.floating].
  final bool snap;

  ///  Whether the app bar should stretch to fill the over-scroll area.
  ///
  ///  The appbar can still expand and contract as the user scrolls,
  ///  but it  will also stretch when the user over-scrolls.
  ///
  final bool stretch;

  /// A list of action widgets to display in a row,
  /// after the [collapsedContent] widget.
  ///
  final List<Widget>? actions;

  /// The leading widget at the start of the appbar,
  ///
  /// It can also be a [BackButton].
  ///
  final Widget? leading;

  /// Provides Control of the AppBar's leading widget.
  ///
  /// When set to true, the framework will automatically add a leading widget
  /// to the app bar or navigation bar. The widget will be either a [BackButton]
  /// (if the [Navigator] has more than one page in the stack) or a drawer
  ///
  /// When set to false, no leading widget will be added automatically.
  /// This is useful when you want to provide your own custom leading widget.
  final bool automaticallyImplyLeading;

  ///The content that is shown below the appbar.
  ///In most cases it's just the page content.
  ///
  final PreferredSizeWidget? bottom;

  /// The widget that is shown behind the [ExpandedContent]
  ///
  /// (e.g. a blurred image of the movie poster)
  final Widget? backdropWidget;

  /// The background color of the expanded appbar.
  final Color? expandedBackgroundColor;

  ///  The background color of the collapsed appbar.
  final Color? collapsedBackgroundColor;

  /// How the scrolling behaves, either Material or Cupertino.
  final ScrollBehavior? scrollBehavior;

  /// Callback that is called when the [ExpandedContent] is collapsed or expanded
  ///
  final CollapsingStateCallback? onCollapseStateChanged;

  /// The duration of the animation when the [ExpandedContent] is collapsing or expanding
  ///
  /// Defaults to [Duration(milliseconds: 300)]
  final Duration? animationDuration;

  /// The curve of the animation as the [ExpandedContent] is collapsing or expanding
  ///
  /// Defaults to [Curves.easeInOut]
  final Curve? animationCurve;

  /// Whether to show the shadow appropriate for the [elevation] even if the
  ///
  /// Defaults to false, meaning that the [elevation] is only applied when the
  ///
  /// When set to true, the [elevation] is applied regardless.
  ///
  /// Ignored when [elevation] is zero.
  final bool forceElevated;

  /// The elevation of the app bar.
  ///
  /// Defaults to `0.0`
  final double elevation;

  const SliverSnap({
    super.key,
    required this.expandedContent,
    required this.collapsedContent,
    required this.sliver,
    this.pinned = true,
    this.collapsedBarHeight = 60.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.snap = false,
    this.floating = false,
    this.stretch = false,
    this.expandedContentHeight,
    this.bottom,
    this.leading,
    this.actions,
    this.backdropWidget,
    this.expandedBackgroundColor,
    this.collapsedBackgroundColor,
    this.scrollController,
    this.scrollBehavior,
    this.onCollapseStateChanged,
    this.automaticallyImplyLeading = false,
    this.forceElevated = false,
    this.elevation = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final isCollapsedValueNotifier = useState(false);
    final defaultExpandedContentHeight =
        expandedContentHeight ?? MediaQuery.of(context).size.height / 2;

    final controller = scrollController ?? useScrollController();
    final snappingScrollNotificationHandler =
        SnappingScrollNotificationHandler.withHapticFeedback(
      expandedBarHeight: defaultExpandedContentHeight,
      collapsedBarHeight: collapsedBarHeight,
      bottomBarHeight: bottom?.preferredSize.height ?? 0.0,
    );
    final scrollPercentValueNotifier = useState(0.0);
    final animatedOpacity = useState(1.0);

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) =>
          snappingScrollNotificationHandler.handleScrollNotification(
        notification: notification,
        isCollapsedValueNotifier: isCollapsedValueNotifier,
        onCollapseStateChanged: (isCollapsed, scrollingOffset, maxExtent) {
          onCollapseStateChanged?.call(
            isCollapsedValueNotifier.value,
            controller.offset,
            controller.position.maxScrollExtent,
          );

          scrollPercentValueNotifier.value = 1 - scrollingOffset / maxExtent;
          animatedOpacity.value =
              _calculateOpacity(scrollPercentValueNotifier.value);
        },
        scrollController: controller,
      ),
      child: SnappingAppBarBody(
        scrollController: controller,
        backdropWidget: backdropWidget,
        collapsedBar:
            MediaQuery.removePadding(context: context, child: collapsedContent),
        bottom: bottom,
        expandedContent: MediaQuery.removePadding(
            context: context,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: animatedOpacity.value,
              child: expandedContent,
            )),
        leading: leading,
        actions: actions,
        pinned: pinned,
        floating: floating,
        snap: snap,
        stretch: stretch,
        automaticallyImplyLeading: automaticallyImplyLeading,
        sliver: sliver,
        scrollBehavior: scrollBehavior,
        collapsedBarHeight: collapsedBarHeight,
        expandedContentHeight: defaultExpandedContentHeight,
        collapsedBackgroundColor: collapsedBackgroundColor,
        expandedBackgroundColor: expandedBackgroundColor,
        isCollapsed: isCollapsedValueNotifier.value,
        forceElevated: forceElevated,
        elevation: elevation,
      ),
    );
  }

  /// Calculates the opacity based on the scroll percentage.
  ///
  /// The opacity is calculated as follows:
  /// - If the scroll percentage is less than [opacityThreshold],
  /// the opacity is 0.0.
  ///
  /// - If the scroll percentage is less than [maxScrollPercentage],
  /// the opacity is
  /// [scrollPercentage] minus [opacityAdjustment].
  ///
  /// - Otherwise, the opacity is [scrollPercentage].
  ///
  /// Returns 1.0 if the [scrollPercentage] is not between 0.0 and 1.0.
  ///
  /// Params:
  /// - [scrollPercentage] : the percentage of the scroll position, a double value
  /// Returns:
  /// - The calculated opacity, a double value
  double _calculateOpacity(double scrollPercentage) {
    const double opacityThreshold = 0.5;
    const double opacityAdjustment = 0.5;
    const double maxScrollPercentage = 1.0;

    if (scrollPercentage < 0 || scrollPercentage > maxScrollPercentage) {
      return 1.0;
    }

    if (scrollPercentage < opacityThreshold) {
      return 0.0;
    } else if (scrollPercentage < maxScrollPercentage) {
      return scrollPercentage - opacityAdjustment;
    } else {
      return scrollPercentage;
    }
  }
}

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) => localIndex;

/// [MultiSliver] allows for returning multiple slivers from a single build method
class MultiSliver extends MultiChildRenderObjectWidget {
  const MultiSliver({
    super.key,
    super.children = const [],
    this.pushPinnedChildren = false,
  });

  /// If true any children that paint beyond the layoutExtent of the entire [MultiSliver] will
  /// be pushed off towards the leading edge of the [Viewport]
  final bool pushPinnedChildren;

  @override
  RenderMultiSliver createRenderObject(BuildContext context) =>
      RenderMultiSliver(
        containing: pushPinnedChildren,
      );

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderMultiSliver renderObject) {
    renderObject.containing = pushPinnedChildren;
  }
}

class SGridView extends StatelessWidget {
  final List<Widget> children;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final int semanticIndexOffset;
  final SemanticIndexCallback semanticIndexCallback;
  final NullableIndexedWidgetBuilder? builder;
  final int? childCount;
  final ChildIndexGetter? findChildIndexCallback;
  final SliverGridDelegate? gridDelegate;
  final int? crossAxisCount;
  final double? maxCrossAxisExtent;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  const SGridView({
    super.key,
    this.children = const [],
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
    this.crossAxisCount,
    this.gridDelegate,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
    this.maxCrossAxisExtent,
  })  : builder = null,
        findChildIndexCallback = null,
        childCount = children.length;

  const SGridView.builder({
    super.key,
    required this.builder,
    this.crossAxisCount,
    this.gridDelegate,
    this.childCount,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
    this.findChildIndexCallback,
    this.maxCrossAxisExtent,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
  }) : children = const [];

  SliverChildDelegate get _delegate => builder != null
      ? SliverChildBuilderDelegate(
          builder!,
          childCount: childCount,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback,
          semanticIndexOffset: semanticIndexOffset,
          findChildIndexCallback: findChildIndexCallback,
        )
      : SliverChildListDelegate(
          children,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback,
          semanticIndexOffset: semanticIndexOffset,
        );

  SliverGridDelegate get _gridDelegate =>
      gridDelegate ??
      (maxCrossAxisExtent != null
          ? SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: maxCrossAxisExtent!,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              childAspectRatio: childAspectRatio,
            )
          : SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount ?? 4,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              childAspectRatio: childAspectRatio,
            ));

  @override
  Widget build(BuildContext context) => SliverGrid(
        delegate: _delegate,
        gridDelegate: _gridDelegate,
      );
}

class SListView extends StatelessWidget {
  final List<Widget> children;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final int semanticIndexOffset;
  final SemanticIndexCallback semanticIndexCallback;
  final NullableIndexedWidgetBuilder? builder;
  final int? childCount;
  final ChildIndexGetter? findChildIndexCallback;

  const SListView({
    super.key,
    this.children = const [],
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
  })  : builder = null,
        findChildIndexCallback = null,
        childCount = children.length;

  const SListView.builder({
    super.key,
    required this.builder,
    this.childCount,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
    this.findChildIndexCallback,
  }) : children = const [];

  SliverChildDelegate get _delegate => builder != null
      ? SliverChildBuilderDelegate(
          builder!,
          childCount: childCount,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback,
          semanticIndexOffset: semanticIndexOffset,
          findChildIndexCallback: findChildIndexCallback,
        )
      : SliverChildListDelegate(
          children,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback,
          semanticIndexOffset: semanticIndexOffset,
        );

  @override
  Widget build(BuildContext context) => SliverList(delegate: _delegate);
}

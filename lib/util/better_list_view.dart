import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef BLVItemBuilder<W extends Widget, E> = Widget Function(
    BuildContext context, int index);

typedef AnimatedWidgetBuilder<W extends Widget, E> = Widget Function(
    Widget child, Animation<double> animation);

typedef EqualityChecker<E> = bool Function(E, E);

class ConstrainedAnimatedReorderableListView<E extends Object>
    extends StatefulWidget {
  final List<E> items;
  final BLVItemBuilder<Widget, E> itemBuilder;
  final List<AnimationEffect>? enterTransition;
  final List<AnimationEffect>? exitTransition;
  final Duration? insertDuration;
  final Duration? removeDuration;
  final ReorderCallback onReorder;
  final void Function(int)? onReorderStart;
  final void Function(int)? onReorderEnd;
  final Axis scrollDirection;
  final ReorderItemProxyDecorator? proxyDecorator;
  final bool buildDefaultDragHandles;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollBehavior? scrollBehavior;
  final String? restorationId;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final Clip clipBehavior;
  final DragStartBehavior dragStartBehavior;
  final AnimatedWidgetBuilder? insertItemBuilder;
  final AnimatedWidgetBuilder? removeItemBuilder;

  @Deprecated("Use [dragStartDelay] instead.")
  final bool longPressDraggable;
  final bool shrinkWrap;
  final bool Function(E a, E b) isSameItem;
  final Duration dragStartDelay;
  final List<E> nonDraggableItems;
  final List<E> lockedItems;
  final bool enableSwap;

  const ConstrainedAnimatedReorderableListView({
    Key? key,
    required this.items,
    required this.itemBuilder,
    required this.onReorder,
    this.enterTransition,
    this.exitTransition,
    this.insertDuration,
    this.removeDuration,
    this.onReorderStart,
    this.onReorderEnd,
    this.proxyDecorator,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.scrollBehavior,
    this.restorationId,
    this.buildDefaultDragHandles = true,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.insertItemBuilder,
    this.removeItemBuilder,
    this.longPressDraggable = true,
    this.shrinkWrap = false,
    required this.isSameItem,
    this.dragStartDelay = const Duration(milliseconds: 500),
    this.nonDraggableItems = const [],
    this.lockedItems = const [],
    this.enableSwap = true,
  }) : super(key: key);

  static ConstrainedAnimatedReorderableListViewState of(BuildContext context) {
    final ConstrainedAnimatedReorderableListViewState? result = context
        .findAncestorStateOfType<ConstrainedAnimatedReorderableListViewState>();
    assert(() {
      if (result == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
            'AnimatedReorderableListViewState.of() called with a context that does not contain a AnimatedReorderableListViewState.',
          ),
          ErrorDescription(
            'No AnimatedReorderableListViewState ancestor could be found starting from the context that was passed to AnimatedReorderableListViewState.of().',
          ),
          ErrorHint(
            'This can happen when the context provided is from the same StatefulWidget that '
            'built the AnimatedReorderableListViewState. ',
          ),
          context.describeElement('The context used was'),
        ]);
      }
      return true;
    }());
    return result!;
  }

  static ConstrainedAnimatedReorderableListViewState? maybeOf(
    BuildContext context,
  ) {
    return context
        .findAncestorStateOfType<ConstrainedAnimatedReorderableListViewState>();
  }

  @override
  State<ConstrainedAnimatedReorderableListView<E>> createState() =>
      ConstrainedAnimatedReorderableListViewState();
}

class ConstrainedAnimatedReorderableListViewState<E extends Object>
    extends State<ConstrainedAnimatedReorderableListView<E>> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      hitTestBehavior: HitTestBehavior.deferToChild,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      primary: widget.primary,
      physics: widget.physics,
      scrollBehavior: widget.scrollBehavior,
      restorationId: widget.restorationId,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      dragStartBehavior: widget.dragStartBehavior,
      clipBehavior: widget.clipBehavior,
      shrinkWrap: widget.shrinkWrap,
      slivers: [
        SliverPadding(
          padding: widget.padding ?? EdgeInsets.zero,
          sliver: ReorderableAnimatedListImpl(
            items: widget.items,
            itemBuilder: widget.itemBuilder,
            enterTransition: widget.enterTransition,
            exitTransition: widget.exitTransition,
            insertDuration: widget.insertDuration,
            removeDuration: widget.removeDuration,
            onReorder: widget.onReorder,
            onReorderStart: widget.onReorderStart,
            onReorderEnd: widget.onReorderEnd,
            proxyDecorator: widget.proxyDecorator,
            buildDefaultDragHandles: widget.buildDefaultDragHandles,
            scrollDirection: widget.scrollDirection,
            insertItemBuilder: widget.insertItemBuilder,
            removeItemBuilder: widget.removeItemBuilder,
            longPressDraggable: widget.longPressDraggable,
            isSameItem: widget.isSameItem,
            dragStartDelay: widget.dragStartDelay,
            nonDraggableItems: widget.nonDraggableItems,
            lockedItems: widget.lockedItems,
            enableSwap: widget.enableSwap,
          ),
        ),
      ],
    );
  }
}

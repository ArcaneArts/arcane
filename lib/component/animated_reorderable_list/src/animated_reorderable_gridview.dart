import 'package:arcane/component/animated_reorderable_list/animated_reorderable_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import 'builder/reorderable_animated_list_base.dart';
import 'builder/reorderable_animated_list_impl.dart';

/// @docImport 'animated_reorderable_listview';

///A GridView that enables users to interactively reorder items through dragging, with animated insertion and removal of items.
///  ```dart
///  enterTransition: [FadeIn(), ScaleIn()],
///  ```
///
/// Effects are always run in parallel (ie. the fade and scale effects in the
/// example above would be run simultaneously), but you can apply delays to
/// offset them or run them in sequence.
///
/// The [onReorder] parameter is required and will be called when a child
/// widget is dragged to a new position.
///
/// All list items must have a key.
///
/// While a drag is underway, the widget returned by the [AnimatedReorderableListView.proxyDecorator]
/// callback serves as a "proxy" (a substitute) for the item in the list. The proxy is
/// created with the original list item as its child.
///
class AnimatedReorderableGridView<E extends Object> extends StatefulWidget {
  /// The current list of items that this[AnimatedReorderableGridView] should represent.
  final List<E> items;

  /// Called, as needed, to build list item widgets.
  ///
  /// List items are only built when they're scrolled into view.
  ///
  /// The [ItemBuilder] index parameter indicates the item's
  /// position in the list. The value of the index parameter will be between
  /// zero and one less than [items]. All items in the list must have a
  /// unique [Key].
  final ItemBuilder<Widget, E> itemBuilder;

  /// Controls the layout of tiles in a grid.
  /// Given the current constraints on the grid,
  /// a SliverGridDelegate computes the layout for the tiles in the grid.
  /// The tiles can be placed arbitrarily,
  /// but it is more efficient to place tiles in roughly in order by scroll offset because grids reify a contiguous sequence of children.
  final SliverGridDelegate sliverGridDelegate;

  /// A list of [AnimationEffect](s) used for the appearing animation when an item is added to the list.
  ///
  /// This property controls how newly added items animate into view. The animations in this list
  /// will run sequentially, meaning each effect will be applied one after another in the order
  /// specified. By default, this property uses a single [FadeIn()] effect.
  ///
  /// ### Default Value
  /// If not explicitly provided, the default animation applied is:
  /// ```dart
  /// [FadeIn()]
  /// ```
  ///
  /// ### Supported Animations
  /// The following animation effects are supported by the library and can be combined as desired:
  /// - `FadeIn()`: A smooth fade-in animation.
  /// - `FlipInY()`: An animation that flips the item along the Y-axis.
  /// - `FlipInX()`: An animation that flips the item along the X-axis.
  /// - `Landing()`: An animation that mimics a landing effect.
  /// - `SizeAnimation()`: Gradually animates the size of the item.
  /// - `ScaleIn()`: A scaling animation where the item grows into view.
  /// - `ScaleInTop()`: A scaling effect originating from the top.
  /// - `ScaleInBottom()`: A scaling effect originating from the bottom.
  /// - `ScaleInLeft()`: A scaling effect originating from the left.
  /// - `ScaleInRight()`: A scaling effect originating from the right.
  /// - `SlideInLeft()`: A sliding animation from the left.
  /// - `SlideInRight()`: A sliding animation from the right.
  /// - `SlideInUp()`: A sliding animation from the bottom to the top.
  /// - `SlideInDown()`: A sliding animation from the top to the bottom.
  ///
  /// ### Custom Animations
  /// In addition to the predefined animations listed above, you can create custom configurations
  /// for each animation to suit your specific needs. For example, you can adjust the duration,
  /// curve, or other parameters for finer control:
  /// ```dart
  /// enterTransition: [
  ///   FadeIn(duration: Duration(milliseconds: 500), curve: Curves.easeIn),
  ///   SlideInLeft(delay: Duration(milliseconds: 200)),
  /// ],
  /// ```
  ///
  final List<AnimationEffect>? enterTransition;

  /// A list of [AnimationEffect](s) used for the disappearing animation when an item was removed from the list.
  ///
  /// This property controls how item will be removed from the view. The animations in this list
  /// will run sequentially, meaning each effect will be applied one after another in the order
  /// specified. By default, this property uses a single [FadeIn()] effect.
  ///
  /// ### Default Value
  /// If not explicitly provided, the default animation applied is:
  /// ```dart
  /// [FadeIn()]
  /// ```
  ///
  /// ### Supported Animations
  /// The following animation effects are supported by the library and can be combined as desired:
  /// - `FadeIn()`: A smooth fade-in animation.
  /// - `FlipInY()`: An animation that flips the item along the Y-axis.
  /// - `FlipInX()`: An animation that flips the item along the X-axis.
  /// - `Landing()`: An animation that mimics a landing effect.
  /// - `SizeAnimation()`: Gradually animates the size of the item.
  /// - `ScaleIn()`: A scaling animation where the item grows into view.
  /// - `ScaleInTop()`: A scaling effect originating from the top.
  /// - `ScaleInBottom()`: A scaling effect originating from the bottom.
  /// - `ScaleInLeft()`: A scaling effect originating from the left.
  /// - `ScaleInRight()`: A scaling effect originating from the right.
  /// - `SlideInLeft()`: A sliding animation from the left.
  /// - `SlideInRight()`: A sliding animation from the right.
  /// - `SlideInUp()`: A sliding animation from the bottom to the top.
  /// - `SlideInDown()`: A sliding animation from the top to the bottom.
  ///
  /// ### Custom Animations
  /// In addition to the predefined animations listed above, you can create custom configurations
  /// for each animation to suit your specific needs. For example, you can adjust the duration,
  /// curve, or other parameters for finer control:
  /// ```dart
  /// exitTransition: [
  ///   FadeIn(duration: Duration(milliseconds: 500), curve: Curves.easeIn),
  ///   SlideInLeft(delay: Duration(milliseconds: 200)),
  /// ],
  /// ```
  ///
  final List<AnimationEffect>? exitTransition;

  /// The duration of the animation when an item is inserted into the list.
  ///
  /// This property defines the default duration for all animations applied to items
  /// when they are added to the list. If you provide a specific duration for each
  /// [AnimationEffect] in the `enterTransition` list, the [insertDuration]
  /// override the durations of all animations in the [enterTransition].
  ///
  /// **Usage:**
  /// - If `insertDuration` is provided, it will override all durations specified
  ///   in the [enterTransition] list.
  /// - If `insertDuration` is not provided, the individual durations defined
  ///   in [enterTransition] will be used instead.
  /// - If neither `insertDuration` nor individual durations are specified, a default
  ///   duration (e.g., `const Duration(milliseconds: 300)`) will be used.
  ///
  /// **Example:**
  /// ```dart
  /// AnimatedReorderableGridView(
  ///   insertDuration: Duration(milliseconds: 500), // Default duration for item insertions.
  ///   enterTransition: [
  ///     FadeIn(duration: Duration(milliseconds: 300)), // Overrides the default for this effect.
  ///     SlideInLeft(), // Will use the default duration from `insertDuration`.
  ///   ],
  /// );
  /// ```
  /// insertDuration
  final Duration? insertDuration;

  /// The duration of the animation when an item is removed from the list.
  ///
  /// This property defines the default duration for all animations applied to items
  /// when they are removed from the list. If you provide a specific duration for each
  /// [AnimationEffect] in the `exitTransition` list, the [removeDuration]
  /// override the durations of all animations in the [exitTransition].
  ///
  /// **Usage:**
  /// - If `removeDuration` is specified, it will be applied as the default duration
  ///   for the removal animation of items.
  /// - If specific durations are provided for individual `AnimationEffect`s, they take precedence.
  /// - If neither `removeDuration` nor individual durations are specified, a default
  ///   duration (e.g., `const Duration(milliseconds: 300)`) may be used.
  ///
  /// **Example:**
  /// ```dart
  /// AnimatedReorderableGridView(
  ///   removeDuration: Duration(milliseconds: 400), // Default duration for item removals.
  ///   exitTransition: [
  ///     FadeOut(duration: Duration(milliseconds: 200)), // Overrides the default for this effect.
  ///     SlideOutRight(), // Will use the default duration from `removeDuration`.
  ///   ],
  /// );
  /// ```
  /// `removeDuration` is overridden by the duration specified in the `exitTransition`.
  final Duration? removeDuration;

  /// A callback used by [AnimatedReorderableGridView] to report that a list item has moved
  /// to a new position in the list.
  ///
  /// Implementations should remove the corresponding list item at `oldIndex`
  /// and reinsert it at `newIndex`.
  final ReorderCallback onReorder;

  /// A callback that is called when an item drag has started.
  ///
  /// The index parameter of the callback is the index of the selected item.
  final void Function(int)? onReorderStart;

  /// A callback that is called when the dragged item is dropped.
  ///
  /// The index parameter of the callback is the index where the item is
  /// dropped. Unlike [onReorder], this is called even when the list item is
  /// dropped in the same location.
  final void Function(int)? onReorderEnd;

  /// {@template flutter.widgets.reorderable_list.proxyDecorator}
  /// A callback that allows the app to add an animated decoration around
  /// an item when it is being dragged.
  /// {@endtemplate}
  final ReorderItemProxyDecorator? proxyDecorator;

  /// The axis along which the scroll view scrolls.
  ///
  /// Defaults to [Axis.vertical].
  final Axis scrollDirection;

  /// {@macro flutter.widgets.scroll_view.reverse}
  final bool reverse;

  /// [ScrollController] to get the current scroll position.
  ///
  ///  Must be null if [primary] is true.
  ///
  ///  It can be used to read the current
  //   scroll position (see [ScrollController.offset]), or change it (see
  //   [ScrollController.animateTo]).
  final ScrollController? controller;

  /// When this is true, the scroll view is scrollable even if it does not have
  /// sufficient content to actually scroll. Otherwise, by default the user can
  /// only scroll the view if it has sufficient content. See [physics].
  ///
  /// Cannot be true while a [ScrollController] is provided to `controller`,
  /// only one ScrollController can be associated with a ScrollView.
  ///
  /// Defaults to null.
  final bool? primary;

  /// {@template flutter.widgets.reorderable_list.padding}
  /// The amount of space by which to inset the list contents.
  ///
  /// It defaults to `EdgeInsets.all(0)`.
  /// {@endtemplate}
  final EdgeInsetsGeometry? padding;

  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions. Furthermore, if [primary] is
  /// false, then the user cannot scroll if there is insufficient content to
  /// scroll, while if [primary] is true, they can always attempt to scroll.
  final ScrollPhysics? physics;

  /// [ScrollBehavior]s also provide [ScrollPhysics]. If an explicit
  /// [ScrollPhysics] is provided in [physics], it will take precedence,
  /// followed by [scrollBehavior], and then the inherited ancestor
  /// [ScrollBehavior].
  final ScrollBehavior? scrollBehavior;

  /// Creates a ScrollView that creates custom scroll effects using slivers.
  /// See the ScrollView constructor for more details on these arguments.
  final String? restorationId;

  /// [ScrollViewKeyboardDismissBehavior] the defines how this [ScrollView] will
  /// dismiss the keyboard automatically.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// Defaults to [Clip.hardEdge].
  ///
  /// Creates a ScrollView that creates custom scroll effects using slivers.
  /// See the ScrollView constructor for more details on these arguments.
  final Clip clipBehavior;

  /// Creates a ScrollView that creates custom scroll effects using slivers.
  /// See the ScrollView constructor for more details on these arguments.
  final DragStartBehavior dragStartBehavior;

  /// A custom builder that is for adding items with animations.
  ///
  /// The child argument is the widget that is returned by [itemBuilder],
  ///  and the `animation` is an [Animation] that should be used to animate an enter
  /// transition for the widget that is built.
  ///
  /// If specified, the [enterTransition] will be ignored.
  final AnimatedWidgetBuilder? insertItemBuilder;

  /// A custom builder that is for removing items with animations.
  ///
  /// The child argument is the widget that is returned by [itemBuilder],
  ///  and the `animation` is an [Animation] that should be used to animate an exit
  /// transition for the widget that is built.
  ///
  /// If specified, the [exitTransition] will be ignored.
  final AnimatedWidgetBuilder? removeItemBuilder;

  @Deprecated("Use [dragStartDelay] instead.")

  /// Set [dragStartDelay] to [Duration.zero] to start the drag operation immediately.
  final bool longPressDraggable;

  /// Whether the extent of the scroll view in the scrollDirection should be determined by the contents being viewed.
  final bool shrinkWrap;

  /// A callback function to determine if two items in the list are considered the same.
  ///
  /// This function is important to prevent unnecessary animations when editing or updating items.
  /// For example, if your items have a unique `id`, you can use this function to compare them
  /// and return `true`, indicating they represent the same item.
  ///
  ///
  /// **Why is this important?**
  ///
  /// If `isSameItem` is not defined and you are working with immutable objects (e.g., creating new
  /// instances on every update), the library may interpret these as different items. This will
  /// trigger animations unnecessarily. Additionally, if you are generating `Key` values directly
  /// from these instances, it can result in the following exception:
  ///
  /// `Multiple widgets used the same GlobalKey.`
  ///
  /// To avoid this exception, you must implement the `isSameItem` callback to accurately compare
  /// the identity of the items in your list.
  ///
  /// Example:
  /// ```dart
  /// isSameItem: (a, b) => a.id == b.id,
  /// ```
  final bool Function(E a, E b) isSameItem;

  /// The amount of time to wait before starting the drag operation.
  ///
  /// Set to [Duration.zero] to start the drag operation immediately.
  final Duration dragStartDelay;

  /// A list of items that are not draggable.
  ///
  /// The item can't be draggable, but it can be reordered.
  final List<E> nonDraggableItems;

  /// A list of items that are locked and can't be reordered.
  final List<E> lockedItems;

  /// Whether to enable swap animation when changing the order of the items.
  ///
  /// Defaults to true.
  final bool enableSwap;

  /// Creates a [AnimatedReorderableGridView] that enables users to interactively reorder items through dragging,
  /// with animated insertion and removal of items.
  const AnimatedReorderableGridView(
      {Key? key,
      required this.items,
      required this.itemBuilder,
      required this.sliverGridDelegate,
      required this.onReorder,
      this.enterTransition,
      this.exitTransition,
      this.insertDuration,
      this.removeDuration,
      this.onReorderStart,
      this.onReorderEnd,
      this.proxyDecorator,
      this.padding,
      this.scrollDirection = Axis.vertical,
      this.reverse = false,
      this.controller,
      this.primary,
      this.physics,
      this.scrollBehavior,
      this.restorationId,
      this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
      this.dragStartBehavior = DragStartBehavior.start,
      this.clipBehavior = Clip.hardEdge,
      this.longPressDraggable = true,
      this.shrinkWrap = false,
      this.insertItemBuilder,
      this.removeItemBuilder,
      required this.isSameItem,
      this.dragStartDelay = const Duration(milliseconds: 500),
      this.nonDraggableItems = const [],
      this.lockedItems = const [],
      this.enableSwap = true})
      : super(key: key);

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// If no [AnimatedReorderableGridViewState] surrounds the given context, then this function
  /// will assert in debug mode and throw an exception in release mode.
  ///
  /// This method can be expensive (it walks the element tree).
  static AnimatedReorderableGridViewState of(BuildContext context) {
    final AnimatedReorderableGridViewState? result =
        context.findAncestorStateOfType<AnimatedReorderableGridViewState>();
    assert(() {
      if (result == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'AnimatedReorderableGridViewState.of() called with a context that does not contain a AnimatedReorderableGridViewState.'),
          ErrorDescription(
            'No AnimatedReorderableGridViewState ancestor could be found starting from the context that was passed to AnimatedReorderableGridViewState.of().',
          ),
          ErrorHint(
              'This can happen when the context provided is from the same StatefulWidget that '
              'built the AnimatedReorderableGridViewState. '),
          context.describeElement('The context used was'),
        ]);
      }
      return true;
    }());
    return result!;
  }

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// This method is typically used by [AnimatedReorderableGridViewState] item widgets that insert
  /// or remove items in response to user input.
  ///
  /// If no [AnimatedReorderableGridViewState] surrounds the context given, then this function will
  /// return null.
  ///
  /// This method can be expensive (it walks the element tree).
  static AnimatedReorderableGridViewState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<AnimatedReorderableGridViewState>();
  }

  @override
  State<AnimatedReorderableGridView<E>> createState() =>
      AnimatedReorderableGridViewState();
}

class AnimatedReorderableGridViewState<E extends Object>
    extends State<AnimatedReorderableGridView<E>> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
            sliver: ReorderableAnimatedListImpl.grid(
              items: widget.items,
              itemBuilder: widget.itemBuilder,
              sliverGridDelegate: widget.sliverGridDelegate,
              insertDuration: widget.insertDuration,
              removeDuration: widget.removeDuration,
              enterTransition: widget.enterTransition,
              exitTransition: widget.exitTransition,
              onReorder: widget.onReorder,
              onReorderStart: widget.onReorderStart,
              onReorderEnd: widget.onReorderEnd,
              proxyDecorator: widget.proxyDecorator,
              scrollDirection: widget.scrollDirection,
              insertItemBuilder: widget.insertItemBuilder,
              removeItemBuilder: widget.removeItemBuilder,
              //ignore: deprecated_member_use_from_same_package
              longPressDraggable: widget.longPressDraggable,
              isSameItem: widget.isSameItem,
              dragStartDelay: widget.dragStartDelay,
              nonDraggableItems: widget.nonDraggableItems,
              lockedItems: widget.lockedItems,
              enableSwap: widget.enableSwap,
            ),
          ),
        ]);
  }
}

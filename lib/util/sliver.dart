import 'package:arcane/arcane.dart';
import 'package:fast_log/fast_log.dart';
import 'package:flutter/rendering.dart';

export 'package:sliver_tools/src/rendering/multi_sliver.dart';

typedef SliverFill = SliverFillRemainingBoxAdapter;

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
  Widget build(BuildContext context) =>
      SliverGrid(delegate: _delegate, gridDelegate: _gridDelegate);
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

class MagicBox extends StatelessWidget {
  final Widget child;

  const MagicBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) => MultiSliver(
        children: [
          child.isSliver(context)
              ? child
              : SliverFillRemainingBoxAdapter(child: child),
        ],
      );
}

bool _sliverInspectionActive = false;
bool get isSliverInspectionActive => _sliverInspectionActive;

extension XSliverWidget on Widget {
  Widget toBox(BuildContext context, {bool softWarn = true}) {
    if (isSliver(context)) {
      warn(
          "$runtimeType is a sliver in a box context, wrapping in a shrink-wrapped CustomScrollView");
      return CustomScrollView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        slivers: [this],
      );
    }
    return this;
  }

  Widget toSliver(BuildContext context,
      {bool fillRemaining = false, bool softWarn = true}) {
    if (isSliver(context)) {
      return this;
    }

    warn(
        "$runtimeType is not a sliver in a sliver context, wrapping in a ${fillRemaining ? "SliverFillRemainingBoxAdapter" : "SliverToBoxAdapter"}");
    return fillRemaining
        ? SliverFillRemainingBoxAdapter(child: this)
        : SliverToBoxAdapter(child: this);
  }

  bool isSliver(BuildContext context) => switch (this) {
        Text() ||
        Container() ||
        Padding() ||
        Align() ||
        Center() ||
        Column() ||
        Row() ||
        Stack() ||
        Positioned() ||
        Expanded() ||
        SizedBox() ||
        Spacer() ||
        AnimatedOpacity() ||
        BoxSignal() ||
        ListView() ||
        GridView() ||
        SingleChildScrollView() ||
        Scrollable() ||
        FlutterLogo() ||
        Bar() ||
        AppBar() ||
        ListTile() ||
        Card() ||
        BasicCard() ||
        TextField() ||
        TextArea() ||
        Button() ||
        OutlineButton() ||
        OutlineButtonMenu() ||
        PrimaryButton() ||
        PrimaryButtonMenu() ||
        SecondaryButton() ||
        SecondaryButtonMenu() ||
        GhostButton() ||
        GhostButtonMenu() ||
        TextButton() ||
        TextButtonMenu() ||
        IconButtonMenu() ||
        IconButton() ||
        Skeletonizer() ||
        AnimatedContainer() =>
          false,
        BarSection() ||
        ExpansionBarSection() ||
        GlassSection() ||
        SliverSignal() ||
        SliverList() ||
        SliverPadding() ||
        SliverToBoxAdapter() ||
        SliverFillRemainingBoxAdapter() ||
        SliverFillRemaining() ||
        SliverGrid() ||
        SListView() ||
        SGridView() ||
        SliverGutter() =>
          true,
        _ => _isSliverDeep(context)
      };

  bool? _isImmediateSliver(BuildContext context) {
    if (this is SliverSignal) {
      return true;
    }

    if (this is BoxSignal) {
      return false;
    }

    if (this is RenderObjectWidget) {
      RenderObjectWidget r = this as RenderObjectWidget;
      dynamic ro = r.createRenderObject(context);
      if (ro is RenderSliver) {
        return true;
      } else if (ro is RenderBox) {
        return false;
      }

      warn(
          "Unable to determine if $runtimeType is a sliver or not because it's render object is a ${ro.runtimeType} which is neither a RenderSliver nor a RenderBox");
      return null;
    }

    return null;
  }

  bool _isSliverDeep(BuildContext context) {
    bool? iss = _isImmediateSliver(context);

    if (iss != null) {
      return iss;
    }

    try {
      if (this is StatelessWidget) {
        if ((this as StatelessWidget).build(context).isSliver(context)) {
          return true;
        }
      }

      if (this is StatefulWidget) {
        StatefulElement element = StatefulElement(this as StatefulWidget);
        Widget w = element.state.build(context);
        if (w.isSliver(context)) {
          return true;
        }
      }
    } catch (e, es) {
      error("Failed to check sliver of $runtimeType with error: $e. $es");
    }

    return false;
  }
}

mixin SliverSignal {}
mixin BoxSignal {}

class TrustSliver extends StatelessWidget with SliverSignal {
  final Widget child;

  const TrustSliver(this.child, {super.key});

  @override
  Widget build(BuildContext context) => child;
}

class TrustBox extends StatelessWidget with BoxSignal {
  final Widget child;

  const TrustBox(this.child, {super.key});

  @override
  Widget build(BuildContext context) => child;
}

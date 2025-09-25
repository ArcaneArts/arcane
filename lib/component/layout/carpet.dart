import 'dart:convert';
import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:crypto/crypto.dart';
import 'package:fast_log/fast_log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:measure_size/measure_size.dart';

/// A type alias for a function that calculates the carpet width based on the build context.
///
/// This callback is used by [CarpetStyle] to dynamically determine the number of columns (tiles) across the screen width, enabling responsive layouts in the Arcane UI system. It integrates with [MediaQuery] for device-aware computations, such as dividing screen width by a target tile size.
typedef CarpetWidthCalculator = int Function(BuildContext context);

/// A private helper function creating a [CarpetWidthCalculator] for fixed target cell sizes.
///
/// Returns a calculator that divides the screen width by the specified target size to determine column count. Used internally by [CarpetStyle.targetCellSize] for mosaic or grid-like layouts in [Carpet] widgets.
CarpetWidthCalculator _targetSizeCarpetWidthCalculator(int targetSize) =>
    (context) => MediaQuery.of(context).size.width ~/ targetSize;

/// The default [CarpetWidthCalculator] dividing screen width by approximately 250 pixels.
///
/// Provides a baseline responsive column count for [Carpet] layouts, balancing tile density on various devices. Integrated as the default in [CarpetStyle] for general-purpose tiling without explicit configuration.
int _defaultCarpetWidthCalc(BuildContext context) =>
    MediaQuery.of(context).size.width ~/ 250;

/// A utility class providing predefined and composite [CarpetStyle] configurations for responsive layouts in the Arcane UI system.
///
/// This class offers static methods to generate styles tailored for different screen sizes and layout needs, such as strips, tapes, lists, grids, and mosaics. It integrates with [Carpet] and [CarpetStyle] to enable dynamic, adaptive tiling of content tiles based on device width and content aspect ratios. Use [CarpetStyles.composite] for breakpoint-based style switching, ensuring seamless transitions across devices in conjunction with [ArcaneTheme].
class CarpetStyles {
  const CarpetStyles._();

  /// Creates a composite [CarpetStyle] by selecting from a map of breakpoint-based styles.
  ///
  /// The map keys represent maximum widths (in device pixels) for each style function. Styles are evaluated in ascending order of breakpoints, falling back to the last entry for larger screens. This method is ideal for responsive designs where layout complexity varies by screen size, integrating with [Carpet] for adaptive quilt generation.
  ///
  /// Example usage in a [Carpet] widget:
  /// ```dart
  /// CarpetStyle style = CarpetStyles.composite(context, {
  ///   600: (ctx) => CarpetStyles.strip(ctx),
  ///   1200: (ctx) => CarpetStyles.grid(ctx),
  /// });
  /// ```
  static CarpetStyle composite(BuildContext context,
      Map<double, CarpetStyle Function(BuildContext)> styles) {
    double width = MediaQuery.of(context).size.width;

    for (var entry in styles.entries) {
      if (width <= entry.key) {
        return entry.value(context);
      }
    }

    return styles.values.last(context);
  }

  /// Generates a strip-style [CarpetStyle] for linear, horizontal layouts.
  ///
  /// This style configures a wide-aspect list view suitable for feed-like displays, with adjustable quilt height multipliers for vertical spacing. It sets fixed tile dimensions to enforce a tape-like flow, integrating with [Carpet] for simple, non-grid content presentation. Use for narrow content strips in [Section] or [Refresher]-wrapped views.
  static CarpetStyle strip(BuildContext context,
      {int quiltHeightMultiplier = 1}) {
    return CarpetStyle()
        .listView(
          aspect: 10,
          quiltHeightMultiplier: 20 * quiltHeightMultiplier,
        )
        .copyWith(maxTileHeight: 20);
  }

  /// Generates a tape-style [CarpetStyle] for granular, horizontal scrolling layouts.
  ///
  /// Configures narrow, high-granularity tiles for tape-like feeds, scaling with device width and adjustable multipliers. Integrates with [Carpet] for dynamic content placement, allowing holes for irregular spacing. Ideal for timeline or news ticker views within [MagicCarpet] or [Refresher] components.
  static CarpetStyle tape(BuildContext context,
      {double scale = 1, int quiltHeightMultiplier = 1}) {
    double width = MediaQuery.of(context).size.width;

    double wSize = width / 2000;
    scale *= 1.2;

    return CarpetStyle().tapeView(
        granularity:
            min((50 * scale).round(), max((50 * scale * wSize).round(), 1)),
        height: min((8 / scale).round(),
            max(((8 / scale) * pow(wSize, 0.4)).round(), 1)),
        quiltMultiplier: quiltHeightMultiplier);
  }

  /// Generates a list-style [CarpetStyle] for vertical, card-like layouts.
  ///
  /// Creates a responsive list view with aspect-ratio-based tile widths, scaling for device size. Used with [Carpet] for stacked content displays, suitable for article lists or feeds in [Section] containers, integrating with [ArcaneTheme] for consistent spacing.
  static CarpetStyle list(BuildContext context,
      {double scale = 1, int quiltHeightMultiplier = 1}) {
    double width = MediaQuery.of(context).size.width;
    double wSize = width / 2000;
    scale = scale * 0.8;

    return CarpetStyle().listView(
        quiltHeightMultiplier: quiltHeightMultiplier,
        aspect: max(
            1,
            min(((10 / scale) * pow(wSize, 0.8)).round(),
                (10 / scale).ceil())));
  }

  /// Generates a grid-style [CarpetStyle] for uniform, multi-cell layouts.
  ///
  /// Configures fixed cell dimensions across width and height, with responsive tile sizing based on screen width. Integrates with [Carpet] for gallery or dashboard views, disabling scalar tiles for strict grid alignment. Use in [CardSection] or [Tabs] for structured content presentation.
  static CarpetStyle grid(BuildContext context,
      {double size = 250,
      int wCells = 1,
      int hCells = 1,
      int quiltHeightMultiplier = 1}) {
    return CarpetStyle().gridView(
        tileSize: ((size * pow(MediaQuery.of(context).size.width / 2000, 0.2)) /
                wCells)
            .round(),
        height: hCells,
        quiltHeightMultiplier: quiltHeightMultiplier,
        width: wCells);
  }

  /// Generates a mosaic-style [CarpetStyle] for irregular, aspect-preserving layouts.
  ///
  /// Targets a specific cell size for non-scalar tiles, creating a masonry-like grid that respects content proportions. Used with [Carpet] for photo galleries or variable-height feeds, integrating with [Refresher] for dynamic loading in [MagicCarpet] implementations.
  static CarpetStyle mosaic(BuildContext context, {double size = 250}) =>
      CarpetStyle(allowScalarTiles: false).targetCellSize(
          (size * pow(MediaQuery.of(context).size.width / 2000, 0.6)).round());
}

/// The core configuration class for [Carpet] layouts, defining tiling rules and responsive behaviors.
///
/// [CarpetStyle] encapsulates parameters for quilt generation, including column counts, tile dimensions, spacing, and loading thresholds. It supports computed styles via [compute] for context-aware adjustments and fluent builders like [listView] for predefined layouts. Integrates with [Carpet] and [QuiltFaucet] to produce adaptive, performant tile arrangements in the Arcane UI system, compatible with [ArcaneTheme] and [Refresher] for smooth scrolling experiences.
class CarpetStyle {
  final CarpetWidthCalculator carpetWidthCalc;
  final int maxQuiltHeight;
  final int maxSizeOptions;
  final int maxTileHeight;
  final int maxTileWidth;
  final int carpetWidth;
  final double spacing;
  final bool allowFutureFeeding;
  final bool allowPastFeeding;
  final bool includeHorizontalPadding;
  final Duration loadMoreCooldown;
  final int unseenQuiltTarget;
  final bool allowScalarTiles;
  final int minTileWidth;
  final int minTileHeight;
  final bool allowHoles;
  final double unknownExtentOfScreenMultiplier;

  /// Constructs a [CarpetStyle] with customizable tiling parameters.
  ///
  /// Initializes defaults for responsive layouts, allowing overrides for specific use cases like grids or lists. The [carpetWidthCalc] enables dynamic column computation, while thresholds like [unseenQuiltTarget] control prefetching in [Carpet] widgets. Use with [CarpetStyles] for predefined configurations.
  const CarpetStyle(
      {this.maxSizeOptions = 10,
      this.maxQuiltHeight = 6,
      this.maxTileHeight = 3,
      this.maxTileWidth = 3,
      this.spacing = 8,
      this.carpetWidth = 5,
      this.carpetWidthCalc = _defaultCarpetWidthCalc,
      this.allowFutureFeeding = true,
      this.allowPastFeeding = true,
      this.includeHorizontalPadding = true,
      this.loadMoreCooldown = const Duration(milliseconds: 250),
      this.unseenQuiltTarget = 2,
      this.allowScalarTiles = true,
      this.allowHoles = false,
      this.minTileWidth = 1,
      this.minTileHeight = 1,
      this.unknownExtentOfScreenMultiplier = 1.0});

  /// Creates a style targeting a specific cell size for mosaic layouts.
  ///
  /// Overrides the width calculator to fit tiles of the given [cellSize], ensuring uniform sizing across devices. Integrates with [Carpet] for aspect-preserving arrangements.
  CarpetStyle targetCellSize(int cellSize) => copyWith(
        carpetWidthCalc: _targetSizeCarpetWidthCalculator(cellSize),
      );

  /// Configures a list-view style with fixed aspect ratios.
  ///
  /// Sets tile dimensions for linear layouts, enforcing single-row heights and adjustable quilt multipliers. Used in [Carpet] for feed-style presentations.
  CarpetStyle listView({int aspect = 5, int quiltHeightMultiplier = 1}) =>
      copyWith(
        carpetWidthCalc: (_) => aspect,
        maxTileWidth: aspect,
        minTileWidth: aspect,
        minTileHeight: 1,
        maxTileHeight: 1,
        maxQuiltHeight: quiltHeightMultiplier,
      );

  /// Configures a cell-view style for uniform block layouts.
  ///
  /// Defines fixed width, height, and column counts for grid-like cells. Suitable for dashboard tiles in [Carpet] widgets.
  CarpetStyle cellView({int width = 3, int height = 1, int columns = 3}) =>
      copyWith(
        carpetWidthCalc: (_) => columns * width,
        maxTileWidth: width,
        minTileWidth: width,
        minTileHeight: height,
        maxTileHeight: height,
        maxQuiltHeight: height,
      );

  /// Configures a tape-view style for granular, horizontal feeds.
  ///
  /// Allows holes and sets granularity for narrow tiles, with height and multiplier adjustments. Used in [Carpet] for timeline views.
  CarpetStyle tapeView(
          {int granularity = 20,
          int height = 4,
          int quiltMultiplier = 4,
          int minGranularityWidth = 5}) =>
      copyWith(
        carpetWidthCalc: (_) => granularity,
        maxTileWidth: granularity,
        minTileWidth: minGranularityWidth,
        minTileHeight: height,
        maxTileHeight: height,
        maxQuiltHeight: quiltMultiplier * height,
        allowHoles: true,
      );

  /// Configures a grid-view style for multi-cell uniform layouts.
  ///
  /// Computes columns based on tile size and cell counts, disabling scalar tiles for strict grids. Used in [Carpet] for galleries or tables.
  CarpetStyle gridView(
          {int width = 1,
          int height = 1,
          int tileSize = 250,
          int quiltHeightMultiplier = 1}) =>
      copyWith(
          carpetWidthCalc: (context) {
            int w = MediaQuery.of(context).size.width ~/ tileSize;

            while (w % width != 0) {
              w++;
            }

            return w;
          },
          maxTileWidth: width,
          minTileWidth: width,
          minTileHeight: height,
          maxTileHeight: height,
          maxQuiltHeight: quiltHeightMultiplier * height,
          allowScalarTiles: false);

  /// Computes and validates style parameters based on the current context.
  ///
  /// Applies device-specific adjustments to ensure valid dimensions, clamping values for feasibility. Returns a new [CarpetStyle] ready for use in [QuiltFaucet] and [Carpet] rendering, integrating with [MediaQuery] for responsiveness.
  CarpetStyle compute(BuildContext context) {
    int carpetWidth = max(1, carpetWidthCalc(context));
    int maxTileWidth = max(1, min(this.maxTileWidth, carpetWidth));
    int maxTileHeight = max(1, min(this.maxTileHeight, maxQuiltHeight));
    int minTileWidth = max(1, min(this.minTileWidth, maxTileWidth));
    int minTileHeight = max(1, min(this.minTileHeight, maxTileHeight));

    return copyWith(
        carpetWidth: carpetWidth,
        maxTileWidth: maxTileWidth,
        maxTileHeight: maxTileHeight,
        minTileWidth: minTileWidth,
        minTileHeight: minTileHeight,
        maxSizeOptions: max(1, min(maxSizeOptions, 64)));
  }

  /// Creates a copy of this [CarpetStyle] with optional overrides.
  ///
  /// Allows immutable updates for fluent configuration, preserving unchanged properties. Essential for style variations in [Carpet] and [QuiltFaucet] without mutating originals.
  CarpetStyle copyWith({
    bool? allowHoles,
    int? maxQuiltHeight,
    int? maxSizeOptions,
    int? maxTileHeight,
    int? maxTileWidth,
    int Function(BuildContext)? carpetWidthCalc,
    int? carpetWidth,
    double? spacing,
    bool? allowFutureFeeding,
    bool? allowPastFeeding,
    bool? includeHorizontalPadding,
    Duration? loadMoreCooldown,
    int? unseenQuiltTarget,
    bool? allowScalarTiles,
    int? minTileWidth,
    int? minTileHeight,
    double? unknownExtentOfScreenMultiplier,
  }) =>
      CarpetStyle(
        unknownExtentOfScreenMultiplier: unknownExtentOfScreenMultiplier ??
            this.unknownExtentOfScreenMultiplier,
        allowHoles: allowHoles ?? this.allowHoles,
        maxQuiltHeight: maxQuiltHeight ?? this.maxQuiltHeight,
        maxSizeOptions: maxSizeOptions ?? this.maxSizeOptions,
        maxTileHeight: maxTileHeight ?? this.maxTileHeight,
        maxTileWidth: maxTileWidth ?? this.maxTileWidth,
        carpetWidthCalc: carpetWidthCalc ?? this.carpetWidthCalc,
        carpetWidth: carpetWidth ?? this.carpetWidth,
        spacing: spacing ?? this.spacing,
        allowFutureFeeding: allowFutureFeeding ?? this.allowFutureFeeding,
        allowPastFeeding: allowPastFeeding ?? this.allowPastFeeding,
        includeHorizontalPadding:
            includeHorizontalPadding ?? this.includeHorizontalPadding,
        loadMoreCooldown: loadMoreCooldown ?? this.loadMoreCooldown,
        unseenQuiltTarget: unseenQuiltTarget ?? this.unseenQuiltTarget,
        allowScalarTiles: allowScalarTiles ?? this.allowScalarTiles,
        minTileWidth: minTileWidth ?? this.minTileWidth,
        minTileHeight: minTileHeight ?? this.minTileHeight,
      );

  @override
  int get hashCode {
    return Object.hash(
      allowHoles,
      maxQuiltHeight,
      maxSizeOptions,
      maxTileHeight,
      maxTileWidth,
      carpetWidth,
      spacing,
      allowFutureFeeding,
      allowPastFeeding,
      includeHorizontalPadding,
      loadMoreCooldown,
      unseenQuiltTarget,
      allowScalarTiles,
      minTileWidth,
      minTileHeight,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final CarpetStyle otherStyle = other as CarpetStyle;
    return maxQuiltHeight == otherStyle.maxQuiltHeight &&
        maxSizeOptions == otherStyle.maxSizeOptions &&
        maxTileHeight == otherStyle.maxTileHeight &&
        maxTileWidth == otherStyle.maxTileWidth &&
        carpetWidth == otherStyle.carpetWidth &&
        spacing == otherStyle.spacing &&
        allowFutureFeeding == otherStyle.allowFutureFeeding &&
        allowPastFeeding == otherStyle.allowPastFeeding &&
        includeHorizontalPadding == otherStyle.includeHorizontalPadding &&
        loadMoreCooldown == otherStyle.loadMoreCooldown &&
        unseenQuiltTarget == otherStyle.unseenQuiltTarget &&
        minTileWidth == otherStyle.minTileWidth &&
        minTileHeight == otherStyle.minTileHeight &&
        allowHoles == otherStyle.allowHoles &&
        allowScalarTiles == otherStyle.allowScalarTiles;
  }
}

/// A responsive, dynamic tiling widget for displaying lists of items in adaptive layouts within the Arcane UI system.
///
/// [Carpet] uses a quilt-based algorithm to arrange tiles in a staggered grid, prefetching content via [QuiltTileFaucet] and rendering with [CarpetStyle]. It supports infinite scrolling with future/past feeding, integrating with [Refresher], [MagicCarpet], and [ArcaneTheme] for smooth, performant feeds. Mixin [SliverSignal] enables sliver compatibility for use in [CustomScrollView] or [SliverList].
class Carpet<T> extends StatefulWidget with SliverSignal {
  final QuiltTileBuilder<T> tileBuilder;
  final QuiltTileFaucet<T> tileFaucet;
  final CarpetStyle style;

  /// Constructs a [Carpet] widget with required builders and optional style.
  ///
  /// The [tileBuilder] renders individual tiles, while [tileFaucet] manages data loading. Defaults to a standard [CarpetStyle] for responsive tiling. Use in [Section] or [FillScreen] for dynamic content displays, ensuring [getTime], [getID], and [getAspect] are implemented in the faucet for proper quilt generation.
  const Carpet(
      {super.key,
      required this.tileBuilder,
      required this.tileFaucet,
      this.style = const CarpetStyle()});

  @override
  State<Carpet<T>> createState() => _CarpetState<T>();
}

/// The private state manager for [Carpet], handling quilt building, prefetching, and rendering.
///
/// Manages the [TransplantingQuiltFaucet], ticker for cooldowns, and scroll listeners for dynamic loading. Integrates with [QuiltFaucet] to build and update quilts on demand, ensuring efficient rendering in sliver contexts via [SliverList.separated].
class _CarpetState<T> extends State<Carpet<T>>
    with SingleTickerProviderStateMixin {
  late TransplantingQuiltFaucet<T> _faucet;
  late Ticker _ticker;
  ScrollPosition? _position;
  bool _isLoadingMore = false;
  bool _firstBuild = true;
  int _lDelta = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updatePosition();
  }

  void _updatePosition() {
    ScrollPosition? newPosition = Scrollable.maybeOf(context)?.position;
    if (newPosition != _position) {
      _position?.removeListener(_pullPastIfNeeded);
      _position = newPosition;
      _position?.addListener(_pullPastIfNeeded);
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_pullPastIfNeeded);
    _ticker.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _faucet = TransplantingQuiltFaucet(
        tileFaucet: widget.tileFaucet, tileBuilder: widget.tileBuilder);
    _ticker = createTicker((elapsed) {
      if (_isLoadingMore) return;
      if (elapsed.inMilliseconds - _lDelta >
          widget.style.loadMoreCooldown.inMilliseconds) {
        _lDelta = elapsed.inMilliseconds;
        _pullPastIfNeeded();
      }
    })
      ..start();
    super.initState();
  }

  /// Checks scroll position and triggers past quilt building if unseen content is low.
  ///
  /// Monitors [unseenPastQuiltCount] and [unknownExtent] against thresholds, initiating [buildPast] with cooldown. Integrates with [QuiltFaucet] for prefetching in infinite scrolls, updating state post-load.
  void _pullPastIfNeeded() {
    QuiltFaucet<T> faucet = _faucet.rawFaucet;
    if (_isLoadingMore) return;
    if (faucet.unseenPastQuiltCount < widget.style.unseenQuiltTarget ||
        faucet.unknownExtent <
            MediaQuery.of(context).size.height *
                widget.style.unknownExtentOfScreenMultiplier) {
      _isLoadingMore = true;
      int c = faucet.tileFaucet.buffer.length;
      int qq = faucet.quiltBuffer.length;

      faucet
          .buildPast()
          .then((_) async => Future.delayed(widget.style.loadMoreCooldown, () {
                if (c != faucet.tileFaucet.buffer.length ||
                    qq != faucet.quiltBuffer.length) {
                  setState(() {});
                }

                _isLoadingMore = false;
              }));
    }
  }

  /// Provides a context-computed [QuiltFaucet] with update callback.
  ///
  /// Initializes or transplants the faucet with current style, triggering rebuilds on updates. Central to [Carpet]'s dynamic rendering.
  QuiltFaucet<T> getFaucet(BuildContext context) => _faucet(
        onUpdate: () => setState(() {}),
        style: widget.style.compute(context),
      );

  @override
  Widget build(BuildContext context) {
    QuiltFaucet<T> faucet = getFaucet(context);

    if (_firstBuild) {
      _firstBuild = false;
      faucet.buildPast().then((_) => setState(() {}));
    }

    Widget sep = Gap(widget.style.spacing);
    Widget out = SliverList.separated(
        itemCount: faucet.quiltBuffer.length,
        addAutomaticKeepAlives: true,
        itemBuilder: (_, i) => faucet.quiltBuffer[i],
        separatorBuilder: (_, __) => sep);

    if (widget.style.includeHorizontalPadding) {
      out = out.padSliverBy(
          left: widget.style.spacing, right: widget.style.spacing);
    }

    return out;
  }
}

/// A type alias for the tile rendering callback in [Carpet].
///
/// Receives a tile data item and returns a [Widget] representation, used by [QuiltFaucet] to build [StaggeredGridTile] children. Integrates with custom components like [Tile], [GlowCard], or [Image] for content-specific rendering in Arcane layouts.
typedef QuiltTileBuilder<T> = Widget Function(T tile);

/// A wrapper class for managing quilt faucet transplantation on style changes.
///
/// Ensures seamless updates to [QuiltFaucet] when [CarpetStyle] recomputes, preserving buffer state. Used internally by [Carpet] to handle responsive reconfiguration without data loss.
class TransplantingQuiltFaucet<T> {
  final QuiltTileFaucet<T> tileFaucet;
  final QuiltTileBuilder<T> tileBuilder;
  QuiltFaucet<T>? _faucet;
  QuiltFaucet<T> get rawFaucet => _faucet!;

  /// Constructs a transplanting faucet with tile source and builder.
  ///
  /// Initializes lazily on first call, integrating with [QuiltFaucet] for quilt management in [Carpet].
  TransplantingQuiltFaucet(
      {required this.tileFaucet, required this.tileBuilder});

  /// Returns or creates a [QuiltFaucet] with the given style and update handler.
  ///
  /// Transplants if style changes, rebuilding past quilts to adapt layout. Triggers [onUpdate] post-rebuild for state refresh in [Carpet].
  QuiltFaucet<T> call({
    required VoidCallback onUpdate,
    required CarpetStyle style,
  }) {
    _faucet ??= QuiltFaucet<T>(
        tileFaucet: tileFaucet, style: style, tileBuilder: tileBuilder);

    if (_faucet!.style != style) {
      _faucet = _faucet!.transplant(
        style: style,
        buffer: tileFaucet,
      );

      _faucet!
        ..buildPast(allowPull: false)
        ..buildPast(allowPull: true).then((_) => onUpdate());
    }

    return _faucet!;
  }
}

/// The core engine for generating and managing quilts from tile data in [Carpet] layouts.
///
/// [QuiltFaucet] handles tile sizing, placement optimization, and buffer management using algorithms for variance-minimized arrangements. It prefetches via [QuiltTileFaucet], caches sizes, and builds [StaggeredGrid] widgets with [MeasureSize] for height tracking. Integrates with [CarpetStyle] for responsive rules and [Refresher] for pull-to-refresh in infinite feeds.
class QuiltFaucet<T> {
  final CarpetStyle style;
  final QuiltTileFaucet<T> tileFaucet;
  QuiltTileBuilder<T> tileBuilder;
  Map<String, List<QSize>> qSizeCache = {};
  DateTime? futureEdge;
  DateTime? pastEdge;
  List<Widget> quiltBuffer = [];
  List<int> quiltPostCounts = [];
  List<double> quiltHeights = [];

  /// Constructs a [QuiltFaucet] with style, tile source, and builder.
  ///
  /// Initializes caches and buffers for quilt generation. Use in [Carpet] via [getFaucet] for dynamic rendering.
  QuiltFaucet({
    required this.tileBuilder,
    required this.tileFaucet,
    required this.style,
  });

  /// Creates a new [QuiltFaucet] by transplanting style or buffer.
  ///
  /// Preserves builder while updating specified properties, enabling reconfiguration in [TransplantingQuiltFaucet].
  QuiltFaucet<T> transplant({CarpetStyle? style, QuiltTileFaucet<T>? buffer}) =>
      QuiltFaucet<T>(
        tileBuilder: tileBuilder,
        tileFaucet: buffer ?? this.tileFaucet,
        style: style ?? this.style,
      );

  /// Retrieves or computes size options for a tile, sorted by area and aspect deviation.
  ///
  /// Caches [QSize] variants within style constraints, filtering scalar tiles if disallowed. Used in [buildQuilt] for placement candidates, integrating with [getAspect] for proportion matching.
  List<QSize> getQSizeList(T post, int nMax) {
    String id = tileFaucet.getID(post);
    if (!qSizeCache.containsKey(id) || qSizeCache[id]!.length != nMax) {
      List<QSize> options = [];
      double aspect = tileFaucet.getAspect(post);
      for (int i = min(style.minTileWidth, style.maxTileWidth);
          i <= min(style.maxTileWidth, style.carpetWidth);
          i++) {
        for (int j = min(style.minTileHeight, style.maxTileHeight);
            j <= style.maxTileHeight;
            j++) {
          if (!style.allowScalarTiles && QSize(i, j, 0).canBeReduced) {
            continue;
          }

          double d = (i / j - aspect).abs();
          options.add(QSize(i, j, d));
        }
      }

      options.sort((a, b) => (a.w * a.h).compareTo(b.w * b.h));
      options.sort((a, b) => a.d.compareTo(b.d));
      qSizeCache[id] = options.take(nMax).toList();
    }

    return qSizeCache[id]!;
  }

  /// Attempts to place a tile of given dimensions in the height map, returning updated heights or null.
  ///
  /// Finds the lowest uniform base across the tile's width, validating fit within quilt height. Used in quilt building to minimize gaps, integrating with variance scoring for optimal arrangements.
  List<int>? placeTile(List<int> heights, int tileW, int tileH, int targetH) {
    if (tileW > style.carpetWidth) return null;
    int bestI = -1;
    int minBase = 999999;
    for (int i = 0; i <= style.carpetWidth - tileW; i++) {
      int maxInRange = heights[i];
      for (int j = i + 1; j < i + tileW; j++) {
        maxInRange = max(maxInRange, heights[j]);
      }

      if (maxInRange < minBase || (maxInRange == minBase && i < bestI)) {
        minBase = maxInRange;
        bestI = i;
      }
    }

    if (bestI == -1) return null;
    if (minBase + tileH > targetH) return null;
    int minInRange = heights[bestI];
    for (int j = bestI + 1; j < bestI + tileW; j++) {
      minInRange = min(minInRange, heights[j]);
    }
    if (minInRange != minBase) return null;
    List<int> newHeights = List.from(heights);
    for (int j = bestI; j < bestI + tileW; j++) {
      newHeights[j] = minBase + tileH;
    }

    return newHeights;
  }

  /// Builds a quilt from a range of tiles, optimizing placement for minimal variance.
  ///
  /// Generates [StaggeredGrid] from selected tiles, handling holes if allowed and falling back to single-post quilts. Logs performance in debug mode. Central algorithm in [buildQuilts], integrating with [createGrid] for rendering.
  QuiltResult buildQuilt(int start, {int? maxPosts}) {
    PrecisionStopwatch? p = kDebugMode ? PrecisionStopwatch.start() : null;
    List<StaggeredGridTile> tiles = [];
    List<int> heights = List.filled(style.carpetWidth, 0);
    int index = start;
    int fbMaxH = style.maxQuiltHeight;
    int maxIndex = start + (maxPosts ?? tileFaucet.buffer.length - start);
    while (index < tileFaucet.buffer.length && index < maxIndex) {
      T post = tileFaucet.buffer[index];
      List<QSize> poss = getQSizeList(post, style.maxSizeOptions * 2);
      List<TileOption> options = [];
      for (QSize size in poss) {
        List<int>? newHeights = placeTile(heights, size.w, size.h, fbMaxH);
        if (newHeights == null) continue;
        double avgHeight =
            newHeights.reduce((a, b) => a + b) / style.carpetWidth;
        double variance = newHeights.fold<double>(
                0, (sum, h) => sum + (h - avgHeight).abs()) /
            style.carpetWidth;
        options.add(TileOption(
          size: size,
          newHeights: newHeights,
          variance: variance,
          d: size.d,
        ));
      }
      bool placed = false;
      if (options.isNotEmpty) {
        options.sort((a, b) =>
            (a.d + a.variance * 0.1).compareTo(b.d + b.variance * 0.1));
        TileOption chosen = options[0];
        if (options.length > 1 && options[1].variance < chosen.variance) {
          chosen = options[1];
        }
        StaggeredGridTile tile = createTile(post, chosen.size.w, chosen.size.h);
        tiles.add(tile);
        heights = chosen.newHeights;
        placed = true;
      } else if (!style.allowHoles) {
        List<int>? newHeights = placeTile(heights, 1, 1, fbMaxH);
        if (newHeights != null) {
          StaggeredGridTile tile = createTile(post, 1, 1);
          tiles.add(tile);
          heights = newHeights;
          placed = true;
        }
      }
      if (!placed) {
        break;
      }
      index++;
    }
    int used = index - start;
    if (used == 0 && start < tileFaucet.buffer.length) {
      return buildSinglePostQuilt(tileFaucet.buffer[start]);
    }

    if (kDebugMode) {
      info(
          "[CARPET] Built quilt of <$used> posts in ${p!.getMilliseconds()}ms (${quiltBuffer.length} quilts)");
    }
    return QuiltResult(
      widget: createGrid(tiles),
      used: used,
    );
  }

  /// Asynchronously builds future-direction quilts, pulling if needed.
  ///
  /// Triggers [buildQuilts] for forward content, integrating with [tileFaucet.pullFuture] for infinite scrolling in [Carpet].
  Future<void> buildFuture() =>
      buildQuilts(QuiltDirection.future, allowPull: true);

  /// Asynchronously builds past-direction quilts, optionally pulling data.
  ///
  /// Handles backward prefetching with [allowPull] flag, updating buffers and edges. Used in [Carpet]'s initial load and scroll listeners.
  Future<void> buildPast({bool allowPull = true}) =>
      buildQuilts(QuiltDirection.past, allowPull: allowPull);

  /// Estimates the unknown extent of unloaded content in screen heights.
  ///
  /// Multiplies average quilt height by unseen past count, aiding scroll predictions in [Carpet].
  double get unknownExtent => averageQuiltHeight * unseenPastQuiltCount;

  /// Estimates the total carpet height including unknowns.
  ///
  /// Sums known heights with averaged unknowns, plus spacing, for viewport calculations in [Carpet].
  double get estimateCarpetExtent {
    double avgUnknown = averageQuiltHeight;

    return quiltHeights.map((i) => i > 0 ? i : avgUnknown).sum() +
        (quiltHeights.length > 1
            ? (quiltHeights.length - 1) * style.spacing
            : 0);
  }

  /// Computes the average height of known quilts.
  ///
  /// Filters positive heights for averaging, defaulting to 1 if none, used in extent estimations.
  double get averageQuiltHeight {
    Iterable<double> d = quiltHeights.where((h) => h > 0);

    if (d.isEmpty) {
      return 1;
    }

    return d.average();
  }

  /// Counts consecutive unknown quilts from the past end.
  ///
  /// Reverses heights to find trailing unknowns, informing prefetch thresholds in [Carpet].
  int get unseenPastQuiltCount {
    int g = 0;

    for (double i in quiltHeights.reversed) {
      if (i > 0) {
        return g;
      }

      g++;
    }

    return g;
  }

  /// Builds a single-tile quilt as fallback for unplaceable content.
  ///
  /// Uses [buildTile] for aspect-optimized sizing, ensuring no empty quilts in [buildQuilt].
  StaggeredGridTile buildTile(T post) {
    int maxX = style.carpetWidth;
    int maxY = style.maxTileHeight;
    int bx = 1;
    int by = 1;
    double lad = double.infinity;
    double aspect = tileFaucet.getAspect(post);
    for (int i = 1; i <= maxX; i++) {
      for (int j = 1; j <= maxY; j++) {
        double d = (i / j - aspect).abs();
        if (d < lad) {
          lad = d;
          bx = i;
          by = j;
        }
      }
    }

    return createTile(post, bx, by);
  }

  /// Builds quilts in the specified direction, handling pulls and insertions.
  ///
  /// Manages buffer updates, edge tracking, and quilt insertion/removal for seamless infinite scrolling. Integrates with [buildQuilt] for tile placement and [tileFaucet] for data fetching, logging pulls in debug mode.
  Future<void> buildQuilts(QuiltDirection direction,
      {bool allowPull = true}) async {
    bool isFuture = direction == QuiltDirection.future;
    DateTime? edge = isFuture ? futureEdge : pastEdge;
    int bufferLength = tileFaucet.buffer.length;
    Iterable<T> unseen = isFuture ? unseenFuture : unseenPast;
    int unseenCount = unseen.length;
    int threshold = style.carpetWidth * style.maxQuiltHeight;
    bool shouldPull = allowPull && (edge == null || unseenCount < threshold);
    int oldLength = bufferLength;
    if (shouldPull) {
      PrecisionStopwatch? p = kDebugMode ? PrecisionStopwatch.start() : null;
      int tl = tileFaucet.buffer.length;
      if (isFuture) {
        await tileFaucet.pullFuture(threshold);
      } else {
        await tileFaucet.pullPast(threshold);
      }
      int gl = tileFaucet.buffer.length - tl;

      if (kDebugMode && gl > 0) {
        info(
            "[CARPET] Pulled <$tl>+$gl ${isFuture ? "future" : "past"} posts in ${p!.getMilliseconds()}ms");
      }
    }

    bufferLength = tileFaucet.buffer.length;
    int added = bufferLength - oldLength;
    bool didPull = added > 0;
    int rebuildCount = 0;
    if (didPull && unseenCount == 0 && quiltBuffer.isNotEmpty) {
      rebuildCount =
          isFuture ? quiltPostCounts.removeAt(0) : quiltPostCounts.removeLast();
      isFuture ? quiltBuffer.removeAt(0) : quiltBuffer.removeLast();
      isFuture ? quiltHeights.removeAt(0) : quiltHeights.removeLast();
    }
    int buildStart =
        isFuture ? 0 : bufferLength - (added + unseenCount + rebuildCount);
    int buildMax = isFuture
        ? (added + unseenCount + rebuildCount)
        : (bufferLength - buildStart);
    if (buildMax <= 0) return;
    List<Widget> newQuilts = [];
    List<int> newCounts = [];
    int current = buildStart;
    int end = buildStart + buildMax;
    if (current < end) {
      QuiltResult res = buildQuilt(current);
      int used = res.used;
      if (used > 0) {
        newQuilts.add(res.widget);
        newCounts.add(used);
        current += used;
      }
    }
    if (isFuture && current < end) {
      int remaining = end - current;
      QuiltResult res = buildQuilt(current, maxPosts: remaining);
      if (res.used > 0) {
        newQuilts.add(res.widget);
        newCounts.add(res.used);
        current += res.used;
      }
    }
    if (isFuture) {
      quiltBuffer.insertAll(0, newQuilts);
      quiltHeights.insertAll(0, List.generate(newQuilts.length, (_) => 0));
      quiltPostCounts.insertAll(0, newCounts);
    } else {
      quiltBuffer.addAll(newQuilts);
      quiltHeights.addAll(List.generate(newQuilts.length, (_) => 0));
      quiltPostCounts.addAll(newCounts);
    }
    if (current > buildStart) {
      if (isFuture) {
        futureEdge = tileFaucet.getTime(tileFaucet.buffer[0]);
      } else {
        pastEdge = tileFaucet.getTime(tileFaucet.buffer[current - 1]);
      }
    }
  }

  /// Creates a [StaggeredGridTile] for the given tile data and dimensions.
  ///
  /// Uses [QuiltTileKey] for unique identification, integrating with [tileBuilder] for content rendering in quilts.
  StaggeredGridTile createTile(T post, int w, int h) {
    return StaggeredGridTile.count(
      key: QuiltTileKey(tileFaucet, post),
      crossAxisCellCount: w,
      mainAxisCellCount: h,
      child: tileBuilder(post),
    );
  }

  /// Wraps tiles in a measurable [StaggeredGrid] for height tracking.
  ///
  /// Uses [QuiltKey] for uniqueness and [MeasureSize] to update [quiltHeights] on layout, logging sizes in verbose mode. Essential for dynamic extent estimation in [Carpet].
  Widget createGrid(List<StaggeredGridTile> tiles) {
    QuiltKey<T> key = QuiltKey<T>(tileFaucet, tiles);
    return MeasureSize(
        key: key,
        onChange: (size) {
          int index = quiltBuffer.indexWhere((q) =>
              q.key is QuiltKey<T> &&
              (q.key as QuiltKey<T>).value == key.value);

          if (index != -1) {
            quiltHeights[index] = size.height;
            verbose(
                "[CARPET] Quilt Sizes(${quiltHeights.where((h) => h > 0).length}k|${quiltHeights.where((u) => u <= 0).length}u|${unseenPastQuiltCount}g): <${averageQuiltHeight.round()} avg> [?${estimateCarpetExtent.format()} xt] ${quiltHeights.map((e) => e > 0 ? e.round().format() : "?")}");
          } else {
            warn("[CARPET] Failed to find quilt for key: $key");
          }
        },
        child: StaggeredGrid.count(
          crossAxisCount: style.carpetWidth,
          mainAxisSpacing: style.spacing,
          crossAxisSpacing: style.spacing,
          children: tiles,
        ));
  }

  /// Recursively extracts the inner [StaggeredGrid] from wrapped widgets.
  ///
  /// Handles [MeasureSize] and [Column] wrappers, throwing on failure for debugging. Used in [hasHoles] for layout validation.
  StaggeredGrid getStaggeredGrid(Widget widget) {
    if (widget is StaggeredGrid) {
      return widget;
    } else if (widget is MeasureSize) {
      return getStaggeredGrid(widget.child);
    } else if (widget is Column) {
      return getStaggeredGrid(widget.children.whereType<StaggeredGrid>().first);
    } else {
      try {
        return getStaggeredGrid((widget as dynamic).child as Widget);
      } catch (e, es) {
        error("[CARPET] Failed to get child widget $e $es");
        rethrow;
      }
    }
  }

  /// Detects holes (gaps) in a quilt's layout by simulating placement.
  ///
  /// Analyzes tile occupations per column, returning true if heights exceed occupied rows. Used for validation in hole-allowed styles like tape views.
  bool hasHoles(Widget widget) {
    StaggeredGrid grid = getStaggeredGrid(widget);
    final List<StaggeredGridTile> tiles =
        grid.children.whereType<StaggeredGridTile>().toList();
    final List<int> heights = List.filled(style.carpetWidth, 0);
    final List<Set<int>> occupied =
        List.generate(style.carpetWidth, (_) => <int>{});

    for (StaggeredGridTile tile in tiles) {
      final int w = tile.crossAxisCellCount;
      final int h = tile.mainAxisCellCount!.toInt();
      int bestC = -1;
      int bestR = 2147483647;
      for (int c = 0; c <= style.carpetWidth - w; c++) {
        int maxH = 0;

        for (int dc = 0; dc < w; dc++) {
          maxH = max(maxH, heights[c + dc]);
        }

        if (maxH < bestR || (maxH == bestR && c < bestC)) {
          bestR = maxH;
          bestC = c;
        }
      }

      if (bestC == -1) return true;

      for (int dc = 0; dc < w; dc++) {
        final int col = bestC + dc;

        for (int dr = 0; dr < h; dr++) {
          occupied[col].add(bestR + dr);
        }

        heights[col] = max(heights[col], bestR + h);
      }
    }
    for (int col = 0; col < style.carpetWidth; col++) {
      if (heights[col] > 0 && occupied[col].length < heights[col]) return true;
    }
    return false;
  }

  /// Builds a single-post fallback quilt when multi-tile placement fails.
  ///
  /// Centers a single [StaggeredGridTile] across the carpet width, ensuring content visibility in edge cases.
  QuiltResult buildSinglePostQuilt(T post) {
    StaggeredGridTile tile = buildTile(post); // Reuses existing buildTile logic
    return QuiltResult(
      widget: StaggeredGrid.count(
        crossAxisCount: style.carpetWidth,
        children: [tile],
      ),
      used: 1,
    );
  }

  /// Getter for unseen future tiles based on edge timestamp.
  ///
  /// Filters buffer for tiles after [futureEdge], used in prefetch decisions.
  Iterable<T> get unseenFuture => futureEdge == null
      ? tileFaucet.buffer
      : tileFaucet.buffer
          .where((p) => tileFaucet.getTime(p).isAfter(futureEdge!));

  /// Getter for unseen past tiles based on edge timestamp.
  ///
  /// Filters buffer for tiles before [pastEdge], informing backward loading.
  Iterable<T> get unseenPast => pastEdge == null
      ? tileFaucet.buffer
      : tileFaucet.buffer
          .where((p) => tileFaucet.getTime(p).isBefore(pastEdge!));
}

/// A data source abstraction for tiles in [Carpet], managing bidirectional loading and buffering.
///
/// [QuiltTileFaucet] handles pulling past/future content via callbacks, maintaining a sorted buffer with cursors. Supports constant endpoints for finite datasets. Integrates with [QuiltFaucet] for quilt building and [Carpet] for infinite scrolling.
class QuiltTileFaucet<T> {
  final DateTime Function(T) getTime;
  final String Function(T) getID;
  final double Function(T) getAspect;
  final Future<List<T>> Function(int max, DateTime? futureCursor) onPullFuture;
  final Future<List<T>> Function(int max, DateTime? pastCursor) onPullPast;
  final List<T> buffer = [];
  bool _busy = false;
  bool _reachedEnd = false;
  bool _reachedStart = false;
  bool get isBusy => _busy;
  bool get hasReachedEndOfPast => _reachedEnd;
  bool get hasReachedStartOfFuture => _reachedStart;
  final bool constantPast;
  final bool constantFuture;

  /// Constructs a [QuiltTileFaucet] with required getters and pull callbacks.
  ///
  /// Initializes empty buffer; [constantPast] and [constantFuture] flag finite directions. Use in [Carpet] constructor for custom data sources like API feeds or local lists.
  QuiltTileFaucet({
    required this.getTime,
    required this.getID,
    required this.getAspect,
    required this.onPullFuture,
    required this.onPullPast,
    this.constantPast = true,
    this.constantFuture = false,
  });

  /// Gets the future cursor from the buffer's first item.
  ///
  /// Returns null if empty, used as [futureCursor] in pulls.
  DateTime? get futureCursor =>
      buffer.isNotEmpty ? getTime(buffer.first) : null;

  /// Gets the past cursor from the buffer's last item.
  ///
  /// Returns null if empty, used as [pastCursor] in pulls.
  DateTime? get pastCursor => buffer.isNotEmpty ? getTime(buffer.last) : null;

  /// Pulls future tiles up to [count], inserting at buffer start.
  ///
  /// Respects busy state and end flags; sets [hasReachedStartOfFuture] on empty constant pulls. Throws [CarpetException] on errors, logging failures.
  Future<void> pullFuture(int count) async {
    if (_busy) return;
    if (hasReachedStartOfFuture) return;
    _busy = true;
    try {
      List<T> m = await onPullFuture(count, futureCursor);

      if (constantFuture && m.isEmpty) {
        _reachedStart = true;

        if (kDebugMode) {
          warn(
              "[CARPET] Reached start of future posts, Ignoring subsequent pulls from future");
        }
      }

      buffer.insertAll(0, m);
    } catch (e, es) {
      error("[CARPET] Failed to pull future: $e $es");
      throw CarpetException("[CARPET] Failed to pull future.");
    } finally {
      _busy = false;
    }
  }

  /// Internal hook for past pulls, allowing overrides like in [QuiltTileForceFeeder].
  ///
  /// Defaults to [onPullPast]; used for custom buffering in subclasses.
  Future<List<T>> doPullPast(int i, DateTime? c) => onPullPast(i, c);

  /// Pulls past tiles up to [count], appending to buffer.
  ///
  /// Similar to [pullFuture], but for backward direction; sets [hasReachedEndOfPast] on empty constant pulls.
  Future<void> pullPast(int count) async {
    if (_busy) return;
    if (hasReachedEndOfPast) return;
    _busy = true;
    try {
      List<T> m = await doPullPast(count, pastCursor);

      if (constantPast && m.isEmpty) {
        _reachedEnd = true;

        if (kDebugMode) {
          warn(
              "[CARPET] Reached end of past content, Ignoring subsequent pulls from past");
        }
      }

      buffer.addAll(m);
    } catch (e, es) {
      error("[CARPET] Failed to pull past: $e $es");
      throw CarpetException("[CARPET] Failed to pull past.");
    } finally {
      _busy = false;
    }
  }
}

/// An enum defining directions for quilt building in [QuiltFaucet].
///
/// Used in [buildQuilts] to specify forward (future) or backward (past) content loading.
enum QuiltDirection { future, past }

/// A simple data class representing potential tile sizes with aspect deviation.
///
/// Used in [QuiltFaucet.getQSizeList] for candidate generation, with [canBeReduced] filtering reducible (scalar) sizes.
class QSize {
  final int w;
  final int h;
  final double d;

  const QSize(this.w, this.h, this.d);

  /// Determines if the size can be reduced (gcd > 1), indicating scalar nature.
  ///
  /// Computed via Euclidean algorithm in [_gcd], used to skip non-uniform tiles if [allowScalarTiles] is false.
  bool get canBeReduced {
    int a = w.abs(), b = h.abs();
    if (a == 0 || b == 0) return false;
    return _gcd(a, b) > 1;
  }

  int _gcd(int a, int b) {
    while (b != 0) {
      int t = b;
      b = a % b;
      a = t;
    }
    return a;
  }
}

/// A candidate for quilt evaluation, scoring layout quality.
///
/// Aggregates size options with variance and deviation for selection in [buildQuilt].
class QuiltCandidate {
  final double score;
  final double avgD;
  final Widget widget;
  final int used;
  final int th;

  const QuiltCandidate({
    required this.score,
    required this.avgD,
    required this.widget,
    required this.used,
    required this.th,
  });
}

/// The result of building a quilt, containing the widget and usage count.
///
/// Returned by [buildQuilt] and [buildSinglePostQuilt] for buffer integration.
class QuiltResult {
  final Widget widget;
  final int used;

  const QuiltResult({
    required this.widget,
    required this.used,
  });
}

/// An option for tile placement, including heights and scoring metrics.
///
/// Generated in [buildQuilt] for variance-minimized selection.
class TileOption {
  final QSize size;
  final List<int> newHeights;
  final double variance;
  final double d;

  const TileOption({
    required this.size,
    required this.newHeights,
    required this.variance,
    required this.d,
  });
}

/// A custom exception for carpet-related errors.
///
/// Thrown by pull methods in [QuiltTileFaucet] on failures, providing descriptive messages for debugging.
class CarpetException implements Exception {
  final String message;
  CarpetException(this.message);

  @override
  String toString() => "Carpet Exception: $message";
}

/// A [ValueKey] for individual quilt tiles based on data ID.
///
/// Ensures unique identification in [StaggeredGridTile], using [getID] from faucet.
class QuiltTileKey<T> extends ValueKey<String> {
  QuiltTileKey(QuiltTileFaucet<T> feeder, T value) : super(feeder.getID(value));
}

/// A [ValueKey] for entire quilts based on tile ID hash.
///
/// Computes SHA-256 of concatenated tile keys for uniqueness in [MeasureSize].
class QuiltKey<T> extends ValueKey<List<int>> {
  QuiltKey(QuiltTileFaucet<T> feeder, List<StaggeredGridTile> tiles)
      : super(sha256
            .convert(utf8.encode(tiles
                .map((t) => t.key)
                .whereType<QuiltTileKey<T>>()
                .map((k) => k.value)
                .join("|")))
            .bytes);
}

/// A force-feeding variant of [QuiltTileFaucet] for static lists.
///
/// Sorts and feeds a predefined [feed] list on first past pull, ideal for offline or fixed datasets in testing [Carpet] layouts.
class QuiltTileForceFeeder<T> extends QuiltTileFaucet<T> {
  final List<T> feed;
  bool fed = false;

  /// Constructs a force feeder with static feed and required getters.
  ///
  /// Overrides pulls to empty for future and feeds on past, sorting by time descending.
  QuiltTileForceFeeder(
      {required this.feed,
      required super.getTime,
      required super.getID,
      required super.getAspect})
      : super(
          onPullFuture: (i, t) async => [],
          onPullPast: (i, t) async => [],
        );

  @override
  Future<List<T>> doPullPast(int i, DateTime? c) => _feed();

  /// Feeds the sorted list on first call, marking as fed.
  ///
  /// Ensures one-time loading for static content simulation.
  Future<List<T>> _feed() async {
    if (fed) return [];
    fed = true;
    feed.sort((a, b) => getTime(b).compareTo(getTime(a)));
    return feed;
  }
}

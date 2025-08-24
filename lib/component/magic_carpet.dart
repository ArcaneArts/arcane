import 'dart:convert';
import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:crypto/crypto.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:fast_log/fast_log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:measure_size/measure_size.dart';

typedef CarpetWidthCalculator = int Function(BuildContext context);

CarpetWidthCalculator _targetSizeCarpetWidthCalculator(int targetSize) =>
    (context) => MediaQuery.of(context).size.width ~/ targetSize;

int _defaultCarpetWidthCalc(BuildContext context) =>
    MediaQuery.of(context).size.width ~/ 250;

class CarpetStyles {
  const CarpetStyles._();

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

  static CarpetStyle strip(BuildContext context,
      {int quiltHeightMultiplier = 1}) {
    return CarpetStyle()
        .listView(
          aspect: 10,
          quiltHeightMultiplier: 20 * quiltHeightMultiplier,
        )
        .copyWith(maxTileHeight: 20);
  }

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

  static CarpetStyle mosaic(BuildContext context, {double size = 250}) =>
      CarpetStyle(allowScalarTiles: false).targetCellSize(
          (size * pow(MediaQuery.of(context).size.width / 2000, 0.6)).round());
}

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

  CarpetStyle targetCellSize(int cellSize) => copyWith(
        carpetWidthCalc: _targetSizeCarpetWidthCalculator(cellSize),
      );

  CarpetStyle listView({int aspect = 5, int quiltHeightMultiplier = 1}) =>
      copyWith(
        carpetWidthCalc: (_) => aspect,
        maxTileWidth: aspect,
        minTileWidth: aspect,
        minTileHeight: 1,
        maxTileHeight: 1,
        maxQuiltHeight: quiltHeightMultiplier,
      );

  CarpetStyle cellView({int width = 3, int height = 1, int columns = 3}) =>
      copyWith(
        carpetWidthCalc: (_) => columns * width,
        maxTileWidth: width,
        minTileWidth: width,
        minTileHeight: height,
        maxTileHeight: height,
        maxQuiltHeight: height,
      );

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

class MagicCarpet<T> extends StatefulWidget with SliverSignal {
  final QuiltTileBuilder<T> tileBuilder;
  final QuiltTileFaucet<T> tileFaucet;
  final CarpetStyle style;

  const MagicCarpet(
      {super.key,
      required this.tileBuilder,
      required this.tileFaucet,
      this.style = const CarpetStyle()});

  @override
  State<MagicCarpet<T>> createState() => _MagicCarpetState<T>();
}

class _MagicCarpetState<T> extends State<MagicCarpet<T>>
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

typedef QuiltTileBuilder<T> = Widget Function(T tile);

class TransplantingQuiltFaucet<T> {
  final QuiltTileFaucet<T> tileFaucet;
  final QuiltTileBuilder<T> tileBuilder;
  QuiltFaucet<T>? _faucet;
  QuiltFaucet<T> get rawFaucet => _faucet!;

  TransplantingQuiltFaucet(
      {required this.tileFaucet, required this.tileBuilder});

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

  QuiltFaucet({
    required this.tileBuilder,
    required this.tileFaucet,
    required this.style,
  });

  QuiltFaucet<T> transplant({CarpetStyle? style, QuiltTileFaucet<T>? buffer}) =>
      QuiltFaucet<T>(
        tileBuilder: tileBuilder,
        tileFaucet: buffer ?? this.tileFaucet,
        style: style ?? this.style,
      );

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

  Future<void> buildFuture() =>
      buildQuilts(QuiltDirection.future, allowPull: true);

  Future<void> buildPast({bool allowPull = true}) =>
      buildQuilts(QuiltDirection.past, allowPull: allowPull);

  double get unknownExtent => averageQuiltHeight * unseenPastQuiltCount;

  double get estimateCarpetExtent {
    double avgUnknown = averageQuiltHeight;

    return quiltHeights.map((i) => i > 0 ? i : avgUnknown).sum() +
        (quiltHeights.length > 1
            ? (quiltHeights.length - 1) * style.spacing
            : 0);
  }

  double get averageQuiltHeight {
    Iterable<double> d = quiltHeights.where((h) => h > 0);

    if (d.isEmpty) {
      return 1;
    }

    return d.average();
  }

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

  StaggeredGridTile createTile(T post, int w, int h) {
    return StaggeredGridTile.count(
      key: QuiltTileKey(tileFaucet, post),
      crossAxisCellCount: w,
      mainAxisCellCount: h,
      child: tileBuilder(post),
    );
  }

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

  Iterable<T> get unseenFuture => futureEdge == null
      ? tileFaucet.buffer
      : tileFaucet.buffer
          .where((p) => tileFaucet.getTime(p).isAfter(futureEdge!));

  Iterable<T> get unseenPast => pastEdge == null
      ? tileFaucet.buffer
      : tileFaucet.buffer
          .where((p) => tileFaucet.getTime(p).isBefore(pastEdge!));
}

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

  QuiltTileFaucet({
    required this.getTime,
    required this.getID,
    required this.getAspect,
    required this.onPullFuture,
    required this.onPullPast,
    this.constantPast = true,
    this.constantFuture = false,
  });

  DateTime? get futureCursor =>
      buffer.isNotEmpty ? getTime(buffer.first) : null;

  DateTime? get pastCursor => buffer.isNotEmpty ? getTime(buffer.last) : null;

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

  Future<List<T>> doPullPast(int i, DateTime? c) => onPullPast(i, c);

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

enum QuiltDirection { future, past }

class QSize {
  final int w;
  final int h;
  final double d;

  const QSize(this.w, this.h, this.d);

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

class QuiltResult {
  final Widget widget;
  final int used;

  const QuiltResult({
    required this.widget,
    required this.used,
  });
}

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

class CarpetException implements Exception {
  final String message;
  CarpetException(this.message);

  @override
  String toString() => "Carpet Exception: $message";
}

class QuiltTileKey<T> extends ValueKey<String> {
  QuiltTileKey(QuiltTileFaucet<T> feeder, T value) : super(feeder.getID(value));
}

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

class QuiltTileForceFeeder<T> extends QuiltTileFaucet<T> {
  final List<T> feed;
  bool fed = false;

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

  Future<List<T>> _feed() async {
    if (fed) return [];
    fed = true;
    feed.sort((a, b) => getTime(b).compareTo(getTime(a)));
    return feed;
  }
}

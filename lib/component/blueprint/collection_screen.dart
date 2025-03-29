import 'dart:async';
import 'dart:convert';

import 'package:arcane/arcane.dart';
import 'package:fast_log/fast_log.dart';
import 'package:fire_crud/fire_crud.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CollectionScreen<T extends Object> extends StatefulWidget {
  final Stream<List<T>> data;
  final CollectionItemIdentifier identifier;
  final CollectionItemMapper mapper;
  final List<String> dimensions;
  final String typeName;
  final String? typeNamePlural;
  final IconData emptyIcon;
  final Widget Function(T item) itemBuilder;
  final Widget Function(String? property, dynamic grouped) groupBuilder;
  final Future<bool> Function(String? orderBy, String? groupBy,
      Map<String, dynamic> filterBy, T last)? onLoadMore;

  const CollectionScreen(
      {super.key,
      this.groupBuilder = _defaultGroupBuilder,
      required this.data,
      this.onLoadMore,
      required this.itemBuilder,
      this.mapper = _defaultCollectionItemMapper,
      this.identifier = _defaultCollectionItemIdentifier,
      this.dimensions = const [],
      this.emptyIcon = Icons.warning,
      required this.typeName,
      this.typeNamePlural});

  @override
  State<CollectionScreen<T>> createState() => _CollectionScreenState<T>();
}

class _CollectionScreenState<T extends Object>
    extends State<CollectionScreen<T>> {
  late BehaviorSubject<Map<dynamic, List<T>>> groups;
  late StreamSubscription<List<T>> sub;
  late GlobalKey visibilityKey;
  late BehaviorSubject<bool> loadingStream;
  late List<T> lastData;
  String? query;

  String? orderBy;
  String? groupBy;
  Map<String, dynamic> filterBy = {};

  @override
  void initState() {
    lastData = widget.data is BehaviorSubject<List<T>>
        ? (widget.data as BehaviorSubject<List<T>>).value
        : [];
    visibilityKey = GlobalKey();
    groups = BehaviorSubject<Map<dynamic, List<T>>>.seeded({});
    sub = widget.data.listen((event) {
      lastData = event;
      updateView(event.where((i) => match(query, i)).toList());
    });
    loadingStream = BehaviorSubject<bool>.seeded(false);
    super.initState();
  }

  void updateQuery(String? query) {
    this.query = query;
    updateView(lastData.where((i) => match(query, i)).toList());
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  void updateView(List<T> data, [bool set = true]) {
    List<T> view = filter(data).toList();
    Set<String> keys = {};
    for (T i in view) {
      keys.addAll(widget.mapper(i).deepKeys);
    }

    sort(view);
    groups.add(group(view));
    if (set) {
      setState(() {});
    }
  }

  Map<dynamic, List<T>> group(List<T> data) {
    if (groupBy == null) {
      return {null: data};
    }

    String gb = groupBy!;

    Map<dynamic, List<T>> groups = {};

    for (T i in data) {
      dynamic key = widget.mapper(i).getValue(gb);
      groups[key] ??= [];
      groups[key]!.add(i);
    }

    return groups;
  }

  Iterable<T> filter(List<T> data) sync* {
    if (filterBy.isEmpty) {
      yield* data;
      return;
    }

    List<String> keys = filterBy.keys.toList();
    String kl = keys.join(",");
    List<(T, List<dynamic>)> raws =
        data.map((i) => (i, widget.mapper(i).getValues(kl).toList())).toList();
    if (raws.isEmpty) return;
    int size = raws.first.$2.length;

    filtering:
    for ((T, List<dynamic>) i in raws) {
      for (int j = 0; j < size; j++) {
        if (keys[j] != i.$2[j]) {
          continue filtering;
        }
      }

      yield i.$1;
    }
  }

  void sort(List<T> data) {
    data.sort((a, b) => widget.identifier(b).compareTo(widget.identifier(a)));

    if (orderBy != null) {
      List<(T, List<dynamic>)> raws = data
          .map((i) => (i, widget.mapper(i).getValues(orderBy!).toList()))
          .toList();
      if (raws.isEmpty) return;
      int size = raws.first.$2.length;

      for (int i = 0; i < size; i++) {
        data.sort((a, b) => raws.first.$2[i].compareTo(raws.last.$2[i]));
      }
    }
  }

  String get plural => widget.typeNamePlural ?? "${widget.typeName}s";

  int compareGroup(dynamic a, dynamic b) {
    if (a.runtimeType == b.runtimeType && a != null && b != null) {
      return b.toString().compareTo(a.toString());
    }

    return a.toString().compareTo(b.toString());
  }

  Widget buildEmpty(BuildContext context) => SliverFillRemainingBoxAdapter(
      child: CenterBody(icon: widget.emptyIcon, message: "No $plural"));

  Widget buildSubList(BuildContext context, List<T> items) => ArcaneList<T>(
      items: items,
      itemBuilder: (context, i) => KeyedSubtree(
          key: ValueKey("li.${widget.identifier(items[i])}"),
          child: widget.itemBuilder(items[i])),
      isSameItem: (a, b) => widget.identifier(a) == widget.identifier(b));

  Widget buildSection(BuildContext context, dynamic group, List<T> items) =>
      group == null
          ? buildSubList(context, items)
          : GlassSection(
              header: widget.groupBuilder(groupBy, group),
              sliver: buildSubList(context, items));

  bool match(String? query, T data) => (query ?? "").trim().isEmpty
      ? true
      : widget
          .mapper(data)
          .values
          .join(",")
          .toLowerCase()
          .contains(query!.toLowerCase());

  Iterable<MenuItem> buildSortMenu(BuildContext context,
      {Map<String, dynamic>? d, String kp = ""}) sync* {
    if (lastData.isEmpty) {
      return;
    }

    Map<String, dynamic> data = d ?? widget.mapper(lastData.first);

    for (String i in data.keys) {
      yield MenuButton(
        child: Text(i),
        subMenu: [
          if (data[i] is Map<String, dynamic>)
            ...buildSortMenu(context, d: data[i], kp: "$kp$i."),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) => SliverScreen(
      header: Bar(
        title: Text(plural),
        trailing: [
          SearchButton(
            mode: SearchButtonMode.live,
            onSearch: (q) => updateQuery(q),
          ),
          IconButtonMenu(icon: Icons.list, items: [...buildSortMenu(context)])
        ],
      ),
      sliver: groups.build(
          (groups) => groups.isEmpty ||
                  (groups.length == 1 && groups.values.first.isEmpty)
              ? buildEmpty(context)
              : Collection(
                  children: [
                    ...(groups.keys.toList()..sort(compareGroup))
                        .map((i) => buildSection(context, i, groups[i]!)),
                    if (widget.onLoadMore != null)
                      SliverFillRemainingBoxAdapter(
                          child: VisibilityDetector(
                              key: visibilityKey,
                              child: loadingStream.build(
                                (i) => Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      Gap(8),
                                      Text("Loading $plural").muted(),
                                    ],
                                  ).padBottom(16),
                                ),
                              ),
                              onVisibilityChanged: (v) {
                                if (v.visibleFraction > 0) {
                                  if (!loadingStream.value) {
                                    loadingStream.add(true);
                                    widget.onLoadMore
                                        ?.call(orderBy, groupBy, filterBy,
                                            groups.values.last.last)
                                        .then((value) {
                                      loadingStream.add(false);
                                    });
                                  }
                                }
                              }))
                  ],
                ),
          loading: SListView()));
}

List<Map<String, dynamic> Function(dynamic)> _destructures = [
  (dynamic d) => d.toMap() as Map<String, dynamic>,
  (dynamic d) => d.toJson() as Map<String, dynamic>,
  (dynamic d) => jsonDecode(d.toJson() as String),
  (dynamic d) => d.toProto3Json() as Map<String, dynamic>,
];

Map<Type, int> _destructureMethodCache = {};
List<Type> _destructureFails = [];

extension XJKL on Map<String, dynamic> {
  Iterable<String> get deepKeys => keys.expand((i) {
        dynamic v = this[i];
        if (v is Map<String, dynamic>) {
          return v.deepKeys.map((j) => "$i.$j");
        }

        return [i];
      });

  Iterable<dynamic> getValues(String keyPath) sync* {
    for (String i in keyPath.split(",")) {
      yield getValue(i);
    }
  }

  dynamic getValue(String keyPath) {
    Map<String, dynamic> buf = this;
    while (keyPath.contains(".")) {
      String tail = keyPath.split(".").last;
      keyPath = keyPath.substring(0, keyPath.length - tail.length - 1);
      dynamic val = buf[keyPath];

      if (val is Map<String, dynamic>) {
        buf = val;
      } else {
        return null;
      }
    }

    return buf[keyPath];
  }
}

extension XJI on Object {
  Map<String, dynamic> destructure() {
    if (_destructureFails.contains(runtimeType)) {
      throw "Destructure method not found for $runtimeType";
    }
    int? i = _destructureMethodCache[runtimeType];
    if (i != null) return _destructures[i](this);

    for (Map<String, dynamic> Function(dynamic) m in _destructures) {
      try {
        Map<String, dynamic> r = m(this);
        _destructureMethodCache[runtimeType] = _destructures.indexOf(m);
        return r;
      } catch (ignored) {}
    }

    _destructureFails.add(runtimeType);
    throw "Destructure method not found for $runtimeType";
  }
}

typedef CollectionItemIdentifier = String Function<T>(T item);

typedef CollectionItemMapper = Map<String, dynamic> Function<T>(T item);

String _defaultCollectionItemIdentifier<T>(T item) {
  String? id = ((item is ModelCrud) ? item.documentPath : null);
  if (id != null) return id;
  try {
    Map<String, dynamic> j = (item as dynamic).destructure();
    id = (j["id"] as String?) ??
        (j["uid"] as String?) ??
        (j["_id"] as String?) ??
        (j["i"] as String?) ??
        (j["n"] as String?) ??
        (j["t"] as String?) ??
        (j["name"] as String?) ??
        (j["title"] as String?) ??
        (j["label"] as String?);
  } catch (e) {}

  return id ?? item?.identityHash.toString() ?? item.toString();
}

Map<String, dynamic> _defaultCollectionItemMapper<T>(T item) {
  try {
    return (item as Object).destructure();
  } catch (e, es) {
    error(e);
    error(es);
    return {};
  }
}

Widget _defaultGroupBuilder(String? property, dynamic grouped) => Bar(
      ignoreContextSignals: true,
      title: Text(grouped.toString()),
      subtitle: property == null ? null : Text(property),
    );

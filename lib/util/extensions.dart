import 'package:arcane/arcane.dart';
import 'package:jiffy/jiffy.dart';

extension XDateTimeRangeArcane on DateTimeRange {
  DateTimeRange get toUtc => DateTimeRange(start.toUtc(), end.toUtc());

  DateTimeRange get toLocal => DateTimeRange(start.toLocal(), end.toLocal());

  DateTimeRange get fullDay => DateTimeRange(start.startOfDay, end.endOfDay);
}

extension XDateTimeStartEnds on DateTime {
  DateTime get startOfDay =>
      Jiffy.parseFromDateTime(this).startOf(Unit.day).dateTime;

  DateTime get endOfDay =>
      Jiffy.parseFromDateTime(this).endOf(Unit.day).dateTime;
}

extension XWidgetArcane on Widget {
  Widget withTooltip(String tooltip) =>
      Tooltip(tooltip: TooltipContainer(child: Text(tooltip)), child: this);

  Widget get iw => IntrinsicWidth(child: this);

  Widget get ih => IntrinsicHeight(child: this);

  Widget get asSliver {
    if (this is ListView) {
      return (this as ListView).asSliver;
    } else if (this is GridView) {
      return (this as GridView).asSliver;
    } else {
      return SliverToBoxAdapter(child: this);
    }
  }
}

extension XSliverListTransformer on ListView {
  SliverList get asSliver => SliverList(key: key, delegate: childrenDelegate);
}

extension XSliverGridTransformer on GridView {
  SliverGrid get asSliver => SliverGrid(
      key: key, gridDelegate: gridDelegate, delegate: childrenDelegate);
}

extension XStringArcane on String {
  Text get text => Text(this);
}

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
  Widget shimmer({bool loading = true}) => Skeletonizer(
        effect: ShimmerEffect(
            duration: Duration(milliseconds: 1500),
            baseColor: Arcane.globalTheme.shadThemeData.colorScheme.secondary,
            highlightColor:
                Arcane.globalTheme.shadThemeData.colorScheme.primary),
        enabled: loading,
        child: this,
      );

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

class StackTraceInfo {
  /// Constructs a [StackTraceInfo] object with the given stack trace.
  ///
  /// The stack trace is required to parse and extract detailed information.
  const StackTraceInfo({
    required StackTrace trace,
  }) : _trace = trace;

  /// The stack trace from which information is extracted.
  final StackTrace _trace;

  /// Retrieves the file information from the stack trace.
  ///
  /// This includes the file path, line number, and column number.
  /// Returns a list of strings containing the file path, line number, and column number.
  List<String> get fileInfo {
    final String traceString = _trace.toString().split('\n')[0];
    final int indexOfFile = traceString.indexOf(RegExp(r'file://'));
    return traceString.substring(indexOfFile + 'file://'.length).split(':');
  }

  /// Retrieves the file name from the stack trace.
  ///
  /// Returns the file name as a string.
  String get fileName {
    return fileInfo[0];
  }

  /// Retrieves the line number from the stack trace.
  ///
  /// Returns the line number as an integer.
  int get lineNumber {
    return int.parse(fileInfo[1]);
  }

  /// Retrieves the column number from the stack trace.
  ///
  /// Returns the column number as an integer.
  int get columnNumber {
    return int.parse(fileInfo[2].replaceAll(')', ''));
  }

  /// Retrieves the class name from the stack trace, if available.
  ///
  /// Returns the class name as a string, or `null` if the class name cannot be determined.
  String? get className {
    List<String> lines = _trace.toString().split('\n');
    List<String> finds = [];
    for (String methodInfo in lines) {
      List<String> classAndMethod = methodInfo.split('.');
      if (classAndMethod.length > 1 && !classAndMethod[1].startsWith('<')) {
        finds.add(classAndMethod[0].replaceAll('#0', '').replaceAll(' ', ''));
      }
    }

    String? s = finds.length >= 3 ? finds[2] : null;

    if (s != null) {
      if (s.contains("(")) {
        s = s.substring(0, s.indexOf("("));
      }

      if (s.startsWith("#")) {
        s = s.substring(2);
      }
    }

    return s;
  }

  /// Retrieves the method name from the stack trace, if available.
  ///
  /// Returns the method name as a string, or `null` if the method name cannot be determined.
  String? get methodName {
    final String methodInfo = _trace.toString().split('\n')[0];
    final List<String> classAndMethod = methodInfo.split('.');
    return classAndMethod.length > 1
        ? classAndMethod[1].startsWith('<')
            ? classAndMethod[0]
                .replaceAll('#0', '')
                .replaceAll(' ', '')
                .substring(
                    0,
                    (classAndMethod[0].indexOf('(') - 1) <= 0
                        ? 0
                        : classAndMethod[0].indexOf('(') - 1)
            : classAndMethod[1]
                .replaceAll('#0', '')
                .replaceAll(' ', '')
                .substring(
                    0,
                    (classAndMethod[1].indexOf('(') - 1) <= 0
                        ? 0
                        : classAndMethod[1].indexOf('(') - 1)
        : null;
  }
}

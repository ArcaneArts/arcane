import 'dart:math';

import 'package:arcane/arcane.dart';
import 'package:chat_color/chat_color.dart';
import 'package:fast_log/fast_log.dart';
import 'package:flutter/foundation.dart';
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

void setupArcaneDebug() {
  if (kDebugMode) {
    String blame() {
      return StackTraceInfo(trace: StackTrace.current).className ?? "?";
    }

    int overshot = 0;
    int lengthBuffer = 10;

    lLogOverride = (level, message) {
      String bl =
          "&r${" " * max(1, lengthBuffer - message.length)}\t\t@(#FF0c0024)&(#FF6940b8)&o${blame()}";
      String s = switch (level) {
        LogCategory.info => "@(#FFade5ff) &r &(#FFd6e7ff)$message$bl",
        LogCategory.error =>
          "@(#FFff3d3d) &r @(#FF2e0009)&(#FFff214e)&l$message$bl",
        LogCategory.verbose => "@(#FFb8afbd) &r &(#FF897c99)$message$bl",
        LogCategory.success =>
          "@(#FF54ff54) &r ${message.spin(0xFFafff96, 0xFF96ffce, unicorn: true)}$bl",
        LogCategory.actioned => "@(#FF9854ff) &r &(#FFd278ff)$message$bl",
        LogCategory.navigation => "@(#FFff8b42) &r &(#FFffebc7)$message$bl",
        LogCategory.network => "@(#FF0099ff) &r &(#FF1ca4ff)$message$bl",
        LogCategory.warning => "@(#FFfffb00) &r &(#FFffed85)&l$message$bl",
      }
          .chatColor;

      if (message.length > lengthBuffer) {
        lengthBuffer = message.length;
      } else {
        overshot++;
      }

      if (overshot > 50) {
        lengthBuffer--;
      }

      print(s);
    };
  }
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

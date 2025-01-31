import 'dart:math';
import 'dart:ui' as ui;

import 'package:chat_color/chat_color.dart';
import 'package:color/color.dart';
import 'package:fast_log/fast_log.dart';
import 'package:flutter/foundation.dart';
import 'package:tinycolor2/tinycolor2.dart';

import 'extensions.dart';

void infoAnnounce(Object message) => noticeAnnouncement(message.toString(),
    preformat: "&l&o&(#FFd6e7ff)", boxSpin: 0xFF394d57);

void errorAnnounce(Object message) => criticalAnnouncement(message.toString(),
    preformat: "&l&o&(#FFff214e)", boxSpin: 0xFF521a16);

void verboseAnnounce(Object message) => noticeAnnouncement(message.toString(),
    preformat: "&l&o&(#FF897c99)", boxSpin: 0xFF3d3442);

void successAnnounce(Object message) => noticeAnnouncement(message.toString(),
    preformat: "&l&o&(#FF96ffce)", boxSpin: 0xFF175717);

void actionedAnnounce(Object message) => noticeAnnouncement(message.toString(),
    preformat: "&l&o&(#FFd278ff)", boxSpin: 0xFF2e0866);

void navigationAnnounce(Object message) =>
    noticeAnnouncement(message.toString(),
        preformat: "&l&o&(#FFffebc7)", boxSpin: 0xFF593c29);

void networkAnnounce(Object message) => noticeAnnouncement(message.toString(),
    preformat: "&l&o&(#FF1ca4ff)", boxSpin: 0xFF1b303d);

void warningAnnounce(Object message) => criticalAnnouncement(message.toString(),
    preformat: "&l&o&(#FFffed85)", boxSpin: 0xFF4d4c13);

void setupArcaneDebug() {
  if (kDebugMode) {
    String blame() {
      return StackTraceInfo(trace: StackTrace.current).className ?? "?";
    }

    int overshot = 0;
    int lengthBuffer = 10;

    lLogOverride = (level, message) {
      message = message.replaceAll("@", "★");
      String bl =
          "&r${" " * max(1, min(lengthBuffer - message.length, 20))}\t\t@(#FF0c0024)&(#FF6940b8)&o${blame()}";
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
          .chatColor
          .replaceAll("★", "@");

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

int _argb2rgb(int argb) {
  return argb & 0x00FFFFFF;
}

String get _fgc => trueColorTrigger;
String get _bgc => trueColorBackgroundTrigger;

void announcement(
    {required String msg,
    required String preformat,
    required Color tl,
    required Color tr,
    required Color bl,
    required Color br,
    bool clip = false,
    bool thick = false,
    bool fringes = false}) {
  List<String> message = msg.split("\n");

  if (message.last.trim().isEmpty) {
    message.removeLast();
  }

  message = message.map((String s) => s.trim()).toList();

  int vpad = 1 + (thick ? 1 : 0);
  int h = message.length + vpad * 2;
  int w =
      message.fold(0, (int prev, String element) => max(prev, element.length)) +
          6;
  w = w % 2 == 0 ? w + 1 : w;

  double d1len = 1 / h;
  double d1wid = 1 / w;
  HsvColor hsvtl = tl.toHsvColor();
  HsvColor hsvtr = tr.toHsvColor();
  HsvColor hsvbl = bl.toHsvColor();
  HsvColor hsvbr = br.toHsvColor();
  String m = "";
  print("");
  for (int i = 0; i < h; i++) {
    double ht = i * d1len;

    StringBuffer sb = StringBuffer();

    if (i > vpad - 1 && i < h - vpad) {
      m = "${" " * ((w - message[i - vpad].length) ~/ 2)}${message[i - vpad]}";
    }

    for (int j = 0; j < w; j++) {
      double wt = j * d1wid;

      HsvColor left = HsvColor(
        _lerpHue(hsvtl.h.toDouble(), hsvbl.h.toDouble(), ht),
        _lerp(hsvtl.s.toDouble(), hsvbl.s.toDouble(), ht),
        _lerp(hsvtl.v.toDouble(), hsvbl.v.toDouble(), ht),
      );

      HsvColor right = HsvColor(
        _lerpHue(hsvtr.h.toDouble(), hsvbr.h.toDouble(), ht),
        _lerp(hsvtr.s.toDouble(), hsvbr.s.toDouble(), ht),
        _lerp(hsvtr.v.toDouble(), hsvbr.v.toDouble(), ht),
      );

      HexColor c = HsvColor(
        _lerpHue(left.h.toDouble(), right.h.toDouble(), wt) % 360,
        _lerp(left.s.toDouble(), right.s.toDouble(), wt),
        _lerp(left.v.toDouble(), right.v.toDouble(), wt),
      ).toHexColor();

      if (fringes && (i == 0 || i + 1 == h) && j % 2 == 0) {
        c = Color.hex("#000000").toHexColor();
      }

      if (clip && ((i == 0 || i + 1 == h) && (j == 0 || j + 1 == w))) {
        c = Color.hex("#000000").toHexColor();
      }

      sb.write(
          "$_bgc(${c.toCssString()})${i > vpad - 1 && i < h - vpad && j < m.length ? m[j] == " " ? m[j] : "$preformat${m[j]}${j + 1 == m.length ? "&r" : ""}" : " "}");
    }

    print(sb.toString().chatColor);
  }
  print("");
}

void criticalAnnouncement(String msg,
    {String preformat = "&l&n&o&e",
    List<int> colors = const [0x4a2c2c, 0x4a3b2c, 0x4a492c, 0x4a422c],
    int? boxSpin}) {
  assert(colors.length == 4, "colors must have 4 values");

  if (boxSpin != null) {
    colors = [
      _argb2rgb(ui.Color(boxSpin).value),
      _argb2rgb(ui.Color(boxSpin).spin(-22).value),
      _argb2rgb(ui.Color(boxSpin).spin(22).value),
      _argb2rgb(ui.Color(boxSpin).spin(44).value)
    ];
  }
  announcement(
      msg: msg,
      fringes: true,
      thick: true,
      preformat: preformat,
      tl: Color.hex("#${colors[0].toRadixString(16)}"),
      tr: Color.hex("#${colors[1].toRadixString(16)}"),
      br: Color.hex("#${colors[2].toRadixString(16)}"),
      bl: Color.hex("#${colors[3].toRadixString(16)}"));
}

void noticeAnnouncement(String msg,
    {String preformat = "&l&o&b",
    List<int> colors = const [0x2c404a, 0x2c364a, 0x2c304a, 0x2f2c4a],
    int? boxSpin}) {
  assert(colors.length == 4, "colors must have 4 values");

  if (boxSpin != null) {
    colors = [
      _argb2rgb(ui.Color(boxSpin).value),
      _argb2rgb(ui.Color(boxSpin).spin(-11).value),
      _argb2rgb(ui.Color(boxSpin).spin(11).value),
      _argb2rgb(ui.Color(boxSpin).spin(33).value)
    ];
  }
  announcement(
      thick: false,
      msg: msg,
      fringes: false,
      clip: true,
      preformat: preformat,
      tl: Color.hex("#${colors[0].toRadixString(16)}"),
      tr: Color.hex("#${colors[1].toRadixString(16)}"),
      br: Color.hex("#${colors[2].toRadixString(16)}"),
      bl: Color.hex("#${colors[3].toRadixString(16)}"));
}

int _rgb2argb(int rgb) {
  return 0xFF000000 | rgb;
}

double _bilerp(double a, double b, double c, double d, double fx, double fy) {
  return _lerp(_lerp(a, b, fx), _lerp(c, d, fx), fy);
}

double _bilerpHue(
    double a, double b, double c, double d, double fx, double fy) {
  return _lerp(_lerpHue(a, b, fx), _lerpHue(c, d, fx), fy);
}

double _lerp(double a, double b, double f) => a + f * (b - a);

double _lerpHue(double a, double b, double f) {
  double d = b - a;
  if (d > 180) {
    b -= 360;
  } else if (d < -180) {
    b += 360;
  }
  return _lerp(a, b, f) % 360;
}

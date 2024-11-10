import 'dart:async';

import 'package:arcane/arcane.dart';
import 'package:flutter/services.dart';

enum IconProxySrc { phosphor, ionic, material, cupertino }

Map<IconProxySrc, Set<String>> knownVariants = {
  IconProxySrc.phosphor: {
    "_bold",
    "_fill",
    "_light",
    "_thin",
  },
  IconProxySrc.ionic: {
    "_sharp",
    "_outline",
  },
  IconProxySrc.material: {"_round", "_sharp", "_outline"},
  IconProxySrc.cupertino: {"_fill"},
};

late Map<IconProxySrc, IconMapping> mappings;
List<Function()> smashers = [];

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  mappings = await buildMappings();
  print("Built mappingS!");
  for (var e in smashers) {
    e();
  }
}

Future<Map<IconProxySrc, IconMapping>> buildMappings() async {
  Map<IconProxySrc, IconMapping> m = {};
  List<Future> work = [];
  int n = 0;
  for (IconProxySrc psrc in IconProxySrc.values) {
    work.add(rootBundle
        .loadString("iconsets/${psrc.name}.txt")
        .then((src) => src.split("\n").where((e) =>
            e.trim().isNotEmpty &&
            e.contains(" = ") &&
            e.contains("(0x") &&
            e.contains(";") &&
            !e.contains(">") &&
            !e.contains("<") &&
            !e.trim().startsWith("/")))
        .then((src) {
      Map<String, int> imap = {};

      for (String i in src) {
        List<String> parts = i.split(" = ");
        String left = parts[0].trim();
        String right = parts[1].trim();
        right = right.split("(0x")[1];
        right = (right.contains(",")
                ? right.split(",").first
                : right.contains(")")
                    ? right.split(")").first
                    : right)
            .trim();
        int? code = int.tryParse(right, radix: 16);
        String name = left.split(" ").last.trim();

        if (code != null) {
          imap[name] = code;
          n++;
        } else {
          print("Failed to parse $i");
        }
      }

      m[psrc] = IconMapping(psrc, imap);
      print("Loaded ${psrc.name} with ${imap.length} icons");
    }));
  }

  await Future.wait(work);
  print("Loaded $n icons");
  return m;
}

T _wait<T>(Future<T> t) {
  late T v;
  Completer<T> c = Completer();
  t.then((value) {
    c.complete(value);
    v = value;
  });

  while (!c.isCompleted) {
    Future.delayed(Duration.zero);
  }

  return v;
}

class MappedIcon {
  final String name;
  final int code;
  final IconProxySrc src;
  final IconData iconData;
  final List<MappedIcon>? variants;

  MappedIcon({
    required this.name,
    required this.code,
    required this.src,
    required this.iconData,
    this.variants,
  });
}

class IconMapping {
  final IconProxySrc src;
  final Map<String, int> mapping;
  late List<String> sorted;
  late List<MappedIcon> icons;

  IconMapping(this.src, this.mapping) {
    sorted = mapping.keys.toList();
    sorted.sort();
    smashers.add(squash);
  }

  IconData getIconData(int code) {
    switch (src) {
      case IconProxySrc.phosphor:
        return IconData(code,
            fontFamily: 'Phosphor', fontPackage: "flutter_phosphor_icons");
      case IconProxySrc.ionic:
        return IconData(code, fontFamily: 'Ionicons', fontPackage: "ionicons");
      case IconProxySrc.material:
        return IconData(code, fontFamily: 'MaterialIcons');
      case IconProxySrc.cupertino:
        return IconData(code, fontFamily: 'CupertinoIcons');
    }
  }

  void squash() {
    icons = [];
    if (knownVariants[src]?.isEmpty ?? true) {
      icons = sorted
          .map((e) => MappedIcon(
                name: e,
                code: mapping[e]!,
                src: src,
                iconData: getIconData(mapping[e]!),
              ))
          .toList();
    } else {
      Map<String, Set<String>> v = {};

      List<String> variants = knownVariants[src]!.toList();
      for (String i in sorted) {
        bool isVariant = false;
        for (String j in variants) {
          if (i.endsWith(j)) {
            String root = i.substring(0, i.length - j.length);
            isVariant = true;
            if (!v.containsKey(root)) {
              v[root] = {};
            }

            v[root]!.add(i);
            break;
          }
        }

        if (!isVariant) {
          if (!v.containsKey(i)) {
            v[i] = {};
          }

          v[i]!.add(i);
        }
      }

      for (String i in v.keys) {
        icons.add(MappedIcon(
            name: i,
            code: _lmap(i),
            src: src,
            iconData: getIconData(mapping[i]!),
            variants: v[i]
                ?.where((g) => g != i)
                .map((k) => MappedIcon(
                    name: k,
                    code: _lmap(k),
                    src: src,
                    iconData: getIconData(mapping[k]!)))
                .toList()));
      }
    }
  }

  int _lmap(String s) {
    if (!mapping.containsKey(s)) {
      print("No mapping for $s on $src");
    }

    return mapping[s]!;
  }
}

class IconProxy {
  final String name;
  final int code;
  final IconProxySrc src;

  const IconProxy({required this.name, required this.code, required this.src});

  static IconProxy fromValue(String value) {
    List<String> parts = value.split(":");
    return IconProxy(
        name: parts[0],
        code: int.parse(parts[2]),
        src: IconProxySrc.values[int.parse(parts[1])]);
  }

  String toValue() => "$name:${src.index}:$code";

  IconData get iconData {
    switch (src) {
      case IconProxySrc.phosphor:
        return IconData(code,
            fontFamily: 'Phosphor', fontPackage: "flutter_phosphor_icons");
      case IconProxySrc.ionic:
        return IconData(code, fontFamily: 'Ionicons', fontPackage: "ionicons");
      case IconProxySrc.material:
        return IconData(code, fontFamily: 'MaterialIcons');
      case IconProxySrc.cupertino:
        return IconData(code, fontFamily: 'CupertinoIcons');
    }
  }
}

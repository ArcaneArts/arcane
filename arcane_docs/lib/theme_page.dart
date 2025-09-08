import 'package:docs/main.dart';
import 'package:docs/pages/docs_page.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

final Map<String, ColorScheme> colorSchemes = {
  'lightBlue': ColorSchemes.lightBlue,
  'darkBlue': ColorSchemes.darkBlue,
  'lightGreen': ColorSchemes.lightGreen,
  'darkGreen': ColorSchemes.darkGreen,
  'lightDefaultColor': ColorSchemes.lightDefaultColor,
  'darkDefaultColor': ColorSchemes.darkDefaultColor,
  'lightOrange': ColorSchemes.lightOrange,
  'darkOrange': ColorSchemes.darkOrange,
  'lightRed': ColorSchemes.lightRed,
  'darkRed': ColorSchemes.darkRed,
  'lightRose': ColorSchemes.lightRose,
  'darkRose': ColorSchemes.darkRose,
  'lightViolet': ColorSchemes.lightViolet,
  'darkViolet': ColorSchemes.darkViolet,
  'lightYellow': ColorSchemes.lightYellow,
  'darkYellow': ColorSchemes.darkYellow,
};

String? nameFromColorScheme(ColorScheme scheme) {
  return colorSchemes.keys
      .where((key) => colorSchemes[key] == scheme)
      .firstOrNull;
}

class _ThemePageState extends State<ThemePage> {
  late Map<String, Color> colors;
  late double radius;
  late double scaling;
  late double surfaceOpacity;
  late double surfaceBlur;
  late double spin;
  late double contrast;
  late ColorScheme colorScheme;
  bool customColorScheme = false;
  bool applyDirectly = true;

  final OnThisPage customColorSchemeKey = OnThisPage();
  final OnThisPage premadeColorSchemeKey = OnThisPage();
  final OnThisPage radiusKey = OnThisPage();
  final OnThisPage scalingKey = OnThisPage();
  final OnThisPage surfaceOpacityKey = OnThisPage();
  final OnThisPage surfaceBlurKey = OnThisPage();
  final OnThisPage contrastKey = OnThisPage();
  final OnThisPage spinKey = OnThisPage();
  final OnThisPage codeKey = OnThisPage();

  @override
  void initState() {
    super.initState();
    colors = ColorSchemes.darkViolet.toColorMap();
    spin = 0;
    contrast = 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyAppState state = Data.of(context);
    colorScheme = state.colorScheme;
    colors = colorScheme.toColorMap();
    radius = state.radius;
    customColorScheme = nameFromColorScheme(colorScheme) == null;
    scaling = state.scaling;
    surfaceOpacity = state.surfaceOpacity;
    surfaceBlur = state.surfaceBlur;
  }

  @override
  Widget build(BuildContext context) {
    MyAppState state = Data.of(context);
    return DocsPage(
      name: 'theme',
      onThisPage: {
        'Custom color scheme': customColorSchemeKey,
        'Premade color scheme': premadeColorSchemeKey,
        'Radius': radiusKey,
        'Scaling': scalingKey,
        'Surface opacity': surfaceOpacityKey,
        'Surface blur': surfaceBlurKey,
        'Spin': spinKey,
        'Contrast': contrastKey,
        'Code': codeKey,
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Theme').h1(),
          const Text('Customize the look and feel of your app.').lead(),
          const Text('Custom color scheme').h2().anchored(customColorSchemeKey),
          // grid color
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                      'You can use your own color scheme to customize the look and feel of your app.')),
            ],
          ).p(),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            children: colors.keys.map(buildGridTile).toList(),
          ).p(),
          const Text('Premade color schemes')
              .h2()
              .anchored(premadeColorSchemeKey),
          // Text('You can also use premade color schemes.').p(),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                      'You can also use premade color schemes to customize the look and feel of your app.')),
            ],
          ).p(),
          Wrap(
            runSpacing: 8,
            spacing: 8,
            children:
                colorSchemes.keys.map(buildPremadeColorSchemeButton).toList(),
          ).p(),
          Text('Radius').h2().anchored(radiusKey),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                      'You can customize how rounded your app looks by changing the radius.')),
            ],
          ).p(),
          ContextMenu(
              items: [
                MenuButton(
                  leading: Icon(Icons.refresh_rounded),
                  onPressed: () => setState(() {
                    radius = 0.4;
                    if (applyDirectly) {
                      state.changeRadius(radius);
                    }
                  }),
                  child: Text("Reset"),
                )
              ],
              child: Slider(
                value: SliderValue.single(radius),
                onChanged: (value) {
                  setState(() {
                    radius = value.value;
                    if (applyDirectly) {
                      state.changeRadius(radius);
                    }
                  });
                },
                min: 0,
                max: 2,
                divisions: 20,
              ).p()),
          const Text('Scaling').h2().anchored(scalingKey),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                      'You can customize the scale of shadcn_flutter components by changing the scaling.')),
            ],
          ).p(),
          ContextMenu(
              items: [
                MenuButton(
                  leading: Icon(Icons.refresh_rounded),
                  onPressed: () => setState(() {
                    scaling = 1.0;
                    if (applyDirectly) {
                      state.changeScaling(scaling);
                    }
                  }),
                  child: Text("Reset"),
                )
              ],
              child: Slider(
                value: SliderValue.single(scaling),
                onChanged: (value) {
                  setState(() {
                    scaling = value.value;
                    if (applyDirectly) {
                      state.changeScaling(scaling);
                    }
                  });
                },
                min: 0.5,
                max: 1.5,
                divisions: 20,
              ).p()),
          const Gap(16),
          const Alert(
            leading: Icon(RadixIcons.infoCircled),
            content: Text(
                'This does not scale the entire app. Only shadcn_flutter components are affected.'),
          ),
          const Text('Surface opacity').h2().anchored(surfaceOpacityKey),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                      'You can customize the opacity of the surface by changing the surface opacity.')),
            ],
          ).p(),
          ContextMenu(
              items: [
                MenuButton(
                  leading: Icon(Icons.refresh_rounded),
                  onPressed: () => setState(() {
                    surfaceOpacity = 0.66;
                    if (applyDirectly) {
                      state.changeSurfaceOpacity(surfaceOpacity);
                    }
                  }),
                  child: Text("Reset"),
                )
              ],
              child: Slider(
                value: SliderValue.single(surfaceOpacity),
                onChanged: (value) {
                  setState(() {
                    surfaceOpacity = value.value;
                    if (applyDirectly) {
                      state.changeSurfaceOpacity(surfaceOpacity);
                    }
                  });
                },
                min: 0,
                max: 1,
                divisions: 100,
              ).p()),
          const Text('Surface blur').h2().anchored(surfaceBlurKey),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                      'You can customize the blur of the surface by changing the surface blur.')),
            ],
          ).p(),
          ContextMenu(
              items: [
                MenuButton(
                  leading: Icon(Icons.refresh_rounded),
                  onPressed: () => setState(() {
                    surfaceBlur = 18;
                    if (applyDirectly) {
                      state.changeSurfaceBlur(surfaceBlur);
                    }
                  }),
                  child: Text("Reset"),
                )
              ],
              child: Slider(
                value: SliderValue.single(surfaceBlur),
                onChanged: (value) {
                  setState(() {
                    surfaceBlur = value.value;
                    if (applyDirectly) {
                      state.changeSurfaceBlur(surfaceBlur);
                    }
                  });
                },
                min: 0,
                max: 36,
                divisions: 36,
              ).p()),

          const Text('Spin').h2().anchored(spinKey),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                      'You can spin the hue of the entire color scheme in degrees')),
            ],
          ).p(),
          ContextMenu(
              items: [
                MenuButton(
                  leading: Icon(Icons.refresh_rounded),
                  onPressed: () => setState(() {
                    spin = 0;
                    if (applyDirectly) {
                      state.changeSpin(spin);
                    }
                  }),
                  child: Text("Reset"),
                )
              ],
              child: Slider(
                value: SliderValue.single(spin),
                onChanged: (value) {
                  setState(() {
                    spin = value.value;
                    if (applyDirectly) {
                      state.changeSpin(spin);
                    }
                  });
                },
                max: 360,
                divisions: 360,
              ).p()),

          const Text('Contrast').h2().anchored(contrastKey),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                      'You can change the contrast of the entire color scheme. -10 to 10')),
            ],
          ).p(),
          ContextMenu(
              items: [
                MenuButton(
                  leading: Icon(Icons.refresh_rounded),
                  onPressed: () => setState(() {
                    contrast = 0;
                    if (applyDirectly) {
                      state.changeContrast(contrast);
                    }
                  }),
                  child: Text("Reset"),
                )
              ],
              child: Slider(
                value: SliderValue.single(contrast + 10),
                onChanged: (value) {
                  value = SliderValue.single(value.value - 10.0);
                  setState(() {
                    contrast = value.value;
                    if (applyDirectly) {
                      state.changeContrast(contrast);
                    }
                  });
                },
                min: 0,
                max: 20,
                divisions: 200,
              ).p()),

          const Text('Code').h2().anchored(codeKey),
          const Text('Use the following code to apply the color scheme.').p(),
          CodeSnippet(
            code: customColorScheme ? buildCustomCode() : buildPremadeCode(),
            mode: 'dart',
          ).p(),
        ],
      ),
    );
  }

  String buildCustomCode() {
    bool isDark = colorScheme.background.computeLuminance() < 0.5;
    StringBuffer buffer = StringBuffer("ArcaneApp(\n");
    buffer.writeln("\t...");
    buffer.writeln("\ttheme: ArcaneTheme(");
    buffer.writeln("\t\tthemeMode: ThemeMode.${isDark ? "dark" : "light"},");
    buffer.writeln("\t\tscheme: ContrastedColorScheme(");
    buffer.writeln("\t\t\t${isDark ? "dark" : "light"}: ColorScheme(");
    buffer.writeln(
        "\t\t\t\tbrightness: ${isDark ? "Brightness.dark" : "Brightness.light"},");
    for (var key in colors.keys) {
      String hex = colors[key]!.value.toRadixString(16);
      buffer.writeln("\t\t\t\t$key: Color(0x$hex),");
    }
    buffer.writeln("\t\t\t),");
    buffer.writeln("\t\t\t${isDark ? "light" : "dark"}: ColorScheme(");
    buffer.writeln(
        "\t\t\t\tbrightness: ${isDark ? "Brightness.light" : "Brightness.dark"},");
    buffer
        .writeln("\t\t\t//TODO: Add ${isDark ? "light" : "dark"} scheme here");
    buffer.writeln("\t\t\t),");
    buffer.writeln("\t\t),");

    if (surfaceBlur != 18) {
      buffer.writeln("\t\tsurfaceBlur: $surfaceBlur,");
    }

    if (spin != 0) {
      buffer.writeln("\t\tspin: $spin,");
    }

    if (contrast != 0) {
      buffer.writeln("\t\tcontrast: $contrast,");
    }

    if (surfaceOpacity != 0.66) {
      buffer.writeln("\t\tsurfaceOpacity: $surfaceOpacity,");
    }

    if (radius != 0.4) {
      buffer.writeln("\t\tradius: $radius,");
    }

    if (scaling != 1.0) {
      buffer.writeln("\t\tscaling: $scaling,");
    }

    buffer.writeln("\t)");
    buffer.writeln(")");
    return buffer.toString();
  }

  String buildPremadeCode() {
    // return 'ColorSchemes.${nameFromColorScheme(colorScheme)}()';
    String name = nameFromColorScheme(colorScheme)!;
    StringBuffer buffer = StringBuffer("ArcaneApp(\n");

    buffer.writeln("\t...");
    buffer.writeln("\ttheme: ArcaneTheme(");

    buffer.writeln("\t\t// Use ThemeMode.system for system theme switching");
    buffer.writeln(
        "\t\tthemeMode: ThemeMode.${name.startsWith("dark") ? "dark" : "light"},");
    buffer.writeln(
        "\t\tscheme: ContrastedColorScheme.fromScheme(ColorSchemes.${name.replaceAll("dark", "").replaceAll("light", "").toLowerCase()}),");

    if (surfaceBlur != 18) {
      buffer.writeln("\t\tsurfaceBlur: $surfaceBlur,");
    }

    if (spin != 0) {
      buffer.writeln("\t\tspin: $spin,");
    }

    if (contrast != 0) {
      buffer.writeln("\t\tcontrast: $contrast,");
    }

    if (surfaceOpacity != 0.66) {
      buffer.writeln("\t\tsurfaceOpacity: $surfaceOpacity,");
    }

    if (radius != 0.4) {
      buffer.writeln("\t\tradius: $radius,");
    }

    if (scaling != 1.0) {
      buffer.writeln("\t\tscaling: $scaling,");
    }

    buffer.writeln("\t)");
    buffer.writeln(")");
    return buffer.toString();
  }

  Color getInvertedColor(Color color) {
    return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  Widget buildPremadeColorSchemeButton(String name) {
    var scheme = colorSchemes[name]!;
    return !customColorScheme && scheme == colorScheme
        ? PrimaryButton(
            onPressed: () {
              setState(() {
                colorScheme = scheme;
                colors = colorScheme.toColorMap();
                customColorScheme = false;
                if (applyDirectly) {
                  MyAppState state = Data.of(context);
                  state.changeColorScheme(colorScheme);
                }
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: scheme.primaryForeground,
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                ),
                const Gap(8),
                Text(name),
              ],
            ),
          )
        : OutlineButton(
            onPressed: () {
              setState(() {
                colorScheme = scheme;
                colors = colorScheme.toColorMap();
                customColorScheme = false;
                if (applyDirectly) {
                  MyAppState state = Data.of(context);
                  state.changeColorScheme(colorScheme);
                }
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: scheme.primaryForeground,
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                ),
                const Gap(8),
                Text(name),
              ],
            ),
          );
  }

  Widget buildGridTile(String name) {
    final colors = this.colors;
    return Container(
      constraints: const BoxConstraints(
        minWidth: 100,
        minHeight: 100,
      ),
      child: Builder(builder: (context) {
        return GestureDetector(
          onTap: () {
            showColorPicker(
              context: context,
              color: ColorDerivative.fromColor(colors[name]!),
              offset: const Offset(0, 8),
              onColorChanged: (value) {
                setState(() {
                  colors[name] = value.toColor();
                  customColorScheme = true;
                  if (applyDirectly) {
                    MyAppState state = Data.of(context);
                    state.changeColorScheme(ColorScheme.fromColors(
                        colors: colors, brightness: colorScheme.brightness));
                  }
                });
              },
            );
          },
          child: FocusableActionDetector(
            mouseCursor: SystemMouseCursors.click,
            child: FittedBox(
              child: AnimatedContainer(
                duration: kDefaultDuration,
                width: 200,
                height: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors[name],
                ),
                child: Stack(
                  children: [
                    Text(name,
                        style:
                            TextStyle(color: getInvertedColor(colors[name]!))),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Text(
                        colors[name]!.value.toRadixString(16),
                        style: TextStyle(
                          color: getInvertedColor(colors[name]!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

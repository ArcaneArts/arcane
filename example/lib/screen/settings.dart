import 'package:arcane/arcane.dart';

Map<String, dynamic> _memSet = {};

EnumOption<ThemeMode> optThemeMode = EnumOption(
    name: "Brightness",
    defaultValue: ThemeMode.system,
    description: "Controls the brightness of the app appearance.",
    icon: Icons.sun_fill,
    reader: () => _memSet["theme_mode"],
    writer: (t) => _memSet["theme_mode"] = t,
    decorator: (e) => Basic(title: Text(e.name.capitalize())),
    options: ThemeMode.values);

BoolOption optLowPowerMode = BoolOption(
    name: "Low Power Mode",
    defaultValue: false,
    icon: Icons.battery_charging_fill,
    description: "Some kind of power saving mechanic. Probably does nothing.",
    reader: () => _memSet["lpm"],
    writer: (t) => _memSet["lpm"] = t);

StringOption optName = StringOption(
    name: "My Name",
    defaultValue: "Joe",
    icon: Icons.person_fill,
    description: "What are you called?",
    reader: () => _memSet["name"],
    writer: (t) => _memSet["name"] = t);

IntOption optAge = IntOption(
    name: "My Age",
    defaultValue: 28,
    icon: Icons.timer_fill,
    description: "How old are you?",
    reader: () => _memSet["age"],
    writer: (t) => _memSet["age"] = t);

OptionScreen optScreen = OptionScreen(
    name: "Advanced",
    options: [optLowPowerMode],
    description: "This is for advanced Settings",
    icon: Icons.activity_fill);

OptionGroup optGroup = OptionGroup(
    name: "Appearance",
    options: [optThemeMode],
    description: "This is an option group for appearance settings",
    icon: Icons.activity_fill);

OptionScreen optMain = OptionScreen(
    name: "Settings", options: [optName, optAge, optScreen, optGroup]);

class ExampleSettings extends StatelessWidget {
  const ExampleSettings({super.key});

  @override
  Widget build(BuildContext context) => SettingsScreen(options: optMain);
}

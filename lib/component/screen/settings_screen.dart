import 'package:arcane/arcane.dart';

Map<String, dynamic> _storage = {};

class TestSettings extends StatelessWidget {
  const TestSettings({super.key});

  @override
  Widget build(BuildContext context) => ArcaneScreen(
          child: Collection(
        children: [
          Gap(16),
          CardSection(
            leadingIcon: Icons.text_aa,
            subtitleText: "Represents Text Inputs",
            titleText: "Strings",
            thumbHash: "H3IFHI4ri5RQpWdCen0rUPLtCQ",
            children: [
              ArcaneInput.text(
                  name: "First Name",
                  placeholder: "Daniel",
                  getter: () async => _storage["fname"],
                  setter: (v) async => _storage["fname"] = v),
              ArcaneInput.textArea(
                  name: "Bio",
                  placeholder: "Some bio or something...",
                  description: "Some kind of description",
                  getter: () async => _storage["fname"],
                  setter: (v) async => _storage["fname"] = v),
            ],
          ),
          Gap(16),
          CardSection(
            leadingIcon: Icons.dots_nine,
            subtitleText: "Represents Enum Inputs",
            thumbHash: "1SgOHAR6KJQIeJp3eYhrYKIGFg",
            titleText: "Enums",
            children: [
              ArcaneInput.select<CrossAxisAlignment>(
                  name: "Cross Axis Alignment",
                  defaultValue: CrossAxisAlignment.start,
                  options: CrossAxisAlignment.values,
                  getter: () async => _storage["caa"],
                  setter: (v) async => _storage["caa"] = v),
              ArcaneInput.selectCards<ThemeMode>(
                  name: "Theme Mode",
                  defaultValue: ThemeMode.system,
                  options: ThemeMode.values,
                  getter: () async => _storage["st"],
                  setter: (v) async => _storage["st"] = v),
            ],
          ),
          Gap(16),
          CardSection(
            leadingIcon: Icons.user_switch,
            subtitleText: "Represents Boolean Inputs",
            titleText: "Bool",
            thumbHash: "HBkSHYSIeHiPiHh8eJd4eTN0EEQG",
            children: [
              ArcaneInput.checkbox(
                  name: "Its a bool",
                  getter: () async => _storage["a"],
                  setter: (v) async => _storage["a"] = v),
              ArcaneInput.checkbox(
                  name: "With a description",
                  description:
                      "Heres some random description about this nonsense",
                  getter: () async => _storage["b"],
                  setter: (v) async => _storage["b"] = v),
              ArcaneInput.checkbox(
                  icon: Icons.address_book,
                  name: "With an icon",
                  description: "And some kind of description",
                  getter: () async => _storage["c"],
                  setter: (v) async => _storage["c"] = v),
            ],
          ),
          Gap(16),
          CardSection(
            leadingIcon: Icons.calendar_blank,
            titleText: "Date & Time",
            thumbHash: "3PcNNYSFeXh/d3eld0iHZoZgVwh2",
            subtitleText: "Represents Date / Time Inputs",
            children: [
              ArcaneInput.date(
                  name: "Its Date Time",
                  getter: () async => _storage["d"],
                  setter: (v) async => _storage["d"] = v),
              ArcaneInput.time(
                  name: "Now's the Time!",
                  getter: () async => _storage["d2"],
                  setter: (v) async => _storage["d2"] = v),
            ],
          ),
          Gap(16),
          CardSection(
            leadingIcon: Icons.color_fill_outline_ionic,
            titleText: "Colors",
            thumbHash: "1QcSHQRnh493V4dIh4eXh1h4kJUI",
            subtitleText: "Represents Color Inputs",
            children: [
              ArcaneInput.color(
                  name: "Color Picker",
                  defaultValue: Colors.red,
                  getter: () async => _storage["d2"],
                  setter: (v) async => _storage["d2"] = v)
            ],
          ),
          Gap(16)
        ],
      ).padSliverHorizontal(16));
}

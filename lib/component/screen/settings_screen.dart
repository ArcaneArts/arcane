import 'package:arcane/arcane.dart';
import 'package:arcane/component/card_section.dart';
import 'package:arcane/component/settings/bool_node.dart';
import 'package:arcane/component/settings/core.dart';
import 'package:arcane/component/settings/date_node.dart';
import 'package:arcane/component/settings/enum_node.dart';
import 'package:arcane/component/settings/string_node.dart';
import 'package:arcane/component/settings/time_node.dart';

Map<String, dynamic> _storage = {};

class TestSettings extends StatelessWidget {
  const TestSettings({super.key});

  @override
  Widget build(BuildContext context) => ArcaneScreen(
          child: Collection(
        children: [
          Gap(16),
          CardSection(
            titleText: "Strings",
            thumbHash: "H3IFHI4ri5RQpWdCen0rUPLtCQ",
            children: [
              KField<String>(
                  meta: KMeta(name: "First Name", placeholder: "Daniel"),
                  provider: KMapProvider(defaultValue: "", storage: _storage),
                  builder: (context) => KUIString()),
              KField<String>(
                  meta: KMeta(name: "Last Name", placeholder: "Mills"),
                  provider: KMapProvider(defaultValue: "", storage: _storage),
                  builder: (context) => KUIString()),
              KField<String>(
                  meta: KMeta(
                    name: "Bio",
                    placeholder: "Some bio or something...",
                  ),
                  provider: KMapProvider(defaultValue: "", storage: _storage),
                  builder: (context) => KUIString(
                        maxLines: 5,
                        minLines: 3,
                      ))
            ],
          ),
          Gap(16),
          CardSection(
            thumbHash: "1SgOHAR6KJQIeJp3eYhrYKIGFg",
            titleText: "Enums",
            children: [
              KField<CrossAxisAlignment>(
                  meta: KMeta(
                    name: "Cross Axis Alignment",
                  ),
                  provider: KMapProvider(
                      defaultValue: CrossAxisAlignment.start,
                      storage: _storage),
                  builder: (context) => KUIEnumNode<CrossAxisAlignment>(
                        options: CrossAxisAlignment.values,
                      )),
              KField<ThemeMode>(
                  meta: KMeta(
                    name: "Theme Mode",
                  ),
                  provider: KMapProvider(
                      defaultValue: ThemeMode.system, storage: _storage),
                  builder: (context) => KUIEnumNode<ThemeMode>(
                        options: ThemeMode.values,
                      )),
            ],
          ),
          Gap(16),
          CardSection(
            titleText: "Bool",
            children: [
              KField<bool>(
                  meta: KMeta(
                    name: "Its a bool",
                  ),
                  provider:
                      KMapProvider(defaultValue: false, storage: _storage),
                  builder: (context) => KUIBoolNode()),
              KField<bool>(
                  meta: KMeta(
                      name: "With a description",
                      description:
                          "Heres some random description about this nonsense"),
                  provider:
                      KMapProvider(defaultValue: false, storage: _storage),
                  builder: (context) => KUIBoolNode()),
              KField<bool>(
                  meta: KMeta(
                      icon: Icons.address_book,
                      name: "With an icon",
                      description: "And some kind of description"),
                  provider:
                      KMapProvider(defaultValue: false, storage: _storage),
                  builder: (context) => KUIBoolNode()),
            ],
          ),
          Gap(16),
          CardSection(
            titleText: "Date & Time",
            children: [
              KField<DateTime>(
                  meta: KMeta(
                    name: "Its Date Time",
                  ),
                  provider: KMapProvider(
                      defaultValue: DateTime.now(), storage: _storage),
                  builder: (context) => KUIDateNode()),
              KField<DateTime>(
                  meta: KMeta(
                    name: "Now's the Time!",
                  ),
                  provider: KMapProvider(
                      defaultValue: DateTime.now(), storage: _storage),
                  builder: (context) => KUITimeNode()),
            ],
          ),
          Gap(16)
        ],
      ).padSliverHorizontal(16));
}

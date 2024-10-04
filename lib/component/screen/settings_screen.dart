import 'package:arcane/arcane.dart';
import 'package:rxdart/rxdart.dart';

BehaviorSubject<int> _su = BehaviorSubject.seeded(0);
void _settingsUpdate() => _su.add(_su.value++);

class BoolOption extends OptionField<bool> {
  BoolOption({
    required super.name,
    super.defaultValue = false,
    super.description,
    super.icon,
    required super.reader,
    required super.writer,
    super.shouldShow = _defShouldShow,
  });

  @override
  Widget get built => BoolOptionView(option: this);
}

class StringOption extends OptionField<String> {
  StringOption({
    required super.name,
    super.defaultValue = "",
    super.description,
    super.icon,
    required super.reader,
    required super.writer,
    super.shouldShow = _defShouldShow,
  });

  @override
  Widget get built => StringOptionView(option: this);
}

class IntOption extends OptionField<int> {
  IntOption({
    required super.name,
    super.defaultValue = 0,
    super.description,
    super.icon,
    required super.reader,
    required super.writer,
    super.shouldShow = _defShouldShow,
  });

  @override
  Widget get built => IntOptionView(option: this);
}

class DoubleOption extends OptionField<double> {
  DoubleOption({
    required super.name,
    super.defaultValue = 0.0,
    super.description,
    super.icon,
    required super.reader,
    required super.writer,
    super.shouldShow = _defShouldShow,
  });

  @override
  Widget get built => DoubleOptionView(option: this);
}

class EnumOption<T extends Enum> extends OptionField<T> {
  final Basic Function(T t) decorator;
  final List<T> options;

  EnumOption({
    required super.name,
    required super.defaultValue,
    required super.reader,
    super.description,
    super.icon,
    required super.writer,
    required this.decorator,
    required this.options,
    super.shouldShow = _defShouldShow,
  });

  @override
  bool matches(String text) =>
      "$name $description $defaultValue ${reader()} ${options.map((e) => e.name).join(" ")}"
          .toLowerCase()
          .contains(text.toLowerCase());

  @override
  Widget get built => EnumOptionView<T>(option: this);
}

abstract class OptionField<T> extends Option {
  final T defaultValue;
  final T? Function() reader;
  final void Function(T? t) writer;

  const OptionField({
    required super.name,
    super.description,
    super.icon,
    required this.defaultValue,
    required this.reader,
    required this.writer,
    super.shouldShow = _defShouldShow,
  });

  @override
  bool matches(String text) => "$name $description $defaultValue ${reader()}"
      .toLowerCase()
      .contains(text.toLowerCase());
}

abstract class Option {
  final IconData icon;
  final String name;
  final String? description;
  final bool Function(BuildContext context) shouldShow;

  const Option(
      {this.icon = Icons.gear_six_fill,
      required this.name,
      this.description,
      this.shouldShow = _defShouldShow});

  bool matches(String text) =>
      "$name $description".toLowerCase().contains(text.toLowerCase());

  Widget get built;

  String get id =>
      "${name.toLowerCase().trim().replaceAll(" ", "-")}-$hashCode-$runtimeType";
}

bool _defShouldShow(BuildContext _) => true;

class OptionGroup extends Option {
  final List<Option> options;

  const OptionGroup({
    required super.name,
    super.description,
    super.icon,
    this.options = const [],
    super.shouldShow = _defShouldShow,
  });

  Option? getParent(Option root) {
    if (root is OptionGroup) {
      for (Option i in root.options) {
        if (i.id == id) {
          return root;
        }

        if (i is OptionGroup) {
          Option? r = getParent(i);

          if (r != null) {
            return i;
          }
        }
      }
    }

    return null;
  }

  Iterable<OptionField> getFields() sync* {
    for (Option i in options) {
      if (i is OptionGroup) {
        yield* i.getFields();
      } else if (i is OptionField) {
        yield i;
      }
    }
  }

  @override
  Widget get built => OptionGroupView(optionGroup: this);
}

class OptionScreen extends OptionGroup {
  OptionScreen({
    required super.name,
    super.description,
    super.icon,
    super.options = const [],
    super.shouldShow = _defShouldShow,
  });

  @override
  Widget get built => OptionScreenTile(options: this);
}

class OptionScreenTile extends StatelessWidget {
  final OptionScreen options;

  const OptionScreenTile({super.key, required this.options});

  @override
  Widget build(BuildContext context) => Tile(
        title: Text(options.name),
        leading: Icon(options.icon),
        trailing: Icon(Icons.chevron_forward_ionic),
        subtitle:
            options.description != null ? Text(options.description!) : null,
        onPressed: () => Arcane.push(context, SettingsScreen(options: options)),
      ).asSliver;
}

class SettingsScreen extends StatefulWidget {
  final OptionScreen options;

  const SettingsScreen({super.key, required this.options});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController searchController = TextEditingController();
  bool searching = false;

  @override
  Widget build(BuildContext context) => SliverScreen(
        header: searching
            ? Bar(
                trailing: [
                  IconButton(
                    icon: Icon(Icons.x),
                    onPressed: () {
                      setState(() {
                        searchController.text = "";
                        searching = false;
                      });
                    },
                  )
                ],
                title: TextField(
                  autofocus: true,
                  placeholder: "Search ${widget.options.name}",
                  controller: searchController,
                  onSubmitted: (v) {
                    setState(() {});
                  },
                  onChanged: (v) => setState(() {}),
                ),
              )
            : Bar(
                trailing: [
                  IconButton(
                    icon: Icon(Icons.magnifying_glass),
                    onPressed: () {
                      setState(() {
                        searchController.text = "";
                        searching = true;
                      });
                    },
                  )
                ],
                titleText: widget.options.name,
                subtitleText: widget.options.description,
              ),
        sliver: StreamBuilder<int>(
            initialData: 0,
            stream: _su,
            builder: (context, _) =>
                searching || searchController.text.trim().isNotEmpty
                    ? MultiSliver(
                        children: [
                          ...widget.options
                              .getFields()
                              .unique
                              .where((e) => e.shouldShow(context))
                              .where((e) => e.matches(searchController.text))
                              .map((e) => e.built)
                        ],
                      )
                    : MultiSliver(
                        children: [
                          ...widget.options.options
                              .whereType<OptionScreen>()
                              .where((e) => e.shouldShow(context))
                              .map((e) => e.built),
                          ...widget.options.options
                              .whereType<OptionField>()
                              .where((e) => e.shouldShow(context))
                              .map((e) => e.built),
                          ...widget.options.options
                              .whereType<OptionGroup>()
                              .where((i) => i is! OptionScreen)
                              .where((e) => e.shouldShow(context))
                              .map((e) => e.built)
                        ],
                      )),
      );
}

class OptionGroupView extends StatelessWidget {
  final OptionGroup optionGroup;

  const OptionGroupView({super.key, required this.optionGroup});

  @override
  Widget build(BuildContext context) => BarSection(
      titleText: optionGroup.name,
      subtitleText: optionGroup.description,
      sliver: MultiSliver(
        children: [
          ...optionGroup.options
              .where((e) => e.shouldShow(context))
              .map((i) => i.built)
        ],
      ));
}

class BoolOptionView extends StatelessWidget {
  final BoolOption option;

  const BoolOptionView({super.key, required this.option});

  @override
  Widget build(BuildContext context) => CheckboxTile(
        value: option.reader() ?? option.defaultValue,
        onChanged: (v) {
          option.writer(v);
          _settingsUpdate();
        },
        title: Text(option.name),
        subtitle: option.description != null ? Text(option.description!) : null,
        leading: Icon(option.icon),
      ).asSliver;
}

class StringOptionView extends StatelessWidget {
  final StringOption option;

  const StringOptionView({super.key, required this.option});

  @override
  Widget build(BuildContext context) => Tile(
        title: Text(option.name),
        subtitle: option.description != null ? Text(option.description!) : null,
        leading: Icon(option.icon),
        trailing: Text(option.reader() ?? option.defaultValue),
        onPressed: () => DialogText(
          title: option.name,
          description: option.description,
          hint: option.reader() ?? option.defaultValue,
          initialValue: option.reader() ?? option.defaultValue,
          confirmText: "Done",
          onConfirm: (v) {
            option.writer(v);
            _settingsUpdate();
          },
        ).open(context),
      ).asSliver;
}

class IntOptionView extends StatelessWidget {
  final IntOption option;

  const IntOptionView({super.key, required this.option});

  @override
  Widget build(BuildContext context) => Tile(
        title: Text(option.name),
        subtitle: option.description != null ? Text(option.description!) : null,
        leading: Icon(option.icon),
        trailing: Text((option.reader() ?? option.defaultValue).toString()),
        onPressed: () => DialogText(
          keyboardType:
              TextInputType.numberWithOptions(signed: true, decimal: false),
          maxLines: 1,
          minLines: 1,
          title: option.name,
          description: option.description,
          hint: (option.reader() ?? option.defaultValue).toString(),
          initialValue: (option.reader() ?? option.defaultValue).toString(),
          confirmText: "Done",
          onConfirm: (r) {
            option.writer(int.tryParse(r));
            _settingsUpdate();
          },
        ).open(context),
      ).asSliver;
}

class DoubleOptionView extends StatelessWidget {
  final DoubleOption option;

  const DoubleOptionView({super.key, required this.option});

  @override
  Widget build(BuildContext context) => Tile(
        title: Text(option.name),
        subtitle: option.description != null ? Text(option.description!) : null,
        leading: Icon(option.icon),
        trailing: Text((option.reader() ?? option.defaultValue).toString()),
        onPressed: () => DialogText(
          keyboardType:
              TextInputType.numberWithOptions(signed: true, decimal: true),
          maxLines: 1,
          minLines: 1,
          title: option.name,
          description: option.description,
          hint: (option.reader() ?? option.defaultValue).toString(),
          initialValue: (option.reader() ?? option.defaultValue).toString(),
          confirmText: "Done",
          onConfirm: (r) {
            option.writer(double.tryParse(r));
            _settingsUpdate();
          },
        ).open(context),
      ).asSliver;
}

class EnumOptionView<T extends Enum> extends StatelessWidget {
  final EnumOption<T> option;

  const EnumOptionView({super.key, required this.option});

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(option.name),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(8),
            CardCarousel(
              children: [
                RadioCards<T>(
                  items: option.options,
                  value: option.reader() ?? option.defaultValue,
                  builder: option.decorator,
                  onChanged: (v) {
                    option.writer(v);
                    _settingsUpdate();
                  },
                )
              ],
            ),
            if (option.description != null) ...[
              Gap(8),
              Text(option.description!)
            ],
          ],
        ),
        leading: Icon(option.icon),
      ).asSliver;
}

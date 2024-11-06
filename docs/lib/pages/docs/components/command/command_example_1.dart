import 'package:arcane/arcane.dart';

class CommandExample1 extends StatelessWidget {
  const CommandExample1({super.key});

  @override
  Widget build(BuildContext context) {
    return Command(
      builder: (context, query) async* {
        Map<String, List<String>> items = {
          'Suggestions': ['Calendar', 'Search Emoji', 'Launch'],
          'Settings': ['Profile', 'Mail', 'Settings'],
        };
        Map<String, Widget> icons = {
          'Calendar': const Icon(Icons.calendar),
          'Search Emoji': const Icon(Icons.search_ionic),
          'Launch': const Icon(Icons.rocket_launch),
          'Profile': const Icon(Icons.user),
          'Mail': const Icon(Icons.mail_ionic),
          'Settings': const Icon(Icons.settings_ionic),
        };
        for (final values in items.entries) {
          List<Widget> resultItems = [];
          for (final item in values.value) {
            if (query == null ||
                item.toLowerCase().contains(query.toLowerCase())) {
              resultItems.add(CommandItem(
                title: Text(item),
                leading: icons[item],
                onTap: () {},
              ));
            }
          }
          if (resultItems.isNotEmpty) {
            await Future.delayed(const Duration(seconds: 1));
            yield [
              CommandCategory(
                title: Text(values.key),
                children: resultItems,
              ),
            ];
          }
        }
      },
    ).sized(width: 300, height: 300);
  }
}

import 'package:arcane/arcane.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Iterable<String>? selectedValues;

  @override
  Widget build(BuildContext context) => FillScreen(
          child: Center(
        child: MultiSelect<String>(
          itemBuilder: (context, item) {
            return MultiSelectChip(value: item, child: Text(item));
          },
          popup: const SelectPopup(
              items: SelectItemList(children: [
            SelectItemButton(
              value: 'Apple',
              child: Text('Apple'),
            ),
            SelectItemButton(
              value: 'Banana',
              child: Text('Banana'),
            ),
            SelectItemButton(
              value: 'Cherry',
              child: Text('Cherry'),
            ),
          ])),
          onChanged: (value) {
            setState(() {
              selectedValues = value;
            });
          },
          constraints: const BoxConstraints(
            minWidth: 200,
          ),
          value: selectedValues,
          placeholder: const Text('Select a fruit'),
        ),
      ));
}

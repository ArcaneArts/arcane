import 'package:arcane/arcane.dart';

class ExampleTiles extends StatelessWidget {
  const ExampleTiles({super.key});

  @override
  Widget build(BuildContext context) => SliverScreen(
        header: const Bar(
          titleText: "Tiles",
        ),
        sliver: MultiSliver(children: [
          const Tile(
            title: Text("Sliver Tile"),
            subtitle: Text("If you scroll down you will see that this sliver tile title / icon / trailing will act as a floating header while overtop of this description text. Basically \n\n\n This is still the description box."),
            leading: Icon(Icons.plus),
            trailing: Icon(Icons.x),
            sliver: true,
          ),
          SListView(
            children: [
              Tile(
                title: const Text("Title"),
                subtitle: const Text("Subtitle"),
                leading: const Icon(Icons.plus),
                trailing: const Icon(Icons.x),
                onPressed: () => print("Tile Pressed"),
              ),
              const Tile(
                title: Text("Title"),
                leading: Icon(Icons.plus),
                trailing: Icon(Icons.x),
              ),
              const Tile(
                leading: Icon(Icons.plus),
                title: Text("Title"),
              ),
              const Tile(
                leading: Icon(Icons.plus),
                subtitle: Text("Subtitle Only"),
              ),
              const SwitchTile(
                title: Text("Checkbox Tile"),
                leading: Icon(Icons.plus),
                subtitle: Text("Subtitle"),
                value: true,
              ),
              const CheckboxTile(
                title: Text("Checkbox Tile"),
                leading: Icon(Icons.plus),
                trailing: Icon(Icons.x),
                subtitle: Text("But with a trailing widget"),
                value: true,
              ),
              const CheckboxTile(
                title: Text("Leading Checkbox Tile"),
                leading: Icon(Icons.plus),
                checkPosition: TileWidgetPosition.leading,
                trailing: Icon(Icons.x),
                subtitle: Text("But with a leading widget"),
                value: true,
              ),
              const Divider(
                height: 16,
              ),
              const Divider(
                height: 100,
              ),
              const Divider(
                height: 100,
              ),
              const Divider(
                height: 100,
              ),
              const Divider(
                height: 16,
              ),
              const Divider(
                height: 100,
              ),
              const Divider(
                height: 100,
              ),
              const Divider(
                height: 100,
              ),
              const Divider(
                height: 16,
              ),
              const Divider(
                height: 100,
              ),
              const Divider(
                height: 100,
              ),
              const Divider(
                height: 100,
              ),
            ],
          )
        ]),
      );
}

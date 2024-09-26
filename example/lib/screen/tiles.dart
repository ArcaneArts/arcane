import 'package:arcane/arcane.dart';

class ExampleTiles extends StatelessWidget {
  const ExampleTiles({super.key});

  @override
  Widget build(BuildContext context) => SliverScreen(
        header: Bar(
          titleText: "Tiles",
        ),
        sliver: MultiSliver(children: [
          Tile(
            title: Text("Sliver Tile"),
            subtitle: Text(
                "If you scroll down you will see that this sliver tile title / icon / trailing will act as a floating header while overtop of this description text. Basically \n\n\n This is still the description box."),
            leading: Icon(Icons.plus),
            trailing: Icon(Icons.x),
            sliver: true,
          ),
          SListView(
            children: [
              Tile(
                title: Text("Title"),
                subtitle: Text("Subtitle"),
                leading: Icon(Icons.plus),
                trailing: Icon(Icons.x),
                onPressed: () => print("Tile Pressed"),
              ),
              Tile(
                title: Text("Title"),
                leading: Icon(Icons.plus),
                trailing: Icon(Icons.x),
              ),
              Tile(
                leading: Icon(Icons.plus),
                title: Text("Title"),
              ),
              Tile(
                leading: Icon(Icons.plus),
                subtitle: Text("Subtitle Only"),
              ),
              SwitchTile(
                title: Text("Checkbox Tile"),
                leading: Icon(Icons.plus),
                subtitle: Text("Subtitle"),
                value: true,
              ),
              CheckboxTile(
                title: Text("Checkbox Tile"),
                leading: Icon(Icons.plus),
                trailing: Icon(Icons.x),
                subtitle: Text("But with a trailing widget"),
                value: true,
              ),
              CheckboxTile(
                title: Text("Leading Checkbox Tile"),
                leading: Icon(Icons.plus),
                checkPosition: TileWidgetPosition.leading,
                trailing: Icon(Icons.x),
                subtitle: Text("But with a leading widget"),
                value: true,
              ),
              Divider(
                height: 16,
              ),
              Divider(
                height: 100,
              ),
              Divider(
                height: 100,
              ),
              Divider(
                height: 100,
              ),
              Divider(
                height: 16,
              ),
              Divider(
                height: 100,
              ),
              Divider(
                height: 100,
              ),
              Divider(
                height: 100,
              ),
              Divider(
                height: 16,
              ),
              Divider(
                height: 100,
              ),
              Divider(
                height: 100,
              ),
              Divider(
                height: 100,
              ),
            ],
          )
        ]),
      );
}

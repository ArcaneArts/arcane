import 'package:arcane/arcane.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  MainAxisSize mainAxisSize = MainAxisSize.max;

  @override
  Widget build(BuildContext context) => ArcaneScreen(
          child: Collection(
        children: [
          CardSection(
            titleText: "Select Dropdown",
            children: [
              ArcaneInput.selectDropdown<MainAxisSize>(
                  defaultValue: MainAxisSize.max,
                  options: MainAxisSize.values,
                  getter: () async => mainAxisSize,
                  setter: (value) async => setState(() => mainAxisSize = value))
            ],
          ),
          Gap(16),
          CardSection(
            titleText: "Icon Menu",
            children: [
              IconButtonMenu(icon: Icons.activity, items: [
                MenuButton(
                  child: Text("Button 1"),
                  subMenu: [
                    MenuButton(child: Text("Button 2")),
                    MenuButton(child: Text("Button 2")),
                    MenuButton(child: Text("Button 2")),
                    MenuButton(child: Text("Button 2")),
                    MenuDivider(),
                    MenuButton(child: Text("Button 2")),
                    MenuButton(child: Text("Button 2")),
                    MenuButton(child: Text("Button 2"))
                  ],
                ),
              ])
            ],
          ),
          Gap(16),
        ],
      ));
}

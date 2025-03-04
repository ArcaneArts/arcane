import 'package:arcane/arcane.dart';

List<String> list = List.generate(5, (index) => "Item $index");

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => MutablePylon<int>(
        rebuildChildren: true,
        local: true,
        value: 0,
        builder: (context) => ArcaneScreen(
            header: Bar(
              title: Text("Hmmmm"),
            ),
            child: DashBorderMode(
                borderstyle: [5, 5],
                builder: (context) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Gap(8),
                        Card(
                          onPressed: () {},
                          child: Text("Immacard"),
                        ),
                        Gap(8),
                        BasicCard(
                          title: Text("Basic Card"),
                        ),
                        Gap(8),
                        OutlineButton(child: Text("OUTLINE BUTTON")),
                        Gap(8),
                        Expanded(
                            child: TextField(
                          minLines: null,
                          maxLines: null,
                          expands: true,
                          style: TextStyle(fontSize: 16),
                          textAlignVertical: TextAlignVertical.top,
                          placeholderWidget: Text(
                            "Instructions for the chat model. I.e. Keep your responses short and sweet, Always reference where you got your information from.",
                            style: TextStyle(fontSize: 16),
                          ),
                        )),
                        Gap(8),
                        Card(child: Text("Immacard")),
                        Gap(8),
                      ],
                    ).padLeft(8).padRight(8))),
      );
}

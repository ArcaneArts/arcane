import 'dart:math';

import 'package:arcane/arcane.dart';

List<String> list = List.generate(5, (index) => "Item $index");

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => ArcaneScreen(
        fab: Fab(
            child: const Icon(Icons.plus),
            onPressed: () {
              setState(() {
                list.add(
                    "Item ${list.length} ${DateTime.now().toIso8601String()}");
              });
            }),
        header: Bar(
          titleText: "Test",
          trailing: [],
        ),
        child: Collection(
          children: [
            Section(
                headerText: "The List",
                child: ArcaneList(
                    items: list,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        key: ValueKey(list[index]),
                        decoration: BoxDecoration(
                            color: HSLColor.fromAHSL(
                                    0.1,
                                    Random(list[index].hashCode).nextDouble() *
                                        360,
                                    1,
                                    0.6)
                                .toColor(),
                            borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          onPressed: () {
                            setState(() {
                              list.removeAt(index);
                            });
                          },
                          title: Text(list[index]),
                        ),
                      );
                    },
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        String v = list.removeAt(oldIndex);
                        list.insert(newIndex, v);
                      });
                    },
                    isSameItem: (a, b) => a == b)),
            Section(
                headerText: "The Grid",
                child: ArcaneGrid(
                    sliverGridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            childAspectRatio: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            maxCrossAxisExtent: 200),
                    items: list,
                    itemBuilder: (BuildContext context, int index) {
                      return BasicCard(
                        borderColor: HSLColor.fromAHSL(
                                0.333,
                                Random(list[index].hashCode).nextDouble() * 360,
                                1,
                                0.6)
                            .toColor(),
                        filled: true,
                        fillColor: HSLColor.fromAHSL(
                                0.05,
                                Random(list[index].hashCode).nextDouble() * 360,
                                1,
                                0.6)
                            .toColor(),
                        onPressed: () {
                          setState(() {
                            list.removeAt(index);
                          });
                        },
                        title: Text(list[index]),
                        key: ValueKey(list[index]),
                      );
                    },
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        String v = list.removeAt(oldIndex);
                        list.insert(newIndex, v);
                      });
                    },
                    isSameItem: (a, b) => a == b))
          ],
        ),
      );
}

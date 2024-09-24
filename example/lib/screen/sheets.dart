import 'package:arcane/arcane.dart';

class ExampleSheets extends StatelessWidget {
  const ExampleSheets({super.key});

  @override
  Widget build(BuildContext context) => Screen(
        header: const Bar(
          titleText: "Sheets",
        ),
        fill: Center(
          child: Column(
            children: [
              PrimaryButton(
                child: const Text("Open Sheet"),
                onPressed: () =>
                    Sheet(builder: (context) => const ExampleSheet())
                        .open(context),
              ),
              const Gap(16),
              PrimaryButton(
                child: const Text("Open Non Swipe Dismissible Sheet"),
                onPressed: () => Sheet(
                  builder: (context) => const ExampleSheet(),
                  dismissible: false,
                ).open(context),
              ),
            ],
          ),
        ),
      );
}

class ExampleSheet extends StatelessWidget {
  const ExampleSheet({super.key});

  @override
  Widget build(BuildContext context) => Screen(
        header: const Bar(
          titleText: "This is a sheet",
        ),
        sliver: MultiSliver(children: [
          BarSection(
              headerText: "Header 1",
              sliver: SliverList(
                  delegate: SliverChildListDelegate(List.generate(
                      25,
                      (i) => Tile(
                            title: Text("Tile $i"),
                            subtitle: Text("Subtitle $i"),
                            leading: const Icon(Icons.plus),
                          ))))),
          BarSection(
              headerText: "Header 2",
              sliver: SliverList(
                  delegate: SliverChildListDelegate(List.generate(
                      25,
                      (i) => Tile(
                            title: Text("Tile $i"),
                            subtitle: Text("Subtitle $i"),
                            leading: const Icon(Icons.plus),
                          ))))),
          BarSection(
              headerText: "Header 3",
              sliver: SliverList(
                  delegate: SliverChildListDelegate(List.generate(
                      25,
                      (i) => Tile(
                            title: Text("Tile $i"),
                            subtitle: Text("Subtitle $i"),
                            leading: const Icon(Icons.plus),
                          )))))
        ]),
      );
}

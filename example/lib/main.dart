import 'package:arcane/arcane.dart';

bool v = false;
String? vv;
void main() {
  runApp(const ExampleArcaneApp());
}

class ExampleArcaneApp extends StatelessWidget {
  const ExampleArcaneApp({super.key});

  @override
  Widget build(BuildContext context) => ArcaneApp(
        home: ExampleNavigationScreen(),
        theme: ArcaneTheme(
            scheme: ContrastedColorScheme.fromScheme(ColorSchemes.zinc)),
      );
}

class ExampleNavigationScreen extends StatefulWidget {
  const ExampleNavigationScreen({super.key});

  @override
  State<ExampleNavigationScreen> createState() =>
      _ExampleNavigationScreenState();
}

class _ExampleNavigationScreenState extends State<ExampleNavigationScreen> {
  NavigationType type = NavigationType.bottomNavigationBar;
  int index = 0;

  @override
  Widget build(BuildContext context) => NavigationScreen(
          type: type,
          index: index,
          onIndexChanged: (index) => setState(() => this.index = index),
          tabs: [
            NavTab(
                label: "Tab 1",
                icon: Icons.activity,
                selectedIcon: Icons.activity_fill,
                builder: (context, footer) => SliverScreen(
                    gutter: false,
                    footer: footer,
                    header: Bar(titleText: "Tab 1"),
                    sliver: SListView.builder(
                        childCount: 10,
                        builder: (context, i) => ListTile(
                              title: Text("Item $i"),
                              subtitle: Text("Subtitle or something"),
                              leading: Icon(Icons.activity),
                            )))),
            NavTab(
                label: "Tab 2",
                icon: Icons.address_book,
                selectedIcon: Icons.address_book_fill,
                builder: (context, footer) => SliverScreen(
                    gutter: false,
                    footer: footer,
                    header: Bar(titleText: "Tab 2"),
                    sliver: SGridView.builder(
                        crossAxisCount: 3,
                        childCount: 10,
                        builder: (context, i) => Card(
                              child: Basic(
                                title: Text("Item $i"),
                                subtitle: Text("Subtitle or something"),
                                leading: Icon(Icons.activity),
                              ),
                            )))),
            NavTab(
                label: "Tab 3",
                icon: Icons.gear_six,
                selectedIcon: Icons.gear_six_fill,
                builder: (context, footer) => FillScreen(
                    footer: footer,
                    gutter: false,
                    header: Bar(titleText: "Tab 3"),
                    child: Center(
                      child: CardCarousel(
                        children: [
                          RadioCards<NavigationType>(
                              builder: (nt) => Basic(title: Text(nt.name)),
                              onChanged: (nt) => setState(() => type = nt),
                              items: NavigationType.values,
                              value: type)
                        ],
                      ),
                    )))
          ]);
}

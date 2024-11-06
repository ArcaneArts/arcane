import 'package:arcane/arcane.dart';

class ScaffoldExample1 extends StatefulWidget {
  const ScaffoldExample1({super.key});

  @override
  State<ScaffoldExample1> createState() => _ScaffoldExample1State();
}

class _ScaffoldExample1State extends State<ScaffoldExample1> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      loadingProgressIndeterminate: true,
      headers: [
        AppBar(
          title: const Text('Counter App'),
          subtitle: const Text('A simple counter app'),
          leading: [
            OutlineButton(
              onPressed: () {},
              density: ButtonDensity.icon,
              child: const Icon(Icons.menu_ionic),
            ),
          ],
          trailing: [
            OutlineButton(
              onPressed: () {},
              density: ButtonDensity.icon,
              child: const Icon(Icons.search_ionic),
            ),
            OutlineButton(
              onPressed: () {},
              density: ButtonDensity.icon,
              child: const Icon(Icons.plus),
            ),
          ],
        ),
        const Divider(),
      ],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:').p(),
            Text(
              '$_counter',
            ).h1(),
            PrimaryButton(
              onPressed: _incrementCounter,
              density: ButtonDensity.icon,
              child: const Icon(Icons.plus),
            ).p(),
          ],
        ),
      ),
    );
  }
}

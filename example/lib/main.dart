import 'package:arcane/extensions/theme_data.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ArcaneComponents());

class ArcaneComponents extends StatelessWidget {
  const ArcaneComponents({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData.light().arcane(),
        darkTheme: ThemeData.dark().arcane(),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: const Text('Card'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ComponentScreen(
                  child: Card(
                    child: Text("This is a card"),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ComponentScreen extends StatelessWidget {
  final Widget child;

  const ComponentScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: child,
        ),
      );
}

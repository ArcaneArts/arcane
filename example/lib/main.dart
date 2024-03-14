import 'package:flutter/material.dart';

void main() => runApp(ArcaneComponents());

class ArcaneComponents extends StatelessWidget {
  const ArcaneComponents({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          children: [
            ListTile(
              title: const Text('Card'),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ComponentScreen(
                    child: const Card(
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

class ComponentScreen extends StatelessWidget {
  final Widget child;

  const ComponentScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: child,
      );
}

import 'package:arcane/extensions/theme_data.dart';
import 'package:example/typography.dart';
import 'package:example/widgets/buttons.dart';
import 'package:example/widgets/communications.dart';
import 'package:example/widgets/containments.dart';
import 'package:example/widgets/navigations.dart';
import 'package:example/widgets/selections.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ArcaneComponents());

class ArcaneComponents extends StatelessWidget {
  const ArcaneComponents({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
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
      appBar: AppBar(
        title: const Text('Arcane Components'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Buttons'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ButtonsPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text('Selections'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SelectionsPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text('Navigations'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NavigationsPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text('Communications'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CommunicationsPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text('Containments'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ContainmentsPage(),
              ),
            ),
          ),
          ListTile(
            title: const Text('Typography'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const TypographyThing()),
            ),
          ),
        ],
      ),
    );
  }
}

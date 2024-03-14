import 'package:arcane/extensions/theme_data.dart';
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
          // ListTile(
          //   title: const Text('Typography'),
          //   onTap: () => Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) =>  Typography(),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ButtonsPage extends StatelessWidget {
  const ButtonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buttons'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Elevated Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: () {}, child: const Text('Elevated Button')),
          const SizedBox(height: 8),
          const ElevatedButton(onPressed: null, child: Text('Disabled Elevated Button')),
          const SizedBox(height: 16),
          const Text('Text Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextButton(onPressed: () {}, child: const Text('Text Button')),
          const SizedBox(height: 8),
          const TextButton(onPressed: null, child: Text('Disabled Text Button')),
          const SizedBox(height: 16),
          const Text('Outlined Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: () {}, child: const Text('Outlined Button')),
          const SizedBox(height: 8),
          const OutlinedButton(onPressed: null, child: Text('Disabled Outlined Button')),
          const SizedBox(height: 16),
          const Text('Icon Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite)),
          const SizedBox(height: 8),
          const IconButton(onPressed: null, icon: Icon(Icons.favorite)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

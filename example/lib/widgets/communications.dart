import 'package:flutter/material.dart';

class CommunicationsPage extends StatelessWidget {
  const CommunicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communication'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Badges', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.mail),
              const SizedBox(width: 8),
              const Text('Messages'),
              const Spacer(),
              Badge(
                label: const Text('3'),
                child: IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Linear Progress Indicators', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const LinearProgressIndicator(),
          const SizedBox(height: 8),
          const LinearProgressIndicator(value: 0.5),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('This is a snackbar'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Show Snackbar'),
          ),
        ],
      ),
    );
  }
}

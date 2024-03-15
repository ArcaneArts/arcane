import 'package:flutter/material.dart';

class ContainmentsPage extends StatelessWidget {
  const ContainmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Miscellaneous'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Alert Dialog'),
                    content: const Text('This is an alert dialog.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Show Alert Dialog'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 200,
                    color: Colors.white,
                    child: const Center(
                      child: Text('This is a bottom sheet.'),
                    ),
                  );
                },
              );
            },
            child: const Text('Show Bottom Sheet'),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card Title',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('This is a card.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('John Doe'),
            subtitle: Text('Software Engineer'),
            trailing: Icon(Icons.arrow_forward),
          ),
          const ListTile(
            leading: Icon(Icons.phone),
            title: Text('Jane Smith'),
            subtitle: Text('Product Manager'),
            trailing: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}

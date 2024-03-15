import 'package:flutter/material.dart';

class ButtonsPage extends StatefulWidget {
  const ButtonsPage({super.key});

  @override
  _ButtonsPageState createState() => _ButtonsPageState();
}

class _ButtonsPageState extends State<ButtonsPage> {
  Calendar calendarView = Calendar.week;
  bool _isExtended = false;

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
          const Text('Segmented Buttons', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SegmentedButton<Calendar>(
            style: SegmentedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.red,
              selectedForegroundColor: Colors.white,
              selectedBackgroundColor: Colors.green,
            ),
            segments: const <ButtonSegment<Calendar>>[
              ButtonSegment<Calendar>(value: Calendar.day, label: Text('Day'), icon: Icon(Icons.calendar_view_day)),
              ButtonSegment<Calendar>(value: Calendar.week, label: Text('Week'), icon: Icon(Icons.calendar_view_week)),
              ButtonSegment<Calendar>(value: Calendar.month, label: Text('Month'), icon: Icon(Icons.calendar_view_month)),
              ButtonSegment<Calendar>(value: Calendar.year, label: Text('Year'), icon: Icon(Icons.calendar_today)),
            ],
            selected: <Calendar>{calendarView},
            onSelectionChanged: (Set<Calendar> newSelection) {
              setState(() {
                calendarView = newSelection.first;
              });
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _isExtended = !_isExtended;
          });
        },
        icon: const Icon(Icons.add),
        label: _isExtended ? const Text('Collapse') : const Text('Expand'),
        isExtended: _isExtended,
      ),
    );
  }
}

enum Calendar { day, week, month, year }

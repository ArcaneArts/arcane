import 'package:flutter/material.dart';

class SelectionsPage extends StatefulWidget {
  const SelectionsPage({super.key});

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionsPage> {
  bool _checkboxValue = false;
  DateTime _selectedDate = DateTime.now();
  bool _switchValue = false;
  String _selectedMenuItem = 'Item 1';
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _radioValue = 0;
  double _sliderValue = 0.0;
  List<String> _selectedChips = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selection'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Checkbox', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          CheckboxListTile(
            title: const Text('Checkbox'),
            value: _checkboxValue,
            onChanged: (bool? value) {
              setState(() {
                _checkboxValue = value ?? false;
              });
            },
          ),
          const SizedBox(height: 16),
          const Text('Date Picker', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            title: const Text('Select Date'),
            subtitle: Text('Selected Date: ${_selectedDate.toString()}'),
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          const Text('Switch', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text('Switch'),
            value: _switchValue,
            onChanged: (bool value) {
              setState(() {
                _switchValue = value;
              });
            },
          ),
          const SizedBox(height: 16),
          const Text('Menu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            value: _selectedMenuItem,
            onChanged: (String? newValue) {
              setState(() {
                _selectedMenuItem = newValue ?? 'Item 1';
              });
            },
            items: <String>['Item 1', 'Item 2', 'Item 3', 'Item 4'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Time Picker', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            title: const Text('Select Time'),
            subtitle: Text('Selected Time: ${_selectedTime.format(context)}'),
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
              );
              if (picked != null && picked != _selectedTime) {
                setState(() {
                  _selectedTime = picked;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          const Text('Radio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            title: const Text('Option 1'),
            leading: Radio<int>(
              value: 0,
              groupValue: _radioValue,
              onChanged: (int? value) {
                setState(() {
                  _radioValue = value ?? 0;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Option 2'),
            leading: Radio<int>(
              value: 1,
              groupValue: _radioValue,
              onChanged: (int? value) {
                setState(() {
                  _radioValue = value ?? 0;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text('Slider', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Slider(
            value: _sliderValue,
            min: 0,
            max: 100,
            divisions: 10,
            label: _sliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                _sliderValue = value;
              });
            },
          ),
          const SizedBox(height: 16),
          const Text('Chips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8.0,
            children: <String>['Chip 1', 'Chip 2', 'Chip 3', 'Chip 4'].map((String chip) {
              return FilterChip(
                label: Text(chip),
                selected: _selectedChips.contains(chip),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      _selectedChips.add(chip);
                    } else {
                      _selectedChips.remove(chip);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

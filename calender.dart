import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CustomCalendarPage(),
  ));
}

// Model class to hold reminder data
class Reminder {
  String id;
  String title;
  DateTime date;

  Reminder({required this.id, required this.title, required this.date});
}

class CustomCalendarPage extends StatefulWidget {
  const CustomCalendarPage({super.key});

  @override
  State<CustomCalendarPage> createState() => _CustomCalendarPageState();
}

class _CustomCalendarPageState extends State<CustomCalendarPage> {
  late DateTime _focusedDate;
  late DateTime _selectedDate;
  final List<Reminder> _reminders = [];

  final List<String> _daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    _focusedDate = DateTime.now();
    _selectedDate = DateTime(_focusedDate.year, _focusedDate.month, _focusedDate.day);
  }

  // Calculates total days in a specific month
  int _getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  // Determines the starting weekday of the month (Monday = 0)
  int _getStartingDayOfWeek(int year, int month) {
    int weekday = DateTime(year, month, 1).weekday;
    return weekday - 1;
  }

  // Opens Dialog Box to Add or Edit a reminder
  void _showReminderDialog({Reminder? existingReminder}) {
    final titleController = TextEditingController(text: existingReminder?.title ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existingReminder == null ? 'New Reminder' : 'Edit Reminder'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: 'Enter reminder title...'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty) return;

              setState(() {
                if (existingReminder != null) {
                  existingReminder.title = titleController.text.trim();
                } else {
                  _reminders.add(Reminder(
                    id: DateTime.now().toString(),
                    title: titleController.text.trim(),
                    date: _selectedDate,
                  ));
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteReminder(Reminder reminder) {
    setState(() {
      _reminders.remove(reminder);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int daysInMonth = _getDaysInMonth(_focusedDate.year, _focusedDate.month);
    final int startingEmptySlots = _getStartingDayOfWeek(_focusedDate.year, _focusedDate.month);
    final int totalGridItems = daysInMonth + startingEmptySlots;

    // Filter reminders for the currently selected date
    final currentDayReminders = _reminders.where((r) =>
    r.date.year == _selectedDate.year &&
        r.date.month == _selectedDate.month &&
        r.date.day == _selectedDate.day).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Reminder'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 1. Month Header (Navigation)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => setState(() => _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1)),
              ),
              Text(
                '${_months[_focusedDate.month - 1]} ${_focusedDate.year}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => setState(() => _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 2. Days of Week Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _daysOfWeek.map((day) => Expanded(
              child: Center(child: Text(day, style: const TextStyle(fontWeight: FontWeight.bold))),
            )).toList(),
          ),
          const SizedBox(height: 10),

          // 3. Calendar Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
            itemCount: totalGridItems,
            itemBuilder: (context, index) {
              if (index < startingEmptySlots) {
                return const SizedBox.shrink(); // Empty spaces before the 1st of the month
              }

              final int dayNumber = index - startingEmptySlots + 1;
              final DateTime cellDate = DateTime(_focusedDate.year, _focusedDate.month, dayNumber);
              final bool isSelected = cellDate == _selectedDate;

              // Check if this specific date has any reminders
              final bool hasReminder = _reminders.any((r) =>
              r.date.year == cellDate.year &&
                  r.date.month == cellDate.month &&
                  r.date.day == cellDate.day);


              return GestureDetector(
                onTap: () => setState(() => _selectedDate = cellDate),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    shape: BoxShape.circle,
                    border: hasReminder && !isSelected ? Border.all(color: Colors.orange, width: 2) : null,
                  ),
                  child: Center(
                    child: Text(
                      '$dayNumber',
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const Divider(),

          // 4. Reminders List Header Section
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reminders (${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showReminderDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add New'),
                ),
              ],
            ),
          ),

          // 5. Active Reminders List View
          Expanded(
            child: currentDayReminders.isEmpty
                ? const Center(child: Text('No reminders for this day.'))
                : ListView.builder(
              itemCount: currentDayReminders.length,
              itemBuilder: (context, index) {
                final reminder = currentDayReminders[index];
                return ListTile(
                  title: Text(reminder.title),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showReminderDialog(existingReminder: reminder),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteReminder(reminder),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


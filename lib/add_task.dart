import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task.dart';
import 'package:task_app/task_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _taskTitleController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _taskTitleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = TaskProvider();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _taskTitleController,
          decoration: const InputDecoration(
            hintText: 'New Task...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          autofocus: true,
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.star_border, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.grey),
              onPressed: _pickDate,
            ),
            if (_selectedDate != null)
              Text(DateFormat('dd MMM, yyyy').format(_selectedDate!)),
            IconButton(
              icon: const Icon(Icons.access_time, color: Colors.grey),
              onPressed: _pickTime,
            ),
            if (_selectedTime != null) Text(_selectedTime!.format(context)),
            const Spacer(),
            TextButton(
              onPressed: () {
                final taskProvider =
                    Provider.of<TaskProvider>(context, listen: false);
                DateTime? taskDateTime;
                if (_selectedDate != null && _selectedTime != null) {
                  taskDateTime = DateTime(
                    _selectedDate!.year,
                    _selectedDate!.month,
                    _selectedDate!.day,
                    _selectedTime!.hour,
                    _selectedTime!.minute,
                  );
                }
                taskProvider.addTask(Task(
                  title: _taskTitleController.text,
                  dateTime: taskDateTime,
                ));
                Navigator.pop(context);
              },
              child: const Text(
                'Add Task',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

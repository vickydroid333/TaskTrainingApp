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
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _taskTitleController.dispose();
    super.dispose();
  }

  String? validateText(String text) {
    if (text.isEmpty) {
      return 'Please enter some text.';
    }
    // Add more validation rules as needed
    return null;
  }

  Future<void> _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      setState(() {
        _selectedDate = pickedDate;
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _taskTitleController,
            decoration: const InputDecoration(
              hintText: 'New Task...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey),
            ),
            validator: (value) => validateText(value!),
            autofocus: true,
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.star_border, color: Colors.grey),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.access_time, color: Colors.grey),
                onPressed: _pickDateTime,
              ),
              if (_selectedDate != null)
                Text(DateFormat('dd MMM, yyyy  |  ').format(_selectedDate!)),
              if (_selectedTime != null) Text(_selectedTime!.format(context)),
              const Spacer(),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final taskProvider =
                        Provider.of<TaskProvider>(context, listen: false);
                    DateTime? taskDateTime;
                    if (_selectedDate != null) {
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
                  }
                },
                child: const Text(
                  'Add Task',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

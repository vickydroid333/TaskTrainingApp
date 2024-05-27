import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  bool _isStarred = false;

  @override
  void dispose() {
    _taskTitleController.dispose();
    super.dispose();
  }

  String? validateText(String? text) {
    if (text == null || text.isEmpty) {
      return 'Please enter some text.';
    }
    return null;
  }

  Future<void> _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
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
    final selectedTime = _selectedTime?.format(context);
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
            validator: (value) => validateText(value),
            autofocus: true,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isStarred = !_isStarred;
                  });
                },
                child: SvgPicture.asset(
                  _isStarred
                      ? 'assets/images/filledstar.svg'
                      : 'assets/images/star.svg',
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: () {
                  _pickDateTime();
                },
                child: SvgPicture.asset(
                  'assets/images/timer.svg',
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              _selectedDate != null
                  ? Text(DateFormat('dd MMM, yyyy').format(_selectedDate!))
                  : const Text(''),
              _selectedTime != null ? Text(' | $selectedTime') : const Text(''),
              const Spacer(),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final taskProvider =
                        Provider.of<TaskProvider>(context, listen: false);
                    DateTime? taskDateTime;
                    if (_selectedDate != null) {
                      if (_selectedTime != null) {
                        taskDateTime = DateTime(
                          _selectedDate!.year,
                          _selectedDate!.month,
                          _selectedDate!.day,
                          _selectedTime!.hour,
                          _selectedTime!.minute,
                        );
                      } else {
                        taskDateTime = DateTime(
                          _selectedDate!.year,
                          _selectedDate!.month,
                          _selectedDate!.day,
                        );
                      }
                    }

                    taskProvider.addTask(Task(
                      title: _taskTitleController.text,
                      dateTime: taskDateTime,
                      isStarred: _isStarred,
                    ));
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Add Task',
                  style: TextStyle(color: Color(0xFFB13D3D), fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'task.dart';
import 'task_provider.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;
  final int taskIndex;

  const TaskDetailsPage({
    super.key,
    required this.task,
    required this.taskIndex,
  });

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  void _markTaskCompleted() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final task = widget.task;
    taskProvider.toggleTaskCompletion(widget.taskIndex, task);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Task marked as ${task.isCompleted! ? 'completed' : 'incomplete'}.'),
        backgroundColor: Colors.black87,
        padding: const EdgeInsets.only(left: 16, right: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            taskProvider.toggleTaskCompletion(widget.taskIndex, task);
          },
          textColor: Colors.orange,
        ),
      ),
    );
  }

  void _deleteTask() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    // Find the task index in the original task list
    final taskIndex = taskProvider.getTaskIndex(widget.task);

    if (taskIndex == -1) return; // Task not found

    final deletedTask = taskProvider.tasks[taskIndex];
    final taskKey = taskProvider.getKeyAt(taskIndex);

    // Remove task from Hive box
    taskProvider.removeTask(taskKey);
    Navigator.pop(context); // Pop back to the previous page

    // Show custom snackbar with undo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            const Text('Task deleted.', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[800],
        padding: const EdgeInsets.only(left: 16, right: 16),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            taskProvider.addTask(deletedTask, taskKey);
          },
          textColor: Colors.orange,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Task Detail'),
        actions: [
          IconButton(
            icon: Icon(
              widget.task.isStarred ?? false ? Icons.star : Icons.star_border,
              color:
                  widget.task.isStarred ?? false ? Colors.amber : Colors.grey,
            ),
            onPressed: () {
              taskProvider.toggleTaskStarred(widget.taskIndex, widget.task);
            },
          ),
          IconButton(icon: const Icon(Icons.delete), onPressed: _deleteTask)
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task.title,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              if (widget.task.dateTime != null)
                Container(
                  padding: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('dd MMM, yyyy  |  hh:mm a')
                            .format(widget.task.dateTime!),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () =>
                            taskProvider.removeTaskDate(widget.taskIndex),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _markTaskCompleted();
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  label: widget.task.isCompleted ?? false
                      ? const Text(
                          'Mark InCompleted',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Text(
                          'Mark Completed',
                          style: TextStyle(color: Colors.white),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // Adjust the radius as needed
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

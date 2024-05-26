import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_app/task.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;
  const TaskDetailsPage({super.key, required this.task});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (widget.task.dateTime != null) ...[
              const SizedBox(height: 16),
              Text(
                'Date: ${DateFormat('dd MMM, yyyy').format(widget.task.dateTime!)}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Time: ${DateFormat('hh:mm a').format(widget.task.dateTime!)}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  widget.task.isStarred ?? false
                      ? Icons.star
                      : Icons.star_border,
                  color: widget.task.isStarred ?? false
                      ? Colors.amber
                      : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.task.isStarred ?? false ? 'Starred' : 'Not Starred',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  widget.task.isCompleted ?? false
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: widget.task.isCompleted ?? false
                      ? Colors.green
                      : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.task.isCompleted ?? false ? 'Completed' : 'Incomplete',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

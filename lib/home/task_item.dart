import 'package:flutter/material.dart';
import 'package:task_app/home/task_data_class.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onChanged;

  const TaskItem({
    super.key,
    required this.task,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: onChanged,
      ),
      title: Text(task.title),
      subtitle: task.hasDateTime
          ? const Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text('18 Jul, 2023'),
                SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text('05:45 PM'),
              ],
            )
          : null,
      trailing: Icon(
        task.isStarred ? Icons.star : Icons.star_border,
        color: task.isStarred ? Colors.orange : Colors.grey,
      ),
    );
  }
}

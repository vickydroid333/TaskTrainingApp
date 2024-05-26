import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../task_detail.dart';
import '../task_provider.dart';

class MyTasks extends StatefulWidget {
  const MyTasks({super.key});

  @override
  State<MyTasks> createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, _) {
            final tasks = taskProvider.starredTasks;
            if (tasks.isEmpty) {
              return const Center(
                child: Text('No starred tasks available'),
              );
            }
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  leading: Checkbox(
                    activeColor: Colors.red,
                    value: task.isCompleted,
                    onChanged: (bool? value) {
                      if (value != null) {
                        taskProvider.toggleTaskCompletion(index, task);
                      }
                    },
                  ),
                  title: Text(task.title),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  subtitle: task.dateTime != null
                      ? Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 16.0,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(DateFormat('dd MMM, yyyy')
                                      .format(task.dateTime!)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Container(
                              padding: const EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 16.0,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(DateFormat('hh:mm a')
                                      .format(task.dateTime!)),
                                ],
                              ),
                            ),
                          ],
                        )
                      : null,
                  trailing: IconButton(
                    icon: Icon(
                      task.isStarred ?? false ? Icons.star : Icons.star_border,
                      color:
                          task.isStarred ?? false ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () {
                      taskProvider.toggleTaskStarred(index, task);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TaskDetailsPage(task: task, taskIndex: index),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

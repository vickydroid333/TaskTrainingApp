import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../task_detail.dart';
import '../task_provider.dart';

class StarredTasks extends StatefulWidget {
  const StarredTasks({super.key});

  @override
  State<StarredTasks> createState() => _StarredTasksState();
}

class _StarredTasksState extends State<StarredTasks> {
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
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TaskDetailsPage(task: task, taskIndex: index),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            taskProvider.toggleTaskCompletion(task);
                          },
                          child: SvgPicture.asset(
                            task.isCompleted ?? false
                                ? 'assets/images/checked.svg'
                                : 'assets/images/unchecked.svg',
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(task.title,
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(
                                height: 8,
                              ),
                              if (task.dateTime != null)
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF6F6F6),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/calender.svg',
                                            height: 16,
                                            width: 16,
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(DateFormat('dd MMM, yyyy')
                                              .format(task.dateTime!)),
                                        ],
                                      ),
                                    ),
                                    if (task.dateTime!.hour != 0 ||
                                        task.dateTime!.minute != 0) ...[
                                      const SizedBox(width: 8.0),
                                      Container(
                                        padding: const EdgeInsets.all(6.0),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF6F6F6),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/timer.svg',
                                              height: 16,
                                              width: 16,
                                              color: const Color(0xFF5A5A5A),
                                            ),
                                            const SizedBox(width: 4.0),
                                            Text(DateFormat('hh:mm a')
                                                .format(task.dateTime!)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            taskProvider.toggleTaskStarred(task);
                          },
                          child: SvgPicture.asset(
                            task.isStarred ?? false
                                ? 'assets/images/filledstar.svg'
                                : 'assets/images/star.svg',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

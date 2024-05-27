import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../task.dart';
import '../task_detail.dart';
import '../task_provider.dart';

class CompletedTasks extends StatefulWidget {
  const CompletedTasks({super.key});

  @override
  State<CompletedTasks> createState() => _CompletedTasksState();
}

class _CompletedTasksState extends State<CompletedTasks> {
  void _markTaskCompleted(BuildContext context, Task task) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.toggleTaskCompletion(task);

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom:
            50.0, // Change this value to adjust the position from the bottom
        left: 20.0,
        right: 20.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Task ${task.isCompleted! ? 'Completed' : 'Incompleted'}.',
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                TextButton(
                  onPressed: () {
                    taskProvider.toggleTaskCompletion(task);
                    overlayEntry!.remove();
                  },
                  child: const Text(
                    'UNDO',
                    style: TextStyle(color: Color(0xFFFFC6C6), fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);

    // Remove the toast after a duration
    Future.delayed(const Duration(seconds: 5), () {
      overlayEntry!.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, _) {
            final completedTasks = taskProvider.completedTasks;
            if (completedTasks.isEmpty) {
              return const Center(child: Text('No completed tasks available'));
            }
            return ListView.builder(
              itemCount: completedTasks.length,
              itemBuilder: (context, index) {
                final task = completedTasks[index];
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
                          onTap: () => _markTaskCompleted(context, task),
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

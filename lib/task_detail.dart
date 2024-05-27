import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  void _markTaskCompleted(BuildContext context) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final task = widget.task;
    taskProvider.toggleTaskCompletion(widget.taskIndex, task);

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
                    taskProvider.toggleTaskCompletion(widget.taskIndex, task);
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

  void _deleteTask(BuildContext context) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    // Find the task index in the original task list
    final taskIndex = taskProvider.getTaskIndex(widget.task);

    if (taskIndex == -1) return; // Task not found

    final deletedTask = taskProvider.tasks[taskIndex];
    final taskKey = taskProvider.getKeyAt(taskIndex);

    // Remove task from Hive box
    taskProvider.removeTask(taskKey);
    Navigator.pop(context); // Pop back to the previous page

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
                const Text(
                  'Task deleted.',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                TextButton(
                  onPressed: () {
                    taskProvider.addTask(deletedTask, taskKey);
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
    final taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: GestureDetector(
            child: SvgPicture.asset('assets/images/backarrow.svg'),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Task Detail',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              taskProvider.toggleTaskStarred(widget.taskIndex, widget.task);
            },
            child: SvgPicture.asset(
              widget.task.isStarred ?? false
                  ? 'assets/images/filledstar.svg'
                  : 'assets/images/star.svg',
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          GestureDetector(
            onTap: () {
              _deleteTask(context);
            },
            child: SvgPicture.asset(
              'assets/images/deletebin.svg',
            ),
          ),
          const SizedBox(
            width: 15,
          )
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
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/images/calender.svg',
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.task.dateTime!.hour != 0 ||
                                widget.task.dateTime!.minute != 0
                            ? DateFormat('dd MMM, yyyy  |  hh:mm a')
                                .format(widget.task.dateTime!)
                            : DateFormat('dd MMM, yyyy')
                                .format(widget.task.dateTime!),
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () =>
                            taskProvider.removeTaskDate(widget.taskIndex),
                        child: SvgPicture.asset(
                          'assets/images/cross.svg',
                          height: 19,
                          width: 19,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _markTaskCompleted(context);
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
                    backgroundColor: const Color(0xFFB13D3D),
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

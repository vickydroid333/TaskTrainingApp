import 'package:flutter/cupertino.dart';
import 'package:task_app/home/task_item.dart';
import 'package:task_app/task.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final List<Task> tasks = [
    /*Task(
        title: 'Buy eggs and bread for breakfast',
        isStarred: false,
        dateTime: DateTime.parse('')),
    Task(
        title: 'Pay college tuition fee',
        isStarred: false,
        dateTime: DateTime.parse('')),
    Task(
        title: 'Plan to book the party hall for birthday',
        isStarred: false,
        dateTime: DateTime.parse('formattedString')),
    Task(
        title: 'Visit granny before Christmas',
        isStarred: true,
        dateTime: DateTime.parse('formattedString')),
    Task(
        title: 'Book flight tickets for San Diego before the offer ends',
        isStarred: false,
        dateTime: DateTime.parse('formattedString')),
    Task(
        title: 'Buy eggs and bread for breakfast',
        isStarred: true,
        dateTime: DateTime.parse('formattedString')),
    Task(
        title: 'Pay college tuition fee',
        isStarred: true,
        dateTime: DateTime.parse('formattedString')),
    Task(
        title: 'Plan to book the party hall for birthday',
        isStarred: false,
        dateTime: DateTime.parse('formattedString')),*/
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskItem(
          task: tasks[index],
          onChanged: (bool? value) {
            setState(() {
              // tasks[index].isCompleted = value ?? false;
            });
          },
        );
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:task_app/home/task_data_class.dart';
import 'package:task_app/home/task_item.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final List<Task> tasks = [
    Task(title: 'Buy eggs and bread for breakfast', isStarred: false),
    Task(title: 'Pay college tuition fee', isStarred: false),
    Task(
        title: 'Plan to book the party hall for birthday',
        isStarred: false,
        hasDateTime: true),
    Task(title: 'Visit granny before Christmas', isStarred: true),
    Task(
        title: 'Book flight tickets for San Diego before the offer ends',
        isStarred: false,
        hasDateTime: true),
    Task(title: 'Buy eggs and bread for breakfast', isStarred: true),
    Task(title: 'Pay college tuition fee', isStarred: true),
    Task(
        title: 'Plan to book the party hall for birthday',
        isStarred: false,
        hasDateTime: true),
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
              tasks[index].isCompleted = value ?? false;
            });
          },
        );
      },
    );
  }
}

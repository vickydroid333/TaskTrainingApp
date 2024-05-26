import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../add_task.dart';
import '../task_detail.dart';
import '../task_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 1;
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: const AddTaskBottomSheet(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F2EB),
      body: Stack(
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 60, left: 20, right: 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/images.jpg'),
                      radius: 30,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good day',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          'Bernice Thompson!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.settings)
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Today's Task",
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 4),
                        Text("3/8 completed",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Task to be completed",
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 4),
                        Text("16 tasks",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8, top: 8),
                        child: TabBar(
                          controller: _tabController,
                          indicatorColor: Colors.red,
                          labelColor: Colors.black,
                          dividerColor: Colors.white,
                          unselectedLabelColor: Colors.grey,
                          tabs: const [
                            Tab(icon: Icon(Icons.star_border)),
                            Tab(text: "My Tasks"),
                            Tab(text: "Completed Tasks"),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              Consumer<TaskProvider>(
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
                                          value: task.isCompleted,
                                          onChanged: (bool? value) {
                                            if (value != null) {
                                              taskProvider.toggleTaskCompletion(
                                                  index, task);
                                            }
                                          },
                                        ),
                                        title: Text(task.title),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                        subtitle: task.dateTime != null
                                            ? Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.calendar_today,
                                                          size: 16.0,
                                                          color: Colors.grey,
                                                        ),
                                                        const SizedBox(
                                                            width: 4.0),
                                                        Text(DateFormat(
                                                                'dd MMM, yyyy')
                                                            .format(task
                                                                .dateTime!)),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8.0),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.access_time,
                                                          size: 16.0,
                                                          color: Colors.grey,
                                                        ),
                                                        const SizedBox(
                                                            width: 4.0),
                                                        Text(DateFormat(
                                                                'hh:mm a')
                                                            .format(task
                                                                .dateTime!)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : null,
                                        trailing: IconButton(
                                          icon: Icon(
                                            task.isStarred ?? false
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: task.isStarred ?? false
                                                ? Colors.amber
                                                : Colors.grey,
                                          ),
                                          onPressed: () {
                                            taskProvider.toggleTaskStarred(
                                                index, task);
                                          },
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TaskDetailsPage(task: task),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              Consumer<TaskProvider>(
                                builder: (context, taskProvider, _) {
                                  final tasks = taskProvider.tasks;
                                  if (tasks.isEmpty) {
                                    return const Center(
                                        child: Text('No tasks available'));
                                  }
                                  return ListView.builder(
                                    itemCount: tasks.length,
                                    itemBuilder: (context, index) {
                                      final task = tasks[index];
                                      return ListTile(
                                        leading: Checkbox(
                                          value: task.isCompleted,
                                          onChanged: (bool? value) {
                                            if (value != null) {
                                              taskProvider.toggleTaskCompletion(
                                                  index, task);
                                            }
                                          },
                                        ),
                                        title: Text(task.title),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                        subtitle: task.dateTime != null
                                            ? Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.calendar_today,
                                                          size: 16.0,
                                                          color: Colors.grey,
                                                        ),
                                                        const SizedBox(
                                                            width: 4.0),
                                                        Text(DateFormat(
                                                                'dd MMM, yyyy')
                                                            .format(task
                                                                .dateTime!)),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8.0),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.access_time,
                                                          size: 16.0,
                                                          color: Colors.grey,
                                                        ),
                                                        const SizedBox(
                                                            width: 4.0),
                                                        Text(DateFormat(
                                                                'hh:mm a')
                                                            .format(task
                                                                .dateTime!)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : null,
                                        trailing: IconButton(
                                          icon: Icon(
                                            task.isStarred ?? false
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: task.isStarred ?? false
                                                ? Colors.amber
                                                : Colors.grey,
                                          ),
                                          onPressed: () {
                                            taskProvider.toggleTaskStarred(
                                                index, task);
                                          },
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TaskDetailsPage(task: task),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              Consumer<TaskProvider>(
                                builder: (context, taskProvider, _) {
                                  final completedTasks =
                                      taskProvider.completedTasks;
                                  if (completedTasks.isEmpty) {
                                    return const Center(
                                        child: Text(
                                            'No completed tasks available'));
                                  }
                                  return ListView.builder(
                                    itemCount: completedTasks.length,
                                    itemBuilder: (context, index) {
                                      final task = completedTasks[index];
                                      return ListTile(
                                        leading: Checkbox(
                                          value: task.isCompleted,
                                          onChanged: (bool? value) {
                                            if (value != null) {
                                              taskProvider.toggleTaskCompletion(
                                                  index, task);
                                            }
                                          },
                                        ),
                                        title: Text(task.title),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                        subtitle: task.dateTime != null
                                            ? Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.calendar_today,
                                                          size: 16.0,
                                                          color: Colors.grey,
                                                        ),
                                                        const SizedBox(
                                                            width: 4.0),
                                                        Text(DateFormat(
                                                                'dd MMM, yyyy')
                                                            .format(task
                                                                .dateTime!)),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8.0),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.access_time,
                                                          size: 16.0,
                                                          color: Colors.grey,
                                                        ),
                                                        const SizedBox(
                                                            width: 4.0),
                                                        Text(DateFormat(
                                                                'hh:mm a')
                                                            .format(task
                                                                .dateTime!)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : null,
                                        trailing: IconButton(
                                          icon: Icon(
                                            task.isStarred ?? false
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: task.isStarred ?? false
                                                ? Colors.amber
                                                : Colors.grey,
                                          ),
                                          onPressed: () {
                                            taskProvider.toggleTaskStarred(
                                                index, task);
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskBottomSheet(context),
        backgroundColor: Colors.red.shade100,
        foregroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
    );
  }
}

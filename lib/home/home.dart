import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/home/completed_tasks.dart';
import 'package:task_app/home/my_tasks.dart';
import 'package:task_app/home/starred_tasks.dart';

import '../add_task.dart';
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
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Today's Task",
                            style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 4),
                        Consumer<TaskProvider>(
                          builder: (context, taskProvider, child) {
                            final completedTasks =
                                taskProvider.completedTasks.length;
                            final totalTasks = taskProvider.tasks.length;
                            return Text(
                              "$completedTasks/$totalTasks completed",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Total Task to be completed",
                            style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 4),
                        Consumer<TaskProvider>(
                            builder: (context, taskProvider, child) {
                          final completedTasks =
                              taskProvider.completedTasks.length;
                          return Text(
                            "$completedTasks tasks",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          );
                        })
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
                        padding:
                            const EdgeInsets.only(right: 16, left: 16, top: 8),
                        child: TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: TabBarView(
                            controller: _tabController,
                            children: const [
                              MyTasks(),
                              CompletedTasks(),
                              StarredTasks()
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

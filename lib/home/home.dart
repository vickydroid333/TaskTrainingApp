import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
      backgroundColor: const Color(0xFFEDE8E2),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Image.asset(
                        'assets/images/profile.jpg',
                        width: 34,
                        height: 34,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good day',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF303030),
                              fontFamily: 'SFProDisplay',
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                          'Bernice Thompson!',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'SFProDisplay',
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SvgPicture.asset('assets/images/settings.svg',
                        colorFilter: const ColorFilter.mode(
                            Color(0xFF231F20), BlendMode.srcIn))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Divider(
                  color: Colors.grey[300],
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
                            style: TextStyle(
                                color: Color(0xFF303030),
                                fontSize: 12,
                                fontFamily: 'SFProDisplay',
                                fontWeight: FontWeight.normal)),
                        const SizedBox(height: 4),
                        Consumer<TaskProvider>(
                          builder: (context, taskProvider, child) {
                            final completedTasks =
                                taskProvider.completedTasks.length;
                            final totalTasks = taskProvider.tasks.length;
                            return Text(
                              "$completedTasks/$totalTasks completed",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'SFProDisplay'),
                            );
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Total Task to be completed",
                            style: TextStyle(
                                color: Color(0xFF303030),
                                fontSize: 12,
                                fontFamily: 'SFProDisplay',
                                fontWeight: FontWeight.normal)),
                        const SizedBox(height: 4),
                        Consumer<TaskProvider>(
                            builder: (context, taskProvider, child) {
                          final completedTasks =
                              taskProvider.completedTasks.length;
                          return Text(
                            "$completedTasks tasks",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SFProDisplay'),
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
                      TabBar(
                        padding: const EdgeInsets.only(
                            left: 20, right: 16, top: 12, bottom: 0),
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        controller: _tabController,
                        indicatorColor: const Color(0xFFB13D3D),
                        labelColor: Colors.black,
                        dividerColor: Colors.white,
                        unselectedLabelColor: Colors.grey,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: const TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.w600),
                        unselectedLabelStyle: const TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.normal),
                        tabs: const [
                          Tab(icon: Icon(Icons.star_border)),
                          Tab(
                            text: "My Tasks",
                          ),
                          Tab(text: "Completed Tasks"),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: TabBarView(
                            controller: _tabController,
                            children: const [
                              StarredTasks(),
                              MyTasks(),
                              CompletedTasks()
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
        backgroundColor: const Color(0xFFFFE4E4),
        child: SvgPicture.asset(
          'assets/images/add.svg',
        ),
      ),
    );
  }
}

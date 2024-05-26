import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'task.dart';

class TaskProvider extends ChangeNotifier {
  Box<Task>? _taskBox;

  TaskProvider() {
    _init();
  }

  Future<void> _init() async {
    try {
      _taskBox = await Hive.openBox<Task>('tasksBox');
      notifyListeners();
    } catch (e) {
      // Handle error if needed
      print("Error opening Hive box: $e");
    }
  }

  List<Task> get tasks {
    if (_taskBox == null) {
      return [];
    }
    return _taskBox!.values.toList();
  }

  List<Task> get completedTasks {
    if (_taskBox == null) {
      return [];
    }
    return _taskBox!.values.where((task) => task.isCompleted == true).toList();
  }

  List<Task> get starredTasks {
    if (_taskBox == null) {
      return [];
    }
    return _taskBox!.values.where((task) => task.isStarred == true).toList();
  }

  @override
  void dispose() {
    _taskBox?.compact();
    super.dispose();
  }

  void addTask(Task task, [int? index]) {
    if (index != null && index >= 0 && index < tasks.length) {
      _taskBox?.putAt(index, task);
    } else {
      _taskBox?.add(task);
    }
    notifyListeners();
  }

  // If we can remove from my tasks tab and then add completed tasks tab.
  void toggleTaskCompletion(int index, Task task) {
    task.isCompleted = !(task.isCompleted ?? false);
    _taskBox?.putAt(index, task);
    notifyListeners();
  }

  void toggleTaskStarred(int index, Task task) {
    task.isStarred = !(task.isStarred ?? false);
    _taskBox?.putAt(index, task);
    notifyListeners();
  }

  void updateTask(int index, Task updatedTask) {
    tasks[index] = updatedTask;
    notifyListeners();
  }

  void removeTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }
}

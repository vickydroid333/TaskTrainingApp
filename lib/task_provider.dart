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
    // Retrieve incomplete tasks in reverse order to show the newest task first
    return _taskBox!.values
        .where((task) => task.isCompleted != true)
        .toList()
        .reversed
        .toList();
  }

  List<Task> get completedTasks {
    if (_taskBox == null) {
      return [];
    }
    return _taskBox!.values
        .where((task) => task.isCompleted == true)
        .toList()
        .reversed
        .toList();
  }

  List<Task> get starredTasks {
    if (_taskBox == null) {
      return [];
    }
    return _taskBox!.values
        .where((task) => task.isStarred == true)
        .toList()
        .reversed
        .toList();
  }

  @override
  void dispose() {
    _taskBox?.compact();
    super.dispose();
  }

  void addTask(Task task, [dynamic key]) {
    if (key != null) {
      _taskBox?.put(key, task);
    } else {
      _taskBox?.add(task);
    }
    notifyListeners();
  }

  void toggleTaskCompletion(Task task) {
    task.isCompleted = !(task.isCompleted ?? false);
    _taskBox?.put(task.key, task);
    notifyListeners();
  }

  void toggleTaskStarred(Task task) {
    task.isStarred = !(task.isStarred ?? false);
    _taskBox?.put(task.key, task);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    _taskBox?.put(updatedTask.key, updatedTask);
    notifyListeners();
  }

  void removeTask(dynamic key) {
    _taskBox?.delete(key);
    notifyListeners();
  }

  void updateTaskDate(Task task, DateTime dateTime) {
    task.dateTime = dateTime;
    _taskBox?.put(task.key, task);
    notifyListeners();
  }

  void removeTaskDate(Task task) {
    task.dateTime = null;
    _taskBox?.put(task.key, task);
    notifyListeners();
  }

  dynamic getKeyAt(int index) {
    final tasksList = tasks;
    if (index >= 0 && index < tasksList.length) {
      return _taskBox
          ?.keyAt(_taskBox!.values.toList().indexOf(tasksList[index]));
    }
    return null;
  }

  int getTaskIndex(Task task) {
    return tasks.indexOf(task);
  }
}

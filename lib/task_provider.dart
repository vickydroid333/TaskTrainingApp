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

  void addTask(Task task, [dynamic key]) {
    if (key != null) {
      _taskBox?.put(key, task);
    } else {
      _taskBox?.add(task);
    }
    notifyListeners();
  }

  void toggleTaskCompletion(int index, Task task) {
    task.isCompleted = !(task.isCompleted ?? false);
    _taskBox?.put(task.key, task);
    notifyListeners();
  }

  void toggleTaskStarred(int index, Task task) {
    task.isStarred = !(task.isStarred ?? false);
    _taskBox?.put(task.key, task);
    notifyListeners();
  }

  void updateTask(int index, Task updatedTask) {
    final key = _taskBox?.keyAt(index);
    if (key != null) {
      _taskBox?.put(key, updatedTask);
    }
    notifyListeners();
  }

  void removeTask(dynamic key) {
    _taskBox?.delete(key);
    notifyListeners();
  }

  void updateTaskDate(int index, DateTime dateTime) {
    tasks[index].dateTime = dateTime;
    _taskBox?.putAt(index, tasks[index]);
    notifyListeners();
  }

  void removeTaskDate(int index) {
    tasks[index].dateTime = null;
    _taskBox?.putAt(index, tasks[index]);
    notifyListeners();
  }

  dynamic getKeyAt(int index) {
    return _taskBox?.keyAt(index);
  }

  int getTaskIndex(Task task) {
    return _taskBox?.values.toList().indexOf(task) ?? -1;
  }
}

import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final DateTime? dateTime;

  @HiveField(2)
  bool? isStarred;

  @HiveField(3)
  bool? isCompleted;

  Task({
    required this.title,
    this.dateTime,
    this.isStarred = false,
    this.isCompleted = false,
  });
}

class Task {
  String title;
  bool isCompleted;
  bool isStarred;
  bool hasDateTime;

  Task({
    required this.title,
    this.isCompleted = false,
    this.isStarred = false,
    this.hasDateTime = false,
  });
}

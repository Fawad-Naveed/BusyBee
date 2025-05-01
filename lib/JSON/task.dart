class Task {
  int? taskId;           // Auto-incremented primary key
  String title;
  String description;
  int isCompleted;       // Use 0 for false, 1 for true
  String? dueDate;       // Store as ISO string (e.g. "2025-04-24T15:30:00")
  int userId;            // Foreign key

  Task({
    this.taskId,
    required this.title,
    required this.description,
    this.isCompleted = 0,
    this.dueDate,
    required this.userId,
  });

  // Convert a Task object into a Map
  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate,
      'userId': userId,
    };
  }

  // Create a Task object from a Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      taskId: map['taskId'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'],
      dueDate: map['dueDate'],
      userId: map['userId'],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:BusyBee/JSON/task.dart';  // your current task.dart file

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  String _filter = 'all';

  List<Task> get filteredTasks {
    final today = DateTime.now();
    return _tasks.where((task) {
      if (task.dueDate == null) return false;

      final taskDate = DateTime.parse(task.dueDate!);

      bool isToday = taskDate.year == today.year &&
                     taskDate.month == today.month &&
                     taskDate.day == today.day;

      if (!isToday) return false;

      if (_filter == 'completed') return task.isCompleted == 1;
      if (_filter == 'pending') return task.isCompleted == 0;
      return true; // all
    }).toList();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void toggleTaskCompletion(Task task) {
    task.isCompleted = task.isCompleted == 1 ? 0 : 1;
    notifyListeners();
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  String get currentFilter => _filter;
}

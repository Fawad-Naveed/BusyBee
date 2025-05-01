import 'package:flutter/material.dart';
class TaskTile extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String notificationTime;

  const TaskTile({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.notificationTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(description),
            const SizedBox(height: 4),
            Text('Date: $date'),
            Text('Notify: $notificationTime'),
          ],
        ),
      ),
    );
  }
}
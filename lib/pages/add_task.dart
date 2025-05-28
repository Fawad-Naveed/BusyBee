import 'package:BusyBee/services/notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  final bool isDaily;
  const AddTaskScreen(this.isDaily,{super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _notificationTimeController = TextEditingController();
  DateTime combineDateAndTime(String dateString, String timeString) {
  // Parse the fullDate string (e.g., "31-12-2025") into day/month/year
  final dateParts = dateString.split('-');
  final day = int.parse(dateParts[0]);
  final month = int.parse(dateParts[1]);
  final year = int.parse(dateParts[2]);

  // Parse the timeString (e.g., "14:30") into hours/minutes
  final timeParts = timeString.split(':');
  final hour = int.parse(timeParts[0]);
  final minute = int.parse(timeParts[1]);

  return DateTime(year, month, day, hour, minute);
}

  @override
  Widget build(BuildContext context) {
    String fullDate;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important for Dialog sizing
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Task',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Topic',
                hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Description',
                hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            if (!widget.isDaily)...[
              const Text(
                "Date",
                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        hintText: 'Day',
                        hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _monthController,
                      decoration: const InputDecoration(
                        hintText: 'Month',
                        hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _yearController,
                      decoration: const InputDecoration(
                        hintText: 'Year',
                        hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            const SizedBox(height: 20),
            TextField(
              controller: _notificationTimeController,
              decoration: const InputDecoration(
                hintText: 'Notification Time',
                hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 123, 181, 144), Color.fromARGB(255, 153, 212, 241)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isNotEmpty &&
                      _descriptionController.text.isNotEmpty) {
                    int day = int.tryParse(_dateController.text) ?? 0;
                    int month = int.tryParse(_monthController.text) ?? 0;
                    int rawYear = int.tryParse(_yearController.text) ?? 0;
                    int year = rawYear < 100 ? 2000 + rawYear : rawYear;
                    if(!widget.isDaily){
                      if(day < 1 || day > 31 || month < 1 || month > 12) {
                     showDialog(context: context, builder: (BuildContext context){
                        return AlertDialog(
                          title: const Text('Invalid Date'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                      return;
                    }
                    if (month == 2 && day > 29) {
                      showDialog(context: context, builder: (BuildContext context){
                        return AlertDialog(
                          title: const Text('Invalid Date'),
                          content: const Text('February cannot have more than 29 days.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                      return;
                    }
                      fullDate = DateFormat('d-M-y').format(DateTime(year, month, day));
                    }else{
                      fullDate = DateFormat('d-M-y').format(DateTime.now());
                    }
                    DateTime notificationTime ;
                    try {
                      notificationTime = combineDateAndTime(fullDate, _notificationTimeController.text);
                      if (notificationTime.isBefore(DateTime.now())) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Invalid Notification Time'),
                            content: Text('Notification time cannot be in the past.'),
                            actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
                          ),
                        );
                        return;
                      }
                      else{
                        Notifications notifications = Notifications();
                        notifications.scheduleNotification(
                          id: notificationTime.millisecondsSinceEpoch.remainder(100000),
                          title: _titleController.text,
                          body: _descriptionController.text,
                          scheduledDate: notificationTime,
                        );
                      }
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Invalid Time Format'),
                          content: Text('Please enter time in HH:mm format (e.g., 14:30)'),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
                        ),
                      );
                      return;
                    }
                    //print('Full Date: $fullDate');
                    Navigator.pop(context, {
                      'title': _titleController.text,
                      'description': _descriptionController.text,
                      'date': fullDate,
                      'notificationTime': _notificationTimeController.text,
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Add Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

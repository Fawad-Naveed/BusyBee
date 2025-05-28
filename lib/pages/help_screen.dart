import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & User Guide'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          SectionHeader(icon: Icons.home, title: "Home Page Overview"),
          HelpText(
            "The Home Page has two main views:\n"
            "- Daily Tasks\n"
            "- Monthly Tasks\n\n"
            "Use the filter at the top to switch between them.",
          ),

          SectionHeader(icon: Icons.today, title: "Daily Tasks"),
          HelpText(
            "➕ Add Task:\n"
            "Tap the add button to create a task. You’ll need to:\n"
            "- Enter a Title\n"
            "- Add a Description\n"
            "- Set a Notification Time (in 24-hour format)\n\n"
            "📋 Manage Task:\n"
            "Tap on any task to:\n"
            "- View its full details\n"
            "- Mark it as Completed\n"
            "- Delete the task",
          ),

          SectionHeader(icon: Icons.calendar_month, title: "Monthly Tasks"),
          HelpText(
            "➕ Add Task:\n"
            "Tap the add button to create a monthly task. You’ll need to:\n"
            "- Enter a Title\n"
            "- Add a Description\n"
            "- Set a Date\n"
            "- Set a Notification Time (24-hour format)\n\n"
            "📅 Filter Tasks by Date:\n"
            "Use the calendar or date filter to view tasks for a specific date.\n\n"
            "📋 Manage Task:\n"
            "Tap any task to:\n"
            "- View full details\n"
            "- Mark as Completed\n"
            "- Delete the task",
          ),

          SectionHeader(icon: Icons.person, title: "Profile"),
          HelpText(
            "On the Profile Screen, you can:\n"
            "- Edit your Personal Information such as name or email.\n\n"
            "Access this via the Profile Icon in the Bottom Navigation Bar.",
          ),

          SectionHeader(icon: Icons.menu, title: "Drawer Menu"),
          HelpText(
            "Tap the Drawer Icon to open the side menu:\n"
            "- 🌙 Dark Mode / Light Mode: Toggle app theme.\n"
            "- 🧹 Filter by Completion Status:\n"
            "  • All Tasks\n"
            "  • Only Completed Tasks\n"
            "  • Only Pending Tasks\n"
            "- ❓ Help: Opens this guide.",
          ),

          SectionHeader(icon: Icons.notifications, title: "Notifications"),
          HelpText(
            "All tasks can be scheduled with reminders. Ensure:\n"
            "- Time is in 24-hour format\n"
            "- Notification permissions are granted on your device.",
          ),

          SizedBox(height: 16),
          Center(
            child: Text(
              "We hope this makes using BusyBee easier and more productive! 😊",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class HelpText extends StatelessWidget {
  final String text;

  const HelpText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

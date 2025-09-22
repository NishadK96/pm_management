import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String timeAgo;
  final String description;

  NotificationItem({
    required this.title,
    required this.timeAgo,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey,
          child: Icon(Icons.notifications, color: Colors.white),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(timeAgo, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}
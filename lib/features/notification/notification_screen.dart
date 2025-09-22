

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/features/notification/widget/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int count=1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:count==0? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.string(IconConst().notificationBell),
            SizedBox(height: 16),
            Text(
              'No Notification Yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('You have no notification right now. Comeback later'),
          ],
        ):ListView(
          children: [
            NotificationItem(
              title: 'Task created successfully!',
              timeAgo: '1hr ago',
              description:
              'Amet minim mollit not ull lorem ipsummet minim mollit not ull lorem ipsum dolor.',
            ),
          ],
        ),
      ),
    );
  }
}

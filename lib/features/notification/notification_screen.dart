

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipsum_user/core/constants/icon_constants.dart';
import 'package:ipsum_user/core/widgets/title_widget.dart';
import 'package:ipsum_user/features/notification/widget/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int count=1;
  @override
  Widget build(BuildContext context) {
    var w= MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: TitleWidget(label: 'Notifications')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:count==0? Container(
          padding: EdgeInsets.only(top: 50),
          width: w,
            child: SvgPicture.string(IconConst().emptyNotification)):
        NotificationItem(
          title: 'Task created successfully!',
          timeAgo: '1hr ago',
          description:
          'Amet minim mollit not ull lorem ipsummet minim mollit not ull lorem ipsum dolor.',
        ),
      ),
    );
  }
}

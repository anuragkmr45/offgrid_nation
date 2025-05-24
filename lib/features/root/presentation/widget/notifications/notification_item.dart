import 'package:flutter/material.dart';
import './notification_model.dart';

class NotificationItem extends StatelessWidget {
  final String name;
  final String action;
  final String time;
  final String avatar;

  NotificationItem({required this.name, required this.action, required this.time, required this.avatar});

  factory NotificationItem.fromModel(AppNotification model) {
    return NotificationItem(
      name: model.name,
      action: model.action,
      time: model.time,
      avatar: model.avatar,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(backgroundImage: AssetImage(avatar)),
      title: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(text: name, style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: ' $action'),
          ],
        ),
      ),
      trailing: Text(time, style: TextStyle(color: Colors.grey)),
    );
  }
}

// // 📁 lib/core/services/notification_listener_service.dart
// import 'dart:convert';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:offgrid_nation_app/core/services/pusher_service.dart';

// class NotificationListenerService {
//   static final NotificationListenerService _singleton = NotificationListenerService._internal();
//   factory NotificationListenerService() => _singleton;

//   NotificationListenerService._internal();

//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   String? _currentUserId;

//   Future<void> initLocalNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher'); // your app icon

//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         final convId = response.payload;
//         if (convId != null) {
//           print('Notification tapped → conversationId: $convId');
//           // You can later handle navigation here (optional)
//         }
//       },
//     );
//   }

//   void startListening(String userId) {
//     _currentUserId = userId;

//     PusherService().subscribeNotifications(
//       userId: userId,
//       onPushNotification: (data) {
//         final convId = data['conversationId'];
//         final sender = data['sender'];
//         final actionType = data['actionType'];

//         String title = '${sender['username']} sent you a message';
//         String body = '';

//         if (actionType == 'text') {
//           body = data['text'] ?? '';
//         } else if (actionType == 'media') {
//           body = '${sender['username']} sent a media file';
//         } else if (actionType == 'post') {
//           body = 'A post was shared with you';
//         } else {
//           body = 'You received a new message';
//         }

//         _showLocalNotification(title, body, convId);
//       },
//     );
//   }

//   void stopListening() {
//     if (_currentUserId != null) {
//       PusherService().unsubscribeNotifications(_currentUserId!);
//       _currentUserId = null;
//     }
//   }

//   Future<void> _showLocalNotification(String title, String body, String conversationId) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'chat_channel', // channel id
//       'Chat Notifications', // channel name
//       channelDescription: 'Chat message notifications',
//       importance: Importance.high,
//       priority: Priority.high,
//       playSound: true,
//     );

//     const NotificationDetails platformDetails = NotificationDetails(
//       android: androidDetails,
//     );

//     await _flutterLocalNotificationsPlugin.show(
//       0, // notification id
//       title,
//       body,
//       platformDetails,
//       payload: conversationId,
//     );
//   }
// }

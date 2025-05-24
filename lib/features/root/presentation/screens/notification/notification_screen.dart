import 'package:flutter/material.dart';
import '../../widget/notifications/notification_item.dart';
import '../../widget/notifications/notification_model.dart';
import '../../widget/notifications/suggested_user_tile.dart';

class NotificationScreen extends StatelessWidget {
  final List<AppNotification> notifications = AppNotification.sampleData;

  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null, // if root screen, no back button
      ),
      body: SafeArea(
        child: FutureBuilder<List<AppNotification>>(
          future: Future.value(notifications), // Placeholder for API call
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _sectionTitle("Today"),
                ...data
                    .where((n) => n.section == 'today')
                    .map(NotificationItem.fromModel)
                    .toList(),

                _sectionTitle("Yesterday"),
                ...data
                    .where((n) => n.section == 'yesterday')
                    .map(NotificationItem.fromModel)
                    .toList(),

                _sectionTitle("Last 7 Days"),
                ...data
                    .where((n) => n.section == 'last7')
                    .map(NotificationItem.fromModel)
                    .toList(),

                _sectionTitle("Suggested for you"),
                SuggestedUserTile(
                  name: "Lorna Alvarado",
                  username: "@lovie34",
                  avatar: 'assets/avatar3.png',
                ),
                SuggestedUserTile(
                  name: "Olivia Wilson",
                  username: "@low_9000",
                  avatar: 'assets/avatar4.png',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

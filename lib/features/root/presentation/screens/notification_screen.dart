import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = [
      {
        "name": "Claudia Alves",
        "image": "https://i.pravatar.cc/150?img=11",
        "message": "started following you.",
        "time": "20min",
      },
      {
        "name": "Avery Davis",
        "image": "https://i.pravatar.cc/150?img=12",
        "message": "and 17 others liked your post.",
        "time": "21min",
      },
    ];

    final yesterday = [
      {
        "name": "Claudia Alves",
        "image": "https://i.pravatar.cc/150?img=11",
        "message": "started following you.",
        "time": "20h",
      },
      {
        "name": "Avery Davis",
        "image": "https://i.pravatar.cc/150?img=12",
        "message": "and 17 others liked your post.",
        "time": "17h",
      },
    ];

    final last7days = [
      {
        "name": "Claudia Alves",
        "image": "https://i.pravatar.cc/150?img=11",
        "message": "started following you.",
        "time": "1d",
      },
      {
        "name": "Avery Davis",
        "image": "https://i.pravatar.cc/150?img=12",
        "message": "and 17 others liked your post.",
        "time": "3d",
      },
    ];

    final suggested = [
      {
        "name": "Lorna Alvarado",
        "username": "@lovie34",
        "image": "https://i.pravatar.cc/150?img=14",
      },
      {
        "name": "Olivia Wilson",
        "username": "@low_9000",
        "image": "https://i.pravatar.cc/150?img=15",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0099FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0099FF),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Today", style: _sectionStyle),
          ..._buildNotificationList(today),
          const SizedBox(height: 16),
          const Text("Yesterday", style: _sectionStyle),
          ..._buildNotificationList(yesterday),
          const SizedBox(height: 16),
          const Text("Last 7days", style: _sectionStyle),
          ..._buildNotificationList(last7days),
          const SizedBox(height: 20),
          const Text("Suggested for you", style: _sectionStyle),
          const SizedBox(height: 10),
          ...suggested.map((user) => _buildSuggestedUser(user)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF007ACC),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Add"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifs",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  static const _sectionStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  List<Widget> _buildNotificationList(List<Map<String, String>> items) {
    return items.map((item) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(item["image"]!),
          radius: 22,
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: item["name"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: " ${item["message"]}",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        trailing: Text(
          item["time"]!,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      );
    }).toList();
  }

  Widget _buildSuggestedUser(Map<String, String> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user["image"]!),
            radius: 25,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user["name"]!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user["username"]!,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("Follow"),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

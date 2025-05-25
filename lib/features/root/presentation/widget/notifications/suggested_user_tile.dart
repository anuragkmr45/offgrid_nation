import 'package:flutter/material.dart';

class SuggestedUserTile extends StatelessWidget {
  final String name;
  final String username;
  final String avatar;

  SuggestedUserTile({
    required this.name,
    required this.username,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: AssetImage(avatar)),
        title: Text(name),
        subtitle: Text(username),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              child: Text('Follow'),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

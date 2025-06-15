import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/features/chat/domain/entities/chat_user_entity.dart';

class UserSearchCard extends StatelessWidget {
  final ChatUserEntity user;
  final VoidCallback? onTap;

  const UserSearchCard({
    super.key,
    required this.user,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(user.profilePicture),
          ),
          const SizedBox(width: 12),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  '@${user.username}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),

          // Send icon
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: onTap,
            tooltip: 'Send to ${user.username}',
          ),
        ],
      ),
    );
  }
}

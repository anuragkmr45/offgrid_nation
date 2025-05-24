import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';

class ChatListItem extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  final String lastMessage;
  final String timeLabel;
  final int unreadCount;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.avatarUrl,
    required this.userName,
    required this.lastMessage,
    required this.timeLabel,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = Platform.isIOS;

    final userNameStyle =
        isIOS
            ? CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.background,
            )
            : Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.background,
            );

    final messageStyle =
        isIOS
            ? CupertinoTheme.of(context).textTheme.textStyle.copyWith(
              fontSize: 10,
              color: AppColors.background,
            )
            : Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 10,
              color: AppColors.background,
            );

    final timeStyle =
        isIOS
            ? CupertinoTheme.of(context).textTheme.textStyle.copyWith(
              fontSize: 12,
              color: AppColors.background,
            )
            : Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.background);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(radius: 24, backgroundImage: NetworkImage(avatarUrl)),
            const SizedBox(width: 12),
            // Name and last message column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName, style: userNameStyle),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage,
                    style: messageStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Time label and read indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(timeLabel, style: timeStyle),
                const SizedBox(height: 4),
                unreadCount > 0
                    ? Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          unreadCount.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    : const Icon(Icons.done, size: 16, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

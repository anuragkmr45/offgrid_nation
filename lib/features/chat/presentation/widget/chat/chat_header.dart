import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';

class ChatHeader extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String name;
  final String profilePicture;
  final String status;
  final VoidCallback onBack;

  const ChatHeader({
    super.key,
    required this.userName,
    required this.name,
    required this.profilePicture,
    required this.status,
    required this.onBack,
  });

  void _navigateToUserProfile(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/user-profile',
      arguments: userName,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: onBack,
          child: const Icon(CupertinoIcons.back),
        ),
        middle: GestureDetector(
          onTap: () => _navigateToUserProfile(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: CachedNetworkImageProvider(profilePicture),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(status, style: const TextStyle(fontSize: 12, color: AppColors.background)),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: GestureDetector(
          onTap: () => _navigateToUserProfile(context),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: CachedNetworkImageProvider(profilePicture),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.background)),
                  Text("@$userName", style: const TextStyle(fontSize: 12, color: AppColors.background)),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

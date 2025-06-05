import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:offgrid_nation_app/core/constants/theme_constants.dart' show AppColors;

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
              // Uncomment below if status needed
              // Text(status, style: const TextStyle(fontSize: 12, color: AppColors.background)),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
              // Uncomment below if status needed
              // Text(status, style: const TextStyle(fontSize: 12, color: AppColors.background)),
            ],
          ),
        ),
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';

class TopicListItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  const TopicListItem({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    // Detect if the platform is iOS or not.
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    // Platform-specific text style for the title.
    final titleStyle =
        isIOS
            ? CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )
            : Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            );

    return Container(
      // The outer container has a colored background and rounded corners.
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Expanded text on the left
          Expanded(child: Text(title, style: titleStyle)),
          // Image on the right, clipped with a rounded rectangle
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 100,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 60,
                  color: Colors.grey,
                  child: const Icon(Icons.broken_image, color: Colors.white),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

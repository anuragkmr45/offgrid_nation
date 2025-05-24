import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/widgets/media_carousel/media_carousel.dart';

class PostWidget extends StatefulWidget {
  final String userName;
  final String userAvatarUrl;
  final String timeText;
  final List<String> mediaUrls;
  final String description;
  final VoidCallback onThunderPressed;
  final VoidCallback onCommentPressed;
  final VoidCallback onSharePressed;
  final VoidCallback onProfileTap;
  final bool isLiked;
  final int likeCount;
  final int commentCount;

  const PostWidget({
    super.key,
    required this.userName,
    required this.userAvatarUrl,
    required this.timeText,
    required this.mediaUrls,
    required this.description,
    required this.onThunderPressed,
    required this.onCommentPressed,
    required this.onSharePressed,
    required this.onProfileTap,
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool _isExpanded = false;

  String get _displayText {
    if (_isExpanded || widget.description.length <= 40) {
      return widget.description;
    } else {
      return widget.description.substring(0, 40) + '...';
    }
  }

  String get _toggleLabel {
    if (widget.description.length <= 40) return '';
    return _isExpanded ? 'Read less' : 'Read more';
  }

  Widget _buildDescription(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => setState(() => _isExpanded = true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_displayText, style: const TextStyle(fontSize: 14)),
          if (_toggleLabel.isNotEmpty)
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  _toggleLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color:
                        Platform.isIOS
                            ? CupertinoColors.activeBlue
                            : Colors.blue,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool get shouldShowTextAsTweetPost =>
      widget.mediaUrls.isEmpty && widget.description.trim().isNotEmpty;

  Widget _buildMediaOrTweetLikeText() {
    if (widget.mediaUrls.isNotEmpty) {
      return MediaCarousel(mediaUrls: widget.mediaUrls);
    } else if (shouldShowTextAsTweetPost) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              Platform.isIOS
                  ? CupertinoColors.systemGrey6
                  : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(widget.description, style: const TextStyle(fontSize: 16)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _buildCupertinoPost(context)
        : _buildMaterialPost(context);
  }

  Widget _buildMaterialPost(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onProfileTap,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(widget.userAvatarUrl),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: widget.onProfileTap,
                      child: Text(
                        widget.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      widget.timeText,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildMediaOrTweetLikeText(),
            const SizedBox(height: 8),
            Row(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                  child: IconButton(
                    key: ValueKey<bool>(widget.isLiked),
                    icon: Image.asset(
                      widget.isLiked
                          ? 'lib/assets/images/post-like-icon.png'
                          : 'lib/assets/images/post-dislike-icon.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: widget.onThunderPressed,
                  ),
                ),
                IconButton(
                  icon: Image.asset(
                    'lib/assets/images/comment-icon.png',
                    width: 24,
                    height: 24,
                  ),
                  onPressed: widget.onCommentPressed,
                ),
                IconButton(
                  icon: Image.asset(
                    'lib/assets/images/share-icon.png',
                    width: 24,
                    height: 24,
                  ),
                  onPressed: widget.onSharePressed,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0),
              child: Row(
                children: [
                  Text(
                    '${widget.likeCount} likes',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${widget.commentCount} comments',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            if (!shouldShowTextAsTweetPost) _buildDescription(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCupertinoPost(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: CupertinoColors.systemGrey4,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onProfileTap,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(widget.userAvatarUrl),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: widget.onProfileTap,
                      child: Text(
                        widget.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      widget.timeText,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildMediaOrTweetLikeText(),
            const SizedBox(height: 8),
            Row(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                  child: CupertinoButton(
                    key: ValueKey<bool>(widget.isLiked),
                    padding: EdgeInsets.zero,
                    onPressed: widget.onThunderPressed,
                    child: Image.asset(
                      widget.isLiked
                          ? 'lib/assets/images/post-like-icon.png'
                          : 'lib/assets/images/post-dislike-icon.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: widget.onCommentPressed,
                  child: Image.asset(
                    'lib/assets/images/comment-icon.png',
                    width: 24,
                    height: 24,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: widget.onSharePressed,
                  child: Image.asset(
                    'lib/assets/images/share-icon.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0),
              child: Row(
                children: [
                  Text(
                    '${widget.likeCount} likes',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${widget.commentCount} comments',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            if (!shouldShowTextAsTweetPost) _buildDescription(context),
          ],
        ),
      ),
    );
  }
}

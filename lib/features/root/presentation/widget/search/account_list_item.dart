import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';

class ProfileListItem extends StatefulWidget {
  final String name;
  final String handle;
  final String avatarUrl;
  final bool isFollowing;
  final bool isBlocked;
  final Future<bool> Function() onFollow;

  const ProfileListItem({
    super.key,
    required this.name,
    required this.handle,
    required this.avatarUrl,
    required this.isFollowing,
    required this.isBlocked,
    required this.onFollow,
  });

  @override
  State<ProfileListItem> createState() => _ProfileListItemState();
}

class _ProfileListItemState extends State<ProfileListItem> {
  late bool _isFollowing;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.isFollowing;
  }

  Future<void> _handleFollowToggle() async {
    if (_isLoading || widget.isBlocked) return;

    setState(() => _isLoading = true);
    final success = await widget.onFollow();
    if (success) {
      setState(() => _isFollowing = !_isFollowing);
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final buttonLabel = _isFollowing ? 'UNFOLLOW' : 'FOLLOW';
    final buttonColor = _isFollowing ? Colors.redAccent : AppColors.primary;

    final followButton =
        widget.isBlocked
            ? const SizedBox.shrink()
            : isIOS
            ? CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: buttonColor,
              onPressed: _handleFollowToggle,
              child:
                  _isLoading
                      ? const CupertinoActivityIndicator()
                      : Text(buttonLabel),
            )
            : ElevatedButton(
              onPressed: _handleFollowToggle,
              style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
              child:
                  _isLoading
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : Text(buttonLabel),
            );

    return Container(
      color: AppColors.primary.withOpacity(0.9),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: CachedNetworkImageProvider(widget.avatarUrl),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(color: AppColors.background),
                ),
                Text(
                  widget.handle,
                  style: const TextStyle(color: AppColors.background),
                ),
              ],
            ),
          ),
          followButton,
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/user_profile_bloc.dart';

class SearchResultItem extends StatelessWidget {
  final String userId;
  final String name;
  final String handle;
  final String avatarUrl;
  final bool isFollowing;
  final bool isBlocked;

  const SearchResultItem({
    super.key,
    required this.userId,
    required this.name,
    required this.handle,
    required this.avatarUrl,
    required this.isFollowing,
    required this.isBlocked,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final nameStyle =
        isIOS
            ? CupertinoTheme.of(context).textTheme.navTitleTextStyle.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            )
            : Theme.of(context).textTheme.titleMedium;

    final handleStyle =
        isIOS
            ? CupertinoTheme.of(
              context,
            ).textTheme.textStyle.copyWith(fontSize: 14, color: Colors.white70)
            : Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white70);

    // 🔁 Wrap in BlocBuilder to rebuild on success
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        final isLoading =
            state.status == UserProfileStatus.loading &&
            state.toggleFollowUnfollowData == null;

        final followButton =
            isBlocked
                ? const Text(
                  'Blocked',
                ) // 🚫 If blocked, just show disabled text
                : isIOS
                ? CupertinoButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  color: Colors.white,
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            context.read<UserProfileBloc>().add(
                              UpdateToggleFollowUnfollowRequest(userId),
                            );
                          },
                  child: Text(
                    isFollowing ? 'UNFOLLOW' : 'FOLLOW',
                    style: const TextStyle(color: Colors.blue),
                  ),
                )
                : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                  ),
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            context.read<UserProfileBloc>().add(
                              UpdateToggleFollowUnfollowRequest(userId),
                            );
                          },
                  child: Text(isFollowing ? 'UNFOLLOW' : 'FOLLOW'),
                );

        return Container(
          color: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: CachedNetworkImageProvider(avatarUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: nameStyle),
                    const SizedBox(height: 4),
                    Text(handle, style: handleStyle),
                  ],
                ),
              ),
              followButton, // 🔁 Dynamic follow/unfollow button
            ],
          ),
        );
      },
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/session/auth_session.dart';
import 'package:offgrid_nation_app/core/utils/formate_post_time.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/content_bloc.dart';
import 'package:offgrid_nation_app/core/utils/feed_lazy_loader.dart';
import '../widget/feed/comments_modal.dart';
import '../widget/feed/post_widget.dart';
import '../widget/feed/share_post.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return const FeedScreenContent();
  }
}

class FeedScreenContent extends StatefulWidget {
  const FeedScreenContent({super.key});

  @override
  State<FeedScreenContent> createState() => _FeedScreenContentState();
}

class _FeedScreenContentState extends State<FeedScreenContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppColors.background,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    context.read<ContentBloc>().add(const FetchContentRequested());
    GetIt.I<AuthSession>().getCurrentUserId().then((id) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<ContentBloc, ContentState>(
        builder: (context, state) {
          if (state.status == ContentStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ContentStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Something went wrong.',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          final posts = state.contents ?? [];

          if (Platform.isIOS) {
            return Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    CupertinoSliverRefreshControl(
                      onRefresh: () async {
                        context.read<ContentBloc>().add(
                          const FetchContentRequested(),
                        );
                      },
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < posts.length) {
                            final post = posts[index];
                            // final isLiked = post.likes.contains(_currentUserId);
                            return PostWidget(
                              userName:
                                  (post.user.fullName.isNotEmpty)
                                      ? post.user.fullName
                                      : post.user.id,
                              userAvatarUrl: post.user.profilePicture,
                              timeText: formatPostTime(
                                post.createdAt.toLocal().toIso8601String(),
                              ),
                              mediaUrls:
                                  post.media.isNotEmpty ? post.media : [],
                              description: post.content,
                              isLiked: post.isLiked,
                              likeCount: post.likesCount,
                              commentCount: post.commentsCount,
                              onThunderPressed: () {
                                // ✅ Dispatch like/unlike event
                                context.read<ContentBloc>().add(
                                  ToggleLikeDislikeRequest(
                                    postId: post.id,
                                    context: context,
                                  ),
                                );
                              },
                              onCommentPressed: () {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder:
                                      (_) => BlocProvider.value(
                                        value: context.read<ContentBloc>(),
                                        child: Container(
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.6,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                          ),
                                          child: CommentModal(
                                            scrollController:
                                                ScrollController(),
                                            postId: post.id,
                                          ),
                                        ),
                                      ),
                                );
                              },

                              onSharePressed: () {
                                ShareHelper.showShareOptions(
                                  context,
                                  content: post.content,
                                  mediaUrls: post.media,
                                );
                              },

                              onProfileTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/user-profile',
                                  arguments: post.user.username,
                                );
                              },
                              // isLiked: isLiked,
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        },
                        childCount:
                            state.hasMore ? posts.length + 1 : posts.length,
                      ),
                    ),
                  ],
                ),
                FeedLazyLoader(
                  controller: _scrollController,
                  canFetchMore: () => context.read<ContentBloc>().state.hasMore,
                  onBottomReached: () {
                    context.read<ContentBloc>().add(
                      const FetchMoreContentRequested(),
                    );
                  },
                ),
              ],
            );
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  context.read<ContentBloc>().add(
                    const FetchContentRequested(),
                  );
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.hasMore ? posts.length + 1 : posts.length,
                  itemBuilder: (context, index) {
                    if (index < posts.length) {
                      final post = posts[index];
                      // final isLiked = post.likes.contains(_currentUserId);
                      return PostWidget(
                        userName:
                            (post.user.fullName.isNotEmpty)
                                ? post.user.fullName
                                : post.user.username,
                        userAvatarUrl: post.user.profilePicture,
                        timeText: formatPostTime(
                          post.createdAt.toLocal().toIso8601String(),
                        ),
                        mediaUrls: post.media.isNotEmpty ? post.media : [],
                        description: post.content,
                        isLiked: post.isLiked,
                        likeCount: post.likesCount,
                        commentCount: post.commentsCount,
                        onThunderPressed: () {
                          // ✅ Dispatch like/unlike event
                          context.read<ContentBloc>().add(
                            ToggleLikeDislikeRequest(
                              postId: post.id,
                              context: context,
                            ),
                          );
                        },
                        onCommentPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isDismissible: true,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (modalContext) {
                              return BlocProvider.value(
                                value: context.read<ContentBloc>(),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: DraggableScrollableSheet(
                                    initialChildSize: 0.6,
                                    minChildSize: 0.6,
                                    maxChildSize: 1.0,
                                    builder: (context, scrollController) {
                                      return CommentModal(
                                        scrollController: scrollController,
                                        postId: post.id,
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },

                        onSharePressed: () {
                          ShareHelper.showShareOptions(
                            context,
                            content: post.content,
                            mediaUrls: post.media,
                          );
                        },
                        onProfileTap: () {
                          Navigator.pushNamed(
                            context,
                            '/user-profile',
                            arguments: post.user.username,
                          );
                        },
                        // isLiked: isLiked,
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              ),
              FeedLazyLoader(
                controller: _scrollController,
                canFetchMore: () => context.read<ContentBloc>().state.hasMore,
                onBottomReached: () {
                  context.read<ContentBloc>().add(
                    const FetchMoreContentRequested(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

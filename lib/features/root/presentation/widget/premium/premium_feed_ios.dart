import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/utils/feed_lazy_loader.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/premium/post_entity.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/events/premium_event.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/premium_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/premium/premium_post_widget.dart';

class PremiumFeedIOS extends StatelessWidget {
  final List<PostEntity> posts;

  const PremiumFeedIOS({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    return Container(
      color: Color(0xFFFbbc06),
      child: Stack(
        children: [
          CustomScrollView(
            controller: controller,
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh:
                    () async => context.read<PremiumBloc>().add(
                      FetchPremiumFeedRequested(),
                    ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => PremiumPostWidget(
                    post: posts[index],
                    onLikeTap: () {},
                    onCommentTap: () {},
                    onShareTap: () {},
                    onProfileTap: () {},
                  ),
                  childCount: posts.length,
                ),
              ),
            ],
          ),
          FeedLazyLoader(
            controller: controller,
            canFetchMore: () => false,
            onBottomReached: () {},
          ),
        ],
      ),
    );
  }
}

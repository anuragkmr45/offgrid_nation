import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/premium/post_entity.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/content_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/events/premium_event.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/premium_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/feed/comments_modal.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/premium/premium_post_widget.dart';

class PremiumFeedAndroid extends StatelessWidget {
  final List<PostEntity> posts;

  const PremiumFeedAndroid({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    return RefreshIndicator(
      color: Color(0xFFFbbc06),
      onRefresh:
          () async =>
              context.read<PremiumBloc>().add(FetchPremiumFeedRequested()),
      child: ListView.builder(
        controller: controller,
        itemCount: posts.length,
        itemBuilder:
            (context, index) => PremiumPostWidget(
              post: posts[index],
              onLikeTap: () {
                context.read<PremiumBloc>().add(
                  TogglePremiumLikeDislikeRequested(
                    postId: posts[index].id,
                    context: context,
                  ),
                );
              },
              onCommentTap: () {
                showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (modalContext) {
                    return BlocProvider.value(
                      value: context.read<ContentBloc>(),
                      child: DraggableScrollableSheet(
                        initialChildSize: 0.6,
                        minChildSize: 0.6,
                        maxChildSize: 1.0,
                        builder: (context, scrollController) {
                          return CommentModal(
                            scrollController: scrollController,
                            postId: posts[index].id,
                          );
                        },
                      ),
                    );
                  },
                );
              },
              onShareTap: () {},
              onProfileTap: () {},
            ),
      ),
    );
  }
}

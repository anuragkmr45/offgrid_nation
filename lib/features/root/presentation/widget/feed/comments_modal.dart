// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:offgrid_nation_app/core/utils/formate_post_time.dart';
// import 'package:offgrid_nation_app/features/root/domain/entities/comment_model.dart';
// import 'package:offgrid_nation_app/features/root/domain/entities/reply_model.dart';
// import 'package:offgrid_nation_app/features/root/presentation/bloc/content_bloc.dart';

// class CommentModal extends StatefulWidget {
//   final ScrollController scrollController;
//   final String postId;

//   const CommentModal({
//     super.key,
//     required this.scrollController,
//     required this.postId,
//   });

//   @override
//   State<CommentModal> createState() => _CommentModalState();
// }

// class _CommentModalState extends State<CommentModal> {
//   final TextEditingController _commentController = TextEditingController();
//   final Set<String> _loadingRepliesFor = {};
//   final Map<String, List<ReplyModel>> _fetchedReplies = {};

//   @override
//   void initState() {
//     super.initState();
//     context.read<ContentBloc>().add(FetchCommentsRequested(widget.postId));
//   }

//   void _addComment() {
//     final text = _commentController.text.trim();
//     if (text.isEmpty) return;
//     _commentController.clear();
//     FocusScope.of(context).unfocus();
//     context.read<ContentBloc>().add(
//       AddCommentRequested(
//         postId: widget.postId,
//         content: text,
//         context: context,
//       ),
//     );
//   }

//   void _toggleLikeComment(String commentId) {
//     context.read<ContentBloc>().add(
//       ToggleCommentLikeRequested(commentId: commentId, context: context),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return SafeArea(
//       child: Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//           ),
//           child: Column(
//             children: [
//               Container(
//                 width: 40,
//                 height: 5,
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               Expanded(child: _buildContent(theme)),
//               _buildCommentInput(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildContent(ThemeData theme) {
//     return BlocBuilder<ContentBloc, ContentState>(
//       builder: (context, state) {
//         final comments = state.comments ?? [];
//         final replies = state.replies ?? [];

//         if (state.status == ContentStatus.loading && comments.isEmpty) {
//           return Center(
//             child:
//                 Platform.isIOS
//                     ? const CupertinoActivityIndicator()
//                     : const CircularProgressIndicator(),
//           );
//         }

//         if (state.status == ContentStatus.failure) {
//           return const Center(
//             child: Text(
//               'Failed to load comments.',
//               style: TextStyle(color: Colors.red),
//             ),
//           );
//         }

//         if (comments.isEmpty) {
//           return const Center(child: Text("No comments yet."));
//         }

//         return ListView.builder(
//           controller: widget.scrollController,
//           itemCount: comments.length,
//           padding: const EdgeInsets.all(16),
//           itemBuilder: (context, index) {
//             final comment = comments[index];
//             final commentReplies =
//                 comment.showAllReplies
//                     ? _fetchedReplies[comment.id] ?? []
//                     : comment.replies.take(2).toList();

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildCommentTile(comment, theme),
//                 for (var reply in commentReplies)
//                   Padding(
//                     padding: const EdgeInsets.only(left: 48, top: 8, bottom: 4),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CircleAvatar(
//                           radius: 14,
//                           backgroundImage: NetworkImage(
//                             reply.user.profilePicture,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 reply.user.fullName,
//                                 style: theme.textTheme.bodyMedium?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(reply.content),
//                               Text(
//                                 formatPostTime(
//                                   reply.createdAt.toIso8601String(),
//                                 ),
//                                 style: theme.textTheme.bodySmall?.copyWith(
//                                   color: Colors.grey[600],
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildCommentInput() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _commentController,
//               textInputAction: TextInputAction.send,
//               onSubmitted: (_) => _addComment(),
//               decoration: const InputDecoration(
//                 hintText: "Add a comment...",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(12)),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 12),
//               ),
//             ),
//           ),
//           IconButton(icon: const Icon(Icons.send), onPressed: _addComment),
//         ],
//       ),
//     );
//   }

//   Widget _buildCommentTile(CommentModel comment, ThemeData theme) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CircleAvatar(
//             radius: 18,
//             backgroundImage: NetworkImage(comment.user.profilePicture),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   comment.user.fullName,
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(comment.content, style: theme.textTheme.bodyMedium),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Text(
//                       formatPostTime(comment.createdAt.toIso8601String()),
//                       style: theme.textTheme.bodySmall?.copyWith(
//                         color: Colors.grey[600],
//                         fontSize: 12,
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     GestureDetector(
//                       onTap: () => _toggleLikeComment(comment.id),
//                       child: Text(
//                         comment.isLiked ? "❤️ Liked" : "🤍 Like",
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: comment.isLiked ? Colors.red : Colors.grey,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/utils/formate_post_time.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/comment_model.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/reply_model.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/content_bloc.dart';

class CommentModal extends StatefulWidget {
  final ScrollController scrollController;
  final String postId;

  const CommentModal({
    super.key,
    required this.scrollController,
    required this.postId,
  });

  @override
  State<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {
  final TextEditingController _commentController = TextEditingController();
  final Set<String> _loadingRepliesFor = {};
  final Map<String, List<ReplyModel>> _fetchedReplies = {};

  @override
  void initState() {
    super.initState();
    context.read<ContentBloc>().add(FetchCommentsRequested(widget.postId));
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    _commentController.clear();
    FocusScope.of(context).unfocus();
    context.read<ContentBloc>().add(
      AddCommentRequested(
        postId: widget.postId,
        content: text,
        context: context,
      ),
    );
  }

  void _toggleLikeComment(String commentId) {
    context.read<ContentBloc>().add(
      ToggleCommentLikeRequested(commentId: commentId, context: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(child: _buildContent(theme)),
              _buildCommentInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return BlocBuilder<ContentBloc, ContentState>(
      builder: (context, state) {
        final comments = state.comments ?? [];

        if (state.status == ContentStatus.loading && comments.isEmpty) {
          return Center(
            child: Platform.isIOS
                ? const CupertinoActivityIndicator()
                : const CircularProgressIndicator(),
          );
        }

        if (state.status == ContentStatus.failure) {
          return const Center(
            child: Text(
              'Failed to load comments.',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (comments.isEmpty) {
          return const Center(child: Text("No comments yet."));
        }

        return ListView.builder(
          controller: widget.scrollController,
          itemCount: comments.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final comment = comments[index];
            final commentReplies = comment.showAllReplies
                ? _fetchedReplies[comment.id] ?? []
                : comment.replies.take(2).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCommentTile(comment, theme),
                for (var reply in commentReplies)
                  Padding(
                    padding: const EdgeInsets.only(left: 48, top: 8, bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage(
                            reply.user.profilePicture,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reply.user.fullName,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(reply.content),
                              Text(
                                formatPostTime(
                                  reply.createdAt.toIso8601String(),
                                ),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!comment.showAllReplies && comment.repliesCount > 2)
                  Padding(
                    padding: const EdgeInsets.only(left: 48.0, top: 4),
                    child: _loadingRepliesFor.contains(comment.id)
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : GestureDetector(
                            onTap: () async {
                              setState(() {
                                _loadingRepliesFor.add(comment.id);
                              });
                              try {
                                final replies = await context.read<ContentBloc>()
                                    .fetchRepliesUsecase(commentId: comment.id);

                                setState(() {
                                  _fetchedReplies[comment.id] = replies;
                                  _loadingRepliesFor.remove(comment.id);

                                  final updatedComments = [...?state.comments];
                                  final i = updatedComments.indexWhere((c) => c.id == comment.id);
                                  updatedComments[i] =
                                      updatedComments[i].copyWith(showAllReplies: true);
                                  context.read<ContentBloc>().emit(
                                    state.copyWith(comments: updatedComments),
                                  );
                                });
                              } catch (e) {
                                setState(() {
                                  _loadingRepliesFor.remove(comment.id);
                                });
                                _showPlatformError(context, e);
                              }
                            },
                            child: const Text(
                              "Read more replies...",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCommentInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _addComment(),
              decoration: const InputDecoration(
                hintText: "Add a comment...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.send), onPressed: _addComment),
        ],
      ),
    );
  }

  Widget _buildCommentTile(CommentModel comment, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(comment.user.profilePicture),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.user.fullName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(comment.content, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      formatPostTime(comment.createdAt.toIso8601String()),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => _toggleLikeComment(comment.id),
                      child: Text(
                        comment.isLiked ? "❤️ Liked" : "🤍 Like",
                        style: TextStyle(
                          fontSize: 13,
                          color: comment.isLiked ? Colors.red : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPlatformError(BuildContext context, Object error) {
    final message = error.toString();
    if (Platform.isAndroid) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } else {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }
}

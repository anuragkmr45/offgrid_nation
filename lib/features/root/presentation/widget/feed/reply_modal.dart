import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:offgrid_nation_app/core/session/auth_session.dart';
import 'package:offgrid_nation_app/core/utils/formate_post_time.dart';
// import 'package:offgrid_nation_app/features/root/domain/entities/reply_model.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/content_bloc.dart';

class ReplyModal extends StatefulWidget {
  final String commentId;

  const ReplyModal({super.key, required this.commentId});

  @override
  State<ReplyModal> createState() => _ReplyModalState();
}

class _ReplyModalState extends State<ReplyModal> {
  final TextEditingController _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ContentBloc>().add(FetchRepliesRequested(widget.commentId));
  }

  Future<void> _submitReply() async {
    final content = _replyController.text.trim();
    if (content.isEmpty) return;

    _replyController.clear();
    FocusScope.of(context).unfocus();

    context.read<ContentBloc>().add(
      AddReplyRequested(
        commentId: widget.commentId,
        content: content,
        context: context,
      ),
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
              Expanded(child: _buildReplyList(theme)),
              _buildInputField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReplyList(ThemeData theme) {
    return BlocBuilder<ContentBloc, ContentState>(
      builder: (context, state) {
        final replies = state.replies ?? [];

        if (state.status == ContentStatus.loading) {
          return Center(
            child:
                Platform.isIOS
                    ? const CupertinoActivityIndicator()
                    : const CircularProgressIndicator(),
          );
        }

        if (replies.isEmpty) {
          return const Center(child: Text("No replies yet."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: replies.length,
          itemBuilder: (context, index) {
            final reply = replies[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: CachedNetworkImageProvider(reply.user.profilePicture),
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
                          formatPostTime(reply.createdAt.toIso8601String()),
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
            );
          },
        );
      },
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _replyController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _submitReply(),
              decoration: const InputDecoration(
                hintText: 'Write a reply...',
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.send), onPressed: _submitReply),
        ],
      ),
    );
  }
}

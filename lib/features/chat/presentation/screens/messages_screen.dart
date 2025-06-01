import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/widgets/custom_search_bar.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/events/chat_event.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/states/chat_state.dart';
import 'package:offgrid_nation_app/features/chat/presentation/widget/chat/chat_list_item.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(const GetConversationsRequested());
  }

  void _onSearchChanged(String query) {
    context.read<ChatBloc>().add(SearchUsersRequested(query));
  }

  void _onSearchSubmitted(String query) {
    context.read<ChatBloc>().add(SearchUsersRequested(query));
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final content = Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomSearchBar(
            controller: _searchController,
            onChanged: _onSearchChanged,
            onSubmitted: _onSearchSubmitted,
            hintText: 'Search...',
          ),
        ),
        Expanded(
          child: Container(
            color: AppColors.primary,
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return Center(
                    child:
                        isIOS
                            ? const CupertinoActivityIndicator()
                            : const CircularProgressIndicator(),
                  );
                } else if (state is ConversationsLoaded) {
                  return ListView.separated(
                    itemCount: state.conversations.length,
                    separatorBuilder:
                        (context, index) => const SizedBox.shrink(),
                    itemBuilder: (context, index) {
                      final chat = state.conversations[index];
                      final user = chat.user;
                      final lastMessage = chat.lastMessage;

                      final String avatarUrl = user.profilePicture;
                      final String userName = user.fullName;

                      final String lastMessageText =
                          lastMessage.text?.trim().isNotEmpty == true
                              ? lastMessage.text!
                              : (lastMessage.attachments.isNotEmpty
                                  ? '📷 Media'
                                  : '');

                      final String timeLabel = _formatTime(lastMessage.sentAt);
                      final int unreadCount = chat.unreadCount;

                      return ChatListItem(
                        avatarUrl: avatarUrl,
                        userName: userName,
                        lastMessage: lastMessageText,
                        timeLabel: timeLabel,
                        unreadCount: unreadCount,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/conversation',
                            arguments: {
                              'conversationId': chat.conversationId,
                              'recipientId': chat.user.id,
                              'recipientName': chat.user.fullName,
                              'status': chat.muted ? 'Muted' : 'Active now',
                            },
                          );
                        },
                      );
                    },
                  );
                } else if (state is ChatError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ],
    );

    return isIOS
        ? CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(middle: Text('Messages')),
          child: SafeArea(child: content),
        )
        : Scaffold(
          backgroundColor: AppColors.primary,
          body: SafeArea(child: content),
        );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 1) return 'Now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
// import 'package:offgrid_nation_app/core/widgets/custom_search_bar.dart';
// import 'package:offgrid_nation_app/features/chat/presentation/widget/chat/chat_list_item.dart';

// class MessagesScreen extends StatefulWidget {
//   const MessagesScreen({super.key});

//   @override
//   State<MessagesScreen> createState() => _MessagesScreenState();
// }

// class _MessagesScreenState extends State<MessagesScreen> {
//   final TextEditingController _searchController = TextEditingController();

//   final List<Map<String, dynamic>> _chatList = [
//     {
//       'avatarUrl':
//           'https://images.unsplash.com/photo-1580842196926-c9355fbc3d79',
//       'userName': 'Claudia Alves',
//       'lastMessage': 'We bend so we don’t break.',
//       'timeLabel': 'Now',
//       'unreadCount': 1,
//     },
//     {
//       'avatarUrl':
//           'https://images.unsplash.com/photo-1607746882042-944635dfe10e',
//       'userName': 'Cahaya Dewi',
//       'lastMessage': 'Happiness is a habit.',
//       'timeLabel': '2 Min',
//       'unreadCount': 2,
//     },
//     {
//       'avatarUrl':
//           'https://images.unsplash.com/photo-1595152772835-219674b2a8a6',
//       'userName': 'Avery Davis',
//       'lastMessage': 'Don’t just fly. Soar.',
//       'timeLabel': '5 Hours',
//       'unreadCount': 0,
//     },
//     {
//       'avatarUrl': 'https://images.unsplash.com/photo-1544723795-3fb6469f5b39',
//       'userName': 'Aaron Loeb',
//       'lastMessage': 'Allow yourself joy.',
//       'timeLabel': '5 Hours',
//       'unreadCount': 3,
//     },
//     {
//       'avatarUrl':
//           'https://images.unsplash.com/photo-1621290085992-1b155db69734',
//       'userName': 'Lorna Alvarado',
//       'lastMessage': 'Keep it simple.',
//       'timeLabel': '22 Hours',
//       'unreadCount': 0,
//     },
//     {
//       'avatarUrl':
//           'https://images.unsplash.com/photo-1590073242679-3c6ad04317d1',
//       'userName': 'Olivia Wilson',
//       'lastMessage': 'Yesterday',
//       'timeLabel': 'Yesterday',
//       'unreadCount': 1,
//     },
//     {
//       'avatarUrl':
//           'https://images.unsplash.com/photo-1517841905240-472988babdf9',
//       'userName': 'Yael Amari',
//       'lastMessage': 'You got this.',
//       'timeLabel': '2 Weeks ago',
//       'unreadCount': 0,
//     },
//   ];

//   void _onSearchChanged(String query) {
//     // For now, do nothing. Later, filter _chatList by 'query'.
//   }

//   void _onSearchSubmitted(String query) {
//     // For now, do nothing. Later, filter or search an API.
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

//     final content = Column(
//       children: [
//         // Search bar at the top
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: CustomSearchBar(
//             controller: _searchController,
//             onChanged: _onSearchChanged,
//             onSubmitted: _onSearchSubmitted,
//             hintText: 'Search...',
//           ),
//         ),
//         // Chat list
//         Expanded(
//           child: Container(
//             color: AppColors.primary,
//             child: ListView.separated(
//               itemCount: _chatList.length,
//               separatorBuilder: (context, index) => const SizedBox.shrink(),
//               itemBuilder: (context, index) {
//                 final chat = _chatList[index];
//                 return ChatListItem(
//                   avatarUrl: chat['avatarUrl'],
//                   userName: chat['userName'],
//                   lastMessage: chat['lastMessage'],
//                   timeLabel: chat['timeLabel'],
//                   unreadCount: chat['unreadCount'],
//                   onTap: () {
//                     Navigator.pushNamed(context, '/conversation');
//                   },
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );

//     // return isIOS
//     //     ? ScaffoldMessenger(
//     //       child: CupertinoPageScaffold(
//     //         // navigationBar: CupertinoNavigationBar(
//     //         //   middle: const Text('Messages'),
//     //         //   heroTag: 'uniqueMessagesNavBar',
//     //         // ),
//     //         child: SafeArea(child: content),
//     //       ),
//     //     )
//     //     : Scaffold(backgroundColor: AppColors.primary, body: content);

//     return isIOS
//         ? CupertinoPageScaffold(
//           navigationBar: CupertinoNavigationBar(middle: const Text('Messages')),
//           child: SafeArea(child: content),
//         )
//         : Scaffold(backgroundColor: AppColors.primary, body: content);
//   }
// }

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
                            arguments: chat.conversationId,
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

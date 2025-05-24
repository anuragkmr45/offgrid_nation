import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/widgets/custom_search_bar.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/chat/chat_list_item.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _chatList = [
    {
      'avatarUrl':
          'https://images.unsplash.com/photo-1580842196926-c9355fbc3d79',
      'userName': 'Claudia Alves',
      'lastMessage': 'We bend so we don’t break.',
      'timeLabel': 'Now',
      'unreadCount': 1,
    },
    {
      'avatarUrl':
          'https://images.unsplash.com/photo-1607746882042-944635dfe10e',
      'userName': 'Cahaya Dewi',
      'lastMessage': 'Happiness is a habit.',
      'timeLabel': '2 Min',
      'unreadCount': 2,
    },
    {
      'avatarUrl':
          'https://images.unsplash.com/photo-1595152772835-219674b2a8a6',
      'userName': 'Avery Davis',
      'lastMessage': 'Don’t just fly. Soar.',
      'timeLabel': '5 Hours',
      'unreadCount': 0,
    },
    {
      'avatarUrl': 'https://images.unsplash.com/photo-1544723795-3fb6469f5b39',
      'userName': 'Aaron Loeb',
      'lastMessage': 'Allow yourself joy.',
      'timeLabel': '5 Hours',
      'unreadCount': 3,
    },
    {
      'avatarUrl':
          'https://images.unsplash.com/photo-1621290085992-1b155db69734',
      'userName': 'Lorna Alvarado',
      'lastMessage': 'Keep it simple.',
      'timeLabel': '22 Hours',
      'unreadCount': 0,
    },
    {
      'avatarUrl':
          'https://images.unsplash.com/photo-1590073242679-3c6ad04317d1',
      'userName': 'Olivia Wilson',
      'lastMessage': 'Yesterday',
      'timeLabel': 'Yesterday',
      'unreadCount': 1,
    },
    {
      'avatarUrl':
          'https://images.unsplash.com/photo-1517841905240-472988babdf9',
      'userName': 'Yael Amari',
      'lastMessage': 'You got this.',
      'timeLabel': '2 Weeks ago',
      'unreadCount': 0,
    },
  ];

  void _onSearchChanged(String query) {
    // For now, do nothing. Later, filter _chatList by 'query'.
  }

  void _onSearchSubmitted(String query) {
    // For now, do nothing. Later, filter or search an API.
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final content = Column(
      children: [
        // Search bar at the top
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomSearchBar(
            controller: _searchController,
            onChanged: _onSearchChanged,
            onSubmitted: _onSearchSubmitted,
            hintText: 'Search...',
          ),
        ),
        // Chat list
        Expanded(
          child: Container(
            color: AppColors.primary,
            child: ListView.separated(
              itemCount: _chatList.length,
              separatorBuilder: (context, index) => const SizedBox.shrink(),
              itemBuilder: (context, index) {
                final chat = _chatList[index];
                return ChatListItem(
                  avatarUrl: chat['avatarUrl'],
                  userName: chat['userName'],
                  lastMessage: chat['lastMessage'],
                  timeLabel: chat['timeLabel'],
                  unreadCount: chat['unreadCount'],
                  onTap: () {
                    Navigator.pushNamed(context, '/conversation');
                  },
                );
              },
            ),
          ),
        ),
      ],
    );

    // return isIOS
    //     ? ScaffoldMessenger(
    //       child: CupertinoPageScaffold(
    //         // navigationBar: CupertinoNavigationBar(
    //         //   middle: const Text('Messages'),
    //         //   heroTag: 'uniqueMessagesNavBar',
    //         // ),
    //         child: SafeArea(child: content),
    //       ),
    //     )
    //     : Scaffold(backgroundColor: AppColors.primary, body: content);

    return isIOS
        ? CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(middle: const Text('Messages')),
          child: SafeArea(child: content),
        )
        : Scaffold(backgroundColor: AppColors.primary, body: content);
  }
}

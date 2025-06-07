import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/services/pusher_service.dart';
import 'package:offgrid_nation_app/core/session/auth_session.dart';
import 'package:offgrid_nation_app/features/chat/domain/entities/message_entity.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/events/chat_event.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/states/chat_state.dart';
import 'package:offgrid_nation_app/features/chat/presentation/widget/chat/chat_bubble.dart';
import 'package:offgrid_nation_app/features/chat/presentation/widget/chat/chat_input.dart';
import 'package:offgrid_nation_app/features/chat/presentation/widget/chat/chat_header.dart';
import 'package:offgrid_nation_app/injection_container.dart';

class ConversationScreen extends StatefulWidget {
  final String? conversationId;
  final String recipientId;
  final String recipientName;
  final String recipientUsername;
  final String profilePicture;
  final String status;

  const ConversationScreen({
    super.key,
    required this.recipientId,
    required this.recipientName,
    required this.conversationId,
    required this.recipientUsername,
    required this.profilePicture,
    this.status = '',
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _myUserId;
  int limit = 20;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _cursor;

  @override
  void initState() {
    super.initState();
    _initChat();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _initChat() async {
    final userId = await sl<AuthSession>().getCurrentUserId();
    if (userId == null) return;

    setState(() => _myUserId = userId);

    _fetchInitialMessages();

    if (widget.conversationId != null) {
      await PusherService().subscribeChatChannel(
        conversationId: widget.conversationId!,
        onNewMessage: (data) {
          final newMsg = MessageEntity.fromJson(data);
          context.read<ChatBloc>().add(PushNewMessageReceived(newMsg));
        },
        onMessageRead: (convId) {},
      );
    }

    if (widget.conversationId != null) {
      context.read<ChatBloc>().add(
        MarkConversationReadRequested(widget.conversationId!),
      );
    }
  }

  void _fetchInitialMessages() {
    context.read<ChatBloc>().add(
      GetMessagesByRecipientRequested(widget.recipientId, limit),
    );
  }

  void _fetchOlderMessages(List<MessageEntity> currentMessages) {
    if (_isLoadingMore || !_hasMore || currentMessages.isEmpty) return;

    final oldestMsg = currentMessages.last;
    final cursor = oldestMsg.sentAt.toIso8601String();

    if (_cursor != null && _cursor == cursor) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
      _cursor = cursor;
    });

    context.read<ChatBloc>().add(
      GetMessagesByRecipientRequested(widget.recipientId, limit, cursor),
    );
  }

  void _handleSend(String message) {
    final body = {
      'recipient': widget.recipientId,
      'actionType': 'text',
      'text': message,
      if (widget.conversationId != null)
        'conversationId': widget.conversationId,
    };
    context.read<ChatBloc>().add(SendMessageRequested(body));
  }

  void _handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      final isTop = _scrollController.position.pixels != 0;
      if (isTop) {
        final state = context.read<ChatBloc>().state;
        if (state is MessagesLoaded) {
          _fetchOlderMessages(state.messages);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final bodyContent = Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              List<MessageEntity> messages = [];

              if (state is MessagesLoaded) {
                messages = state.messages;
                _isLoadingMore = false;
                _hasMore = state.messages.length >= limit;
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollEndNotification &&
                      _scrollController.position.pixels >=
                          _scrollController.position.maxScrollExtent - 200 &&
                      !_isLoadingMore &&
                      _hasMore &&
                      messages.isNotEmpty) {
                    _fetchOlderMessages(messages);
                  }
                  return false;
                },
                child: ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8), // spacing
                  itemCount: messages.length + (_isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_isLoadingMore && index == messages.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent, // blue loader
                          ),
                        ),
                      );
                    }

                    final msg = messages[index];
                    final bool isMe =
                        _myUserId != null && msg.sender.id == _myUserId;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4), // spacing between bubbles
                      child: ChatBubble(
                        message: msg.text ?? '',
                        time: _formatTime(msg.sentAt),
                        isMe: isMe,
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),

        ChatInput(onSend: _handleSend),
      ],
    );

    return isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              leading: GestureDetector(
                onTap: _handleBack,
                child: const Icon(CupertinoIcons.back),
              ),
              middle: Text(widget.recipientName),
            ),
            child: SafeArea(
              bottom: true,
              child: bodyContent,
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: true, // FIX: keyboard does not hide chat
            appBar: ChatHeader(
              userName: widget.recipientUsername,
              name: widget.recipientName,
              profilePicture: widget.profilePicture,
              status: widget.status,
              onBack: _handleBack,
            ),
            body: SafeArea(
              bottom: true,
              child: bodyContent,
            ),
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

  @override
  void dispose() {
    if (widget.conversationId != null) {
      PusherService().unsubscribeChatChannel(widget.conversationId!);
    }

    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:offgrid_nation_app/core/services/pusher_service.dart';
// import 'package:offgrid_nation_app/core/session/auth_session.dart';
// import 'package:offgrid_nation_app/features/chat/domain/entities/message_entity.dart';
// import 'package:offgrid_nation_app/features/chat/presentation/bloc/chat_bloc.dart';
// import 'package:offgrid_nation_app/features/chat/presentation/bloc/events/chat_event.dart';
// import 'package:offgrid_nation_app/features/chat/presentation/bloc/states/chat_state.dart';
// import 'package:offgrid_nation_app/features/chat/presentation/widget/chat/chat_bubble.dart';
// import 'package:offgrid_nation_app/features/chat/presentation/widget/chat/chat_input.dart';
// import 'package:offgrid_nation_app/features/chat/presentation/widget/chat/chat_header.dart';
// import 'package:offgrid_nation_app/injection_container.dart';

// class ConversationScreen extends StatefulWidget {
//   final String? conversationId;
//   final String recipientId;
//   final String recipientName;
//   final String recipientUsername;
//   final String profilePicture;
//   final String status;

//   const ConversationScreen({
//     super.key,
//     required this.recipientId,
//     required this.recipientName,
//     required this.conversationId,
//     required this.recipientUsername,
//     required this.profilePicture,
//     this.status = '',
//   });

//   @override
//   State<ConversationScreen> createState() => _ConversationScreenState();
// }

// class _ConversationScreenState extends State<ConversationScreen> {
//   final ScrollController _scrollController = ScrollController();
//   String? _myUserId;
//   int limit = 20;
//   bool _isLoadingMore = false;
//   bool _hasMore = true;
//   String? _cursor;

//   @override
//   void initState() {
//     super.initState();
//     _initChat();
//     _scrollController.addListener(_onScroll);
//   }

//   Future<void> _initChat() async {
//     final userId = await sl<AuthSession>().getCurrentUserId();
//     if (userId == null) return;

//     setState(() => _myUserId = userId);

//     _fetchInitialMessages();

//     if (widget.conversationId != null) {
//       await PusherService().subscribeChatChannel(
//         conversationId: widget.conversationId!,
//         onNewMessage: (data) {
//           final newMsg = MessageEntity.fromJson(data);
//           context.read<ChatBloc>().add(PushNewMessageReceived(newMsg));
//         },
//         onMessageRead: (convId) {},
//       );
//     }

//     if (widget.conversationId != null) {
//       context.read<ChatBloc>().add(
//         MarkConversationReadRequested(widget.conversationId!),
//       );
//     }
//   }

//   void _fetchInitialMessages() {
//     context.read<ChatBloc>().add(
//       GetMessagesByRecipientRequested(widget.recipientId, limit),
//     );
//   }

//   void _fetchOlderMessages(List<MessageEntity> currentMessages) {
//     if (_isLoadingMore || !_hasMore || currentMessages.isEmpty) return;

//     final oldestMsg = currentMessages.last;
//     final cursor = oldestMsg.sentAt.toIso8601String();

//     if (_cursor != null && _cursor == cursor) {
//       return;
//     }

//     setState(() {
//       _isLoadingMore = true;
//       _cursor = cursor;
//     });

//     context.read<ChatBloc>().add(
//       GetMessagesByRecipientRequested(widget.recipientId, limit, cursor),
//     );
//   }

//   void _handleSend(String message) {
//     final body = {
//       'recipient': widget.recipientId,
//       'actionType': 'text',
//       'text': message,
//       if (widget.conversationId != null)
//         'conversationId': widget.conversationId,
//     };
//     context.read<ChatBloc>().add(SendMessageRequested(body));
//   }

//   void _handleBack() {
//     if (Navigator.canPop(context)) {
//       Navigator.pop(context);
//     } else {
//       Navigator.pushReplacementNamed(context, '/home');
//     }
//   }

//   void _onScroll() {
//     if (_scrollController.position.atEdge) {
//       final isTop = _scrollController.position.pixels != 0;
//       if (isTop) {
//         final state = context.read<ChatBloc>().state;
//         if (state is MessagesLoaded) {
//           _fetchOlderMessages(state.messages);
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

//     final bodyContent = Column(
//       children: [
//         Expanded(
//           child: BlocBuilder<ChatBloc, ChatState>(
//             builder: (context, state) {
//               List<MessageEntity> messages = [];

//               if (state is MessagesLoaded) {
//                 messages = state.messages;
//                 _isLoadingMore = false;
//                 _hasMore = state.messages.length >= limit;
//               }

//               // 👉 Show loading on first mount
//               if (state is ChatLoading && messages.isEmpty) {
//                 return const Center(
//                   child: CircularProgressIndicator(
//                     color: Colors.blueAccent,
//                   ),
//                 );
//               }

//               return NotificationListener<ScrollNotification>(
//                 onNotification: (scrollNotification) {
//                   if (scrollNotification is ScrollEndNotification &&
//                       _scrollController.position.pixels >=
//                           _scrollController.position.maxScrollExtent - 200 &&
//                       !_isLoadingMore &&
//                       _hasMore &&
//                       messages.isNotEmpty) {
//                     _fetchOlderMessages(messages);
//                   }
//                   return false;
//                 },
//                 child: ListView.builder(
//                   reverse: true,
//                   controller: _scrollController,
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   padding: const EdgeInsets.symmetric(vertical: 8), // spacing
//                   itemCount: messages.length + (_isLoadingMore ? 1 : 0),
//                   itemBuilder: (context, index) {
//                     if (_isLoadingMore && index == messages.length) {
//                       return const Center(
//                         child: Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: CircularProgressIndicator(
//                             color: Colors.blueAccent,
//                           ),
//                         ),
//                       );
//                     }

//                     final msg = messages[index];
//                     final bool isMe =
//                         _myUserId != null && msg.sender.id == _myUserId;
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4), // spacing between bubbles
//                       child: ChatBubble(
//                         message: msg.text ?? '',
//                         time: _formatTime(msg.sentAt),
//                         isMe: isMe,
//                       ),
//                     );
//                   },
//                 ),
//               );
//             },
//           ),
//         ),

//         ChatInput(onSend: _handleSend),
//       ],
//     );

//     return isIOS
//         ? CupertinoPageScaffold(
//             navigationBar: CupertinoNavigationBar(
//               leading: GestureDetector(
//                 onTap: _handleBack,
//                 child: const Icon(CupertinoIcons.back),
//               ),
//               middle: Text(widget.recipientName),
//             ),
//             child: SafeArea(
//               bottom: true,
//               child: bodyContent,
//             ),
//           )
//         : Scaffold(
//             resizeToAvoidBottomInset: true, // keyboard does not hide chat
//             appBar: ChatHeader(
//               userName: widget.recipientUsername,
//               name: widget.recipientName,
//               profilePicture: widget.profilePicture,
//               status: widget.status,
//               onBack: _handleBack,
//             ),
//             body: SafeArea(
//               bottom: true,
//               child: bodyContent,
//             ),
//           );
//   }

//   String _formatTime(DateTime dateTime) {
//     final now = DateTime.now();
//     final diff = now.difference(dateTime);
//     if (diff.inMinutes < 1) return 'Now';
//     if (diff.inMinutes < 60) return '${diff.inMinutes}m';
//     if (diff.inHours < 24) return '${diff.inHours}h';
//     if (diff.inDays < 7) return '${diff.inDays}d';
//     return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
//   }

//   @override
//   void dispose() {
//     if (widget.conversationId != null) {
//       PusherService().unsubscribeChatChannel(widget.conversationId!);
//     }

//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }
// }

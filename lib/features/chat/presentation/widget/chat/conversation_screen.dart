// import 'dart:io' show Platform;
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:offgrid_nation_app/features/chat/presentation/widget/chat/chat_bubble.dart';
// import 'package:offgrid_nation_app/features/chat/presentation/widget/chat/chat_header.dart';
// import 'package:offgrid_nation_app/features/chat/presentation/widget/chat/chat_input.dart';

// class ConversationScreen extends StatefulWidget {
//   const ConversationScreen({super.key});

//   @override
//   State<ConversationScreen> createState() => _ConversationScreenState();
// }

// class _ConversationScreenState extends State<ConversationScreen> {
//   // Demo conversation messages.
//   final List<Map<String, dynamic>> _messages = [
//     {'text': 'Hello! How are you?', 'time': '2:14 PM', 'isMe': false},
//     {'text': 'I\'m good, thanks. And you?', 'time': '2:15 PM', 'isMe': true},
//     {
//       'text': 'Doing great! What are you up to?',
//       'time': '2:16 PM',
//       'isMe': false,
//     },
//   ];

//   /// Called when the user sends a message.
//   void _handleSend(String messageText) {
//     // For demo, we use a static time. Later, replace with actual timestamps.
//     setState(() {
//       _messages.add({'text': messageText, 'time': '2:17 PM', 'isMe': true});
//     });
//   }

//   /// Called when the back button is pressed.
//   /// Using pushReplacement for demonstration; consider using Navigator.pop if applicable.
//   void _handleBack() {
//     if (Navigator.canPop(context)) {
//       Navigator.pop(context);
//     } else {
//       Navigator.pushReplacementNamed(context, '/home');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isIOS = Platform.isIOS;

//     // The main body content shared between platforms.
//     final bodyContent = Column(
//       children: [
//         // Message list
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.all(8),
//             itemCount: _messages.length,
//             itemBuilder: (context, index) {
//               final msg = _messages[index];
//               return ChatBubble(
//                 message: msg['text'],
//                 time: msg['time'],
//                 isMe: msg['isMe'],
//               );
//             },
//           ),
//         ),
//         // Input field for new messages
//         ChatInput(onSend: _handleSend),
//       ],
//     );

//     // return isIOS
//     //     ? CupertinoPageScaffold(
//     //       navigationBar: CupertinoNavigationBar(
//     //         middle: Text('John Doe'),
//     //         trailing: GestureDetector(
//     //           onTap: _handleBack,
//     //           child: const Icon(CupertinoIcons.back),
//     //         ),
//     //       ),
//     //       child: SafeArea(child: bodyContent),
//     //     )
//     //     : Scaffold(
//     //       appBar: ChatHeader(
//     //         userName: 'John Doe',
//     //         status: 'Active now',
//     //         onBack: _handleBack,
//     //       ),
//     //       body: SafeArea(child: bodyContent),
//     //     );

//     return isIOS
//         ? CupertinoPageScaffold(
//           navigationBar: CupertinoNavigationBar(
//             leading: GestureDetector(
//               onTap: _handleBack,
//               child: const Icon(CupertinoIcons.back),
//             ),
//             middle: const Text('John Doe'),
//           ),
//           child: SafeArea(child: bodyContent),
//         )
//         : Scaffold(
//           appBar: ChatHeader(
//             userName: 'John Doe',
//             status: 'Active now',
//             onBack: _handleBack,
//           ),
//           body: SafeArea(child: bodyContent),
//         );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/events/chat_event.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/states/chat_state.dart';
import 'package:offgrid_nation_app/features/chat/presentation/widget/chat/chat_bubble.dart';
import 'package:offgrid_nation_app/features/chat/presentation/widget/chat/chat_input.dart';
import 'package:offgrid_nation_app/features/chat/presentation/widget/chat/chat_header.dart';

class ConversationScreen extends StatefulWidget {
  final String conversationId;
  final String recipientId;
  final String recipientName;
  final String status;

  const ConversationScreen({
    super.key,
    required this.conversationId,
    required this.recipientId,
    required this.recipientName,
    this.status = 'Active now',
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(GetMessagesRequested(widget.conversationId));
    context.read<ChatBloc>().add(
      MarkConversationReadRequested(widget.conversationId),
    );
  }

  // void _scrollToBottom() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (_scrollController.hasClients) {
  //       _scrollController.animateTo(
  //         0.0,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeOut,
  //       );
  //     }
  //   });
  // }

  void _handleSend(String message) {
    final body = {
      'recipient': widget.recipientId,
      'actionType': 'text',
      'text': message,
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

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final bodyContent = Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is ChatLoading) {
                return Center(
                  child:
                      isIOS
                          ? const CupertinoActivityIndicator()
                          : const CircularProgressIndicator(),
                );
              } else if (state is MessagesLoaded) {
                final messages = state.messages;
                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return ChatBubble(
                      message: msg.text ?? '',
                      time: _formatTime(msg.sentAt),
                      isMe: msg.sender != widget.recipientId,
                    );
                  },
                );
              } else {
                return const SizedBox();
              }
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
          child: SafeArea(child: bodyContent),
        )
        : Scaffold(
          appBar: ChatHeader(
            userName: widget.recipientName,
            status: widget.status,
            onBack: _handleBack,
          ),
          body: SafeArea(child: bodyContent),
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

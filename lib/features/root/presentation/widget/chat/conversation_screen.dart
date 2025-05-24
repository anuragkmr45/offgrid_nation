import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/chat/chat_bubble.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/chat/chat_header.dart';
import 'package:offgrid_nation_app/features/root/presentation/widget/chat/chat_input.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  // Demo conversation messages.
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hello! How are you?', 'time': '2:14 PM', 'isMe': false},
    {'text': 'I\'m good, thanks. And you?', 'time': '2:15 PM', 'isMe': true},
    {
      'text': 'Doing great! What are you up to?',
      'time': '2:16 PM',
      'isMe': false,
    },
  ];

  /// Called when the user sends a message.
  void _handleSend(String messageText) {
    // For demo, we use a static time. Later, replace with actual timestamps.
    setState(() {
      _messages.add({'text': messageText, 'time': '2:17 PM', 'isMe': true});
    });
  }

  /// Called when the back button is pressed.
  /// Using pushReplacement for demonstration; consider using Navigator.pop if applicable.
  void _handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Platform.isIOS;

    // The main body content shared between platforms.
    final bodyContent = Column(
      children: [
        // Message list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              return ChatBubble(
                message: msg['text'],
                time: msg['time'],
                isMe: msg['isMe'],
              );
            },
          ),
        ),
        // Input field for new messages
        ChatInput(onSend: _handleSend),
      ],
    );

    // return isIOS
    //     ? CupertinoPageScaffold(
    //       navigationBar: CupertinoNavigationBar(
    //         middle: Text('John Doe'),
    //         trailing: GestureDetector(
    //           onTap: _handleBack,
    //           child: const Icon(CupertinoIcons.back),
    //         ),
    //       ),
    //       child: SafeArea(child: bodyContent),
    //     )
    //     : Scaffold(
    //       appBar: ChatHeader(
    //         userName: 'John Doe',
    //         status: 'Active now',
    //         onBack: _handleBack,
    //       ),
    //       body: SafeArea(child: bodyContent),
    //     );

    return isIOS
        ? CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: GestureDetector(
              onTap: _handleBack,
              child: const Icon(CupertinoIcons.back),
            ),
            middle: const Text('John Doe'),
          ),
          child: SafeArea(child: bodyContent),
        )
        : Scaffold(
          appBar: ChatHeader(
            userName: 'John Doe',
            status: 'Active now',
            onBack: _handleBack,
          ),
          body: SafeArea(child: bodyContent),
        );
  }
}

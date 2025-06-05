import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String time; // e.g. "2:15 PM"
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    // Determine bubble alignment and color
    final alignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = isMe ? Colors.blueAccent : Colors.grey[300];
    final textColor = isMe ? Colors.white : Colors.black87;

    // Platform-specific text style
    final isIOS = Platform.isIOS;
    final textStyle =
        isIOS
            ? CupertinoTheme.of(
              context,
            ).textTheme.textStyle.copyWith(color: textColor, fontSize: 16)
            : Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: textColor);

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: isMe ? 40 : 8,
            right: isMe ? 8 : 40,
          ),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(message, style: textStyle),
        ),
        // Time label
        Padding(
          padding: EdgeInsets.only(left: isMe ? 0 : 16, right: isMe ? 16 : 0),
          child: Text(time, style: TextStyle(fontSize: 10, color: Colors.grey)),
        ),
      ],
    );
  }
}

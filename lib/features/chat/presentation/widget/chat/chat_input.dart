import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSend; // Callback with the typed message

  const ChatInput({super.key, required this.onSend});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Platform.isIOS;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // Text input
          Expanded(
            child:
                isIOS
                    ? CupertinoTextField(
                      controller: _controller,
                      placeholder: 'Type a message...',
                      onSubmitted: (_) => _handleSend(),
                    )
                    : TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
          ),
          const SizedBox(width: 8),
          // Send button
          if (isIOS)
            CupertinoButton(
              color: Colors.blueAccent,
              onPressed: _handleSend,
              child: const Text('Send'),
            )
          else
            ElevatedButton(onPressed: _handleSend, child: const Text('Send')),
        ],
      ),
    );
  }
}

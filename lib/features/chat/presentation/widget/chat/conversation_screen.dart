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
                  reverse:
                      false,
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg =
                        messages[messages.length -
                            1 -
                            index];
                    return ChatBubble(
                      message: msg.text ?? '',
                      time: _formatTime(msg.sentAt),
                      isMe: msg.sender.id != widget.recipientId,
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

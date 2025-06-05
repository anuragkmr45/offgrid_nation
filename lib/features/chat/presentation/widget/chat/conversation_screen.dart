import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  List<MessageEntity> _messages = [];
  String? _myUserId;
  int limit = 10;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    final userId = await sl<AuthSession>().getCurrentUserId();
    if (userId == null) return;

    setState(() => _myUserId = userId);
    context.read<ChatBloc>().add(
      GetMessagesByRecipientRequested(widget.recipientId, limit),
    );
    if (widget.conversationId != null) {
      context.read<ChatBloc>().add(
        MarkConversationReadRequested(widget.conversationId!),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final bodyContent = Column(
      children: [
        Expanded(
          child: BlocListener<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state is MessagesLoaded) {
                setState(() {
                  _messages = state.messages;
                });
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                });
              } else if (state is SendMessageSuccess) {
                setState(() {
                  _messages.add(state.response);
                });
              }
            },
            child:
                _messages.isEmpty
                    ? const Center(child: Text("No messages"))
                    : ListView.builder(
                      reverse: false,
                      controller: _scrollController,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        final bool isMe =
                            _myUserId != null && msg.sender.id == _myUserId;
                        return ChatBubble(
                          message: msg.text ?? '',
                          time: _formatTime(msg.sentAt),
                          isMe: isMe,
                        );
                      },
                    ),
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
            userName: widget.recipientUsername,
            name: widget.recipientName,
            profilePicture: widget.profilePicture,
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

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/features/chat/domain/entities/message_entity.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageRequested extends ChatEvent {
  final Map<String, dynamic> body;
  const SendMessageRequested(this.body);

  @override
  List<Object?> get props => [body];
}

class GetMessagesRequested extends ChatEvent {
  final String conversationId;
  final String? cursor;
  const GetMessagesRequested(this.conversationId, {this.cursor});

  @override
  List<Object?> get props => [conversationId, cursor];
}

class UploadMediaRequested extends ChatEvent {
  final String endpoint;
  final String filePath;
  const UploadMediaRequested(this.endpoint, this.filePath);

  @override
  List<Object?> get props => [endpoint, filePath];
}

class GetConversationsRequested extends ChatEvent {
  const GetConversationsRequested();
}

class MarkConversationReadRequested extends ChatEvent {
  final String conversationId;
  const MarkConversationReadRequested(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

class ToggleMuteConversationRequested extends ChatEvent {
  final String conversationId;
  final bool isMuted;
  const ToggleMuteConversationRequested(this.conversationId, this.isMuted);

  @override
  List<Object?> get props => [conversationId, isMuted];
}

class DeleteConversationRequested extends ChatEvent {
  final String conversationId;
  const DeleteConversationRequested(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

class SearchUsersRequested extends ChatEvent {
  final String query;
  const SearchUsersRequested(this.query);

  @override
  List<Object?> get props => [query];
}

class GetMessagesByRecipientRequested extends ChatEvent {
  final String recipientId;
  final int? limit;
  final String? cursor;
  const GetMessagesByRecipientRequested(this.recipientId, [this.limit ,this.cursor]);

  @override
  List<Object?> get props => [recipientId, limit, cursor];
}

class PushNewMessageReceived extends ChatEvent {
  final MessageEntity message;
  const PushNewMessageReceived(this.message);

  @override
  List<Object?> get props => [message];
}

class SendPostMessageRequested extends ChatEvent {
  final String recipientId;
  final String postId;
  final String? conversationId;
  final BuildContext context;

  const SendPostMessageRequested({
    required this.recipientId,
    required this.postId,
    this.conversationId,
    required this.context,
  });

  @override
  List<Object?> get props => [recipientId, postId, conversationId];
}



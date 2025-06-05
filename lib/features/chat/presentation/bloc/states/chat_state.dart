import 'package:equatable/equatable.dart';
import 'package:offgrid_nation_app/features/chat/domain/entities/chat_user_entity.dart';
import 'package:offgrid_nation_app/features/chat/domain/entities/message_entity.dart';
import 'package:offgrid_nation_app/features/chat/domain/entities/conversation_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class SendMessageSuccess extends ChatState {
  final MessageEntity response;
  const SendMessageSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class MessagesLoaded extends ChatState {
  final List<MessageEntity> messages;
  const MessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ConversationsLoaded extends ChatState {
  final List<ConversationEntity> conversations;
  const ConversationsLoaded(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class MediaUploaded extends ChatState {
  final String url;
  const MediaUploaded(this.url);

  @override
  List<Object?> get props => [url];
}

class ChatActionCompleted extends ChatState {}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchResultsLoaded extends ChatState {
  final List<ChatUserEntity> users;
  const SearchResultsLoaded(this.users);

  @override
  List<Object?> get props => [users];
}


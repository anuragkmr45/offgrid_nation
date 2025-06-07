// 📁 lib/features/chat/presentation/bloc/chat_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/errors/network_exception.dart';
import 'package:offgrid_nation_app/features/chat/domain/entities/message_entity.dart';
import 'package:offgrid_nation_app/features/chat/domain/usecases/get_messages_by_recipient_usecase.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/events/chat_event.dart';
import 'package:offgrid_nation_app/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:offgrid_nation_app/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:offgrid_nation_app/features/chat/domain/usecases/upload_media_usecase.dart';
import 'package:offgrid_nation_app/features/chat/domain/usecases/get_conversations_usecase.dart';
import 'package:offgrid_nation_app/features/chat/domain/usecases/mark_conversation_read_usecase.dart';
import 'package:offgrid_nation_app/features/chat/domain/usecases/mute_conversation_usecase.dart';
import 'package:offgrid_nation_app/features/chat/domain/usecases/delete_conversation_usecase.dart';
import 'package:offgrid_nation_app/features/chat/domain/usecases/search_users_usecase.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/states/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUsecase sendMessageUsecase;
  final GetMessagesUsecase getMessagesUsecase;
  final UploadMediaUsecase uploadMediaUsecase;
  final GetConversationsUsecase getConversationsUsecase;
  final MarkConversationReadUsecase markReadUsecase;
  final MuteConversationUsecase muteUsecase;
  final DeleteConversationUsecase deleteUsecase;
  final SearchUsersUsecase searchUsersUsecase;
  final GetMessagesByRecipientUsecase getMessagesByRecipientUsecase;

  ChatBloc({
    required this.sendMessageUsecase,
    required this.getMessagesUsecase,
    required this.uploadMediaUsecase,
    required this.getConversationsUsecase,
    required this.markReadUsecase,
    required this.muteUsecase,
    required this.deleteUsecase,
    required this.searchUsersUsecase,
    required this.getMessagesByRecipientUsecase,
  }) : super(ChatInitial()) {
    on<SendMessageRequested>(_onSendMessage);
    on<GetMessagesRequested>(_onGetMessages);
    on<UploadMediaRequested>(_onUploadMedia);
    on<GetConversationsRequested>(_onGetConversations);
    on<MarkConversationReadRequested>(_onMarkRead);
    on<ToggleMuteConversationRequested>(_onToggleMute);
    on<DeleteConversationRequested>(_onDeleteConversation);
    on<SearchUsersRequested>(_onSearchUsers);
    on<GetMessagesByRecipientRequested>(_onGetMessagesByRecipient);
    on<PushNewMessageReceived>(_onPushNewMessageReceived);
  }

  Future<void> _onSendMessage(
    SendMessageRequested event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final result = await sendMessageUsecase(event.body);

      // Instead of emitting SendMessageSuccess → just trigger PushNewMessageReceived
      if (state is MessagesLoaded) {
        final currentMessages = (state as MessagesLoaded).messages;

        final alreadyExists = currentMessages.any((m) => m.id == result.id);

        if (!alreadyExists) {
          final updatedMessages = [result, ...currentMessages];
          emit(MessagesLoaded(updatedMessages)); // 👈 always emit this
        } else {
          emit(MessagesLoaded(currentMessages)); // keep same
        }
      } else {
        // No messages loaded yet → emit MessagesLoaded
        emit(MessagesLoaded([result]));
      }

      // ⚠️ REMOVE this → this is causing state change to SendMessageSuccess
      // add(PushNewMessageReceived(result));
    } catch (e) {
      emit(
        ChatError(
          e is NetworkException
              ? (e.message ?? 'Unexpected network error')
              : 'Send message failed',
        ),
      );
    }
  }

  Future<void> _onGetMessages(
    GetMessagesRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final result = await getMessagesUsecase(
        event.conversationId,
        cursor: event.cursor,
      );
      emit(MessagesLoaded(result));
    } catch (e) {
      emit(
        ChatError(
          e is NetworkException
              ? (e.message ?? 'Unexpected network error')
              : 'Load message failed',
        ),
      );
    }
  }

  Future<void> _onUploadMedia(
    UploadMediaRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final url = await uploadMediaUsecase(event.endpoint, event.filePath);
      emit(MediaUploaded(url));
    } catch (e) {
      emit(
        ChatError(
          e is NetworkException
              ? (e.message ?? 'Unexpected network error')
              : 'Upload failed',
        ),
      );
    }
  }

  Future<void> _onGetConversations(
    GetConversationsRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final list = await getConversationsUsecase();
      emit(ConversationsLoaded(list));
    } catch (e) {
      emit(
        ChatError(
          e is NetworkException
              ? (e.message ?? 'Unexpected network error')
              : 'Conversations load failed',
        ),
      );
    }
  }

  Future<void> _onMarkRead(
    MarkConversationReadRequested event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await markReadUsecase(event.conversationId);
      emit(ChatActionCompleted());
    } catch (e) {
      emit(
        ChatError(
          e is NetworkException
              ? (e.message ?? 'Unexpected network error')
              : 'Mark as read failed',
        ),
      );
    }
  }

  Future<void> _onToggleMute(
    ToggleMuteConversationRequested event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await muteUsecase(event.conversationId, event.isMuted);
      emit(ChatActionCompleted());
    } catch (e) {
      emit(
        ChatError(
          e is NetworkException
              ? (e.message ?? 'Unexpected network error')
              : 'Mute toggle failed',
        ),
      );
    }
  }

  Future<void> _onDeleteConversation(
    DeleteConversationRequested event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await deleteUsecase(event.conversationId);
      emit(ChatActionCompleted());
    } catch (e) {
      emit(
        ChatError(
          e is NetworkException
              ? (e.message ?? 'Unexpected network error')
              : 'Delete failed',
        ),
      );
    }
  }

  Future<void> _onSearchUsers(
    SearchUsersRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final users = await searchUsersUsecase(event.query);
      emit(SearchResultsLoaded(users));
    } catch (e) {
      emit(
        ChatError(
          e is NetworkException
              ? (e.message ?? 'Unexpected network error')
              : 'Search failed',
        ),
      );
    }
  }

  Future<void> _onGetMessagesByRecipient(
    GetMessagesByRecipientRequested event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final messages = await getMessagesByRecipientUsecase(
        event.recipientId,
        event.limit,
        event.cursor,
      );
      emit(MessagesLoaded(messages));
    } catch (e) {
      emit(
        ChatError(
          e is NetworkException
              ? (e.message ?? 'Unexpected error')
              : 'Failed to load messages',
        ),
      );
    }
  }

  Future<void> _onPushNewMessageReceived(
    PushNewMessageReceived event,
    Emitter<ChatState> emit,
  ) async {
    try {
      if (state is MessagesLoaded) {
        final currentMessages = (state as MessagesLoaded).messages;

        // SAFETY: Check if message already exists (avoid duplicates)
        final alreadyExists = currentMessages.any(
          (m) => m.id == event.message.id,
        );

        if (!alreadyExists) {
          final updatedMessages = [event.message, ...currentMessages];
          emit(MessagesLoaded(updatedMessages));
        } else {
          // No-op if duplicate
          emit(MessagesLoaded(currentMessages));
        }
      } else {
        // If no messages loaded yet → start with this one
        emit(MessagesLoaded([event.message]));
      }
    } catch (e) {
      emit(
        ChatError(
          e is NetworkException
              ? (e.message ?? 'Unexpected error')
              : 'Failed to process new message',
        ),
      );
    }
  }
}

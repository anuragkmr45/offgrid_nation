part of '../content_bloc.dart';

@immutable
sealed class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object?> get props => [];
}

class FetchContentRequested extends ContentEvent {
  final int limit;

  const FetchContentRequested({this.limit = 20});
}

class FetchMoreContentRequested extends ContentEvent {
  final int limit;

  const FetchMoreContentRequested({this.limit = 20});
}

class ToggleLikeDislikeRequest extends ContentEvent {
  final String postId;
  final BuildContext context;

  const ToggleLikeDislikeRequest({required this.postId, required this.context});

  @override
  List<Object?> get props => [postId];
}

class FetchCommentsRequested extends ContentEvent {
  final String postId;

  const FetchCommentsRequested(this.postId);

  @override
  List<Object?> get props => [postId];
}

class AddCommentRequested extends ContentEvent {
  final String postId;
  final String content;
  final BuildContext context;

  const AddCommentRequested({
    required this.postId,
    required this.content,
    required this.context,
  });

  @override
  List<Object?> get props => [postId, content];
}

class ToggleCommentLikeRequested extends ContentEvent {
  final String commentId;
  final BuildContext context;

  const ToggleCommentLikeRequested({
    required this.commentId,
    required this.context,
  });

  @override
  List<Object?> get props => [commentId];
}

class FetchRepliesRequested extends ContentEvent {
  final String commentId;

  const FetchRepliesRequested(this.commentId);

  @override
  List<Object?> get props => [commentId];
}

class AddReplyRequested extends ContentEvent {
  final String commentId;
  final String content;
  final BuildContext context;

  const AddReplyRequested({
    required this.commentId,
    required this.content,
    required this.context,
  });

  @override
  List<Object?> get props => [commentId, content];
}

class SearchUsersRequested extends ContentEvent {
  final String query;
  const SearchUsersRequested(this.query);

  @override
  List<Object?> get props => [query];
}

class SharePostRequested extends ContentEvent {
  final BuildContext context;
  final String postId;
  final String recipientId;
  final String? conversationId;

  const SharePostRequested({
    required this.context,
    required this.postId,
    required this.recipientId,
    this.conversationId,
  });

  @override
  List<Object?> get props => [context, postId, recipientId, conversationId];
}

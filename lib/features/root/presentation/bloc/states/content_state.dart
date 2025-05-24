part of '../content_bloc.dart';

enum ContentStatus { initial, loading, success, loadingMore, failure }

class ContentState extends Equatable {
  final ContentStatus status;
  final List<ContentModel>? contents;
  final String? nextCursor;
  final bool hasMore;
  final List<CommentModel>? comments;
  final List<ReplyModel>? replies;
  final String? errorMessage;

  const ContentState({
    this.status = ContentStatus.initial,
    this.contents,
    this.nextCursor,
    this.hasMore = true,
    this.comments,
    this.replies,
    this.errorMessage,
  });

  ContentState copyWith({
    ContentStatus? status,
    List<ContentModel>? contents,
    String? nextCursor,
    bool? hasMore,
    List<CommentModel>? comments,
    List<ReplyModel>? replies,
    String? errorMessage,
  }) {
    return ContentState(
      status: status ?? this.status,
      contents: contents ?? this.contents,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      comments: comments ?? this.comments,
      replies: replies ?? this.replies,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    contents,
    nextCursor,
    hasMore,
    comments,
    replies,
    errorMessage,
  ];
}

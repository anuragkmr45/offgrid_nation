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
  final List<ChatUserEntity>? searchResults;

  const ContentState({
    this.status = ContentStatus.initial,
    this.contents,
    this.nextCursor,
    this.hasMore = true,
    this.comments,
    this.replies,
    this.errorMessage, 
    this.searchResults, 
  });

  ContentState copyWith({
    ContentStatus? status,
    List<ContentModel>? contents,
    String? nextCursor,
    bool? hasMore,
    List<CommentModel>? comments,
    List<ReplyModel>? replies,
    String? errorMessage,
  List<ChatUserEntity>? searchResults,
  }) {
    return ContentState(
      status: status ?? this.status,
      contents: contents ?? this.contents,
      nextCursor: nextCursor ?? this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      comments: comments ?? this.comments,
      replies: replies ?? this.replies,
      errorMessage: errorMessage ?? this.errorMessage,
      searchResults: searchResults ?? this.searchResults,
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
    searchResults
  ];
}

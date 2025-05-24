import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/errors/error_handler.dart';
import 'package:offgrid_nation_app/core/session/auth_session.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/comment_model.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/content_modal.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/reply_model.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/add_comment_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/add_reply_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/content_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/fetch_comments_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/fetch_replies_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/toggle_comment_like_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/toggle_like_dislike_usecase.dart';

part 'events/content_event.dart';
part 'states/content_state.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final AuthSession authSession;
  final FetchContentUsecase fetchUsecase;
  final ToggleLikeDislikeUsecase toggleLikeDislikeUsecase;
  final FetchCommentsUsecase fetchCommentsUsecase;
  final AddCommentUsecase addCommentUsecase;
  final ToggleCommentLikeUsecase toggleCommentLikeUsecase;
  final FetchRepliesUsecase fetchRepliesUsecase;
  final AddReplyUsecase addReplyUsecase;

  ContentBloc({
    required this.fetchUsecase,
    required this.toggleLikeDislikeUsecase,
    required this.authSession,
    required this.fetchCommentsUsecase,
    required this.addCommentUsecase,
    required this.toggleCommentLikeUsecase,
    required this.fetchRepliesUsecase,
    required this.addReplyUsecase,
  }) : super(const ContentState()) {
    on<FetchContentRequested>(_onFetch);
    on<FetchMoreContentRequested>(_onFetchMore);
    on<ToggleLikeDislikeRequest>(_onToggleLikeDislike);
    on<FetchCommentsRequested>(_onFetchComments);
    on<AddCommentRequested>(_onAddComment);
    on<ToggleCommentLikeRequested>(_onToggleCommentLike);
    on<FetchRepliesRequested>(_onFetchReplies);
    on<AddReplyRequested>(_onAddReply);
  }

  Future<void> _onFetch(
    FetchContentRequested event,
    Emitter<ContentState> emit,
  ) async {
    if (!state.hasMore ||
        state.status == ContentStatus.loadingMore ||
        state.status == ContentStatus.loading)
      return;

    emit(state.copyWith(status: ContentStatus.loading));

    try {
      final (data, nextCursor) = await fetchUsecase.call(limit: event.limit);
      emit(
        state.copyWith(
          status: ContentStatus.success,
          contents: data,
          nextCursor: nextCursor,
          hasMore: nextCursor != null && data.isNotEmpty,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ContentStatus.failure,
          errorMessage: ErrorHandler.handle(e),
        ),
      );
    }
  }

  Future<void> _onFetchMore(
    FetchMoreContentRequested event,
    Emitter<ContentState> emit,
  ) async {
    if (!state.hasMore || state.status == ContentStatus.loadingMore) return;

    emit(state.copyWith(status: ContentStatus.loadingMore));

    try {
      final (data, nextCursor) = await fetchUsecase.call(
        limit: event.limit,
        cursor: state.nextCursor,
      );
      emit(
        state.copyWith(
          status: ContentStatus.success,
          contents: [...?state.contents, ...data],
          nextCursor: nextCursor,
          hasMore: nextCursor != null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ContentStatus.failure,
          errorMessage: ErrorHandler.handle(e),
        ),
      );
    }
  }

  Future<void> _onToggleLikeDislike(
    ToggleLikeDislikeRequest event,
    Emitter<ContentState> emit,
  ) async {
    final posts = state.contents;
    if (posts == null) return;

    final index = posts.indexWhere((p) => p.id == event.postId);
    if (index == -1) return;

    final oldPost = posts[index];
    final nowLiked = !oldPost.isLiked;

    // ✅ Optimistic update using likesCount
    final optimisticPost = oldPost.copyWith(
      isLiked: nowLiked,
      likesCount:
          nowLiked
              ? oldPost.likesCount + 1
              : (oldPost.likesCount > 0 ? oldPost.likesCount - 1 : 0),
    );

    final optimisticPosts = List<ContentModel>.from(posts)
      ..[index] = optimisticPost;
    emit(state.copyWith(contents: optimisticPosts));

    try {
      final response = await toggleLikeDislikeUsecase(event.postId);

      final confirmedIsLiked = response['isLiked'] as bool? ?? nowLiked;
      final confirmedLikesCount =
          response['likesCount'] as int? ?? optimisticPost.likesCount;

      final finalPost = optimisticPost.copyWith(
        isLiked: confirmedIsLiked,
        likesCount: confirmedLikesCount,
      );

      final finalPosts = List<ContentModel>.from(posts)..[index] = finalPost;
      emit(state.copyWith(contents: finalPosts));

      // ✅ Optional: re-fetch full feed after like
      // emit(state.copyWith(status: ContentStatus.loading));
      // add(const FetchContentRequested());
    } catch (e) {
      // Rollback to old post
      final rollbackPosts = List<ContentModel>.from(posts)..[index] = oldPost;
      emit(state.copyWith(contents: rollbackPosts));

      final msg = ErrorHandler.handle(e);
      if (Platform.isAndroid) {
        ScaffoldMessenger.of(
          event.context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      } else {
        showCupertinoDialog(
          context: event.context,
          builder:
              (_) => CupertinoAlertDialog(
                title: const Text("Error"),
                content: Text(msg),
                actions: [
                  CupertinoDialogAction(
                    child: const Text("OK"),
                    onPressed: () => Navigator.of(event.context).pop(),
                  ),
                ],
              ),
        );
      }
    }
  }

  Future<void> _onFetchComments(
    FetchCommentsRequested event,
    Emitter<ContentState> emit,
  ) async {
    try {
      final comments = await fetchCommentsUsecase(postId: event.postId);
      emit(state.copyWith(comments: comments));
    } catch (e) {
      _showError(event.postId, e);
    }
  }

  // Future<void> _onAddComment(
  //   AddCommentRequested event,
  //   Emitter<ContentState> emit,
  // ) async {
  //   try {
  //     final comment = await addCommentUsecase(
  //       postId: event.postId,
  //       content: event.content,
  //     );
  //     final updated = [...?state.comments, comment];
  //     emit(state.copyWith(comments: updated));
  //   } catch (e) {
  //     _showPlatformError(event.context, e);
  //   }
  // }
  Future<void> _onAddComment(
    AddCommentRequested event,
    Emitter<ContentState> emit,
  ) async {
    final posts = state.contents;
    if (posts == null) return;

    final index = posts.indexWhere((p) => p.id == event.postId);
    if (index == -1) return;

    final oldPost = posts[index];

    // Optimistic update: increase comment count
    final optimisticPost = oldPost.copyWith(
      commentsCount: oldPost.commentsCount + 1,
    );

    final optimisticPosts = List<ContentModel>.from(posts)
      ..[index] = optimisticPost;
    emit(state.copyWith(contents: optimisticPosts));

    try {
      // Call API
      await addCommentUsecase(postId: event.postId, content: event.content);

      // ✅ Refetch comment list for modal
      final updatedComments = await fetchCommentsUsecase(postId: event.postId);
      emit(state.copyWith(comments: updatedComments));

      // ✅ Optionally refetch feed data in background
      add(const FetchContentRequested());
    } catch (e) {
      // Rollback comment count on failure
      final rollbackPosts = List<ContentModel>.from(posts)..[index] = oldPost;
      emit(state.copyWith(contents: rollbackPosts));
      _showPlatformError(event.context, e);
    }
  }

  Future<void> _onToggleCommentLike(
    ToggleCommentLikeRequested event,
    Emitter<ContentState> emit,
  ) async {
    try {
      await toggleCommentLikeUsecase(event.commentId);
      // re-fetch or optimistically update if needed
    } catch (e) {
      _showPlatformError(event.context, e);
    }
  }

  Future<void> _onFetchReplies(
    FetchRepliesRequested event,
    Emitter<ContentState> emit,
  ) async {
    try {
      final replies = await fetchRepliesUsecase(commentId: event.commentId);
      emit(state.copyWith(replies: replies));
    } catch (e) {
      _showError(event.commentId, e);
    }
  }

  // Future<void> _onAddReply(
  //   AddReplyRequested event,
  //   Emitter<ContentState> emit,
  // ) async {
  //   try {
  //     final reply = await addReplyUsecase(
  //       commentId: event.commentId,
  //       content: event.content,
  //     );
  //     final updated = [...?state.replies, reply];
  //     emit(state.copyWith(replies: updated));
  //   } catch (e) {
  //     _showPlatformError(event.context, e);
  //   }
  // }
  Future<void> _onAddReply(
    AddReplyRequested event,
    Emitter<ContentState> emit,
  ) async {
    final currentUser = await authSession.getCurrentUserRef();

    // Temporary reply (optimistic UI)
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final tempReply = ReplyModel(
      id: tempId,
      commentId: event.commentId,
      user: currentUser,
      content: event.content,
      likes: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final optimisticReplies = [tempReply, ...?state.replies];
    emit(state.copyWith(replies: optimisticReplies));

    try {
      // Post reply to backend
      final realReply = await addReplyUsecase(
        commentId: event.commentId,
        content: event.content,
      );

      // Replace temp reply with real one
      final correctedReplies =
          optimisticReplies.map((r) => r.id == tempId ? realReply : r).toList();
      emit(state.copyWith(replies: correctedReplies));

      // ✅ Optional: Re-fetch full reply list for consistency
      final updatedReplies = await fetchRepliesUsecase(
        commentId: event.commentId,
      );
      emit(state.copyWith(replies: updatedReplies));
    } catch (e) {
      // Rollback on failure
      final rollbackReplies = List<ReplyModel>.from(state.replies ?? [])
        ..removeWhere((r) => r.id == tempId);
      emit(state.copyWith(replies: rollbackReplies));

      _showPlatformError(event.context, e);
    }
  }
}

void _showPlatformError(BuildContext context, Object error) {
  final message = ErrorHandler.handle(error);
  if (Platform.isAndroid) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  } else {
    showCupertinoDialog(
      context: context,
      builder:
          (_) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }
}

void _showError(String contextKey, Object error) {
  debugPrint('[$contextKey] ${ErrorHandler.handle(error)}');
}

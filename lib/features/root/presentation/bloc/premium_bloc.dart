import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/errors/network_exception.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/premium/post_entity.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/add_comment_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/add_reply_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/fetch_comments_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/toggle_like_dislike_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/premium/create_checkout_session_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/premium/fetch_premium_feed_usecase.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/events/premium_event.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/states/premium_state.dart';

class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  final CreateCheckoutSessionUseCase createCheckoutSessionUseCase;
  final FetchPremiumFeedUseCase fetchPremiumFeedUseCase;
  final ToggleLikeDislikeUsecase toggleLikeDislikeUsecase;
  final AddReplyUsecase addReplyUseCase;
  final AddCommentUsecase addCommentUseCase;
  final FetchCommentsUsecase fetchCommentsUseCase;

  PremiumBloc({
    required this.createCheckoutSessionUseCase,
    required this.fetchPremiumFeedUseCase,
    required this.toggleLikeDislikeUsecase,
    required this.addReplyUseCase,
    required this.addCommentUseCase,
    required this.fetchCommentsUseCase,
  }) : super(PremiumInitial()) {
    on<CreateCheckoutSessionRequested>(_onCreateCheckoutSessionRequested);
    on<FetchPremiumFeedRequested>(_onFetchPremiumFeedRequested);
    on<TogglePremiumLikeDislikeRequested>(_onTogglePremiumLikeDislikeRequested);
    on<FetchPremiumCommentsRequested>(_onFetchPremiumCommentsRequested);
    on<AddPremiumCommentRequested>(_onAddPremiumCommentRequested);
    on<AddPremiumReplyRequested>(_onAddPremiumReplyRequested);
  }

  Future<void> _onCreateCheckoutSessionRequested(
    CreateCheckoutSessionRequested event,
    Emitter<PremiumState> emit,
  ) async {
    emit(CreateCheckoutSessionLoading());
    try {
      final url = await createCheckoutSessionUseCase();
      emit(CreateCheckoutSessionSuccess(url));
    } on NetworkException catch (e) {
      emit(CreateCheckoutSessionFailure(e.message ?? 'Something went wrong'));
    } catch (e) {
      emit(CreateCheckoutSessionFailure(e.toString()));
    }
  }

  Future<void> _onFetchPremiumFeedRequested(
    FetchPremiumFeedRequested event,
    Emitter<PremiumState> emit,
  ) async {
    emit(PremiumFeedLoading());
    try {
      final posts = await fetchPremiumFeedUseCase();
      emit(PremiumFeedLoaded(posts));
    } on NetworkException catch (e) {
      if (e.message == 'USER_NOT_PREMIUM') {
        emit(PremiumUserNotSubscribed());
      } else {
        emit(PremiumFeedFailure(e.message ?? 'Something went wrong'));
      }
    } catch (e) {
      emit(PremiumFeedFailure(e.toString()));
    }
  }

  Future<void> _onTogglePremiumLikeDislikeRequested(
    TogglePremiumLikeDislikeRequested event,
    Emitter<PremiumState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PremiumFeedLoaded) return;

    final posts = currentState.posts;
    final index = posts.indexWhere((p) => p.id == event.postId);
    if (index == -1) return;

    final oldPost = posts[index];
    final nowLiked = !oldPost.isLiked;

    final optimisticPost = oldPost.copyWith(
      isLiked: nowLiked,
      likesCount:
          nowLiked
              ? oldPost.likesCount + 1
              : (oldPost.likesCount > 0 ? oldPost.likesCount - 1 : 0),
    );

    final updatedPosts = List<PostEntity>.from(posts)..[index] = optimisticPost;
    emit(PremiumFeedLoaded(updatedPosts));

    try {
      final result = await toggleLikeDislikeUsecase(event.postId);

      final confirmedPost = optimisticPost.copyWith(
        isLiked: result['isLiked'] as bool? ?? nowLiked,
        likesCount: result['likesCount'] as int? ?? optimisticPost.likesCount,
      );

      final confirmedPosts = List<PostEntity>.from(posts)
        ..[index] = confirmedPost;

      emit(PremiumFeedLoaded(confirmedPosts));
    } catch (e) {
      final rollbackPosts = List<PostEntity>.from(posts)..[index] = oldPost;
      emit(PremiumFeedLoaded(rollbackPosts));

      final message = "Failed to toggle like: ${e.toString()}";

      if (Platform.isIOS) {
        showCupertinoDialog(
          context: event.context,
          builder:
              (_) => CupertinoAlertDialog(
                title: const Text("Error"),
                content: Text(message),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text("OK"),
                    onPressed: () => Navigator.pop(event.context),
                  ),
                ],
              ),
        );
      } else {
        ScaffoldMessenger.of(
          event.context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  Future<void> _onFetchPremiumCommentsRequested(
    FetchPremiumCommentsRequested event,
    Emitter<PremiumState> emit,
  ) async {
    try {
      final comments = await fetchCommentsUseCase(postId: event.postId);
      emit(PremiumCommentsLoaded(comments));
    } catch (e) {
      emit(PremiumFeedFailure("Failed to fetch comments: ${e.toString()}"));
    }
  }

  Future<void> _onAddPremiumCommentRequested(
    AddPremiumCommentRequested event,
    Emitter<PremiumState> emit,
  ) async {
    try {
      await addCommentUseCase(postId: event.postId, content: event.content);
      add(FetchPremiumCommentsRequested(event.postId));
    } catch (e) {
      _showError(
        context: event.context,
        message: "Failed to comment: ${e.toString()}",
      );
    }
  }

  Future<void> _onAddPremiumReplyRequested(
    AddPremiumReplyRequested event,
    Emitter<PremiumState> emit,
  ) async {
    try {
      await addReplyUseCase(commentId: event.commentId, content: event.content);
      add(
        FetchPremiumCommentsRequested(event.commentId),
      ); // assuming replies are refetched
    } catch (e) {
      _showError(
        context: event.context,
        message: "Failed to reply: ${e.toString()}",
      );
    }
  }

  void _showError({required BuildContext context, required String message}) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder:
            (_) => CupertinoAlertDialog(
              title: const Text("Error"),
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text("OK"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}

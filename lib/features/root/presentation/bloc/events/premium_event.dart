import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class PremiumEvent extends Equatable {
  const PremiumEvent();

  @override
  List<Object?> get props => [];
}

class CreateCheckoutSessionRequested extends PremiumEvent {}

class FetchPremiumFeedRequested extends PremiumEvent {}

class TogglePremiumLikeDislikeRequested extends PremiumEvent {
  final String postId;
  final BuildContext context;

  const TogglePremiumLikeDislikeRequested({
    required this.postId,
    required this.context,
  });

  @override
  List<Object?> get props => [postId];
}

class FetchPremiumCommentsRequested extends PremiumEvent {
  final String postId;
  const FetchPremiumCommentsRequested(this.postId);
}

class AddPremiumCommentRequested extends PremiumEvent {
  final String postId;
  final String content;
  final BuildContext context;

  const AddPremiumCommentRequested({
    required this.postId,
    required this.content,
    required this.context,
  });
}

class AddPremiumReplyRequested extends PremiumEvent {
  final String commentId;
  final String content;
  final BuildContext context;

  const AddPremiumReplyRequested({
    required this.commentId,
    required this.content,
    required this.context,
  });
}

import 'package:equatable/equatable.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/comment_model.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/premium/post_entity.dart';

abstract class PremiumState extends Equatable {
  const PremiumState();

  @override
  List<Object?> get props => [];
}

class PremiumInitial extends PremiumState {}

class PremiumFeedLoading extends PremiumState {}

class CreateCheckoutSessionLoading extends PremiumState {}

class CreateCheckoutSessionSuccess extends PremiumState {
  final String checkoutUrl;

  const CreateCheckoutSessionSuccess(this.checkoutUrl);

  @override
  List<Object?> get props => [checkoutUrl];
}

class CreateCheckoutSessionFailure extends PremiumState {
  final String message;

  const CreateCheckoutSessionFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class PremiumFeedLoaded extends PremiumState {
  final List<PostEntity> posts;

  const PremiumFeedLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class PremiumFeedFailure extends PremiumState {
  final String message;

  const PremiumFeedFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class PremiumUserNotSubscribed extends PremiumState {}

class PremiumCommentsLoaded extends PremiumState {
  final List<CommentModel> comments;
  const PremiumCommentsLoaded(this.comments);

  @override
  List<Object?> get props => [comments];
}

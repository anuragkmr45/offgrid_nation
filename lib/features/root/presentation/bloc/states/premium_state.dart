import 'package:equatable/equatable.dart';

abstract class PremiumState extends Equatable {
  const PremiumState();

  @override
  List<Object?> get props => [];
}

class PremiumInitial extends PremiumState {}

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

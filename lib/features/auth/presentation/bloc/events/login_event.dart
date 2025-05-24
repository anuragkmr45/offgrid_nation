part of '../login_bloc.dart';

@immutable
sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String identifier;
  final String password;

  const LoginSubmitted({required this.identifier, required this.password});

  @override
  List<Object> get props => [identifier, password];
}

class GoogleLoginRequested extends LoginEvent {}

class AppleLoginRequested extends LoginEvent {}

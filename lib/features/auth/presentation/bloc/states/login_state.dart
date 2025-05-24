part of '../login_bloc.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState with EquatableMixin {
  final LoginStatus status;
  final String? authKey;
  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.initial,
    this.authKey,
    this.errorMessage,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? authKey,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      authKey: authKey ?? this.authKey,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, authKey, errorMessage];
}

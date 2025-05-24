import 'package:equatable/equatable.dart';

enum ResetPasswordStatus {
  initial,
  loading,
  otpSent,
  otpVerified,
  success,
  failure,
}

class ResetPasswordState extends Equatable {
  final ResetPasswordStatus status;
  final String? errorMessage;

  const ResetPasswordState({
    this.status = ResetPasswordStatus.initial,
    this.errorMessage,
  });

  ResetPasswordState copyWith({
    ResetPasswordStatus? status,
    String? errorMessage,
  }) {
    return ResetPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

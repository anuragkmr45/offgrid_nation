part of '../signup_bloc.dart';

enum SignupStatus { initial, loading, otpSent, success, failure }

enum UsernameAvailabilityStatus { initial, checking, available, unavailable }

enum OTPVerificationStatus { initial, verifying, verified, invalid }

class SignupState extends Equatable {
  final SignupStatus status;
  final String? authKey;
  final String? errorMessage;
  final String? verificationId;
  final UsernameAvailabilityStatus usernameAvailability;
  final OTPVerificationStatus otpVerification;

  const SignupState({
    this.status = SignupStatus.initial,
    this.authKey,
    this.errorMessage,
    this.verificationId,
    this.usernameAvailability = UsernameAvailabilityStatus.initial,
    this.otpVerification = OTPVerificationStatus.initial,
  });

  SignupState copyWith({
    SignupStatus? status,
    String? authKey,
    String? errorMessage,
    String? verificationId,
    UsernameAvailabilityStatus? usernameAvailability,
    OTPVerificationStatus? otpVerification,
  }) {
    return SignupState(
      status: status ?? this.status,
      authKey: authKey ?? this.authKey,
      errorMessage: errorMessage,
      verificationId: verificationId ?? this.verificationId,
      usernameAvailability: usernameAvailability ?? this.usernameAvailability,
      otpVerification: otpVerification ?? this.otpVerification,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    authKey,
    verificationId,
    usernameAvailability,
    otpVerification,
  ];
}

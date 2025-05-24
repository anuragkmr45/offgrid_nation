import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordRequested extends ResetPasswordEvent {
  final String phone;
  const ForgotPasswordRequested(this.phone);

  @override
  List<Object?> get props => [phone];
}

class VerifyPhoneResetPassword extends ResetPasswordEvent {
  final String phone;
  final String otp;
  const VerifyPhoneResetPassword(this.phone, this.otp);

  @override
  List<Object?> get props => [phone, otp];
}

class SubmitResetPassword extends ResetPasswordEvent {
  final String phone;
  final String newPassword;

  const SubmitResetPassword({required this.phone, required this.newPassword});

  @override
  List<Object?> get props => [phone, newPassword];
}

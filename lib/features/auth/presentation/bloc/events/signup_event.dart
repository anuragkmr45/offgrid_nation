part of '../signup_bloc.dart';

abstract class SignupEvent extends Equatable {
  const SignupEvent();
}

class CheckUsernameAvailability extends SignupEvent {
  final String username;
  const CheckUsernameAvailability(this.username);
  @override
  List<Object?> get props => [username];
}

class UsernameChanged extends SignupEvent {
  final String username;
  const UsernameChanged(this.username);

  @override
  List<Object?> get props => [username];
}

class SendOTPRequested extends SignupEvent {
  final String username;
  final String phone;

  const SendOTPRequested(this.username, this.phone);

  @override
  List<Object?> get props => [phone];
}

class VerifyOTP extends SignupEvent {
  final String phone;
  final String otp;
  const VerifyOTP(this.phone, this.otp);
  @override
  List<Object?> get props => [phone, otp];
}

class SignupSubmitted extends SignupEvent {
  final String phone;
  final String password;

  const SignupSubmitted({required this.phone, required this.password});

  @override
  List<Object?> get props => [phone, password];
}

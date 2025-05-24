import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:offgrid_nation_app/features/auth/domain/usecases/check_username_availability_usecase.dart';
import 'package:offgrid_nation_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:offgrid_nation_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:offgrid_nation_app/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:offgrid_nation_app/core/errors/error_handler.dart';

part './events/signup_event.dart';
part './states/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUseCase signupUseCase;
  final CheckUsernameAvailabilityUseCase checkUsernameAvailabilityUseCase;
  final VerifyOTPUseCase verifyOTPUseCase;
  final SendOTPUseCase sendOTPUseCase;

  SignupBloc({
    required this.signupUseCase,
    required this.checkUsernameAvailabilityUseCase,
    required this.verifyOTPUseCase,
    required this.sendOTPUseCase,
  }) : super(const SignupState()) {
    on<CheckUsernameAvailability>(_onCheckUsernameAvailability);
    on<UsernameChanged>((event, emit) {
      emit(
        state.copyWith(
          usernameAvailability: UsernameAvailabilityStatus.initial,
        ),
      );
    });
    on<SendOTPRequested>(_onSendOTPRequested);
    on<VerifyOTP>(_onVerifyOTP);
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  Future<void> _onCheckUsernameAvailability(
    CheckUsernameAvailability event,
    Emitter<SignupState> emit,
  ) async {
    emit(
      state.copyWith(usernameAvailability: UsernameAvailabilityStatus.checking),
    );
    try {
      final isAvailable = await checkUsernameAvailabilityUseCase(
        event.username,
      );
      emit(
        state.copyWith(
          usernameAvailability:
              isAvailable
                  ? UsernameAvailabilityStatus.available
                  : UsernameAvailabilityStatus.unavailable,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          usernameAvailability: UsernameAvailabilityStatus.unavailable,
          errorMessage: ErrorHandler.handle(error),
        ),
      );
    }
  }

  Future<void> _onSendOTPRequested(
    SendOTPRequested event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(status: SignupStatus.loading));

    try {
      final result = await sendOTPUseCase(event.username, event.phone);
      final message = result['message'] ?? '';
      print('OTP Send API Response: $result');

      if (message.contains('OTP sent')) {
        emit(state.copyWith(status: SignupStatus.otpSent));
      } else {
        emit(
          state.copyWith(
            status: SignupStatus.failure,
            errorMessage: result['message'] ?? 'Failed to send OTP',
          ),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: SignupStatus.failure,
          errorMessage: ErrorHandler.handle(error),
        ),
      );
    }
  }

  Future<void> _onVerifyOTP(VerifyOTP event, Emitter<SignupState> emit) async {
    emit(state.copyWith(otpVerification: OTPVerificationStatus.verifying));
    try {
      final isValid = await verifyOTPUseCase(event.phone, event.otp);
      final message = isValid['message'] ?? '';

      if (message.toString().contains('complete')) {
        emit(state.copyWith(otpVerification: OTPVerificationStatus.verified));
      } else {
        emit(state.copyWith(otpVerification: OTPVerificationStatus.invalid));
      }
    } catch (error) {
      emit(
        state.copyWith(
          otpVerification: OTPVerificationStatus.invalid,
          errorMessage: ErrorHandler.handle(error),
        ),
      );
    }
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(status: SignupStatus.loading));

    try {
      final userId = await signupUseCase.call({
        'mobile': event.phone,
        'password': event.password,
      });

      if (userId.isNotEmpty) {
        emit(state.copyWith(status: SignupStatus.success));
      } else {
        emit(
          state.copyWith(
            status: SignupStatus.failure,
            errorMessage: 'Signup failed: Invalid response from server',
          ),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: SignupStatus.failure,
          errorMessage: ErrorHandler.handle(error),
        ),
      );
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:offgrid_nation_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:offgrid_nation_app/core/errors/error_handler.dart';
import 'events/reset_password_event.dart';
import 'states/reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ResetPasswordUseCase useCase;

  ResetPasswordBloc(this.useCase) : super(const ResetPasswordState()) {
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<VerifyPhoneResetPassword>(_onVerifyPhoneResetPasswordRequest);
    on<SubmitResetPassword>(_onSubmitResetPassword);
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ResetPasswordStatus.loading));
    try {
      final result = await useCase.forgotPasswordOTP(event.phone);
      final message = result['message'] ?? '';

      if (message.toString().contains('sent to mobile')) {
        emit(state.copyWith(status: ResetPasswordStatus.otpSent));
      } else if (message.toString().contains('not registered')) {
        emit(
          state.copyWith(
            status: ResetPasswordStatus.failure,
            errorMessage: 'Mobile not registered',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ResetPasswordStatus.failure,
            errorMessage: message.isNotEmpty ? message : 'Failed to send OTP.',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: ErrorHandler.handle(e),
        ),
      );
    }
  }

  Future<void> _onVerifyPhoneResetPasswordRequest(
    VerifyPhoneResetPassword event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ResetPasswordStatus.loading));
    try {
      final result = await useCase.verifyPhoneResetPassword(
        event.phone,
        event.otp,
      );
      final message = result['message'] ?? '';

      if (message.toString().contains('successfully')) {
        emit(state.copyWith(status: ResetPasswordStatus.otpVerified));
      } else if (message.toString().contains('Invalid')) {
        emit(
          state.copyWith(
            status: ResetPasswordStatus.failure,
            errorMessage: 'Invalid OTP',
          ),
        );
      } else if (message.toString().contains('not registered')) {
        emit(
          state.copyWith(
            status: ResetPasswordStatus.failure,
            errorMessage: 'Mobile not registered',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ResetPasswordStatus.failure,
            errorMessage:
                message.isNotEmpty ? message : 'Failed to Verify OTP.',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: ErrorHandler.handle(e),
        ),
      );
    }
  }

  Future<void> _onSubmitResetPassword(
    SubmitResetPassword event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ResetPasswordStatus.loading));
    try {
      final result = await useCase.resetPassword(
        phone: event.phone,
        newPassword: event.newPassword,
      );

      final message = result['message'] ?? '';

      if (message.toString().contains('successfully')) {
        emit(state.copyWith(status: ResetPasswordStatus.success));
      } else if (message.toString().contains('not registered')) {
        emit(
          state.copyWith(
            status: ResetPasswordStatus.failure,
            errorMessage: 'Mobile not registered',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ResetPasswordStatus.failure,
            errorMessage:
                message.isNotEmpty ? message : 'Failed to Verify OTP.',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.failure,
          errorMessage: ErrorHandler.handle(e),
        ),
      );
    }
  }
}

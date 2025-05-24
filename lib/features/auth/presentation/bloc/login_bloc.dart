import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart' show immutable;
import 'package:offgrid_nation_app/core/session/auth_session.dart';
import 'package:offgrid_nation_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:offgrid_nation_app/core/errors/error_handler.dart';
// import 'package:offgrid_nation_app/core/utils/hash_utils.dart';
import 'package:offgrid_nation_app/features/auth/domain/usecases/sign_in_with_google_usecase.dart'
    show SignInWithGoogleUseCase;
import 'package:offgrid_nation_app/injection_container.dart';

part 'events/login_event.dart';
part 'states/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  // final SignInWithAppleUseCase signInWithAppleUseCase;

  LoginBloc({
    required this.loginUseCase,
    required this.signInWithGoogleUseCase,
    // required this.signInWithAppleUseCase,
  }) : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<AppleLoginRequested>(_onAppleLoginRequested);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      // final hashedPassword = HashUtils.hashPassword(event.password);
      // final token = await loginUseCase.call(event.identifier, event.password);
      // emit(state.copyWith(status: LoginStatus.success, authKey: token));
      final user = await loginUseCase.call(event.identifier, event.password);

      await sl<AuthSession>().saveUserMeta(
        username: user['username'],
        fullName: user['fullName'],
        profilePicture: user['profilePicture'],
      );

      emit(state.copyWith(status: LoginStatus.success, authKey: user['token']));
    } catch (error) {
      final message = ErrorHandler.handle(error);
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: message));
    }
  }

  Future<void> _onAppleLoginRequested(
    AppleLoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    // TODO: Replace with actual Apple login use case.
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final authKey = await loginUseCase.call("appleUser", "dummyPassword");
      emit(
        state.copyWith(
          status: LoginStatus.success,
          authKey: authKey['token'] as String?,
        ),
      );
    } catch (error) {
      final message = ErrorHandler.handle(error);
      emit(state.copyWith(status: LoginStatus.failure, errorMessage: message));
    }
  }

  Future<void> _onGoogleLoginRequested(
    GoogleLoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      final authKey = await signInWithGoogleUseCase();
      emit(state.copyWith(status: LoginStatus.success, authKey: authKey));
    } catch (error, stackTrace) {
      print("authkey got from login error $error");
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: ErrorHandler.handle(error),
        ),
      );
      addError(error, stackTrace);
    }
  }
}

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/auth/send_reset_password_email_use_case.dart';
import '../../../models/bloc_status.dart';
import '../../../models/error.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  late final SendResetPasswordEmailUseCase _sendResetPasswordEmailUseCase;

  ResetPasswordBloc({
    required SendResetPasswordEmailUseCase sendResetPasswordEmailUseCase,
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
  }) : super(
          ResetPasswordState(
            status: status,
            email: email,
          ),
        ) {
    _sendResetPasswordEmailUseCase = sendResetPasswordEmailUseCase;
    on<ResetPasswordEventEmailChanged>(_emailChanged);
    on<ResetPasswordEventSubmit>(_submit);
  }

  void _emailChanged(
    ResetPasswordEventEmailChanged event,
    Emitter<ResetPasswordState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
    ));
  }

  Future<void> _submit(
    ResetPasswordEventSubmit event,
    Emitter<ResetPasswordState> emit,
  ) async {
    try {
      await _manageSendingResetPasswordEmail(emit);
    } on AuthError catch (authError) {
      _onAuthError(authError, emit);
    } on NetworkError catch (networkError) {
      _onNetworkError(networkError, emit);
    } on TimeoutException catch (_) {
      _onTimeoutException(emit);
    }
  }

  Future<void> _manageSendingResetPasswordEmail(
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    await _sendResetPasswordEmailUseCase
        .execute(email: state.email)
        .timeout(const Duration(seconds: 10));
    emit(state.copyWithInfo(
      ResetPasswordBlocInfo.emailHasBeenSent,
    ));
  }

  void _onAuthError(
    AuthError authError,
    Emitter<ResetPasswordState> emit,
  ) {
    if (authError.code == AuthErrorCode.invalidEmail.name) {
      emit(state.copyWithError(
        ResetPasswordBlocError.invalidEmail,
      ));
    } else if (authError.code == AuthErrorCode.userNotFound.name) {
      emit(state.copyWithError(
        ResetPasswordBlocError.userNotFound,
      ));
    }
  }

  void _onNetworkError(
    NetworkError networkError,
    Emitter<ResetPasswordState> emit,
  ) {
    if (networkError.code == NetworkErrorCode.lossOfConnection.name) {
      emit(state.copyWithError(
        ResetPasswordBlocError.lossOfConnection,
      ));
    }
  }

  void _onTimeoutException(Emitter<ResetPasswordState> emit) {
    emit(state.copyWithError(
      ResetPasswordBlocError.timeoutException,
    ));
  }
}

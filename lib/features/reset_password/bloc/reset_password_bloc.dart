import 'dart:async';

import 'package:app/config/errors.dart';
import 'package:app/domain/use_cases/auth/send_reset_password_email_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/custom_bloc.dart';
import 'package:app/models/error.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc
    extends CustomBloc<ResetPasswordEvent, ResetPasswordState> {
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
      await _tryToSendResetPasswordEmail(emit);
    } on AuthError catch (authError) {
      _manageAuthError(authError, emit);
    } on NetworkError catch (networkError) {
      _manageNetworkError(networkError, emit);
    } on TimeoutException catch (_) {
      emitTimeoutExceptionStatus(emit);
    }
  }

  Future<void> _tryToSendResetPasswordEmail(
    Emitter<ResetPasswordState> emit,
  ) async {
    emitLoadingStatus(emit);
    await _sendResetPasswordEmailUseCase
        .execute(email: state.email)
        .timeout(const Duration(seconds: 10));
    emitInfo<ResetPasswordBlocInfo>(
      emit,
      ResetPasswordBlocInfo.emailHasBeenSent,
    );
  }

  void _manageAuthError(
    AuthError authError,
    Emitter<ResetPasswordState> emit,
  ) {
    if (authError.code == AuthErrorCode.invalidEmail) {
      emitError<ResetPasswordBlocError>(
        emit,
        ResetPasswordBlocError.invalidEmail,
      );
    } else if (authError.code == AuthErrorCode.userNotFound) {
      emitError<ResetPasswordBlocError>(
        emit,
        ResetPasswordBlocError.userNotFound,
      );
    }
  }

  void _manageNetworkError(
    NetworkError networkError,
    Emitter<ResetPasswordState> emit,
  ) {
    if (networkError.code == NetworkErrorCode.lossOfConnection) {
      emitLossOfInternetConnectionStatus(emit);
    }
  }
}

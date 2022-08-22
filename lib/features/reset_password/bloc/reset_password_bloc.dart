import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/auth_error.dart';
import '../../../domain/use_cases/auth/send_reset_password_email_use_case.dart';
import '../../../models/bloc_status.dart';

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
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      await _sendResetPasswordEmailUseCase.execute(email: state.email);
      emit(state.copyWithInfo(
        ResetPasswordBlocInfo.emailHasBeenSent,
      ));
    } on AuthError catch (authError) {
      final ResetPasswordBlocError? blocError =
          _convertAuthErrorToResetPasswordBlocError(authError);
      if (blocError != null) {
        emit(state.copyWithError(
          blocError,
        ));
      }
    }
  }

  ResetPasswordBlocError? _convertAuthErrorToResetPasswordBlocError(
    AuthError authError,
  ) {
    if (authError == AuthError.invalidEmail) {
      return ResetPasswordBlocError.invalidEmail;
    } else if (authError == AuthError.userNotFound) {
      return ResetPasswordBlocError.userNotFound;
    }
    return null;
  }
}

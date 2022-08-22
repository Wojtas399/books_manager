import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/bloc_status.dart';

part 'reset_password_event.dart';

part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc({
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
  }) : super(
          ResetPasswordState(
            status: status,
            email: email,
          ),
        ) {
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
    emit(state.copyWithInfo(
      ResetPasswordBlocInfo.emailHasBeenSent,
    ));
  }
}

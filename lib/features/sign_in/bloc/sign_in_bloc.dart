import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/auth/get_logged_user_id_use_case.dart';
import '../../../domain/use_cases/auth/load_logged_user_id_use_case.dart';
import '../../../domain/use_cases/auth/sign_in_use_case.dart';
import '../../../models/bloc_state.dart';
import '../../../models/bloc_status.dart';
import '../../../models/error.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  late final LoadLoggedUserIdUseCase _loadLoggedUserIdUseCase;
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final SignInUseCase _signInUseCase;

  SignInBloc({
    required LoadLoggedUserIdUseCase loadLoggedUserIdUseCase,
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required SignInUseCase signInUseCase,
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
    String password = '',
  }) : super(
          SignInState(
            status: status,
            email: email,
            password: password,
          ),
        ) {
    _loadLoggedUserIdUseCase = loadLoggedUserIdUseCase;
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _signInUseCase = signInUseCase;
    on<SignInEventInitialize>(_initialize);
    on<SignInEventEmailChanged>(_emailChanged);
    on<SignInEventPasswordChanged>(_passwordChanged);
    on<SignInEventSubmit>(_submit);
    on<SignInEventCleanForm>(_cleanForm);
  }

  Future<void> _initialize(
    SignInEventInitialize event,
    Emitter<SignInState> emit,
  ) async {
    if (await _isUserSignedIn()) {
      emit(state.copyWithInfo(
        SignInBlocInfo.userHasBeenSignedIn,
      ));
    }
  }

  void _emailChanged(
    SignInEventEmailChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
    ));
  }

  void _passwordChanged(
    SignInEventPasswordChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
    ));
  }

  Future<void> _submit(
    SignInEventSubmit event,
    Emitter<SignInState> emit,
  ) async {
    try {
      await _signIn(emit);
    } on AuthError catch (authError) {
      _manageAuthError(authError, emit);
    } on NetworkError catch (networkError) {
      _manageNetworkError(networkError, emit);
    } on TimeoutException catch (_) {
      _manageTimeoutException(emit);
    }
  }

  void _cleanForm(
    SignInEventCleanForm event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(
      email: '',
      password: '',
    ));
  }

  Future<bool> _isUserSignedIn() async {
    await _loadLoggedUserIdUseCase.execute();
    final String? loggedUserId = await _getLoggedUserIdUseCase.execute().first;
    return loggedUserId != null;
  }

  Future<void> _signIn(Emitter<SignInState> emit) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    await _signInUseCase
        .execute(email: state.email, password: state.password)
        .timeout(const Duration(seconds: 10));
    emit(state.copyWithInfo(
      SignInBlocInfo.userHasBeenSignedIn,
    ));
  }

  void _manageAuthError(AuthError authError, Emitter<SignInState> emit) {
    if (authError.code == AuthErrorCode.invalidEmail.name) {
      emit(state.copyWithError(
        SignInBlocError.invalidEmail,
      ));
    } else if (authError.code == AuthErrorCode.wrongPassword.name) {
      emit(state.copyWithError(
        SignInBlocError.wrongPassword,
      ));
    } else if (authError.code == AuthErrorCode.userNotFound.name) {
      emit(state.copyWithError(
        SignInBlocError.userNotFound,
      ));
    }
  }

  void _manageNetworkError(
    NetworkError networkError,
    Emitter<SignInState> emit,
  ) {
    if (networkError.code == NetworkErrorCode.lossOfConnection.name) {
      emit(state.copyWith(
        status: const BlocStatusLossOfInternetConnection(),
      ));
    }
  }

  void _manageTimeoutException(Emitter<SignInState> emit) {
    emit(state.copyWith(
      status: const BlocStatusTimeoutException(),
    ));
  }
}

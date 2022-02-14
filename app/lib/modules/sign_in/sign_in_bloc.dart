import 'package:app/core/auth/auth_bloc.dart';
import 'package:app/models/operation_status.model.dart';
import 'package:app/models/http_result.model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/modules/sign_in/sign_in_actions.dart';
import 'package:app/modules/sign_in/sign_in_state.dart';

class SignInBloc extends Bloc<SignInAction, SignInState> {
  final AuthBloc authBloc;

  SignInBloc({required this.authBloc}) : super(SignInState());

  @override
  Stream<SignInState> mapEventToState(SignInAction event) async* {
    if (event is SignInEmailChanged) {
      yield _getStateWithUpdatedEmail(event.email);
    } else if (event is SignInPasswordChanged) {
      yield _getStateWithUpdatedPassword(event.password);
    } else if (event is SignInSubmitted) {
      yield state.copyWith(signInStatus: OperationLoading());
      Stream<OperationStatus> signInResult$ = _signIn(
        event.email.trim(),
        event.password.trim(),
      );
      await for (final value in signInResult$) {
        yield state.copyWith(signInStatus: value);
      }
    }
  }

  SignInState _getStateWithUpdatedEmail(String email) {
    return state.copyWith(email: email);
  }

  SignInState _getStateWithUpdatedPassword(String password) {
    return state.copyWith(password: password);
  }

  Stream<OperationStatus> _signIn(String email, String password) async* {
    Stream<HttpResult> httpResult$ = authBloc.signIn(
      email: email,
      password: password,
    );
    await for (final value in httpResult$) {
      if (value is HttpSuccess) {
        yield OperationSuccessful();
      } else {
        yield OperationFailed('Podano niepoprawny adres e-mail lub hasło...');
      }
    }
  }
}

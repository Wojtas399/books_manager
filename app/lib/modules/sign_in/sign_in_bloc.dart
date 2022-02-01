import 'package:app/core/auth/auth_bloc.dart';
import 'package:app/core/form_submission_status.dart';
import 'package:app/models/custom_exception.dart';
import 'package:app/models/operation_result.model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/modules/sign_in/sign_in_actions.dart';
import 'package:app/modules/sign_in/sign_in_state.dart';

class SignInBloc extends Bloc<SignInAction, SignInState> {
  final AuthBloc authBloc;

  SignInBloc({required this.authBloc}) : super(SignInState());

  @override
  Stream<SignInState> mapEventToState(SignInAction event) async* {
    if (event is SignInEmailChanged) {
      yield _emailChanged(event.email);
    } else if (event is SignInPasswordChanged) {
      yield _passwordChanged(event.password);
    } else if (event is SignInSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());
      yield await _signIn(event.email.trim(), event.password.trim()).first;
    }
  }

  SignInState _emailChanged(String email) {
    return state.copyWith(
      email: email,
      formStatus: InitialFormStatus(),
    );
  }

  SignInState _passwordChanged(String password) {
    return state.copyWith(
      password: password,
      formStatus: InitialFormStatus(),
    );
  }

  Stream<SignInState> _signIn(String email, String password) async* {
    Stream<HttpResult> signInResult$ = authBloc.signIn(
      email: email,
      password: password,
    );
    await for (final value in signInResult$) {
      if (value is HttpSuccess) {
        yield state.copyWith(formStatus: SubmissionSuccess());
      } else {
        yield state.copyWith(
          formStatus: SubmissionFailed(
            CustomException('Podano niepoprawny adres e-mail lub hasło...'),
          ),
        );
      }
    }
  }
}

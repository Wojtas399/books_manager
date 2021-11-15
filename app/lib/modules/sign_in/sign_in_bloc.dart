import 'package:app/repositories/auth/auth_interface.dart';
import 'package:app/core/form_submission_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/modules/sign_in/sign_in_event.dart';
import 'package:app/modules/sign_in/sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  AuthInterface authInterface;

  SignInBloc({required this.authInterface}) : super(SignInState());

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is SignInEmailChanged) {
      yield state.copyWith(
        username: event.email,
        formStatus: InitialFormStatus(),
      );
    } else if (event is SignInPasswordChanged) {
      yield state.copyWith(
        password: event.password,
        formStatus: InitialFormStatus(),
      );
    } else if (event is SignInSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());
      await authInterface.signIn(
        email: event.email.trim(),
        password: event.password.trim(),
      );
      yield state.copyWith(formStatus: SubmissionSuccess());
    }
  }
}

import 'package:app/modules/sign_in/sign_in_bloc.dart';
import 'package:app/modules/sign_in/sign_in_state.dart';
import 'package:app/repositories/auth/auth_interface.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/core/form_submission_status.dart';
import 'package:app/modules/sign_in/sign_in_event.dart';

import '../../core/user/user_bloc_test.dart';

void main() {
  AuthInterface authInterface = MockAuthInterface();
  late SignInBloc signInBloc;

  setUp(() {
    signInBloc = SignInBloc(authInterface: authInterface);
  });

  tearDown(() => reset(authInterface));

  blocTest<SignInBloc, SignInState>(
    'Should be InitialFormStatus on start',
    build: () => signInBloc,
    verify: (bloc) {
      expect(bloc.state.formStatus, isA<InitialFormStatus>());
    },
  );

  blocTest<SignInBloc, SignInState>(
    'Should be SubmissionSuccess on successfully signed in',
    build: () => signInBloc,
    act: (bloc) =>
        bloc.add(SignInSubmitted(email: 'email', password: 'password')),
    verify: (bloc) {
      expect(bloc.state.formStatus, isA<SubmissionSuccess>());
    },
  );
}

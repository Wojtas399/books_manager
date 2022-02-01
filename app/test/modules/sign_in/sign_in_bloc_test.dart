import 'package:app/core/auth/auth_bloc.dart';
import 'package:app/core/form_submission_status.dart';
import 'package:app/models/operation_result.model.dart';
import 'package:app/modules/sign_in/sign_in_actions.dart';
import 'package:app/modules/sign_in/sign_in_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  final AuthBloc authBloc = MockAuthBloc();
  late SignInBloc signInBloc;

  setUp(() {
    signInBloc = SignInBloc(authBloc: authBloc);
  });

  tearDown(() {
    reset(authBloc);
  });

  blocTest(
    'email changed',
    build: () => signInBloc,
    act: (SignInBloc bloc) {
      bloc.add(SignInEmailChanged(email: 'new email'));
    },
    verify: (SignInBloc bloc) {
      expect(bloc.state.email, 'new email');
    },
  );

  blocTest(
    'password changed',
    build: () => signInBloc,
    act: (SignInBloc bloc) {
      bloc.add(SignInPasswordChanged(password: 'new password'));
    },
    verify: (SignInBloc bloc) {
      expect(bloc.state.password, 'new password');
    },
  );

  blocTest(
    'sign in, success',
    build: () => signInBloc,
    setUp: () {
      when(
        () => authBloc.signIn(email: 'email', password: 'password'),
      ).thenAnswer((_) => Stream.value(HttpSuccess()));
    },
    act: (SignInBloc bloc) {
      bloc.add(SignInSubmitted(email: 'email', password: 'password'));
    },
    verify: (SignInBloc bloc) {
      verify(
        () => authBloc.signIn(email: 'email', password: 'password'),
      ).called(1);
      expect(bloc.state.formStatus, isA<SubmissionSuccess>());
    },
  );

  blocTest(
    'sign in, failure',
    build: () => signInBloc,
    setUp: () {
      when(
        () => authBloc.signIn(email: 'email', password: 'password'),
      ).thenAnswer((_) => Stream.value(HttpFailure()));
    },
    act: (SignInBloc bloc) {
      bloc.add(SignInSubmitted(email: 'email', password: 'password'));
    },
    verify: (SignInBloc bloc) {
      verify(
        () => authBloc.signIn(email: 'email', password: 'password'),
      ).called(1);
      expect(bloc.state.formStatus, isA<SubmissionFailed>());
    },
  );
}
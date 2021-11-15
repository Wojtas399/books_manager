import 'package:app/common/enum/avatar_type.dart';
import 'package:app/core/form_submission_status.dart';
import 'package:app/modules/sign_up/sign_up_bloc.dart';
import 'package:app/modules/sign_up/sign_up_event.dart';
import 'package:app/modules/sign_up/sing_up_state.dart';
import 'package:app/repositories/auth/auth_interface.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'sign_in_sign_up_mocks.dart';

void main() {
  group('SignUpBloc', () {
    AuthInterface authInterface = MockAuthInterface();
    late SignUpBloc signUpBloc;

    setUp(() {
      signUpBloc = SignUpBloc(authInterface: authInterface);
    });

    tearDown(() => reset(authInterface));

    group('formStatus', () {
      blocTest<SignUpBloc, SignUpState>(
        'Should be InitialFormStatus on start',
        build: () => signUpBloc,
        verify: (bloc) {
          expect(bloc.state.formStatus, isA<InitialFormStatus>());
        },
      );

      blocTest<SignUpBloc, SignUpState>(
        'Should be SubmissionSuccess on successfully signed up',
        build: () => signUpBloc,
        act: (bloc) => bloc.add(
          SignUpSubmitted(
              username: 'username',
              email: 'email',
              password: 'password',
              chosenAvatar: AvatarType.red,
              customAvatar: 'customAvatar'),
        ),
        verify: (bloc) {
          expect(bloc.state.formStatus, isA<SubmissionSuccess>());
        },
      );
    });

    group('avatars', () {
      blocTest<SignUpBloc, SignUpState>(
        'Should save red book avatar',
        build: () => signUpBloc,
        act: (bloc) => bloc.add(
          SignUpSubmitted(
              username: 'username',
              email: 'email',
              password: 'password',
              chosenAvatar: AvatarType.red,
              customAvatar: 'customAvatar'),
        ),
        verify: (bloc) {
          expect(bloc.state.formStatus, isA<SubmissionSuccess>());
        },
      );

      blocTest<SignUpBloc, SignUpState>(
        'Should save green book avatar',
        build: () => signUpBloc,
        act: (bloc) => bloc.add(
          SignUpSubmitted(
              username: 'username',
              email: 'email',
              password: 'password',
              chosenAvatar: AvatarType.green,
              customAvatar: 'customAvatar'),
        ),
        verify: (bloc) {
          expect(bloc.state.formStatus, isA<SubmissionSuccess>());
        },
      );

      blocTest<SignUpBloc, SignUpState>(
        'Should save blue book avatar',
        build: () => signUpBloc,
        act: (bloc) => bloc.add(
          SignUpSubmitted(
              username: 'username',
              email: 'email',
              password: 'password',
              chosenAvatar: AvatarType.blue,
              customAvatar: 'customAvatar'),
        ),
        verify: (bloc) {
          expect(bloc.state.formStatus, isA<SubmissionSuccess>());
        },
      );

      blocTest<SignUpBloc, SignUpState>(
        'Should save custom avatar',
        build: () => signUpBloc,
        act: (bloc) => bloc.add(
          SignUpSubmitted(
              username: 'username',
              email: 'email',
              password: 'password',
              chosenAvatar: AvatarType.custom,
              customAvatar: 'custom/avatar'),
        ),
        verify: (bloc) {
          expect(bloc.state.formStatus, isA<SubmissionSuccess>());
        },
      );
    });
  });
}

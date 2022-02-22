import 'package:app/core/auth/auth_bloc.dart';
import 'package:app/models/avatar_model.dart';
import 'package:app/models/http_result.model.dart';
import 'package:app/models/operation_status.model.dart';
import 'package:app/modules/sign_up/sign_up_bloc.dart';
import 'package:app/modules/sign_up/sign_up_event.dart';
import 'package:app/modules/sign_up/sing_up_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  final AuthBloc authBloc = MockAuthBloc();
  late SignUpBloc signUpBloc;

  setUp(() {
    signUpBloc = SignUpBloc(authBloc: authBloc);
  });

  tearDown(() {
    reset(authBloc);
  });

  blocTest(
    'username changed',
    build: () => signUpBloc,
    act: (SignUpBloc bloc) {
      bloc.add(SignUpUsernameChanged(username: 'username'));
    },
    verify: (SignUpBloc bloc) {
      expect(bloc.state.username, 'username');
    },
  );

  blocTest(
    'email changed',
    build: () => signUpBloc,
    act: (SignUpBloc bloc) {
      bloc.add(SignUpEmailChanged(email: 'email'));
    },
    verify: (SignUpBloc bloc) {
      expect(bloc.state.email, 'email');
    },
  );

  blocTest(
    'password changed',
    build: () => signUpBloc,
    act: (SignUpBloc bloc) {
      bloc.add(SignUpPasswordChanged(password: 'password123'));
    },
    verify: (SignUpBloc bloc) {
      expect(bloc.state.password, 'password123');
    },
  );

  blocTest(
    'password changed',
    build: () => signUpBloc,
    act: (SignUpBloc bloc) {
      bloc.add(SignUpPasswordChanged(password: 'password123'));
    },
    verify: (SignUpBloc bloc) {
      expect(bloc.state.password, 'password123');
    },
  );

  blocTest(
    'password confirmation changed',
    build: () => signUpBloc,
    act: (SignUpBloc bloc) {
      bloc.add(SignUpPasswordConfirmationChanged(passwordConfirmation: 'p123'));
    },
    verify: (SignUpBloc bloc) {
      expect(bloc.state.passwordConfirmation, 'p123');
    },
  );

  blocTest(
    'avatar type changed',
    build: () => signUpBloc,
    act: (SignUpBloc bloc) {
      bloc.add(SignUpAvatarTypeChanged(avatarType: AvatarType.blue));
    },
    verify: (SignUpBloc bloc) {
      expect(bloc.state.avatarType, AvatarType.blue);
    },
  );

  blocTest(
    'custom avatar path changed',
    build: () => signUpBloc,
    act: (SignUpBloc bloc) {
      bloc.add(SignUpCustomAvatarPathChanged(imagePath: 'image/path'));
    },
    verify: (SignUpBloc bloc) {
      expect(bloc.state.customAvatarPath, 'image/path');
    },
  );

  blocTest(
    'sign up, successful',
    build: () => signUpBloc,
    setUp: () {
      when(
        () => authBloc.signUp(
          username: 'username',
          email: 'email',
          password: 'password',
          avatar: CustomAvatar(imgFilePathFromDevice: 'custom/avatar/path'),
        ),
      ).thenAnswer((_) => Stream.value(HttpSuccess()));
    },
    act: (SignUpBloc bloc) {
      bloc.add(SignUpSubmitted(
        username: 'username',
        email: 'email',
        password: 'password',
        avatarType: AvatarType.custom,
        customAvatarPath: 'custom/avatar/path',
      ));
    },
    verify: (SignUpBloc bloc) {
      verify(
        () => authBloc.signUp(
          username: 'username',
          email: 'email',
          password: 'password',
          avatar: CustomAvatar(imgFilePathFromDevice: 'custom/avatar/path'),
        ),
      ).called(1);
      expect(bloc.state.signUpStatus, OperationSuccessful());
    },
  );

  blocTest(
    'sign up, failed',
    build: () => signUpBloc,
    setUp: () {
      when(
        () => authBloc.signUp(
          username: 'username',
          email: 'email',
          password: 'password',
          avatar: CustomAvatar(imgFilePathFromDevice: 'custom/avatar/path'),
        ),
      ).thenAnswer((_) => Stream.value(HttpFailure(message: 'Error!')));
    },
    act: (SignUpBloc bloc) {
      bloc.add(SignUpSubmitted(
        username: 'username',
        email: 'email',
        password: 'password',
        avatarType: AvatarType.custom,
        customAvatarPath: 'custom/avatar/path',
      ));
    },
    verify: (SignUpBloc bloc) {
      verify(
        () => authBloc.signUp(
          username: 'username',
          email: 'email',
          password: 'password',
          avatar: CustomAvatar(imgFilePathFromDevice: 'custom/avatar/path'),
        ),
      ).called(1);
      expect(bloc.state.signUpStatus, OperationFailed('Error!'));
    },
  );
}

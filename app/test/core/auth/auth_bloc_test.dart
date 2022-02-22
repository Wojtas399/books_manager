import 'package:app/core/auth/auth_bloc.dart';
import 'package:app/interfaces/auth_interface.dart';
import 'package:app/models/avatar_model.dart';
import 'package:app/models/http_result.model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

void main() {
  final AuthInterface authInterface = MockAuthInterface();
  late AuthBloc bloc;

  setUp(() {
    bloc = AuthBloc(authInterface: authInterface);
  });

  tearDown(() {
    reset(authInterface);
  });

  test('sign in, success', () async {
    when(
      () => authInterface.signIn(email: 'email', password: 'password'),
    ).thenAnswer((_) async => '');

    HttpResult result = await bloc
        .signIn(
          email: 'email',
          password: 'password',
        )
        .first;

    expect(result, HttpSuccess());
  });

  test('sign in, failure', () async {
    when(
      () => authInterface.signIn(email: 'email', password: 'password'),
    ).thenAnswer((_) async => throw 'Error!');

    HttpResult result = await bloc
        .signIn(
          email: 'email',
          password: 'password',
        )
        .first;

    expect(result, HttpFailure(message: 'Error!'));
  });

  test('sign up, success', () async {
    when(
      () => authInterface.signUp(
        username: 'username',
        email: 'email',
        password: 'password',
        avatar: StandardAvatarRed(),
      ),
    ).thenAnswer((_) async => '');

    HttpResult result = await bloc
        .signUp(
          username: 'username',
          email: 'email',
          password: 'password',
          avatar: StandardAvatarRed(),
        )
        .first;

    expect(result, HttpSuccess());
  });

  test('sign up, failure', () async {
    when(
      () => authInterface.signUp(
        username: 'username',
        email: 'email',
        password: 'password',
        avatar: StandardAvatarRed(),
      ),
    ).thenAnswer((_) async => throw 'Error!');

    HttpResult result = await bloc
        .signUp(
          username: 'username',
          email: 'email',
          password: 'password',
          avatar: StandardAvatarRed(),
        )
        .first;

    expect(result, HttpFailure(message: 'Error!'));
  });

  test('sign out', () async {
    when(() => authInterface.logOut()).thenAnswer((_) async => '');

    await bloc.signOut();

    verify(() => authInterface.logOut()).called(1);
  });
}

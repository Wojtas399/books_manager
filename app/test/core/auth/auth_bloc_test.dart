import 'package:app/core/auth/auth_bloc.dart';
import 'package:app/models/http_result.model.dart';
import 'package:app/repositories/auth/auth_interface.dart';
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

    HttpResult result =
        await bloc.signIn(email: 'email', password: 'password').first;

    expect(result, HttpSuccess());
  });

  test('sign in, failure', () async {
    when(
      () => authInterface.signIn(email: 'email', password: 'password'),
    ).thenAnswer((_) async => throw 'Error!');

    HttpResult result =
        await bloc.signIn(email: 'email', password: 'password').first;

    expect(result, HttpFailure(message: 'Error!'));
  });

  test('sign up, success', () async {
    when(
      () => authInterface.signUp(
        username: 'username',
        email: 'email',
        password: 'password',
        avatar: 'avatar',
      ),
    ).thenAnswer((_) async => '');

    HttpResult result = await bloc
        .signUp(
          username: 'username',
          email: 'email',
          password: 'password',
          avatarPath: 'avatar',
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
        avatar: 'avatar',
      ),
    ).thenAnswer((_) async => throw 'Error!');

    HttpResult result = await bloc
        .signUp(
          username: 'username',
          email: 'email',
          password: 'password',
          avatarPath: 'avatar',
        )
        .first;

    expect(result, HttpFailure(message: 'Error!'));
  });
}

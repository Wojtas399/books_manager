import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:app/domain/entities/auth_error.dart';
import 'package:app/domain/repositories/auth_repository.dart';
import 'package:app/firebase/services/fire_auth_service.dart';

class MockFireAuthService extends Mock implements FireAuthService {}

void main() {
  final fireAuthService = MockFireAuthService();
  late AuthRepository repository;

  setUp(() {
    repository = AuthRepository(fireAuthService: fireAuthService);
  });

  tearDown(() {
    reset(fireAuthService);
  });

  test(
    'is user signed in, should return stream which contains user login status',
    () async {
      const bool expectedValue = true;
      when(
        () => fireAuthService.isUserSignedIn,
      ).thenAnswer((_) => Stream.value(expectedValue));

      final Stream<bool> isUserSignedIn$ = repository.isUserSignedIn$;

      expect(
        await isUserSignedIn$.first,
        expectedValue,
      );
    },
  );

  test(
    'sign in, should call method responsible for signing in user',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      when(
        () => fireAuthService.signIn(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => '');

      await repository.signIn(email: email, password: password);

      verify(
        () => fireAuthService.signIn(
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );

  test(
    'sign in, should throw appropriate auth error if email is invalid',
    () async {
      const String email = 'email.com';
      const String password = 'password123';
      when(
        () => fireAuthService.signIn(
          email: email,
          password: password,
        ),
      ).thenThrow(FirebaseAuthException(code: 'invalid-email'));

      try {
        await repository.signIn(email: email, password: password);
      } on AuthError catch (error) {
        expect(error, AuthError.invalidEmail);
      }
    },
  );

  test(
    'sign in, should throw appropriate auth error if password is invalid',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      when(
        () => fireAuthService.signIn(
          email: email,
          password: password,
        ),
      ).thenThrow(FirebaseAuthException(code: 'invalid-password'));

      try {
        await repository.signIn(email: email, password: password);
      } on AuthError catch (error) {
        expect(error, AuthError.invalidPassword);
      }
    },
  );

  test(
    'sign in, should throw appropriate auth error if user has not been found',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      when(
        () => fireAuthService.signIn(
          email: email,
          password: password,
        ),
      ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      try {
        await repository.signIn(email: email, password: password);
      } on AuthError catch (error) {
        expect(error, AuthError.userNotFound);
      }
    },
  );
}

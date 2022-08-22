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
    'sign in, should throw appropriate auth error if password is wrong',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      when(
        () => fireAuthService.signIn(
          email: email,
          password: password,
        ),
      ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      try {
        await repository.signIn(email: email, password: password);
      } on AuthError catch (error) {
        expect(error, AuthError.wrongPassword);
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

  test(
    'sign up, should call method responsible for signing up user',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      when(
        () => fireAuthService.signUp(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => '');

      await repository.signUp(email: email, password: password);

      verify(
        () => fireAuthService.signUp(
          email: email,
          password: password,
        ),
      ).called(1);
    },
  );

  test(
    'sign up, should throw appropriate auth error if email is already in use',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      when(
        () => fireAuthService.signUp(
          email: email,
          password: password,
        ),
      ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      try {
        await repository.signUp(email: email, password: password);
      } on AuthError catch (error) {
        expect(error, AuthError.emailAlreadyInUse);
      }
    },
  );

  test(
    'send password reset email, should call method responsible for sending password reset email',
    () async {
      const String email = 'email@example.com';
      when(
        () => fireAuthService.sendPasswordResetEmail(email: email),
      ).thenAnswer((_) async => '');

      await repository.sendPasswordResetEmail(email: email);

      verify(
        () => fireAuthService.sendPasswordResetEmail(email: email),
      ).called(1);
    },
  );

  test(
    'send reset password email, should throw auth error if email is invalid',
    () async {
      const String email = 'email';
      when(
        () => fireAuthService.sendPasswordResetEmail(email: email),
      ).thenThrow(FirebaseAuthException(code: 'invalid-email'));

      try {
        await repository.sendPasswordResetEmail(email: email);
      } on AuthError catch (error) {
        expect(error, AuthError.invalidEmail);
      }
    },
  );

  test(
    'send reset password email, should throw auth error if user has not been found',
    () async {
      const String email = 'email';
      when(
        () => fireAuthService.sendPasswordResetEmail(email: email),
      ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      try {
        await repository.sendPasswordResetEmail(email: email);
      } on AuthError catch (error) {
        expect(error, AuthError.userNotFound);
      }
    },
  );
}

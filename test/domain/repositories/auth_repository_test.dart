import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:app/database/firebase/services/fire_auth_service.dart';
import 'package:app/database/shared_preferences/shared_preferences_service.dart';
import 'package:app/domain/entities/auth_state.dart';
import 'package:app/domain/entities/auth_error.dart';
import 'package:app/domain/repositories/auth_repository.dart';

class MockFireAuthService extends Mock implements FireAuthService {}

class MockSharedPreferencesService extends Mock
    implements SharedPreferencesService {}

void main() {
  final fireAuthService = MockFireAuthService();
  final sharedPreferencesService = MockSharedPreferencesService();
  late AuthRepository repository;

  setUp(() {
    repository = AuthRepository(
      fireAuthService: fireAuthService,
      sharedPreferencesService: sharedPreferencesService,
    );
  });

  tearDown(() {
    reset(fireAuthService);
    reset(sharedPreferencesService);
  });

  test(
    'auth state, should return stream with auth state set to signed in if loaded user id is not null',
    () async {
      when(
        () => sharedPreferencesService.loadLoggedUserId(),
      ).thenAnswer((_) async => 'userId');

      final Stream<AuthState> authState$ = repository.authState$;

      expect(await authState$.first, AuthState.signedIn);
    },
  );

  test(
    'auth state, should return stream with auth state set to signed out if loaded user id is null',
    () async {
      when(
        () => sharedPreferencesService.loadLoggedUserId(),
      ).thenAnswer((_) async => null);

      final Stream<AuthState> authState$ = repository.authState$;

      expect(await authState$.first, AuthState.signedOut);
    },
  );

  test(
    'sign in, should call methods responsible for signing in user and for saving logged user id in shared preferences',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      const String loggedUserId = 'userId';
      when(
        () => fireAuthService.signIn(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => loggedUserId);
      when(
        () => sharedPreferencesService.saveLoggedUserId(
          loggedUserId: loggedUserId,
        ),
      ).thenAnswer((_) async => '');

      await repository.signIn(email: email, password: password);

      verify(
        () => fireAuthService.signIn(
          email: email,
          password: password,
        ),
      ).called(1);
      verify(
        () => sharedPreferencesService.saveLoggedUserId(
          loggedUserId: loggedUserId,
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
    'sign up, should call methods responsible for signing up user and for saving logged user id in shared preferences',
    () async {
      const String email = 'email@example.com';
      const String password = 'password123';
      const String loggedUserId = 'userId';
      when(
        () => fireAuthService.signUp(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => loggedUserId);
      when(
        () => sharedPreferencesService.saveLoggedUserId(
          loggedUserId: loggedUserId,
        ),
      ).thenAnswer((_) async => '');

      await repository.signUp(email: email, password: password);

      verify(
        () => fireAuthService.signUp(
          email: email,
          password: password,
        ),
      ).called(1);
      verify(
        () => sharedPreferencesService.saveLoggedUserId(
          loggedUserId: loggedUserId,
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

  test(
    'sign out, should call methods responsible for signing out user and for removing user id from shared preferences',
    () async {
      when(
        () => fireAuthService.signOut(),
      ).thenAnswer((_) async => '');
      when(
        () => sharedPreferencesService.removeLoggedUserId(),
      ).thenAnswer((_) async => '');

      await repository.signOut();

      verify(
        () => fireAuthService.signOut(),
      ).called(1);
      verify(
        () => sharedPreferencesService.removeLoggedUserId(),
      ).called(1);
    },
  );

  test(
    'delete logged user, should call methods responsible for deleting user and for removing user id from shared preferences',
    () async {
      const String password = 'password';
      when(
        () => fireAuthService.deleteLoggedUser(password: password),
      ).thenAnswer((_) async => '');
      when(
        () => sharedPreferencesService.removeLoggedUserId(),
      ).thenAnswer((_) async => '');

      await repository.deleteLoggedUser(password: password);

      verify(
        () => fireAuthService.deleteLoggedUser(password: password),
      ).called(1);
      verify(
        () => sharedPreferencesService.removeLoggedUserId(),
      ).called(1);
    },
  );

  test(
    'delete logged user, should throw auth error if password is wrong',
    () async {
      const String password = 'password';
      when(
        () => fireAuthService.deleteLoggedUser(password: password),
      ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      try {
        await repository.deleteLoggedUser(password: password);
      } on AuthError catch (error) {
        expect(error, AuthError.wrongPassword);
      }
    },
  );
}

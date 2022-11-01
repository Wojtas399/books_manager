import 'package:app/config/errors.dart';
import 'package:app/data/repositories/auth_repository.dart';
import 'package:app/models/error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/data/data_sources/mock_auth_data_source.dart';

void main() {
  final authDataSource = MockAuthDataSource();
  late AuthRepository repository;

  setUp(() {
    repository = AuthRepository(
      authDataSource: authDataSource,
    );
  });

  tearDown(() {
    reset(authDataSource);
  });

  test(
    'logged user id, should return result of method from data source responsible for getting logged user id',
    () async {
      const String expectedLoggedUserId = 'u1';
      authDataSource.mockGetLoggedUserId(loggedUserId: expectedLoggedUserId);

      final Stream<String?> loggedUserId$ = repository.loggedUserId$;

      expect(await loggedUserId$.first, expectedLoggedUserId);
    },
  );

  group(
    'sign in',
    () {
      const String email = 'email@example.com';
      const String password = 'password123';

      Future<void> methodCall() async {
        await repository.signIn(email: email, password: password);
      }

      test(
        'should call method from data source responsible for signing in user',
        () async {
          authDataSource.mockSignIn();

          await methodCall();

          verify(
            () => authDataSource.signIn(email: email, password: password),
          ).called(1);
        },
      );

      test(
        'should throw appropriate auth error if email is invalid',
        () async {
          authDataSource.mockSignIn(
            throwable: FirebaseAuthException(code: 'invalid-email'),
          );

          AuthError? authError;
          try {
            await methodCall();
          } on AuthError catch (error) {
            authError = error;
          }

          expect(
            authError,
            const AuthError(code: AuthErrorCode.invalidEmail),
          );
        },
      );

      test(
        'should throw appropriate auth error if password is wrong',
        () async {
          authDataSource.mockSignIn(
            throwable: FirebaseAuthException(code: 'wrong-password'),
          );

          AuthError? authError;
          try {
            await methodCall();
          } on AuthError catch (error) {
            authError = error;
          }

          expect(
            authError,
            const AuthError(code: AuthErrorCode.wrongPassword),
          );
        },
      );

      test(
        'should throw appropriate auth error if user has not been found',
        () async {
          authDataSource.mockSignIn(
            throwable: FirebaseAuthException(code: 'user-not-found'),
          );

          AuthError? authError;
          try {
            await methodCall();
          } on AuthError catch (error) {
            authError = error;
          }

          expect(
            authError,
            const AuthError(code: AuthErrorCode.userNotFound),
          );
        },
      );

      test(
        'should throw appropriate network error if network connection has been lost',
        () async {
          authDataSource.mockSignIn(
            throwable: FirebaseAuthException(code: 'network-request-failed'),
          );

          NetworkError? networkError;
          try {
            await methodCall();
          } on NetworkError catch (error) {
            networkError = error;
          }

          expect(
            networkError,
            const NetworkError(code: NetworkErrorCode.lossOfConnection),
          );
        },
      );
    },
  );

  group(
    'sign up',
    () {
      const String email = 'email@example.com';
      const String password = 'password123';
      const String signedUpUserId = 'u1';

      Future<String> methodCall() async {
        return await repository.signUp(email: email, password: password);
      }

      test(
        'should call method from data source responsible for signing up user and should return signed up user id',
        () async {
          const String signedUpUserId = 'u1';
          authDataSource.mockSignUp(signedUpUserId: signedUpUserId);

          final String userId = await methodCall();

          verify(
            () => authDataSource.signUp(email: email, password: password),
          ).called(1);
          expect(userId, signedUpUserId);
        },
      );

      test(
        'should throw appropriate auth error if email is already in use',
        () async {
          authDataSource.mockSignUp(
            signedUpUserId: signedUpUserId,
            throwable: FirebaseAuthException(code: 'email-already-in-use'),
          );

          AuthError? authError;
          try {
            await methodCall();
          } on AuthError catch (error) {
            authError = error;
          }

          expect(
            authError,
            const AuthError(code: AuthErrorCode.emailAlreadyInUse),
          );
        },
      );
    },
  );

  group(
    'send password reset email',
    () {
      const String email = 'email@example.com';

      Future<void> methodCall() async {
        await repository.sendPasswordResetEmail(email: email);
      }

      test(
        'should call method from data source responsible for sending password reset email',
        () async {
          authDataSource.mockSendPasswordResetEmail();

          await methodCall();

          verify(
            () => authDataSource.sendPasswordResetEmail(email: email),
          ).called(1);
        },
      );

      test(
        'should throw auth error if email is invalid',
        () async {
          authDataSource.mockSendPasswordResetEmail(
            throwable: FirebaseAuthException(code: 'invalid-email'),
          );

          AuthError? authError;
          try {
            await methodCall();
          } on AuthError catch (error) {
            authError = error;
          }

          expect(
            authError,
            const AuthError(code: AuthErrorCode.invalidEmail),
          );
        },
      );

      test(
        'should throw auth error if user has not been found',
        () async {
          authDataSource.mockSendPasswordResetEmail(
            throwable: FirebaseAuthException(code: 'user-not-found'),
          );

          AuthError? authError;
          try {
            await methodCall();
          } on AuthError catch (error) {
            authError = error;
          }

          expect(
            authError,
            const AuthError(code: AuthErrorCode.userNotFound),
          );
        },
      );
    },
  );

  test(
    'check logged user password correctness, should return result of method from data source responsible for checking logged user password correctness',
    () async {
      const bool expectedValue = false;
      authDataSource.mockCheckLoggedUserPasswordCorrectness(
        isPasswordCorrect: expectedValue,
      );

      final bool isPasswordCorrect = await repository
          .checkLoggedUserPasswordCorrectness(password: 'password');

      expect(isPasswordCorrect, expectedValue);
    },
  );

  group(
    'change logged user password',
    () {
      const String currentPassword = 'currentPassword';
      const String newPassword = 'newPassword';

      Future<void> methodCall() async {
        await repository.changeLoggedUserPassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
      }

      test(
        'should call method from data source responsible for changing logged user password',
        () async {
          authDataSource.mockChangeLoggedUserPassword();

          await methodCall();

          verify(
            () => authDataSource.changeLoggedUserPassword(
              currentPassword: currentPassword,
              newPassword: newPassword,
            ),
          ).called(1);
        },
      );

      test(
        'should throw auth error if current password is wrong',
        () async {
          authDataSource.mockChangeLoggedUserPassword(
            throwable: FirebaseAuthException(code: 'wrong-password'),
          );

          AuthError? authError;
          try {
            await methodCall();
          } on AuthError catch (error) {
            authError = error;
          }

          expect(
            authError,
            const AuthError(code: AuthErrorCode.wrongPassword),
          );
        },
      );
    },
  );

  test(
    'sign out, should call method from data source responsible for signing out user',
    () async {
      authDataSource.mockSignOut();

      await repository.signOut();

      verify(
        () => authDataSource.signOut(),
      ).called(1);
    },
  );

  group(
    'delete logged user',
    () {
      const String password = 'password';

      Future<void> methodCall() async {
        await repository.deleteLoggedUser(password: password);
      }

      test(
        'should call method from data source responsible for deleting user',
        () async {
          authDataSource.mockDeleteLoggedUser();

          await methodCall();

          verify(
            () => authDataSource.deleteLoggedUser(password: password),
          ).called(1);
        },
      );

      test(
        'delete logged user, should throw auth error if password is wrong',
        () async {
          authDataSource.mockDeleteLoggedUser(
            throwable: FirebaseAuthException(code: 'wrong-password'),
          );

          AuthError? authError;
          try {
            await methodCall();
          } on AuthError catch (error) {
            authError = error;
          }

          expect(
            authError,
            const AuthError(code: AuthErrorCode.wrongPassword),
          );
        },
      );
    },
  );
}

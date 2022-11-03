import 'package:app/config/errors.dart';
import 'package:app/data/data_sources/auth_data_source.dart';
import 'package:app/models/error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/firebase/mock_firebase_auth_service.dart';

void main() {
  final firebaseAuthService = MockFirebaseAuthService();
  late AuthDataSource dataSource;

  setUp(() {
    dataSource = AuthDataSource(firebaseAuthService: firebaseAuthService);
  });

  tearDown(() {
    reset(firebaseAuthService);
  });

  test(
    'get logged user id, should return result of method responsible for getting logged user id from firebase auth',
    () async {
      const String expectedLoggedUserId = 'u1';
      firebaseAuthService.mockGetLoggedUserId(
        loggedUserId: expectedLoggedUserId,
      );

      final Stream<String?> loggedUserId$ = dataSource.loggedUserId$;

      expect(await loggedUserId$.first, expectedLoggedUserId);
    },
  );

  group(
    'sign in',
    () {
      const String email = 'email@example.com';
      const String password = 'password123';

      Future<void> methodCall() async {
        await dataSource.signIn(email: email, password: password);
      }

      test(
        'should call method from firebase auth responsible for signing in user',
        () async {
          firebaseAuthService.mockSignIn();

          await methodCall();

          verify(
            () => firebaseAuthService.signIn(email: email, password: password),
          ).called(1);
        },
      );

      test(
        'should throw appropriate auth error if email is invalid',
        () async {
          firebaseAuthService.mockSignIn(
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
          firebaseAuthService.mockSignIn(
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
          firebaseAuthService.mockSignIn(
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
          firebaseAuthService.mockSignIn(
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
        return await dataSource.signUp(email: email, password: password);
      }

      test(
        'should call method from firebase auth responsible for signing up user and should return signed up user id',
        () async {
          const String signedUpUserId = 'u1';
          firebaseAuthService.mockSignUp(signedUpUserId: signedUpUserId);

          final String userId = await methodCall();

          verify(
            () => firebaseAuthService.signUp(email: email, password: password),
          ).called(1);
          expect(userId, signedUpUserId);
        },
      );

      test(
        'should throw appropriate auth error if email is already in use',
        () async {
          firebaseAuthService.mockSignUp(
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
        await dataSource.sendPasswordResetEmail(email: email);
      }

      test(
        'should call method from firebase auth responsible for sending password reset email',
        () async {
          firebaseAuthService.mockSendPasswordResetEmail();

          await methodCall();

          verify(
            () => firebaseAuthService.sendPasswordResetEmail(email: email),
          ).called(1);
        },
      );

      test(
        'should throw auth error if email is invalid',
        () async {
          firebaseAuthService.mockSendPasswordResetEmail(
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
          firebaseAuthService.mockSendPasswordResetEmail(
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

  group(
    'check logged user password correctness',
    () {
      const String password = 'password';

      test(
        'should return true if firebase auth method responsible for reauthentication does not throw error',
        () async {
          firebaseAuthService.mockReauthenticateLoggedUserWithPassword();

          final bool isCorrect = await dataSource
              .checkLoggedUserPasswordCorrectness(password: password);

          expect(isCorrect, true);
        },
      );

      test(
        'should return false if firebase auth method responsible for reauthentication throw wrong password error',
        () async {
          when(
            () => firebaseAuthService.reauthenticateLoggedUserWithPassword(
              password: password,
            ),
          ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

          final bool isCorrect = await dataSource
              .checkLoggedUserPasswordCorrectness(password: password);

          expect(isCorrect, false);
        },
      );

      test(
        'should rethrow error if firebase auth method responsible for reauthentication throw error different than wrong password',
        () async {
          when(
            () => firebaseAuthService.reauthenticateLoggedUserWithPassword(
              password: password,
            ),
          ).thenThrow(FirebaseAuthException(code: 'unknown'));

          try {
            await dataSource.checkLoggedUserPasswordCorrectness(
              password: password,
            );
          } on FirebaseAuthException catch (authException) {
            expect(
              authException,
              FirebaseAuthException(code: 'unknown'),
            );
          }
        },
      );
    },
  );

  group(
    'change logged user password',
    () {
      const String currentPassword = 'currentPassword';
      const String newPassword = 'newPassword';

      Future<void> methodCall() async {
        await dataSource.changeLoggedUserPassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
      }

      test(
        'should call method from firebase auth responsible for changing logged user password',
        () async {
          firebaseAuthService.mockChangeLoggedUserPassword();

          await methodCall();

          verify(
            () => firebaseAuthService.changeLoggedUserPassword(
              currentPassword: currentPassword,
              newPassword: newPassword,
            ),
          ).called(1);
        },
      );

      test(
        'should throw auth error if current password is wrong',
        () async {
          firebaseAuthService.mockChangeLoggedUserPassword(
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
    'sign out, should call method from firebase auth responsible for signing out user',
    () async {
      firebaseAuthService.mockSignOut();

      await dataSource.signOut();

      verify(
        () => firebaseAuthService.signOut(),
      ).called(1);
    },
  );

  group(
    'delete logged user',
    () {
      const String password = 'password';

      Future<void> methodCall() async {
        await dataSource.deleteLoggedUser(password: password);
      }

      test(
        'should call method from firebase auth responsible for deleting user',
        () async {
          firebaseAuthService.mockDeleteLoggedUser();

          await methodCall();

          verify(
            () => firebaseAuthService.deleteLoggedUser(password: password),
          ).called(1);
        },
      );

      test(
        'should throw auth error if password is wrong',
        () async {
          firebaseAuthService.mockDeleteLoggedUser(
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

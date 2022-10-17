import 'package:app/config/errors.dart';
import 'package:app/data/repositories/auth_repository.dart';
import 'package:app/models/error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/local_db/mock_auth_local_db_service.dart';
import '../../mocks/remote_db/mock_auth_remote_db_service.dart';

void main() {
  final authLocalDbService = MockAuthLocalDbService();
  final authRemoteDbService = MockAuthRemoteDbService();
  late AuthRepository repository;

  setUp(() {
    repository = AuthRepository(
      authLocalDbService: authLocalDbService,
      authRemoteDbService: authRemoteDbService,
    );
  });

  tearDown(() {
    reset(authLocalDbService);
    reset(authRemoteDbService);
  });

  test(
    'load logged user id, should load id of logged user from local db and assign it to stream',
    () async {
      const String loggedUserId = 'userId';
      authLocalDbService.mockLoadLoggedUserId(loggedUserId: loggedUserId);

      await repository.loadLoggedUserId();
      final Stream<String?> loggedUserId$ = repository.loggedUserId$;

      expect(await loggedUserId$.first, loggedUserId);
    },
  );

  group(
    'sign in',
    () {
      const String email = 'email@example.com';
      const String password = 'password123';

      test(
        'should call methods responsible for signing in user in remote db, for saving logged user id in local db and should return signed in user id',
        () async {
          const String signedInUserId = 'u1';
          authRemoteDbService.mockSignIn(signedInUserId: signedInUserId);
          authLocalDbService.mockSaveLoggedUserId();

          final String userId = await repository.signIn(
            email: email,
            password: password,
          );

          verify(
            () => authRemoteDbService.signIn(email: email, password: password),
          ).called(1);
          verify(
            () => authLocalDbService.saveLoggedUserId(
              loggedUserId: signedInUserId,
            ),
          ).called(1);
          expect(userId, signedInUserId);
        },
      );

      test(
        'should throw appropriate auth error if email is invalid',
        () async {
          when(
            () => authRemoteDbService.signIn(email: email, password: password),
          ).thenThrow(FirebaseAuthException(code: 'invalid-email'));

          AuthError? authError;
          try {
            await repository.signIn(email: email, password: password);
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
          when(
            () => authRemoteDbService.signIn(email: email, password: password),
          ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

          AuthError? authError;
          try {
            await repository.signIn(email: email, password: password);
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
          when(
            () => authRemoteDbService.signIn(email: email, password: password),
          ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

          AuthError? authError;
          try {
            await repository.signIn(email: email, password: password);
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
          when(
            () => authRemoteDbService.signIn(email: email, password: password),
          ).thenThrow(FirebaseAuthException(code: 'network-request-failed'));

          NetworkError? networkError;
          try {
            await repository.signIn(email: email, password: password);
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

      test(
        'should call methods responsible for signing up user in remote db, for saving logged user id in local db and should return signed up user id',
        () async {
          const String signedUpUserId = 'u1';
          authRemoteDbService.mockSignUp(signedUpUserId: signedUpUserId);
          authLocalDbService.mockSaveLoggedUserId();

          final String userId = await repository.signUp(
            email: email,
            password: password,
          );

          verify(
            () => authRemoteDbService.signUp(email: email, password: password),
          ).called(1);
          verify(
            () => authLocalDbService.saveLoggedUserId(
              loggedUserId: signedUpUserId,
            ),
          ).called(1);
          expect(userId, signedUpUserId);
        },
      );

      test(
        'should throw appropriate auth error if email is already in use',
        () async {
          when(
            () => authRemoteDbService.signUp(email: email, password: password),
          ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

          AuthError? authError;
          try {
            await repository.signUp(email: email, password: password);
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

      test(
        'should call method from remote db responsible for sending password reset email',
        () async {
          authRemoteDbService.mockSendPasswordResetEmail();

          await repository.sendPasswordResetEmail(email: email);

          verify(
            () => authRemoteDbService.sendPasswordResetEmail(email: email),
          ).called(1);
        },
      );

      test(
        'should throw auth error if email is invalid',
        () async {
          when(
            () => authRemoteDbService.sendPasswordResetEmail(email: email),
          ).thenThrow(FirebaseAuthException(code: 'invalid-email'));

          AuthError? authError;
          try {
            await repository.sendPasswordResetEmail(email: email);
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
          when(
            () => authRemoteDbService.sendPasswordResetEmail(email: email),
          ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

          AuthError? authError;
          try {
            await repository.sendPasswordResetEmail(email: email);
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
    'check logged user password correctness, should return result of method from remote db responsible for checking logged user password correctness',
    () async {
      const bool expectedValue = false;
      authRemoteDbService.mockCheckLoggedUserPasswordCorrectness(
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

      test(
        'should call method from remote db responsible for changing logged user password',
        () async {
          authRemoteDbService.mockChangeLoggedUserPassword();

          await repository.changeLoggedUserPassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
          );

          verify(
            () => authRemoteDbService.changeLoggedUserPassword(
              currentPassword: currentPassword,
              newPassword: newPassword,
            ),
          ).called(1);
        },
      );

      test(
        'should throw auth error if current password is wrong',
        () async {
          authRemoteDbService.mockChangeLoggedUserPassword(
            throwable: FirebaseAuthException(code: 'wrong-password'),
          );

          AuthError? authError;
          try {
            await repository.changeLoggedUserPassword(
              currentPassword: currentPassword,
              newPassword: newPassword,
            );
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
    'sign out, should call methods responsible for signing out user from remote db and for removing user id from local db',
    () async {
      authRemoteDbService.mockSignOut();
      authLocalDbService.mockRemoveLoggedUserId();

      await repository.signOut();

      verify(
        () => authRemoteDbService.signOut(),
      ).called(1);
      verify(
        () => authLocalDbService.removeLoggedUserId(),
      ).called(1);
      expect(await repository.loggedUserId$.first, null);
    },
  );

  test(
    'delete logged user, should call methods responsible for deleting user from remote db and for removing user id from local db',
    () async {
      const String password = 'password';
      authRemoteDbService.mockDeleteLoggedUser();
      authLocalDbService.mockRemoveLoggedUserId();

      await repository.deleteLoggedUser(password: password);

      verify(
        () => authRemoteDbService.deleteLoggedUser(password: password),
      ).called(1);
      verify(
        () => authLocalDbService.removeLoggedUserId(),
      ).called(1);
    },
  );

  test(
    'delete logged user, should throw auth error if password is wrong',
    () async {
      const String password = 'password';
      when(
        () => authRemoteDbService.deleteLoggedUser(password: password),
      ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      AuthError? authError;
      try {
        await repository.deleteLoggedUser(password: password);
      } on AuthError catch (error) {
        authError = error;
      }

      expect(
        authError,
        const AuthError(code: AuthErrorCode.wrongPassword),
      );
    },
  );
}

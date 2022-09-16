import 'package:app/config/errors.dart';
import 'package:app/data/data_sources/local_db/auth_local_db_service.dart';
import 'package:app/data/data_sources/remote_db/auth_remote_db_service.dart';
import 'package:app/data/repositories/auth_repository.dart';
import 'package:app/models/error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthLocalDbService extends Mock implements AuthLocalDbService {}

class MockAuthRemoteDbService extends Mock implements AuthRemoteDbService {}

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
      when(
        () => authLocalDbService.loadLoggedUserId(),
      ).thenAnswer((_) async => loggedUserId);

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
        'should call methods responsible for signing in user in remote db and for saving logged user id in local db',
        () async {
          const String loggedUserId = 'userId';
          when(
            () => authRemoteDbService.signIn(email: email, password: password),
          ).thenAnswer((_) async => loggedUserId);
          when(
            () => authLocalDbService.saveLoggedUserId(
              loggedUserId: loggedUserId,
            ),
          ).thenAnswer((_) async => '');

          await repository.signIn(email: email, password: password);

          verify(
            () => authRemoteDbService.signIn(email: email, password: password),
          ).called(1);
          verify(
            () => authLocalDbService.saveLoggedUserId(
              loggedUserId: loggedUserId,
            ),
          ).called(1);
          expect(await repository.loggedUserId$.first, loggedUserId);
        },
      );

      test(
        'should throw appropriate auth error if email is invalid',
        () async {
          const AuthError expectedAuthError = AuthError(
            code: AuthErrorCode.invalidEmail,
          );

          when(
            () => authRemoteDbService.signIn(email: email, password: password),
          ).thenThrow(FirebaseAuthException(code: 'invalid-email'));

          try {
            await repository.signIn(email: email, password: password);
          } on AuthError catch (error) {
            expect(error, expectedAuthError);
          }
        },
      );

      test(
        'should throw appropriate auth error if password is wrong',
        () async {
          const AuthError expectedAuthError = AuthError(
            code: AuthErrorCode.wrongPassword,
          );

          when(
            () => authRemoteDbService.signIn(email: email, password: password),
          ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

          try {
            await repository.signIn(email: email, password: password);
          } on AuthError catch (error) {
            expect(error, expectedAuthError);
          }
        },
      );

      test(
        'should throw appropriate auth error if user has not been found',
        () async {
          const AuthError expectedAuthError = AuthError(
            code: AuthErrorCode.userNotFound,
          );

          when(
            () => authRemoteDbService.signIn(email: email, password: password),
          ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

          try {
            await repository.signIn(email: email, password: password);
          } on AuthError catch (error) {
            expect(error, expectedAuthError);
          }
        },
      );

      test(
        'should throw appropriate network error if network connection has been lost',
        () async {
          const NetworkError expectedNetworkError = NetworkError(
            code: NetworkErrorCode.lossOfConnection,
          );

          when(
            () => authRemoteDbService.signIn(email: email, password: password),
          ).thenThrow(FirebaseAuthException(code: 'network-request-failed'));

          try {
            await repository.signIn(email: email, password: password);
          } on NetworkError catch (error) {
            expect(error, expectedNetworkError);
          }
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
        'should call methods responsible for signing up user in remote db and for saving logged user id in local db',
        () async {
          const String loggedUserId = 'userId';
          when(
            () => authRemoteDbService.signUp(email: email, password: password),
          ).thenAnswer((_) async => loggedUserId);
          when(
            () => authLocalDbService.saveLoggedUserId(
              loggedUserId: loggedUserId,
            ),
          ).thenAnswer((_) async => '');

          await repository.signUp(email: email, password: password);

          verify(
            () => authRemoteDbService.signUp(email: email, password: password),
          ).called(1);
          verify(
            () => authLocalDbService.saveLoggedUserId(
              loggedUserId: loggedUserId,
            ),
          ).called(1);
          expect(await repository.loggedUserId$.first, loggedUserId);
        },
      );

      test(
        'should throw appropriate auth error if email is already in use',
        () async {
          const AuthError expectedAuthError = AuthError(
            code: AuthErrorCode.emailAlreadyInUse,
          );

          when(
            () => authRemoteDbService.signUp(email: email, password: password),
          ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

          try {
            await repository.signUp(email: email, password: password);
          } on AuthError catch (error) {
            expect(error, expectedAuthError);
          }
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
          when(
            () => authRemoteDbService.sendPasswordResetEmail(email: email),
          ).thenAnswer((_) async => '');

          await repository.sendPasswordResetEmail(email: email);

          verify(
            () => authRemoteDbService.sendPasswordResetEmail(email: email),
          ).called(1);
        },
      );

      test(
        'should throw auth error if email is invalid',
        () async {
          const AuthError expectedAuthError = AuthError(
            code: AuthErrorCode.invalidEmail,
          );

          when(
            () => authRemoteDbService.sendPasswordResetEmail(email: email),
          ).thenThrow(FirebaseAuthException(code: 'invalid-email'));

          try {
            await repository.sendPasswordResetEmail(email: email);
          } on AuthError catch (error) {
            expect(error, expectedAuthError);
          }
        },
      );

      test(
        'should throw auth error if user has not been found',
        () async {
          const AuthError expectedAuthError = AuthError(
            code: AuthErrorCode.userNotFound,
          );

          when(
            () => authRemoteDbService.sendPasswordResetEmail(email: email),
          ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

          try {
            await repository.sendPasswordResetEmail(email: email);
          } on AuthError catch (error) {
            expect(error, expectedAuthError);
          }
        },
      );
    },
  );

  test(
    'sign out, should call methods responsible for signing out user from remote db and for removing user id from local db',
    () async {
      when(
        () => authRemoteDbService.signOut(),
      ).thenAnswer((_) async => '');
      when(
        () => authLocalDbService.removeLoggedUserId(),
      ).thenAnswer((_) async => '');

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
      when(
        () => authRemoteDbService.deleteLoggedUser(password: password),
      ).thenAnswer((_) async => '');
      when(
        () => authLocalDbService.removeLoggedUserId(),
      ).thenAnswer((_) async => '');

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
      const AuthError expectedAuthError = AuthError(
        code: AuthErrorCode.wrongPassword,
      );
      when(
        () => authRemoteDbService.deleteLoggedUser(password: password),
      ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      try {
        await repository.deleteLoggedUser(password: password);
      } on AuthError catch (error) {
        expect(error, expectedAuthError);
      }
    },
  );
}

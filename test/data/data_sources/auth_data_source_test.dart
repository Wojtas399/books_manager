import 'package:app/data/data_sources/auth_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/data/data_sources/firebase/mock_firebase_auth_service.dart';

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

      final Stream<String?> loggedUserId$ = dataSource.getLoggedUserId();

      expect(await loggedUserId$.first, expectedLoggedUserId);
    },
  );

  test(
    'sign in, should call method from firebase auth service responsible for signing in user',
    () async {
      const String email = 'email@example.com';
      const String password = 'password';
      firebaseAuthService.mockSignIn();

      await dataSource.signIn(
        email: email,
        password: password,
      );

      verify(
        () => firebaseAuthService.signIn(email: email, password: password),
      ).called(1);
    },
  );

  test(
    'sign up, should call method from firebase auth service responsible for signing up user',
    () async {
      const String email = 'email@example.com';
      const String password = 'password';
      const String signedUpUserId = 'u1';
      firebaseAuthService.mockSignUp(signedUpUserId: signedUpUserId);

      final String userId = await dataSource.signUp(
        email: email,
        password: password,
      );

      verify(
        () => firebaseAuthService.signUp(email: email, password: password),
      ).called(1);
      expect(userId, signedUpUserId);
    },
  );

  test(
    'send password reset email, should call method from firebase auth service responsible for sending password reset email',
    () async {
      const String email = 'email@example.com';
      firebaseAuthService.mockSendPasswordResetEmail();

      await dataSource.sendPasswordResetEmail(email: email);

      verify(
        () => firebaseAuthService.sendPasswordResetEmail(email: email),
      ).called(1);
    },
  );

  group(
    'check logged user password correctness',
    () {
      const String password = 'password';

      test(
        'should return true if firebase method responsible for reauthentication does not throw error',
        () async {
          firebaseAuthService.mockReauthenticateLoggedUserWithPassword();

          final bool isCorrect = await dataSource
              .checkLoggedUserPasswordCorrectness(password: password);

          expect(isCorrect, true);
        },
      );

      test(
        'should return false if firebase method responsible for reauthentication throw wrong password error',
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
        'should rethrow error if firebase method responsible for reauthentication throw error different than wrong password',
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

  test(
    'change logged user password, should call method from firebase auth responsible for change logged user password',
    () async {
      const String currentPassword = 'currentPassword';
      const String newPassword = 'newPassword';
      firebaseAuthService.mockChangeLoggedUserPassword();

      await dataSource.changeLoggedUserPassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      verify(
        () => firebaseAuthService.changeLoggedUserPassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      ).called(1);
    },
  );

  test(
    'sign out, should call method from firebase auth service responsible for signing out user',
    () async {
      firebaseAuthService.mockSignOut();

      await dataSource.signOut();

      verify(
        () => firebaseAuthService.signOut(),
      ).called(1);
    },
  );

  test(
    'delete logged user, should call method from firebase auth service responsible for deleting logged user',
    () async {
      const String password = 'password';
      firebaseAuthService.mockDeleteLoggedUser();

      await dataSource.deleteLoggedUser(password: password);

      verify(
        () => firebaseAuthService.deleteLoggedUser(password: password),
      ).called(1);
    },
  );
}

import 'package:app/data/data_sources/remote_db/auth_remote_db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/remote_db/firebase/mock_firebase_auth_service.dart';

void main() {
  final firebaseAuthService = MockFirebaseAuthService();
  late AuthRemoteDbService service;

  setUp(() {
    service = AuthRemoteDbService(firebaseAuthService: firebaseAuthService);
  });

  tearDown(() {
    reset(firebaseAuthService);
  });

  test(
    'sign in, should call method from firebase auth service responsible for signing in user',
    () async {
      const String email = 'email@example.com';
      const String password = 'password';
      const String signedInUserId = 'u1';
      firebaseAuthService.mockSignIn(signedInUserId: signedInUserId);

      final String userId = await service.signIn(
        email: email,
        password: password,
      );

      verify(
        () => firebaseAuthService.signIn(email: email, password: password),
      ).called(1);
      expect(userId, signedInUserId);
    },
  );

  test(
    'sign up, should call method from firebase auth service responsible for signing up user',
    () async {
      const String email = 'email@example.com';
      const String password = 'password';
      const String signedUpUserId = 'u1';
      firebaseAuthService.mockSignUp(signedUpUserId: signedUpUserId);

      final String userId = await service.signUp(
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

      await service.sendPasswordResetEmail(email: email);

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

          final bool isCorrect = await service
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

          final bool isCorrect = await service
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
            await service.checkLoggedUserPasswordCorrectness(
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

      await service.changeLoggedUserPassword(
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

      await service.signOut();

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

      await service.deleteLoggedUser(password: password);

      verify(
        () => firebaseAuthService.deleteLoggedUser(password: password),
      ).called(1);
    },
  );
}

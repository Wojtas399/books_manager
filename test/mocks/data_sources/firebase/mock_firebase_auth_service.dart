import 'package:app/data/data_sources/firebase/services/firebase_auth_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {
  void mockGetLoggedUserId({String? loggedUserId}) {
    when(
      () => getLoggedUserId(),
    ).thenAnswer((_) => Stream.value(loggedUserId));
  }

  void mockSignIn() {
    when(
      () => signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockSignUp({required String signedUpUserId}) {
    when(
      () => signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => signedUpUserId);
  }

  void mockSendPasswordResetEmail() {
    when(
      () => sendPasswordResetEmail(
        email: any(named: 'email'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockChangeLoggedUserPassword() {
    when(
      () => changeLoggedUserPassword(
        currentPassword: any(named: 'currentPassword'),
        newPassword: any(named: 'newPassword'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockSignOut() {
    when(
      () => signOut(),
    ).thenAnswer((_) async => '');
  }

  void mockDeleteLoggedUser() {
    when(
      () => deleteLoggedUser(
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockReauthenticateLoggedUserWithPassword() {
    when(
      () => reauthenticateLoggedUserWithPassword(
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => '');
  }
}
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_auth_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {
  void mockSignIn({required String signedInUserId}) {
    when(
      () => signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => signedInUserId);
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

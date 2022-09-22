import 'package:app/data/data_sources/remote_db/auth_remote_db_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDbService extends Mock implements AuthRemoteDbService {
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

  void mockCheckLoggedUserPasswordCorrectness({
    required bool isPasswordCorrect,
  }) {
    when(
      () => checkLoggedUserPasswordCorrectness(
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => isPasswordCorrect);
  }

  void mockChangeLoggedUserPassword({Object? throwable}) {
    if (throwable != null) {
      when(_changeLoggedUserPasswordMethodCall).thenThrow(throwable);
    } else {
      when(_changeLoggedUserPasswordMethodCall).thenAnswer((_) async => '');
    }
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

  Future<void> _changeLoggedUserPasswordMethodCall() {
    return changeLoggedUserPassword(
      currentPassword: any(named: 'currentPassword'),
      newPassword: any(named: 'newPassword'),
    );
  }
}

import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthInterface extends Mock implements AuthInterface {
  void mockGetLoggedUserId({String? loggedUserId}) {
    when(
      () => loggedUserId$,
    ).thenAnswer((_) => Stream.value(loggedUserId));
  }

  void mockLoadLoggedUserId() {
    when(
      () => loadLoggedUserId(),
    ).thenAnswer((_) async => '');
  }

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
}

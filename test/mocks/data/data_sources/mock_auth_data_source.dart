import 'package:app/data/data_sources/auth_data_source.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthDataSource extends Mock implements AuthDataSource {
  void mockGetLoggedUserId({String? loggedUserId}) {
    when(
      () => getLoggedUserId(),
    ).thenAnswer((_) => Stream.value(loggedUserId));
  }

  void mockSignIn({Object? throwable}) {
    if (throwable != null) {
      when(_signInMethodCall).thenThrow(throwable);
    } else {
      when(_signInMethodCall).thenAnswer((_) async => '');
    }
  }

  void mockSignUp({required String signedUpUserId, Object? throwable}) {
    if (throwable != null) {
      when(_signUpMethodCall).thenThrow(throwable);
    } else {
      when(_signUpMethodCall).thenAnswer((_) async => signedUpUserId);
    }
  }

  void mockSendPasswordResetEmail({Object? throwable}) {
    if (throwable != null) {
      when(_sendPasswordResetEmailMethodCall).thenThrow(throwable);
    } else {
      when(_sendPasswordResetEmailMethodCall).thenAnswer((_) async => '');
    }
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

  void mockDeleteLoggedUser({Object? throwable}) {
    if (throwable != null) {
      when(_deleteLoggedUserMethodCall).thenThrow(throwable);
    } else {
      when(_deleteLoggedUserMethodCall).thenAnswer((_) async => '');
    }
  }

  Future<void> _signInMethodCall() {
    return signIn(
      email: any(named: 'email'),
      password: any(named: 'password'),
    );
  }

  Future<String> _signUpMethodCall() {
    return signUp(
      email: any(named: 'email'),
      password: any(named: 'password'),
    );
  }

  Future<void> _sendPasswordResetEmailMethodCall() {
    return sendPasswordResetEmail(
      email: any(named: 'email'),
    );
  }

  Future<void> _changeLoggedUserPasswordMethodCall() {
    return changeLoggedUserPassword(
      currentPassword: any(named: 'currentPassword'),
      newPassword: any(named: 'newPassword'),
    );
  }

  Future<void> _deleteLoggedUserMethodCall() {
    return deleteLoggedUser(
      password: any(named: 'password'),
    );
  }
}

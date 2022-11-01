import 'package:app/data/data_sources/firebase/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthDataSource {
  late final FirebaseAuthService _firebaseAuthService;

  AuthDataSource({required FirebaseAuthService firebaseAuthService}) {
    _firebaseAuthService = firebaseAuthService;
  }

  Stream<String?> getLoggedUserId() {
    return _firebaseAuthService.getLoggedUserId();
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _firebaseAuthService.signIn(
      email: email,
      password: password,
    );
  }

  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuthService.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuthService.sendPasswordResetEmail(email: email);
  }

  Future<bool> checkLoggedUserPasswordCorrectness({
    required String password,
  }) async {
    try {
      await _firebaseAuthService.reauthenticateLoggedUserWithPassword(
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (authException) {
      if (authException.code == 'wrong-password') {
        return false;
      } else {
        rethrow;
      }
    }
  }

  Future<void> changeLoggedUserPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _firebaseAuthService.changeLoggedUserPassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuthService.signOut();
  }

  Future<void> deleteLoggedUser({required String password}) async {
    await _firebaseAuthService.deleteLoggedUser(password: password);
  }
}

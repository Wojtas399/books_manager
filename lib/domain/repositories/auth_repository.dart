import 'package:firebase_auth/firebase_auth.dart';

import '../../firebase/services/fire_auth_service.dart';
import '../../interfaces/auth_interface.dart';
import '../entities/auth_error.dart';

class AuthRepository implements AuthInterface {
  late final FireAuthService _fireAuthService;

  AuthRepository({required FireAuthService fireAuthService}) {
    _fireAuthService = fireAuthService;
  }

  @override
  Stream<bool> get isUserSignedIn$ => _fireAuthService.isUserSignedIn;

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _fireAuthService.signIn(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (exception) {
      throw _convertFirebaseCodeToAuthError(exception.code);
    }
  }

  AuthError _convertFirebaseCodeToAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return AuthError.invalidEmail;
      case 'wrong-password':
        return AuthError.wrongPassword;
      case 'user-not-found':
        return AuthError.userNotFound;
      case 'email-is-already-in-use':
        return AuthError.emailIsAlreadyInUse;
      default:
        return AuthError.unknown;
    }
  }
}

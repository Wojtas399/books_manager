import 'package:firebase_auth/firebase_auth.dart';

import '../../firebase/services/fire_auth_service.dart';
import '../../interfaces/auth_interface.dart';
import '../entities/auth_error.dart';
import '../entities/auth_state.dart';

class AuthRepository implements AuthInterface {
  late final FireAuthService _fireAuthService;

  AuthRepository({required FireAuthService fireAuthService}) {
    _fireAuthService = fireAuthService;
  }

  @override
  Stream<AuthState> get authState$ => _fireAuthService.isUserSignedIn.map(
        (bool isSignedIn) =>
            isSignedIn ? AuthState.signedIn : AuthState.signedOut,
      );

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
      throw _convertFirebaseAuthExceptionCodeToAuthError(exception.code);
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _fireAuthService.signUp(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (exception) {
      throw _convertFirebaseAuthExceptionCodeToAuthError(exception.code);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _fireAuthService.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (exception) {
      throw _convertFirebaseAuthExceptionCodeToAuthError(exception.code);
    }
  }

  AuthError _convertFirebaseAuthExceptionCodeToAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return AuthError.invalidEmail;
      case 'wrong-password':
        return AuthError.wrongPassword;
      case 'user-not-found':
        return AuthError.userNotFound;
      case 'email-already-in-use':
        return AuthError.emailAlreadyInUse;
      default:
        return AuthError.unknown;
    }
  }
}

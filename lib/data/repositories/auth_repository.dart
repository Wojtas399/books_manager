import 'package:app/config/errors.dart';
import 'package:app/data/firebase/services/firebase_auth_service.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/models/error.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository implements AuthInterface {
  late final FirebaseAuthService _firebaseAuthService;

  AuthRepository({required FirebaseAuthService firebaseAuthService}) {
    _firebaseAuthService = firebaseAuthService;
  }

  @override
  Stream<String?> get loggedUserId$ => _firebaseAuthService.getLoggedUserId();

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuthService.signIn(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (exception) {
      throw _mapFirebaseAuthExceptionToCustomError(exception.code);
    }
  }

  @override
  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuthService.signUp(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (exception) {
      throw _mapFirebaseAuthExceptionToCustomError(exception.code);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuthService.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (exception) {
      throw _mapFirebaseAuthExceptionToCustomError(exception.code);
    }
  }

  @override
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

  @override
  Future<void> changeLoggedUserPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _firebaseAuthService.changeLoggedUserPassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } on FirebaseAuthException catch (exception) {
      throw _mapFirebaseAuthExceptionToCustomError(exception.code);
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuthService.signOut();
  }

  @override
  Future<void> deleteLoggedUser({required String password}) async {
    try {
      await _firebaseAuthService.deleteLoggedUser(password: password);
    } on FirebaseAuthException catch (exception) {
      throw _mapFirebaseAuthExceptionToCustomError(exception.code);
    }
  }

  CustomError _mapFirebaseAuthExceptionToCustomError(String code) {
    switch (code) {
      case 'invalid-email':
        return const AuthError(code: AuthErrorCode.invalidEmail);
      case 'wrong-password':
        return const AuthError(code: AuthErrorCode.wrongPassword);
      case 'user-not-found':
        return const AuthError(code: AuthErrorCode.userNotFound);
      case 'email-already-in-use':
        return const AuthError(code: AuthErrorCode.emailAlreadyInUse);
      case 'network-request-failed':
        return const NetworkError(code: NetworkErrorCode.lossOfConnection);
      default:
        return const AuthError(code: AuthErrorCode.unknown);
    }
  }
}

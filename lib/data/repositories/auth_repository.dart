import 'package:app/config/errors.dart';
import 'package:app/data/data_sources/auth_data_source.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/models/error.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository implements AuthInterface {
  late final AuthDataSource _authDataSource;

  AuthRepository({
    required AuthDataSource authDataSource,
  }) {
    _authDataSource = authDataSource;
  }

  @override
  Stream<String?> get loggedUserId$ => _authDataSource.getLoggedUserId();

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _authDataSource.signIn(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (exception) {
      throw _convertFirebaseAuthExceptionToCustomError(exception.code);
    }
  }

  @override
  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    try {
      return await _authDataSource.signUp(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (exception) {
      throw _convertFirebaseAuthExceptionToCustomError(exception.code);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _authDataSource.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (exception) {
      throw _convertFirebaseAuthExceptionToCustomError(exception.code);
    }
  }

  @override
  Future<bool> checkLoggedUserPasswordCorrectness({
    required String password,
  }) async {
    return await _authDataSource.checkLoggedUserPasswordCorrectness(
      password: password,
    );
  }

  @override
  Future<void> changeLoggedUserPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _authDataSource.changeLoggedUserPassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } on FirebaseAuthException catch (exception) {
      throw _convertFirebaseAuthExceptionToCustomError(exception.code);
    }
  }

  @override
  Future<void> signOut() async {
    await _authDataSource.signOut();
  }

  @override
  Future<void> deleteLoggedUser({required String password}) async {
    try {
      await _authDataSource.deleteLoggedUser(password: password);
    } on FirebaseAuthException catch (exception) {
      throw _convertFirebaseAuthExceptionToCustomError(exception.code);
    }
  }

  CustomError _convertFirebaseAuthExceptionToCustomError(String code) {
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../../database/firebase/services/fire_auth_service.dart';
import '../../database/shared_preferences/shared_preferences_service.dart';
import '../../interfaces/auth_interface.dart';
import '../entities/auth_error.dart';
import '../entities/auth_state.dart';

class AuthRepository implements AuthInterface {
  late final FireAuthService _fireAuthService;
  late final SharedPreferencesService _sharedPreferencesService;

  AuthRepository({
    required FireAuthService fireAuthService,
    required SharedPreferencesService sharedPreferencesService,
  }) {
    _fireAuthService = fireAuthService;
    _sharedPreferencesService = sharedPreferencesService;
  }

  @override
  Stream<AuthState> get authState$ => Rx.fromCallable(
        () async => await _sharedPreferencesService.loadLoggedUserId(),
      ).map(
        (String? loggedUserId) =>
            loggedUserId != null ? AuthState.signedIn : AuthState.signedOut,
      );

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final String loggedUserId = await _fireAuthService.signIn(
        email: email,
        password: password,
      );
      await _sharedPreferencesService.saveLoggedUserId(
        loggedUserId: loggedUserId,
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
      final String loggedUserId = await _fireAuthService.signUp(
        email: email,
        password: password,
      );
      await _sharedPreferencesService.saveLoggedUserId(
        loggedUserId: loggedUserId,
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

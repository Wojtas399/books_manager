import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../../database/firebase/services/fire_auth_service.dart';
import '../../database/shared_preferences/shared_preferences_service.dart';
import '../../interfaces/auth_interface.dart';
import '../entities/auth_error.dart';
import '../entities/auth_state.dart';
import '../entities/network_error.dart';

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
      ).map(_getAuthStateDependsOnUserId);

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
      _manageFirebaseAuthException(exception.code);
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
      _manageFirebaseAuthException(exception.code);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _fireAuthService.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (exception) {
      _manageFirebaseAuthException(exception.code);
    }
  }

  @override
  Future<void> signOut() async {
    await _fireAuthService.signOut();
    await _sharedPreferencesService.removeLoggedUserId();
  }

  @override
  Future<void> deleteLoggedUser({required String password}) async {
    try {
      await _fireAuthService.deleteLoggedUser(password: password);
      await _sharedPreferencesService.removeLoggedUserId();
    } on FirebaseAuthException catch (exception) {
      _manageFirebaseAuthException(exception.code);
    }
  }

  AuthState _getAuthStateDependsOnUserId(String? userId) {
    if (userId != null) {
      return AuthState.signedIn;
    }
    return AuthState.signedOut;
  }

  AuthError _manageFirebaseAuthException(String code) {
    switch (code) {
      case 'invalid-email':
        throw AuthError.invalidEmail;
      case 'wrong-password':
        throw AuthError.wrongPassword;
      case 'user-not-found':
        throw AuthError.userNotFound;
      case 'email-already-in-use':
        throw AuthError.emailAlreadyInUse;
      case 'network-request-failed':
        throw NetworkError.lossOfConnection;
      default:
        throw AuthError.unknown;
    }
  }
}

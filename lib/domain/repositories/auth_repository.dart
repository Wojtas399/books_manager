import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../../database/firebase/services/fire_auth_service.dart';
import '../../database/shared_preferences/shared_preferences_service.dart';
import '../../interfaces/auth_interface.dart';
import '../../models/error.dart';

class AuthRepository implements AuthInterface {
  late final FireAuthService _fireAuthService;
  late final SharedPreferencesService _sharedPreferencesService;
  final BehaviorSubject<String?> _loggedUserId$ =
      BehaviorSubject<String?>.seeded(null);

  AuthRepository({
    required FireAuthService fireAuthService,
    required SharedPreferencesService sharedPreferencesService,
  }) {
    _fireAuthService = fireAuthService;
    _sharedPreferencesService = sharedPreferencesService;
  }

  @override
  Stream<String?> get loggedUserId$ => _loggedUserId$.stream;

  @override
  Future<void> loadLoggedUserId() async {
    _loggedUserId$.add(
      await _sharedPreferencesService.loadLoggedUserId(),
    );
  }

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
      _loggedUserId$.add(loggedUserId);
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
      _loggedUserId$.add(loggedUserId);
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
    _loggedUserId$.add(null);
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

  void _manageFirebaseAuthException(String code) {
    switch (code) {
      case 'invalid-email':
        throw AuthError(authErrorCode: AuthErrorCode.invalidEmail);
      case 'wrong-password':
        throw AuthError(authErrorCode: AuthErrorCode.wrongPassword);
      case 'user-not-found':
        throw AuthError(authErrorCode: AuthErrorCode.userNotFound);
      case 'email-already-in-use':
        throw AuthError(authErrorCode: AuthErrorCode.emailAlreadyInUse);
      case 'network-request-failed':
        throw NetworkError(networkErrorCode: NetworkErrorCode.lossOfConnection);
      default:
        throw AuthError(authErrorCode: AuthErrorCode.unknown);
    }
  }
}

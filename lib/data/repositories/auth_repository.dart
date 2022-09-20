import 'package:app/config/errors.dart';
import 'package:app/data/data_sources/local_db/auth_local_db_service.dart';
import 'package:app/data/data_sources/remote_db/auth_remote_db_service.dart';
import 'package:app/domain/interfaces/auth_interface.dart';
import 'package:app/models/error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class AuthRepository implements AuthInterface {
  late final AuthLocalDbService _authLocalDbService;
  late final AuthRemoteDbService _authRemoteDbService;
  final BehaviorSubject<String?> _loggedUserId$ =
      BehaviorSubject<String?>.seeded(null);

  AuthRepository({
    required AuthLocalDbService authLocalDbService,
    required AuthRemoteDbService authRemoteDbService,
  }) {
    _authLocalDbService = authLocalDbService;
    _authRemoteDbService = authRemoteDbService;
  }

  @override
  Stream<String?> get loggedUserId$ => _loggedUserId$.stream;

  @override
  Future<void> loadLoggedUserId() async {
    _loggedUserId$.add(
      await _authLocalDbService.loadLoggedUserId(),
    );
  }

  @override
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final String loggedUserId = await _authRemoteDbService.signIn(
        email: email,
        password: password,
      );
      await _authLocalDbService.saveLoggedUserId(loggedUserId: loggedUserId);
      _loggedUserId$.add(loggedUserId);
      return loggedUserId;
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
      final String loggedUserId = await _authRemoteDbService.signUp(
        email: email,
        password: password,
      );
      await _authLocalDbService.saveLoggedUserId(loggedUserId: loggedUserId);
      _loggedUserId$.add(loggedUserId);
      return loggedUserId;
    } on FirebaseAuthException catch (exception) {
      throw _convertFirebaseAuthExceptionToCustomError(exception.code);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _authRemoteDbService.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (exception) {
      throw _convertFirebaseAuthExceptionToCustomError(exception.code);
    }
  }

  @override
  Future<bool> checkLoggedUserPasswordCorrectness({
    required String password,
  }) async {
    return await _authRemoteDbService.checkLoggedUserPasswordCorrectness(
      password: password,
    );
  }

  @override
  Future<void> changeLoggedUserPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _authRemoteDbService.changeLoggedUserPassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } on FirebaseAuthException catch (exception) {
      throw _convertFirebaseAuthExceptionToCustomError(exception.code);
    }
  }

  @override
  Future<void> signOut() async {
    await _authRemoteDbService.signOut();
    await _authLocalDbService.removeLoggedUserId();
    _loggedUserId$.add(null);
  }

  @override
  Future<void> deleteLoggedUser({required String password}) async {
    try {
      await _authRemoteDbService.deleteLoggedUser(password: password);
      await _authLocalDbService.removeLoggedUserId();
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

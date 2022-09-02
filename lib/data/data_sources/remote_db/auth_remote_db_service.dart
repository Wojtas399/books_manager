import 'package:app/data/data_sources/remote_db/firebase/services/firebase_auth_service.dart';

class AuthRemoteDbService {
  late final FirebaseAuthService _firebaseAuthService;

  AuthRemoteDbService({required FirebaseAuthService firebaseAuthService}) {
    _firebaseAuthService = firebaseAuthService;
  }

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuthService.signIn(
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

  Future<void> signOut() async {
    await _firebaseAuthService.signOut();
  }

  Future<void> deleteLoggedUser({required String password}) async {
    await _firebaseAuthService.deleteLoggedUser(password: password);
  }
}

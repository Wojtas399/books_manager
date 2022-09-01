import 'package:app/data/data_sources/remote_db/firebase/services/fire_auth_service.dart';

class AuthRemoteDbService {
  late final FireAuthService _fireAuthService;

  AuthRemoteDbService({required FireAuthService fireAuthService}) {
    _fireAuthService = fireAuthService;
  }

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    return await _fireAuthService.signIn(
      email: email,
      password: password,
    );
  }

  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    return await _fireAuthService.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _fireAuthService.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _fireAuthService.signOut();
  }

  Future<void> deleteLoggedUser({required String password}) async {
    await _fireAuthService.deleteLoggedUser(password: password);
  }
}

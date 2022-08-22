import 'package:firebase_auth/firebase_auth.dart';

import '../fire_instances.dart';

class FireAuthService {
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    final UserCredential credential =
        await FireInstances.auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _readUserIdFromCredential(credential);
  }

  Future<String> signUp({
    required String email,
    required String password,
  }) async {
    final UserCredential credential =
        await FireInstances.auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _readUserIdFromCredential(credential);
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await FireInstances.auth.sendPasswordResetEmail(email: email);
  }

  String _readUserIdFromCredential(UserCredential credential) {
    final String? userId = credential.user?.uid;
    if (userId != null) {
      return userId;
    } else {
      throw 'Cannot read user id';
    }
  }
}

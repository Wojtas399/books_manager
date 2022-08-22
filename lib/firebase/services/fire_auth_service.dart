import 'package:firebase_auth/firebase_auth.dart';

import '../fire_instances.dart';

class FireAuthService {
  Stream<bool> get isUserSignedIn => FireInstances.auth.authStateChanges().map(
        (User? user) => user != null,
      );

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await FireInstances.auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await FireInstances.auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await FireInstances.auth.sendPasswordResetEmail(email: email);
  }
}
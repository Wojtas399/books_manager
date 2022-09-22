import 'package:app/data/data_sources/remote_db/firebase/firebase_instances.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
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

  Future<void> changeLoggedUserPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await reauthenticateLoggedUserWithPassword(password: currentPassword);
    await FireInstances.auth.currentUser?.updatePassword(newPassword);
  }

  Future<void> signOut() async {
    await FireInstances.auth.signOut();
  }

  Future<void> deleteLoggedUser({required String password}) async {
    await reauthenticateLoggedUserWithPassword(password: password);
    await FireInstances.auth.currentUser?.delete();
  }

  Future<void> reauthenticateLoggedUserWithPassword({
    required String password,
  }) async {
    final User? loggedUser = FireInstances.auth.currentUser;
    final String? loggedUserEmail = loggedUser?.email;
    if (loggedUser != null && loggedUserEmail != null) {
      final AuthCredential credential = EmailAuthProvider.credential(
        email: loggedUserEmail,
        password: password,
      );
      await loggedUser.reauthenticateWithCredential(credential);
    }
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

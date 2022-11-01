abstract class AuthInterface {
  Stream<String?> get loggedUserId$;

  Future<void> signIn({
    required String email,
    required String password,
  });

  Future<String> signUp({
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail({required String email});

  Future<bool> checkLoggedUserPasswordCorrectness({required String password});

  Future<void> changeLoggedUserPassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> signOut();

  Future<void> deleteLoggedUser({required String password});
}

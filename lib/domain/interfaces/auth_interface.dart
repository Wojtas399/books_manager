abstract class AuthInterface {
  Stream<String?> get loggedUserId$;

  Future<void> loadLoggedUserId();

  Future<void> signIn({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> signOut();

  Future<void> deleteLoggedUser({required String password});
}

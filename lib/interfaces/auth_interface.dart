abstract class AuthInterface {
  Stream<bool> get isUserSignedIn$;

  Future<void> signIn({
    required String email,
    required String password,
  });
}
